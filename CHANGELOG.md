# 0.17.0 (Oct 2, 2026)
* Upgraded `nullstone-io/ns` provider to `~> 0.13.0`.
* Replaced `ns_env_variables` and `ns_secret_keys` with the layered `ns_env_layout`, `ns_env_values`, and `ns_env_platform_data` data sources to aggregate environment variables and secrets.
* Emitted the `env` platform data record, including the source of each variable and the Secrets Manager ARN of each managed secret.
* Reported the reserved variables Lambda sets on the function (`AWS_REGION`, `AWS_DEFAULT_REGION`, `AWS_LAMBDA_FUNCTION_NAME`, `AWS_LAMBDA_FUNCTION_MEMORY_SIZE`) in the `cloud` layer of the `env` platform data record.
* Upgraded capability scaffolding to emit `capability` on capability outputs and `cap_prefixes`.

# 0.16.0 (Jul 30, 2026)
* Added optional `notification` connection to configure monitoring on error rates.

# 0.15.0 (Jun 18, 2026)
* Upgraded capability scaffolding to reduce conflicts.
* Used `aws_tags` from upgraded `data.ns_workspace`.

# 0.14.3 (Jul 10, 2026)
* Fixed ns tf provider.

# 0.14.2 (Jun 10, 2026)
* Upgraded terraform providers.

# 0.14.1 (May 08, 2026)
* Fixed module manifest to use OpenTofu.

# 0.14.0 (May 08, 2026)
* Switched to OpenTofu.
* Migrated app scaffold to open-source module.
* Updated `var.runtime` description with supported runtimes.

# 0.13.5 (Mar 05, 2026)
* Upgrade to latest ns terraform provider to improve env var interpolation

# 0.13.4 (Sep 22, 2025)
* Restored "existing" secret refs that were removed in v0.13.0 upgrade.

# 0.13.3 (Sep 22, 2025)
* Prevent resource recreation as a result of changes in v0.13.0 upgrade.

# 0.13.2 (Sep 22, 2025)
* Fixed syntax from v0.13.0 upgrade.

# 0.13.1 (Sep 22, 2025)
* Fixed syntax from v0.13.0 upgrade.

# 0.13.0 (Sep 22, 2025)
* Upgrade terraform providers.

# 0.12.27 (Feb 27, 2025)
* Fixed `topics` usage from `event_sources` in capabilities.

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
