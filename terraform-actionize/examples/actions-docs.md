# Actions — invoke reference

```bash
# rotates storage account key1
terraform apply -invoke=action.azapi_resource_action.rotate_storage_key

# restarts the virtual machine
terraform apply -invoke=action.azurerm_virtual_machine_power.example
```

Another option is to put the cli invocation directly above the action in a comment, like so:

```hcl
# Invoke: terraform apply -invoke=action.azurerm_virtual_machine_power.example
action "azurerm_virtual_machine_power" "example" {
  config {
    virtual_machine_id = azurerm_linux_virtual_machine.this.id
    power_action       = "restart"
  }
}
```