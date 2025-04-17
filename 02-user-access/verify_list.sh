#!/bin/bash

CONTROLLER_URL="https://controller.lab.example.com"
ADMIN_USER="admin"
ADMIN_PASS="redhat"

tower-cli config host "$CONTROLLER_URL"
tower-cli config username "$ADMIN_USER"
tower-cli config password "$ADMIN_PASS"
tower-cli config verify_ssl false

echo "📋 Verifying assigned roles for each user by organization..."
echo

for ORG_FILE in generated_users/*.txt; do
  ORG_NAME=$(basename "$ORG_FILE" .txt)
  echo "🏢 Organization: $ORG_NAME"

  while IFS=: read -r USER ROLE; do
    [[ -z "$USER" || -z "$ROLE" ]] && continue

    echo "  🔎 $USER (expected role: $ROLE)"
    tower-cli role list --user "$USER" -f human | grep -i "$ORG_NAME" | sed 's/^/    📌 /'
  done < "$ORG_FILE"

  echo
done

echo "✅ Verification complete."
