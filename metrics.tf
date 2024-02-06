locals {
  service_dims = tomap({
    "FunctionName" = local.resource_name
  })

  metrics_mappings = concat(local.base_metrics, local.cap_metrics)

  cap_metrics_defs = lookup(local.capabilities, "metrics", [])
  cap_metrics = [
    for m in local.cap_metrics_defs : {
      name = m.name
      type = m.type
      unit = m.unit

      mappings = {
        for metric_id, mapping in jsondecode(lookup(m, "mappings", "{}")) : metric_id => {
          account_id        = mapping.account_id
          dimensions        = mapping.dimensions
          stat              = lookup(mapping, "stat", null)
          namespace         = lookup(mapping, "namespace", null)
          metric_name       = lookup(mapping, "metric_name", null)
          expression        = lookup(mapping, "expression", null)
          hide_from_results = lookup(mapping, "hide_from_results", null)
        }
      }
    }
  ]

  base_metrics = [
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

