# AzureRM Native Actions Reference

Use this reference to match Azure resources in a Terraform codebase to available native `action "<azurerm_action_type>"` operations.

> [!TIP] ✨ When a codebase contains an `action "azapi_resource_action"` block that can be replaced by a native azurerm action listed here, flag it with ✨ and recommend migrating. Native actions are provider-validated, require no ARM type string or API version, and have long-term HashiCorp support.

---

## Available actions

|azurerm / azapi resource|Action type|Required params|Optional params|Possible values|
|---|---|---|---|---|
|`azurerm_linux_virtual_machine` `azurerm_windows_virtual_machine`|`azurerm_virtual_machine_power`|`virtual_machine_id`, `power_action`|`timeout` (default: `30m`)|`power_action`: `restart` \| `power_on` \| `power_off`|
|`azurerm_cdn_frontdoor_endpoint`|`azurerm_cdn_front_door_cache_purge`|`front_door_endpoint_id`, `content_paths`|`domains`, `timeout` (default: `15m`)|`content_paths`: list of paths e.g. `["/*"]`; `domains`: list of custom domain names|
|`azurerm_managed_redis`|`azurerm_managed_redis_databases_flush`|`managed_redis_database_id`|`linked_database_ids`, `timeout` (default: `15m`)|—|
|`azurerm_mssql_job`|`azurerm_mssql_execute_job`|`job_id`|`timeout` (default: `15m`), `wait_for_completion` (default: `false`)|—|
|`azurerm_data_protection_backup_instance_postgresql_flexible_server` (and other backup instance types)|`azurerm_data_protection_backup_instance_protect`|`backup_instance_id`, `protect_action`|—|`protect_action`: `stop_protection` \| `resume_protection` \| `suspend_backups` \| `resume_backups`|