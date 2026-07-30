#!/usr/bin/env bash
# discover-azurerm-actions.sh
#
# Inspired by quixoticmonk/extract-provider-supported-actions (extract_provider_resources.sh).
#
# Differences from the original:
#   * Scoped to the azurerm provider only.
#   * Does NOT run `terraform init -upgrade` — it never mutates the lockfile or bumps provider
#     versions. It reads whatever azurerm version is ALREADY installed in this workspace, so the
#     result reflects the user's actual pinned versions.
#
# The multi-megabyte provider schema is held in a shell variable and distilled by jq; only the
# sorted action names are printed, so the heavy JSON never reaches the agent's context.
#
# Requires : terraform (workspace already initialized), jq.
# Output   : {"azurerm": [ ...sorted action names... ]}
# Exit     : non-zero if the schema can't be read (e.g. workspace not initialized) — the caller
#            should then fall back to the pre-computed community catalog.
set -euo pipefail

PROVIDER="azurerm"
SCHEMA_KEY="action_schemas"

# Read the schema once; if terraform errors (not initialized), set -e aborts -> caller falls back.
schema="$(terraform providers schema -json)"

provider_key="$(printf '%s' "$schema" | jq -r '.provider_schemas | keys[]' | grep "/${PROVIDER}$" || true)"

if [ -n "$provider_key" ]; then
  printf '%s' "$schema" \
    | jq -r "{\"$PROVIDER\": (.provider_schemas.\"${provider_key}\" | .${SCHEMA_KEY} // {} | keys | sort)}"
else
  echo "{\"$PROVIDER\": []}"
fi