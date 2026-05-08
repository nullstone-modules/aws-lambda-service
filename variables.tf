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
As of this publishing, the possible values supported by AWS Lambda for zip-packaged functions are:
nodejs24.x, nodejs22.x, python3.14, python3.13, python3.12, python3.11, python3.10, java25, java21, java17, java11, java8.al2, dotnet10, dotnet8, ruby4.0, ruby3.4, ruby3.3, provided.al2023, provided.al2.
https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html#runtimes-supported
EOF
}

variable "handler" {
  type        = string
  description = <<EOF
The entrypoint defined in the code that AWS executes when running the lambda.
See https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-features.html#gettingstarted-features-programmingmodel for runtime-specific instructions.
EOF
}
