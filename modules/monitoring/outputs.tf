output "cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.ec2_high_cpu.name
}

output "alb_alarm_name" {
  value = aws_cloudwatch_metric_alarm.alb_unhealthy.alarm_name
}
