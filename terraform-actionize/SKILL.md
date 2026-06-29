---
name: terraform-actionize
description: Finds and implements native Terraform Actions for Azure resources in a Terraform codebase. Supports the azurerm and azapi providers. Requires terraform >= 1.14 and azapi >= 2.9.
when_to_use: Use when the user wants to discover Terraform Actions compatible with their Terraform resources, migrate existing azapi Terraform Actions to azurerm, generate terraform apply -invoke= commands for their actions, or find new day-2 operations (start/stop, key rotation, failover, cache purge) available for their Azure resources.
allowed-tools: Read
license: MIT
compatibility: terraform >= 1.14, azapi >= 2.9
---
# Terraform Actionize

## Instructions

### Step 1: Analyze the User's Codebase
Examine the user's existing Terraform code -- specifically look for each resource definition they use and any existing actions that exist. Also confirm that they're using `terraform >= 1.14` and `azapi >= 2.9` for their version constraints. If either constraint is not satisfied, inform the user that these versions are required to use this skill and do not proceed until they confirm the constraints have been met. If they have existing actions for azapi, you can analyze them in step 2 or skip to step 3.

### Step 2: Review Potential AzAPI to AzureRM Action Migrations
Use the `references/azurerm-actions.md` document to understand what skills currently exist for Terraform Actions in the `azurerm` provider. `references/examples-azapi-vs-azurerm-actions.md` shows what this looks like in practice.

### Step 3: Review Potential AzAPI Actions to Add to Codebase
Use the `references/azapi-actions.md` document to understand what skills currently exist for Terraform Actions in the `azapi` provider.

### Step 4: Confirm with User Actions to Implement
Work with the user to decide which actions they want to implement based on the `azurerm-actions.md` and `azapi-actions.md` references: these will turn into actions they want to have contributed to their codebase. Only surface actions that do not already exist in the codebase — do not suggest actions the user has already implemented, unless they are not native Terraform Actions and there is an equivalent (e.g. `resource.azapi_resource_action` vs `action.azapi_resource_action`). Pay particular attention to the following:
* If there are any actions using `action.azapi_resource_action` that can be migrated, then you can give a ✨ emoji next to each resource with the recommendation to migrate as well as the name of the resource to migrate to.
* If there are any actions listed under irreversible / persistent data purge section, please indicate their potential for permanent data deletion and give a ⚠️ emoji next to them
* If there are any operations that cannot be used with the `azapi` provider because they use the data plane, you can call them out and give them a 🔎 emoji. These cannot be turned into usable actions, but are helpful to surface for the user's understanding
* All other implementable `azapi` or `azurerm` actions can simply be identified with a checkmark emoji ✔️

If no new actions are applicable to the codebase, or the user does not wish to add any, provide a brief summary of what was found (e.g. resources scanned, any existing actions already in place) and end the skill gracefully.

### Step 5:  Implement the User's Requested Action(s) Based on Supplied Input
Finally, confirm with the user where the actions should be implemented. By default offer to place them in an `actions.tf` file, however you can also recommend to co-locate actions next to the resources they act upon by placing them directly after the resources themselves. For each new action selected to implement, use the `references/examples-azapi-action.md` and `references/examples-azapi-vs-azurerm-actions.md` and ensure that any parameters listed have their defaults called out as well as information for the user to decide what values they want to use in creating each `action.azapi_resource_action`. If migrating from an `azapi` to `azurerm` action, please use `references/examples-azapi-vs-azurerm-actions.md` as well as the latest information on the `azurerm` provider for said Terraform action (including `references/azurerm-actions.md`) as your source of truth.

As a minimal example, powering on a virtual machine with the native azurerm action is just a `power_on` for the `power_action` argument:

```hcl
# Invoke with: terraform apply -invoke=action.azurerm_virtual_machine_power.start_vm
action "azurerm_virtual_machine_power" "start_vm" {
  config {
    virtual_machine_id = azurerm_linux_virtual_machine.this.id
    power_action       = "power_on"
  }
}
```

### Step 5.5: Confirm Invocation Arguments

Before proceeding, ask the user whether they use any additional `terraform apply` arguments 
(e.g. `-var`, `-var-file`, `-backend-config`). Record the answer and apply it to all 
generated `terraform apply -invoke=` commands and any documentation.

### Step 6: Provide Documentation
Once the actions are implemented, request the user to confirm generating an `actionize.md` or other file/location on how to invoke all the actions created (or another method if supplied). Each doc should follow `references/examples-actions-docs.md`.

Once completed with adding the actions and generating docs provide a success message, a nerd emoji  🤓, and something fun or whitty about doing day-2 ops with Terraform.