resource "aws_iam_policy" "education_readonly" {
  name = "EducationReadOnly"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:Get*",
          "s3:List*"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "manager_ec2_readonly" {
  name = "ManagerEC2ReadOnly"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ec2:Describe*"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "engineer_s3_full" {
  name = "EngineerS3FullAccess"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:*"
        ]

        Resource = "*"
      }
    ]
  })
}