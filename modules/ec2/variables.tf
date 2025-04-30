variable "ami_id" {
  description = "AMI ID for the EC2 instance (Ubuntu 24.04 LTS by default)"
  type        = string
  default     = "ami-03250b0e01c28d196"
}

variable "instance_type" {
  description = "EC2 instance type to use"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name for the EC2 key pair"
  type        = string
}

variable "public_key_material" {
  description = "SSH public key string for EC2"
  type        = string
}

variable "instance_name" {
  description = "Tag name for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to launch the EC2 instance in"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID to attach to the EC2 instance"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name to attach to the EC2 instance"
  type        = string
}
