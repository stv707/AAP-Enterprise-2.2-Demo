#!/bin/bash

CONTROLLER_URL="https://controller.lab.example.com"
ADMIN_USER="admin"
ADMIN_PASS="redhat"

echo "🔐 Configuring tower-cli connection..."
tower-cli config host "$CONTROLLER_URL"
tower-cli config username "$ADMIN_USER"
tower-cli config password "$ADMIN_PASS"
tower-cli config verify_ssl false

# === Create Organizations ===
create_org() {
  local org_name="$1"
  echo "🏢 Creating organization: $org_name"
  tower-cli organization create --name "$org_name" || echo "⚠️  $org_name may already exist."
}

echo "🏗 Creating organizations..."
create_org "IT"
create_org "Dev"
create_org "Network"

echo "✅ All organizations created (or already exist)."
