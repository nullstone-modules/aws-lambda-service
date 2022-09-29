locals {
  event_sources = merge(flatten([
    for mod in local.cap_modules : {
      for item in lookup(mod.outputs, "event_sources", []) : "${mod.id}_${item.name}" => item
    }
  ])...)
}

resource "aws_lambda_event_source_mapping" "caps" {
  for_each = local.event_sources

  function_name    = aws_lambda_function.this.function_name
  event_source_arn = each.value.source_arn
  enabled          = try(each.value.enabled, true)

  batch_size        = try(each.value.batch_size, null)
  starting_position = try(each.value.starting_position, null)
  topics            = try(each.value.topics, null)
}
