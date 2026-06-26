locals {
  roles_policies = {
    readonly = [
      "job-function/ViewOnlyAccess"
    ]
    auditor = [
      "SecurityAudit"
    ]
    developer = [
      "AmazonVPCFullAccess",
      "AmazonEC2FullAccess",
      "AmazonRDSFullAccess",
      "AmazonS3FullAccess"
    ]
    admin = [
      "AdministratorAccess"
    ]
  }
  roles_policies_list = flatten([
    for role, policies in local.roles_policies : [
      for policy in policies : {
        role   = role
        policy = policy
      }
    ]
  ])
}