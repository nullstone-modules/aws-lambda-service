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
