# AzureRM Action Examples

## VM power — original AzAPI action & response

✨ This action has been migrated to the native azurerm provider action below. This block will be removed from the codebase once migration is confirmed.

```hcl
action "azapi_resource_action" "restart_vm" {
  config {
    type        = "Microsoft.Compute/virtualMachines@2024-11-01"
    resource_id = azurerm_linux_virtual_machine.this.id
    action      = "restart"
    method      = "POST"
  }
}
```

---

## VM power — migrated to native azurerm action

Replaces the `azapi_resource_action` block above. Provider-validated schema — no ARM type string or API version to maintain.

```hcl
action "azurerm_virtual_machine_power" "example" {
  config {
    virtual_machine_id = azurerm_linux_virtual_machine.this.id
    power_action       = "restart"
  }
}
```