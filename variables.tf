variable "region" {
  default = "ap-south-1"
}

variable "node-type" {
  default = "cache.m4.large"
}

variable "node-count" {
  type    = number
  default = 1
}

