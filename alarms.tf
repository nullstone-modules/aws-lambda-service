resource "aws_cloudwatch_metric_alarm" "error_rate" {
  count = local.enable_alarms ? 1 : 0

  alarm_name          = "${local.resource_name}/error-rate"
  alarm_description   = "Lambda error rate >= ${var.alert_thresholds.error_rate}% on ${local.resource_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = var.alert_thresholds.error_rate
  treat_missing_data  = "notBreaching"
  tags                = local.tags

  metric_query {
    id          = "error_rate"
    expression  = "100 * errors / invocations"
    label       = "Error Rate (%)"
    return_data = true
  }

  metric_query {
    id = "errors"

    metric {
      metric_name = "Errors"
      namespace   = "AWS/Lambda"
      period      = 300
      stat        = "Sum"
      dimensions  = local.service_dims
    }
  }

  metric_query {
    id = "invocations"

    metric {
      metric_name = "Invocations"
      namespace   = "AWS/Lambda"
      period      = 300
      stat        = "Sum"
      dimensions  = local.service_dims
    }
  }

  alarm_actions = [local.notification_arn]
  ok_actions    = [local.notification_arn]
}
