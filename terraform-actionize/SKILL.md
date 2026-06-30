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

### Step 4: Discover AzureRM Actions
Discover which `azurerm` actions the workspace's installed provider supports; if the local
schema can't be read, fall back to the latest published list. DO NOT RUN OR READ
`terraform providers schema -json` DIRECTLY: the script distills the specific provider info as the raw schema is far
too large for context.

#### Step 4.A: Use the script for azurerm action discovery
When `bash`, `jq`, and `terraform` are available, run:
```bash
bash scripts/discover-azurerm-actions.sh 
```
This is authoritative: it reflects the `azurerm` version installed in the current workspace.
If the script does not execute or returns a non-zero exit code, go to Step 4.B.

#### Step 4.B: Fall back to the latest published list
Use WebFetch to pull https://raw.githubusercontent.com/quixoticmonk/extract-provider-supported-actions/main/actions-report.json and filter for the  `azurerm` provider. This is the latest published list, not the user's
installed version — before implementing any action from it, tell the user to run
`terraform init -upgrade` so a compatible provider is installed (and to raise their version
constraint if the action still doesn't resolve).

### Step 5: Confirm with User Actions to Implement
Decide which actions to contribute to the user's codebase by cross-referencing three sources:

- **Discovery (Step 4) = availability gate.** Treat the discovered list as the set of
  *available* action names; a reference action is a candidate only if its name appears in it
  (if discovery came from Step 4.B, apply its upgrade caveat first.)
- **References = metadata.** For each candidate, read its entry in `references/azurerm-actions.md`
  or `references/azapi-actions.md` for its category (standard, purge, migration target) and
  implementation snippet.
- **Existing code (Step 1) = exclusion.** Drop actions already implemented — *unless* the
  existing usage is the non-native resource form (`resource.azapi_resource_action` / `action.azapi_resource_action`) and an
  available native equivalent (`action.azurerm_*`) exists.

> Data-plane-only operations using `action.azapi_resource_action` are exempt from the availability gate — they won't work with this action because they use separate endpoints. Surface them for awareness only.

**Tag each surfaced action so the user can scan intent and risk:**
* ✨ — an existing generic `azapi` action that can be migrated to an available `azurerm` native
  equivalent; put ✨ next to the resource with the recommendation and the **name of the target
  action** to migrate to.
* ⚠️ — listed under the irreversible / persistent data-purge section; flag the potential for
  permanent data deletion.
* 🔎 — a data-plane operation that cannot become a usable action (azapi can't reach the data
  plane); surface for understanding only.
* ✔️ — any other implementable `azapi` or `azurerm` action.

Present the tagged list and let the user pick which actions to implement.

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