# Job Definition
resource "aws_batch_job_definition" "generate_batch_jd_report" {
  name = "${var.prefix}-report"
  type = "container"
  platform_capabilities = ["FARGATE"]
  propagate_tags = true
  tags = { "job_definition" : "${var.prefix}-report" }

  container_properties = jsonencode({
    image = "${local.account_id}.dkr.ecr.us-west-2.amazonaws.com/${var.prefix}-report:${var.image_tag}"
    executionRoleArn = var.iam_execution_role_arn
    jobRoleArn = var.iam_job_role_arn
    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group = aws_cloudwatch_log_group.cw_log_group.name
      }
    }
    resourceRequirements = [{
      type = "MEMORY"
      value = "512"
    }, {
      type = "VCPU",
      value = "0.25"
    }]
  })
}

# Log group
resource "aws_cloudwatch_log_group" "cw_log_group" {
  name = "/aws/batch/job/${var.prefix}-report/"
}
