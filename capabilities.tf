// This file is replaced by code-generation using 'capabilities.tf.tmpl'
// This file helps app module creators define a contract for what types of capability outputs are supported.
locals {
  capabilities = {
    env = [
      {
        name  = ""
        value = ""
      }
    ]

    secrets = [
      {
        name  = ""
        value = ""
      }
    ]

    // private_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    private_urls = [
      {
        url = ""
      }
    ]

    // public_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    public_urls = [
      {
        url = ""
      }
    ]

    log_configurations = [
      {
        logDriver = "awslogs"
        options = {
          "awslogs-region"        = data.aws_region.this.name
          "awslogs-group"         = module.logs.name
          "awslogs-stream-prefix" = local.block_name
        }
      }
    ]

    permissions = [
      {
        // required
        sid_prefix = ""
        action     = "lambda:InvokeFunction" // lambda:InvokeFunction | lambda:GetFunction
        principal  = ""

        // optional
        source_arn             = ""
        source_account         = ""
        event_source_token     = ""
        qualifier              = ""
        revision_id            = ""
        principal_org_id       = ""
        function_url_auth_type = ""
      }
    ]
  }
}
