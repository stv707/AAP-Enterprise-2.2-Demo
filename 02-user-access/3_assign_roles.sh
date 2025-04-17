#!/bin/bash

CONTROLLER_URL="https://controller.lab.example.com"
ADMIN_USER="admin"
ADMIN_PASS="redhat"

tower-cli config host "$CONTROLLER_URL"
tower-cli config username "$ADMIN_USER"
tower-cli config password "$ADMIN_PASS"
tower-cli config verify_ssl false

echo "🔐 Assigning org-level roles to individual users..."

for ORG_FILE in generated_users/*.txt; do
  ORG_NAME=$(basename "$ORG_FILE" .txt)

  while IFS=: read -r USER ROLE; do
    echo "🔑 Granting $ROLE to $USER in $ORG_NAME"
    tower-cli organization associate --user "$USER" --name "$ORG_NAME" --role "$ROLE" || echo "⚠️  Failed for $USER"
  done
done

echo "✅ All user org-level roles assigned."
