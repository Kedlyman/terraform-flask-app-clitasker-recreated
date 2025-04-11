variable "project_name" {
  description = "The name of the project, used to tag resources"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID in which the ALB and target group are deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB placement"
  type        = list(string)
}

variable "ec2_instance_id" {
  description = "The EC2 instance to attach to the ALB target group"
  type        = string
}