output "elasticache-ep" {
  value = aws_elasticache_cluster.redis-cluster.cache_nodes.0.address
}

output "lambda-function-arn" {
  value = aws_lambda_function.s3-monitor-lambda.arn
}