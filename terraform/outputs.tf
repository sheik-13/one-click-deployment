output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}
output "cloudwatch_app_log_group" {
  value       = aws_cloudwatch_log_group.app_log_group.name
  description = "CloudWatch Log Group for Flask Application Logs"
}

output "cloudwatch_syslog_group" {
  value       = aws_cloudwatch_log_group.syslog_group.name
  description = "CloudWatch Log Group for Linux System Logs"
}
