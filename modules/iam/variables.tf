variable "project_name" {
  description = "The name of the project used for naming IAM resources"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket that EC2 instances need access to"
  type        = string
}

variable "secret_name" {
  default = "aws-cli-project-db-password-2"
  description = "The name or prefix of the Secrets Manager secret that EC2 instances can read"
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources are deployed"
  type        = string
}