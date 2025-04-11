output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "lb_dimension" {
  description = "CloudWatch dimension value for the LoadBalancer"
  value       = aws_lb.alb.id
}