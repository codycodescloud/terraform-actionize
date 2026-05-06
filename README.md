# terraform-actionizer

A Claude Code skill that finds and implements native Terraform Actions for Azure resources. Supports day-2 operations like key rotation, start/stop, failover, and cache purge across the `azurerm` and `azapi` providers.

**Requirements:** `terraform >= 1.14` and `azapi >= 2.9`

## Installation

Clone the repo and symlink the skill into your Claude Code skills directory:

```bash
git clone https://github.com/codycodescloud/terraform-actionizer.git ~/terraform-actionizer
ln -s ~/terraform-actionizer/terraform-actionizer ~/.claude/skills/terraform-actionizer
```

Then invoke it in any Claude Code session:

```
/terraform-actionizer
```

## Updating

```bash
cd ~/terraform-actionizer && git pull
```

## Learn More

[The Terraform Actions Are Inside the AzAPI](https://blog.codycodes.cloud/the-terraform-actions-are-inside-the-azapi) — background on how native Terraform Actions work via the AzAPI provider.

## License

MIT © codycodescloud
