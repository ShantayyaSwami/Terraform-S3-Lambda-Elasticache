resource "aws_s3_bucket" "staging" {
  bucket = "stagingibmlabs"
}


resource "aws_s3_bucket_public_access_block" "s3-lambda-access" {
  bucket                  = aws_s3_bucket.staging.id
  block_public_acls       = "false"
  ignore_public_acls      = "false"
  block_public_policy     = "false"
  restrict_public_buckets = "false"
}


resource "aws_s3_object" "staging-index" {
  bucket       = aws_s3_bucket.staging.id
  key          = "index.html"
  source       = "stage-index.html"
  content_type = "text/html"
}



resource "aws_s3_bucket_notification" "stage-bucket_notification" {
  bucket = aws_s3_bucket.staging.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3-monitor-lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3-lambda-permission]
}
