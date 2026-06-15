# Get AWS Account ID
data "aws_caller_identity" "current" {}

# Output the account ID
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Read users from CSV
locals {
  users = csvdecode(file("users.csv"))
}

# Output user names
output "user_names" {
  value = [for user in local.users : "${user.first_name} ${user.last_name}"]
}

# Create IAM users
resource "aws_iam_user" "users" {
  for_each = { for user in local.users : user.first_name => user }

  name = lower("${substr(each.value.first_name, 0, 1)}${each.value.last_name}")
  path = "/users/"

  tags = {
    "DisplayName" = "${each.value.first_name} ${each.value.last_name}"
    "Department"  = each.value.department
    "JobTitle"    = each.value.job_title
    "Email"       = each.value.email
    "Phone"       = each.value.phone
  }
}

# Create IAM user login profile (password)
resource "aws_iam_user_login_profile" "users" {
  for_each = aws_iam_user.users

  user                    = each.value.name
  password_reset_required = true

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
    ]
  }
}

output "user_passwords" {
  value = {
    for user, profile in aws_iam_user_login_profile.users :
    user => "Password created - user must reset on first login"
  }
  sensitive = true
}

resource "aws_iam_group_policy_attachment" "education_attach" {
  group      = aws_iam_group.education.name
  policy_arn = aws_iam_policy.education_readonly.arn
}

resource "aws_iam_group_policy_attachment" "manager_attach" {
  group      = aws_iam_group.managers.name
  policy_arn = aws_iam_policy.manager_ec2_readonly.arn
}

resource "aws_iam_group_policy_attachment" "engineer_attach" {
  group      = aws_iam_group.engineers.name
  policy_arn = aws_iam_policy.engineer_s3_full.arn
}