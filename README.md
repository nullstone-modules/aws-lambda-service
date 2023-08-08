# Lambda Application

Create a Nullstone application that is served through AWS Lambda.

This application module creates an AWS Lambda using the built-in runtimes that AWS Lambda offers (see https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html).

## When to use

AWS Lambda is a great choice for applications that require short bursts of execution (< 15 minutes).
There are no servers to manage.
Security and deployment are controlled explicitly through infrastructure code.

## Security & Compliance

Security scanning is graciously provided by [Bridgecrew](https://bridgecrew.io/).
Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/general)
![CIS AWS V1.3](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/cis_aws_13)
![PCI-DSS V3.2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/pci)
![NIST-800-53](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/nist)
![ISO27001](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/iso)
![SOC2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/soc2)
![HIPAA](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/hipaa)

## Network Access

Nullstone places the Lambda Function into private subnets for the connected network.
As a result, the Lambda Function can route to services on the private network.

## Execution

This application module supports various capabilities to handle execution of a Lambda Function.
- Ingress: Enables public access to execute Lambda as HTTP Request (e.g. API Gateway capabilities)
- Trigger: Enable events to execute Lambda (e.g. Cron Trigger, SQS Queue)
- CLI Execution: `nullstone exec` (See [`exec`](https://docs.nullstone.io/getting-started/cli/docs.html#exec) for more information)

## Logs

Logs are automatically emitted to AWS Cloudwatch Log Group: `/aws/lambda/<function-name>`.
To access through the Nullstone CLI, use `nullstone logs` CLI command. (See [`logs`](https://docs.nullstone.io/getting-started/cli/docs.html#logs) for more information)

## Secrets

Nullstone cannot automatically inject secrets into your Lambda application.
Instead, Nullstone injects environment variables that refer to secrets stored in AWS Secrets Manager.
If the Nullstone app has a secret `POSTGRES_URL`, Nullstone will inject `POSTGRES_URL_SECRET_ID` that contains the Secrets Manager Secret ID to retrieve.

For more information on how to retrieve secrets for your language, check out [Retrieve secrets from AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/retrieving-secrets.html).
