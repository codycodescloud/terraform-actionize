# AzAPI Actions Reference

Use this reference to match azurerm / azapi resources in a Terraform codebase to available `action "azapi_resource_action"` operations.

---

## Credential rotation

|azurerm / azapi resource|ARM Type|action =|Params|Body|
|---|---|---|---|---|
|`azurerm_storage_account`|`Microsoft.Storage/storageAccounts@2024-01-01`|`regenerateKey`|`keyName` — ask: `key1` or `key2` (default: `key1`)|`{ keyName = "key1" }`|
|`azurerm_redis_cache`|`Microsoft.Cache/redis@2024-11-01`|`regenerateKey`|`keyType` — ask: `Primary` or `Secondary` (default: `Primary`)|`{ keyType = "Primary" }`|
|`azurerm_redis_enterprise_database`|`Microsoft.Cache/redisEnterprise/databases@2024-10-01`|`regenerateKey`|`keyType` — ask: `Primary` or `Secondary`|`{ keyType = "Primary" }` — async 202|
|`azurerm_eventhub_namespace_authorization_rule`|`Microsoft.EventHub/namespaces/authorizationRules@2024-01-01`|`regenerateKeys`|`keyType` — ask: `PrimaryKey` or `SecondaryKey`|`{ keyType = "PrimaryKey" }`|
|`azurerm_eventhub_authorization_rule`|`Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2024-01-01`|`regenerateKeys`|`keyType` — ask: `PrimaryKey` or `SecondaryKey`|`{ keyType = "PrimaryKey" }`|
|`azurerm_servicebus_namespace_authorization_rule`|`Microsoft.ServiceBus/namespaces/AuthorizationRules@2021-11-01`|`regenerateKeys`|`keyType` — ask: `PrimaryKey` or `SecondaryKey`|`{ keyType = "PrimaryKey" }`|
|`azurerm_servicebus_queue_authorization_rule`|`Microsoft.ServiceBus/namespaces/queues/authorizationRules@2021-11-01`|`regenerateKeys`|`keyType` — ask: `PrimaryKey` or `SecondaryKey`|`{ keyType = "PrimaryKey" }`|
|`azurerm_cosmosdb_account`|`Microsoft.DocumentDB/databaseAccounts@2024-11-15`|`regenerateKey`|`keyKind` — ask: `primary`, `secondary`, `primaryReadonly`, `secondaryReadonly`|`{ keyKind = "primary" }` — async 202|
|`azurerm_cognitive_account`|`Microsoft.CognitiveServices/accounts@2024-10-01`|`regenerateKey`|`keyName` — ask: `Key1` or `Key2` (capital K)|`{ keyName = "Key1" }`|
|`azurerm_search_service`|`Microsoft.Search/searchServices@2025-05-01`|`regenerateAdminKey/primary`|`key` — infer from action path: `primary` or `secondary`|`{}` — kind in URL path, not body|
|`azurerm_signalr_service`|`Microsoft.SignalRService/signalR@2024-03-01`|`regenerateKey`|`keyType` — ask: `Primary`, `Secondary`, or `Salt`|`{ keyType = "Primary" }` — async 202|
|`azurerm_web_pubsub`|`Microsoft.SignalRService/webPubSub@2024-03-01`|`regenerateKey`|`keyType` — ask: `Primary` or `Secondary`|`{ keyType = "Primary" }` — async 202|
|`azurerm_container_registry`|`Microsoft.ContainerRegistry/registries@2023-11-01`|`regenerateCredential`|`name` — ask: `password` or `password2`|`{ name = "password" }` — requires `admin_enabled = true`|
|`azurerm_maps_account`|`Microsoft.Maps/accounts@2024-07-01-preview`|`regenerateKey`|`keyType` — ask: `primary` or `secondary` (lowercase)|`{ keyType = "primary" }`|
|`azurerm_relay_namespace_authorization_rule`|`Microsoft.Relay/namespaces/authorizationRules@2024-01-01`|`regenerateKeys`|`keyType` — ask: `PrimaryKey` or `SecondaryKey`|`{ keyType = "PrimaryKey" }`|

---

## App Service and Function Apps

|azurerm / azapi resource|ARM Type|action =|Params|Body / Notes|
|---|---|---|---|---|
|`azurerm_linux_web_app` `azurerm_windows_web_app`|`Microsoft.Web/sites@2024-11-01`|`slotsswap`|`targetSlot` — ask if not `production`; `preserveVnet` — default `true`|`{ targetSlot = "production", preserveVnet = true }` — both fields required|
|`azurerm_linux_web_app_slot` `azurerm_windows_web_app_slot`|`Microsoft.Web/sites/slots@2024-11-01`|`slotsswap`|`targetSlot` — ask if not `production`|Same body|
|`azurerm_linux_web_app` `azurerm_linux_function_app`|`Microsoft.Web/sites@2024-11-01`|`restart`|None — infer `resource_id` from codebase|`{}` — add `query_parameters = { softRestart = ["false"], synchronous = ["true"] }`|
|`azurerm_linux_web_app`|`Microsoft.Web/sites@2024-11-01`|`start` / `stop`|None|`{}`|
|`azurerm_linux_function_app`|`Microsoft.Web/sites@2024-11-01`|`syncfunctiontriggers`|None|`{}` — re-registers all trigger bindings|
|`azurerm_linux_web_app`|`Microsoft.Web/sites@2024-04-01`|`applySlotConfig`|`targetSlot` — ask which slot|`{ targetSlot = "staging" }`|
|`azurerm_linux_web_app`|`Microsoft.Web/sites@2024-04-01`|`resetSlotConfig`|None|`{}`|

---

## CDN and Front Door cache purge

> [!NOTE] Classic Azure CDN is retired — no new resources since August 2025. Use AFD Standard/Premium for all new work.

|azurerm / azapi resource|ARM Type|action =|Params|Body|
|---|---|---|---|---|
|`azurerm_cdn_frontdoor_endpoint`|`Microsoft.Cdn/profiles/afdEndpoints@2025-04-15`|`purge`|`contentPaths` — ask (default: `["/*"]`); `domains` — ask, optional|`{ contentPaths = ["/*"], domains = ["www.example.com"] }`|

---

## Cost and lifecycle: start / stop / pause / resume

|azurerm / azapi resource|ARM Type|action =|Params|Notes|
|---|---|---|---|---|
|`azurerm_kubernetes_cluster`|`Microsoft.ContainerService/managedClusters@2024-09-01`|`start` / `stop`|None — infer `resource_id`|VMSS-backed only|
|`azurerm_firewall`|`Microsoft.Network/azureFirewalls@2024-05-01`|`deallocate` / `allocate`|None|Highest savings ~$500–700/mo non-prod|
|`azurerm_application_gateway`|`Microsoft.Network/applicationGateways@2024-05-01`|`start` / `stop`|None|V2 SKU only|
|`azurerm_mssql_managed_instance`|`Microsoft.Sql/managedInstances@2023-08-01`|`start` / `stop`|None|General Purpose tier only|
|`azurerm_synapse_sql_pool`|`Microsoft.Synapse/workspaces/sqlPools@2021-06-01`|`pause` / `resume`|None||
|`azurerm_mssql_database`|`Microsoft.Sql/servers/databases@2021-11-01`|`pause` / `resume`|None|DW SKU only — not serverless|
|`azurerm_linux_virtual_machine_scale_set`|`Microsoft.Compute/virtualMachineScaleSets@2024-11-01`|`start` / `deallocate` / `powerOff` / `restart` / `redeploy` / `reimageall`|`instanceIds` — ask if targeting specific instances, otherwise omit|`{}` or `{ instanceIds = ["0","1"] }`|
|`azurerm_kusto_cluster`|`Microsoft.Kusto/clusters@2024-04-13`|`start` / `stop`|None||
|`azurerm_analysis_services_server`|`Microsoft.AnalysisServices/servers@2017-08-01`|`suspend` / `resume`|None||
|`azurerm_data_factory_trigger_schedule`|`Microsoft.DataFactory/factories/triggers@2018-06-01`|`start` / `stop`|None||
|`azurerm_data_factory_integration_runtime_azure_ssis`|`Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01`|`start` / `stop`|None||
|`azurerm_spring_cloud_service`|`Microsoft.AppPlatform/Spring@2022-05-01-preview`|`start` / `stop`|None||

---

## DR, failover, and runCommand

|azurerm / azapi resource|ARM Type|action =|Params|Body / Notes|
|---|---|---|---|---|
|`azurerm_cosmosdb_account`|`Microsoft.DocumentDB/databaseAccounts@2024-11-15`|`failoverPriorityChange`|`failoverPolicies` — must ask: region names + priority order|`{ failoverPolicies = [{ locationName = "westus2", failoverPriority = 0 }] }`|
|`azurerm_mssql_failover_group`|`Microsoft.Sql/servers/failoverGroups@2023-08-01`|`failover`|None — target secondary server's failover group|`{}`|
|`azurerm_mssql_failover_group`|`Microsoft.Sql/servers/failoverGroups@2023-08-01`|`forceFailoverAllowDataLoss`|None|`{}`|
|`azurerm_storage_account`|`Microsoft.Storage/storageAccounts@2023-05-01`|`failover`|`failoverType` — ask: `Planned` (reversible) or omit (unplanned, converts to LRS)|`query_parameters = { failoverType = ["Planned"] }`|
|`azurerm_linux_virtual_machine`|`Microsoft.Compute/virtualMachines@2024-11-01`|`runCommand`|`commandId` — default `RunShellScript`; `script` — must ask|`{ commandId = "RunShellScript", script = ["echo hello"] }`|
|`azurerm_kubernetes_cluster`|`Microsoft.ContainerService/managedClusters@2025-03-01`|`runCommand`|`command` — must ask|`{ command = "kubectl get pods", context = "" }` — async, poll `commandResults/{id}`|
|`azurerm_kubernetes_cluster`|`Microsoft.ContainerService/managedClusters@2025-05-01`|`rotateClusterCertificates`|None|`{}` — causes node restarts|
|`azurerm_kubernetes_cluster`|`Microsoft.ContainerService/managedClusters@2025-05-01`|`rotateServiceAccountSigningKeys`|None|`{}`|

---

## Irreversible / Persistent Data Purge

> [!TIP] Present all actions in this section with a warning emoji ⚠️. These operations may have irreversible consequences and should be used with cognizance and caution.

| azurerm / azapi resource           | ARM Type                                                | action = | Params                                                                                                                               | Notes                                                           |
| ---------------------------------- | ------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------- |
| `azurerm_key_vault` (soft-deleted) | `Microsoft.KeyVault/locations/deletedVaults@2024-11-01` | `purge`  | None — `resource_id` is non-standard, must be `/subscriptions/{s}/providers/Microsoft.KeyVault/locations/{loc}/deletedVaults/{name}` | Permanent                                                       |
| `azurerm_log_analytics_workspace`  | `Microsoft.OperationalInsights/workspaces@2025-07-01`   | `purge`  | `table` — must ask; `filters` — must ask (column, operator, value)                                                                   | Permanent, throttled 50/hr                                      |
| `azurerm_application_insights`     | `Microsoft.Insights/components@2015-05-01`              | `purge`  | `table`, `filters` — must ask                                                                                                        | Workspace-based AppInsights must purge via LAW endpoint instead |
| `azurerm_virtual_network_gateway`  | `Microsoft.Network/virtualNetworkGateways@2024-05-01`   | `reset`  | `gatewayVip` — ask only if active-active (optional)                                                                                  | `{}`                                                            |

---

## Not possible via AzAPI — data plane operations

> [!TIP] Present these with a magnifying glass emoji 🔎 when a matched resource exists in the codebase but the requested action is not reachable via `action "azapi_resource_action"` because it targets a data plane endpoint rather than the ARM management plane.

|azurerm / azapi resource|Operation|Reason|Alternative|
|---|---|---|---|
|`azurerm_databricks_workspace`|Cluster start / stop|Data plane: `{ws}.azuredatabricks.net/api/2.0/clusters`|Databricks Terraform provider|
|`azurerm_synapse_workspace`|Pipeline trigger start / stop|Data plane: `{ws}.dev.azuresynapse.net`|`az synapse trigger start/stop`|
|`azurerm_key_vault`|Key / secret / certificate purge (item-level)|Data plane: `{vault}.vault.azure.net`|`az keyvault {key\|secret\|certificate} purge`|
|`azurerm_iothub`|Key rotation|No atomic ARM verb — client-side PATCH only|`az iot hub policy renew-key`|
|`azurerm_mssql_database` (serverless)|Pause / resume|No ARM verb — only `autoPauseDelay` property|Set `auto_pause_delay_in_minutes` in `azurerm_mssql_database`|
