# 0.12.17 (Jan 16, 2024)
* Added metrics outputs to enable real-time monitoring.

# 0.12.16 (Nov 03, 2023)
* Added `invoke_arn` to `app_metadata` for capabilities.

# 0.12.1 (Aug 08, 2023)
* Updated `README.md` with application management info.

# 0.12.0 (Aug 08, 2023)
* Added compliance scanning.
* Added support for dead letter queue capabilities.
* Enabled concurrency execution limit of 100.
* Enabled X-Ray tracing.
* Fixed compliance issues.

# 0.11.1 (Aug 01, 2023)
* Configure S3 Bucket ownership so ACL can be configured properly.

# 0.11.0 (Apr 25, 2023)
* Dropped `service_` prefix from variables.

# 0.10.0 (Feb 28, 2023)
* Added support for environment variable interpolation.
* Fixed generation of capability variables when the variable has no value.
