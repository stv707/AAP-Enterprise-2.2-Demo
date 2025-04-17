#!/bin/bash

# === Step 0: Config ===
CONTROLLER_URL="https://controller.lab.example.com"
ADMIN_USER="admin"
ADMIN_PASS="redhat"
INVENTORY_NAME="Prod"
GROUP_NAME="prod_servers"
HOST_NAME="servere.lab.example.com"
TEAM_NAME="Operations"
ORG_NAME="Default"

# === Step 1: Configure tower-cli ===
echo "⚙️  Configuring tower-cli"
tower-cli config host "$CONTROLLER_URL"
tower-cli config username "$ADMIN_USER"
tower-cli config password "$ADMIN_PASS"
tower-cli config verify_ssl false

# === Step 2: Create Inventory ===
echo "📦 Creating Inventory: $INVENTORY_NAME"
tower-cli inventory create \
  --name "$INVENTORY_NAME" \
  --description "Production Inventory" \
  --organization "$ORG_NAME" || true

# === Step 3: Create Group ===
echo "📁 Creating Group: $GROUP_NAME"
tower-cli group create \
  --name "$GROUP_NAME" \
  --description "Production servers" \
  --inventory "$INVENTORY_NAME" || true

# === Step 4: Create Host (without --group)
echo "🖥️  Creating Host: $HOST_NAME"
tower-cli host create \
  --name "$HOST_NAME" \
  --description "Server E for Prod" \
  --inventory "$INVENTORY_NAME" || true

# === Step 5: Associate Host to Group
echo "🔗 Associating host to group"
tower-cli group associate \
  --group "$GROUP_NAME" \
  --host "$HOST_NAME" || true

# === Step 6: Grant Admin Role on Inventory to Team
echo "🔐 Granting Admin role on inventory to team $TEAM_NAME"
tower-cli role grant \
  --type admin \
  --team "$TEAM_NAME" \
  --inventory "$INVENTORY_NAME" || true

echo "✅ Inventory setup completed for $INVENTORY_NAME"
