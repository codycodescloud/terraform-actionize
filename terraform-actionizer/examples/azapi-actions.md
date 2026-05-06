# AzAPI Action Examples

## Generic template

Replace `type`, `resource_id`, `action`, `method`, and `body` for any ARM action.

```hcl
action "azapi_resource_action" "<name>" {
  config {
    type        = "<ARM resource type>@<api-version>"
    resource_id = <resource>.<label>.id
    action      = "<arm-action-verb>"
    method      = "POST"
    body = {
      <key> = "<value>"
    }
  }
}
```

---

## Storage account key rotation

Rotates `key1` on a storage account.

```hcl
action "azapi_resource_action" "rotate_storage_key" {
  config {
    type        = "Microsoft.Storage/storageAccounts@2023-05-01"
    resource_id = azurerm_storage_account.this.id
    action      = "regenerateKey"
    method      = "POST"
    body = {
      keyName = "key1"
    }
  }
}
```