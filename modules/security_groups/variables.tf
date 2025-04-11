variable "vpc_id" {
  description = "The ID of the VPC where security groups will be created"
  type        = string
}

variable "project_name" {
  description = "Name prefix used for tagging resources"
  type        = string
}

variable "my_ip_cidr" {
  description = "My IP in CIDR format"
  type        = string
}