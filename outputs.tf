output "users" {
  value = aws_iam_user.users
}

output "passwords" {
  value = {
    for user, user_login in aws_iam_user_login_profile.users : user => user_login.password
  }
  sensitive = true
}

output "users_roles" {
  value = local.roles_policies_list
}

output "users_map" {
  value = local.users_map
}