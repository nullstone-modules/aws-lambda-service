# Lambda Application

Create a Nullstone application that is served through AWS Lambda.

This application module creates an AWS Lambda using the built-in runtimes that AWS Lambda offers (see https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html).

## When to use

AWS Lambda is a great choice for applications that require short bursts of execution (< 15 minutes).
There are no servers to manage.
Security and deployment are controlled explicitly through infrastructure code.
