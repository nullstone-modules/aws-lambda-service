# 0.12.26 (Jan 22, 2025)
* When an app secret is removed, it is immediately deleted from AWS secrets manager.

# 0.12.25 (Jul 18, 2024)
* Added the ability to reference existing secrets using interpolation.
* e.g. "{{ secret(arn-of-existing-secret) }}"

* # 0.12.21 (Feb 06, 2024)
* Added support for metrics in capabilities.

# 0.12.20 (Feb 01, 2024)
* Fixed secrets policy to set resources to `[<arn>, ...]` instead of `[[<arn>,...]]`.

# 0.12.19 (Feb 01, 2024)
* Fixed usage of `for_each` in secrets policy.

# 0.12.18 (Jan 24, 2024)
* Fixed secrets policy when no secrets are specified.
* Enabled `metrics_reader` to access Cloudwatch metrics.

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
