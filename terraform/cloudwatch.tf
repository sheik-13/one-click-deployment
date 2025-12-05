resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/apt-devops-assignment/app"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "syslog_group" {
  name              = "/apt-devops-assignment/syslog"
  retention_in_days = 14
}
