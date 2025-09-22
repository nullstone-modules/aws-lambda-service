// This file is replaced by code-generation using 'capabilities.tf.tmpl'
// This file helps app module creators define a contract for what types of capability outputs are supported.
locals {
  cap_modules = [
    {
      name       = ""
      tfId       = ""
      namespace  = ""
      env_prefix = ""
      outputs    = {}
    }
  ]

  cap_env_vars = {}
  cap_secrets  = {}

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
          "awslogs-region"        = data.aws_region.this.region
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

    event_sources = [
      {
        // required
        name       = "" // used to uniquely identify the event source
        source_arn = ""

        // optional
        enabled           = true
        batch_size        = null // number
        starting_position = null // string
        topic             = []   // list(string)
      }
    ]

    dead_letter_queues = [
      {
        queue_arn = ""
      }
    ]

    // metrics allows capabilities to attach metrics to the application
    // These metrics are displayed on the Application Monitoring page
    // See https://docs.nullstone.io/extending/metrics/aws-cloudwatch.html#metrics-mappings
    metrics = [
      {
        name = ""
        type = "usage|usage-percent|duration|generic"
        unit = ""

        mappings = "{}"
      }
    ]
  }
}
