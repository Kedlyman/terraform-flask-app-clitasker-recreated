variable "project_name" {
  description = "The name of the project, used to name the alarms"
  type        = string
}

variable "ec2_instance_id" {
  description = "EC2 instance ID to monitor for high CPU usage"
  type        = string
}

variable "tg_arn" {
  description = "Target Group ARN associated with the ALB to monitor unhealthy hosts"
  type        = string
}

variable "lb_dimension" {
  description = "LoadBalancer dimension value for CloudWatch ALB alarm (format: app/your-lb-name/longid)"
  type        = string
}