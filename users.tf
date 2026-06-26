locals {
  users = yamldecode(file("${path.module}/users-roles.yaml")).users
  users_map = {
    for user_config in local.users : user_config.username => user_config.roles
  }
}

resource "aws_iam_user" "users" {
  for_each = toset(local.users[*].username)
  name     = each.value
}

resource "aws_iam_user_login_profile" "users" {
  for_each        = aws_iam_user.users
  user            = each.value.name
  password_length = 8
  lifecycle {
    ignore_changes = [password_length, password_reset_required, pgp_key]
  }
}

data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "assume_role_policy" {
  for_each = toset(keys(local.roles_policies))
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        for username in keys(aws_iam_user.users) :
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"
        if contains(local.users_map[username], each.value)
      ]
    }
  }
}
# Role
resource "aws_iam_role" "roles" {
  for_each           = toset(keys(local.roles_policies))
  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[each.value].json
}
# Policy
data "aws_iam_policy" "policies" {
  for_each = toset(local.roles_policies_list[*].policy)
  arn      = "arn:aws:iam::aws:policy/${each.value}"
}
# Needs Policy and Role
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  count      = length(local.roles_policies_list)
  policy_arn = data.aws_iam_policy.policies[local.roles_policies_list[count.index].policy].arn
  role       = aws_iam_role.roles[local.roles_policies_list[count.index].role].name
}

