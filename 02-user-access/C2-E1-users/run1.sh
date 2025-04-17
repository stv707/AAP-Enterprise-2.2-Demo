#!/bin/bash

# === CONFIG ===
CONTROLLER_HOST="https://controller.lab.example.com"
USERNAME="admin"
PASSWORD="redhat"

echo "🔐 Logging in to Automation Controller..."
# Run login command and capture token
TOKEN=$(awx --conf.host "$CONTROLLER_HOST" \
            --conf.username "$USERNAME" \
            --conf.password "$PASSWORD" \
            --conf.insecure login | jq -r .token)

if [[ -z "$TOKEN" || "$TOKEN" == "null" ]]; then
  echo "❌ Login failed. Check credentials or controller URL."
  exit 1
fi

# Export for the wrapper
export AWX_HOST="$CONTROLLER_HOST"
export AWX_TOKEN="$TOKEN"

echo "✅ Login successful."

# === WRAPPER FUNCTION ===
AWX() {
  awx --conf.host "$AWX_HOST" --conf.token "$AWX_TOKEN" --conf.insecure "$@"
}

# === Create Teams ===
echo "👥 Creating teams..."
AWX team create --name DevTeam --organization Default || true
AWX team create --name OpsTeam --organization Default || true
AWX team create --name SecTeam --organization Default || true

# === Create Users and Assign to Teams ===
create_user_and_assign() {
  local username="$1"
  local fname="$2"
  local lname="$3"
  local email="$4"
  local team="$5"

  echo "👤 Creating user: $username"
  AWX user create \
    --username "$username" \
    --password "redhat123" \
    --first-name "$fname" \
    --last-name "$lname" \
    --email "$email" \
    --is-superuser false || true

  echo "➕ Assigning $username to $team"
  AWX team associate --team "$team" --user "$username" || true
}

# === UOB-Style Users ===
create_user_and_assign "alice" "Alice" "Tan" "alice@uob.local" "DevTeam"
create_user_and_assign "bala"  "Bala"  "Krishna" "bala@uob.local" "DevTeam"
create_user_and_assign "irene" "Irene" "Lau" "irene@uob.local" "OpsTeam"
create_user_and_assign "ian"   "Ian"   "Tan" "ian@uob.local" "OpsTeam"
create_user_and_assign "azmi"  "Azmi"  "Hassan" "azmi@uob.local" "SecTeam"

echo "🎉 All users and teams created successfully."
