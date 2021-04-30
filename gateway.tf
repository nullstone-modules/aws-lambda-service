resource "aws_apigatewayv2_api" "this" {
  name                         = data.ns_workspace.this.hyphenated_name
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = true
  target                       = aws_lambda_function.this.invoke_arn
  tags                         = data.ns_workspace.this.tags

  count = local.has_subdomain ? 1 : 0
}

locals {
  domain_name_configurations = local.subdomain_cert_arn != "" ? [] : []
}

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = local.subdomain_name
  tags        = data.ns_workspace.this.tags

  dynamic "domain_name_configuration" {
    for_each = compact([local.subdomain_cert_arn])
    content {
      certificate_arn = domain_name_configuration.value
      endpoint_type   = "REGIONAL"
      security_policy = "TLS_1_2"
    }
  }

  count = local.has_subdomain ? 1 : 0
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id      = aws_apigatewayv2_api.this[count.index].id
  domain_name = aws_apigatewayv2_domain_name.this[count.index].domain_name
  stage       = "$default"

  count = local.has_subdomain ? 1 : 0
}
