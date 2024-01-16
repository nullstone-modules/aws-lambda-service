locals {
  service_dims = tomap({
    "FunctionName" = local.resource_name
  })

  metrics_mappings = [
    {
      name = "invocations"
      type = "invocations"
      unit = "count"

      mappings = {
        invocations_total = {
          account_id  = local.account_id
          stat        = "Sum"
          namespace   = "AWS/Lambda"
          metric_name = "Invocations"
          dimensions  = local.service_dims
        }
        invocations_errors = {
          account_id  = local.account_id
          stat        = "Sum"
          namespace   = "AWS/Lambda"
          metric_name = "Errors"
          dimensions  = local.service_dims
        }
      }
    },
    {
      name = "duration"
      type = "duration"
      unit = "milliseconds"

      mappings = {
        duration_average = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "AWS/Lambda"
          metric_name = "Duration"
          dimensions  = local.service_dims
        }
        duration_min = {
          account_id  = local.account_id
          stat        = "Minimum"
          namespace   = "AWS/Lambda"
          metric_name = "Duration"
          dimensions  = local.service_dims
        }
        duration_max = {
          account_id  = local.account_id
          stat        = "Maximum"
          namespace   = "AWS/Lambda"
          metric_name = "Duration"
          dimensions  = local.service_dims
        }
      }
    }
  ]
}

