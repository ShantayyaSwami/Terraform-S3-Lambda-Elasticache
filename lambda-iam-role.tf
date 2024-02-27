resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "lambda_s3_elasticache_policy" {
  name        = "lambda_s3_elasticache_policy"
  description = "Custom IAM policy for Lambda function to read from S3 and write to Elasticache"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "elasticache:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_s3_elasticache_policy_attachment" {
  name       = "lambda_s3_elasticache_policy_attachment"
  policy_arn = aws_iam_policy.lambda_s3_elasticache_policy.arn
  roles      = [aws_iam_role.lambda_role.name]
}
