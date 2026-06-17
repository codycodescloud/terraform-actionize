# terraform-actionize

![MIT License](https://img.shields.io/badge/license-MIT-blue)
![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.14-purple)
![AzAPI](https://img.shields.io/badge/azapi-%3E%3D2.9-blueviolet)

A Claude Code skill that finds and implements native Terraform Actions for Azure resources. Supports day-2 operations like key rotation, start/stop, failover, and cache purge across the `azurerm` and `azapi` providers.

Generates ready-to-run `action` blocks with invocation commands and optional documentation (`actionize.md`) for your whole team.

## Installation

Clone and symlink the skill into your Claude Code skills directory:

```bash
git clone https://github.com/codycodescloud/terraform-actionize.git ~/terraform-actionize
ln -s ~/terraform-actionize/terraform-actionize ~/.claude/skills/terraform-actionize
```

Then invoke it in any Claude Code session inside a Terraform project:

```
/terraform-actionize
```

To update later: `cd ~/terraform-actionize && git pull`

## Demo
<img width="960" height="627" alt="image" src="https://github.com/user-attachments/assets/ba62e97f-7d71-4f65-919c-9666655c9443" />

## Contributing

Found a missing action or a bug? [Open an issue](https://github.com/codycodescloud/terraform-actionize/issues) — contributions welcome.

## Learn More

* [Terraform-Actionize Blog Post](https://blog.codycodes.cloud/terraform-actionize)
* [Unlocking more Terraform Actions on Azure with AzAPI](https://blog.codycodes.cloud/unlocking-more-terraform-actions-on-azure-with-azapi)

## License

MIT © codycodescloud
