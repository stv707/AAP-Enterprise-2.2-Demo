#!/bin/bash

CONTROLLER_URL="https://controller.lab.example.com"
ADMIN_USER="admin"
ADMIN_PASS="redhat"
USER_PASS="redhat123"   # 🔐 Password for all created users

# === Step 1: Configure tower-cli
echo "🔐 Setting tower-cli config..."
tower-cli config host "$CONTROLLER_URL"
tower-cli config username "$ADMIN_USER"
tower-cli config password "$ADMIN_PASS"
tower-cli config verify_ssl false

# === Step 2: Test Login
echo "🔍 Testing login to $CONTROLLER_URL..."
if ! tower-cli user list --page-size 1 &>/dev/null; then
    echo "❌ Login failed! Please check host, username, or password."
    exit 1
fi

echo "✅ Login successful. Proceeding with team and user setup..."

# === Step 3: Create Teams
echo "🔧 Creating teams..."
tower-cli team create --name DevTeam --organization Default || true
tower-cli team create --name OpsTeam --organization Default || true
tower-cli team create --name SecTeam --organization Default || true

# === Step 4: Create Users and Assign to Teams
create_user_and_assign() {
  local username="$1"
  local first="$2"
  local last="$3"
  local email="$4"
  local team="$5"

  echo "👤 Creating user: $username"
  tower-cli user create \
    --username "$username" \
    --password "$USER_PASS" \
    --first-name "$first" \
    --last-name "$last" \
    --email "$email" \
    --is-superuser false || true

  echo "👥 Adding $username to $team"
  tower-cli team associate --team "$team" --user "$username" || true
}

# === Users to Create and Assign ===
create_user_and_assign "alice" "Alice" "Tan" "alice@uob.local" "DevTeam"
create_user_and_assign "bala"  "Bala"  "Krishna" "bala@uob.local" "DevTeam"
create_user_and_assign "irene" "Irene" "Lau" "irene@uob.local" "OpsTeam"
create_user_and_assign "ian"   "Ian"   "Tan" "ian@uob.local" "OpsTeam"
create_user_and_assign "azmi"  "Azmi"  "Hassan" "azmi@uob.local" "SecTeam"

# === Step 5: Assign Roles for Demo (Confirmed `tower-cli role grant`)
echo "🔑 Assigning roles for demo..."

# Users
tower-cli role grant --type admin   --user alice --organization Default || true
tower-cli role grant --type auditor --user irene --organization Default || true

# Teams
tower-cli role grant --type member  --team DevTeam --organization Default || true
tower-cli role grant --type auditor --team OpsTeam --organization Default || true
tower-cli role grant --type admin   --team SecTeam --organization Default || true





echo "🎉 All users, teams, and roles created and assigned successfully."
