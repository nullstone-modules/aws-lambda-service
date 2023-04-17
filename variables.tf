variable "memory" {
  type        = number
  default     = 128
  description = <<EOF
The amount of memory to reserve and cap the service.
If the service exceeds this amount, the service will be killed with exit code 127 representing "Out-of-memory".
Memory is measured in MiB, or megabytes.
This means the default is 128 MiB or 0.125 GiB.
EOF
}

variable "timeout" {
  type        = number
  default     = 3
  description = <<EOF
The maximum number of seconds the service is allotted to execute.
The maximum this can be set is 900 seconds (15 minutes).
EOF
}

variable "runtime" {
  type        = string
  description = <<EOF
The runtime of the service.
This can be set to one of nodejs, nodejs4.3, nodejs6.10, nodejs8.10, nodejs10.x, nodejs12.x, nodejs14.x, java8, java8.al2, java11, python2.7, python3.6, python3.7, python3.8, dotnetcore1.0, dotnetcore2.0, dotnetcore2.1, dotnetcore3.1, nodejs4.3-edge, go1.x, ruby2.5, ruby2.7, provided, provided.al2.
EOF
}

variable "handler" {
  type        = string
  description = <<EOF
The entrypoint defined in the code that AWS executes when running the lambda.
See https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-features.html#gettingstarted-features-programmingmodel for runtime-specific instructions.
EOF
}
