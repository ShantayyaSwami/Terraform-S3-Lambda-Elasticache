resource "aws_elasticache_cluster" "redis-cluster" {
  cluster_id           = "example-cluster"
  engine               = "redis"
  node_type            = var.node-type
  num_cache_nodes      = var.node-count
  parameter_group_name = "default.redis7"
  port                 = 6379
  tags = {
    name = "elasticache-redis-cluster"
  }
  subnet_group_name  = aws_elasticache_subnet_group.example_subnet_group.name
  security_group_ids = [aws_security_group.example_security_group.id]
}