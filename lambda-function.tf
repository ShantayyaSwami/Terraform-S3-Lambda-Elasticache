resource "aws_lambda_permission" "s3-lambda-permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3-monitor-lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.staging.arn
}

resource "aws_lambda_function" "s3-monitor-lambda" {
  filename      = "${path.module}/python/lambda-function.zip"
  function_name = "s3LambdaMonitor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda-function.lambda_handler"
  runtime       = "python3.8"
  publish       = true # Enable logging to CloudWatch Logs
  timeout       = 60

  # Configure the CloudWatch Logs for the Lambda function
  tracing_config {
    mode = "PassThrough"
  }

  vpc_config {
    subnet_ids         = [aws_subnet.example_subnet.id]
    security_group_ids = [aws_security_group.example_security_group.id]
  }

  # Specify the CloudWatch Logs retention policy
  environment {
    variables = {
      LOG_GROUP_NAME        = "/aws/lambda/s3LambdaMonitor"
      LOG_RETENTION_IN_DAYS = "30" # Set retention period to 30 days (adjust as needed)
      REDIS_HOST            = aws_elasticache_cluster.redis-cluster.cache_nodes.0.address
      REDIS_PORT            = aws_elasticache_cluster.redis-cluster.port
    }
  }
}

data "archive_file" "zip-lambda-function" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/lambda-function.zip"
}
