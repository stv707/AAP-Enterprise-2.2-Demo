#!/bin/bash

# === CONFIG ===
HUB_API="https://hub.lab.example.com/api/galaxy/"
AUTH_USER="admin"
AUTH_PASS="redhat"

# Login and get token
TOKEN=$(curl -s -X POST "${HUB_API}v3/auth/token/" \
  -H "Content-Type: application/json" \
  -d "{\"username\": \"${AUTH_USER}\", \"password\": \"${AUTH_PASS}\"}" | jq -r .token)

auth_header="Authorization: Token $TOKEN"

# === GROUPS CREATION ===
declare -A GROUPS
GROUPS=( ["DevTeam"]="Upload collections" ["OpsTeam"]="Manage containers" ["SecTeam"]="Read-only" )

for group in "${!GROUPS[@]}"; do
  echo "🔧 Creating group: $group"
  curl -s -X POST "${HUB_API}v3/groups/" \
    -H "Content-Type: application/json" \
    -H "$auth_header" \
    -d "{\"name\": \"$group\"}" | jq .
done

# === USERS CREATION ===
echo "👤 Creating users and assigning to groups..."

create_user() {
  local username="$1"
  local first="$2"
  local last="$3"
  local email="$4"
  local group="$5"

  echo "➡️ Creating user: $username in $group"
  curl -s -X POST "${HUB_API}v3/users/" \
    -H "Content-Type: application/json" \
    -H "$auth_header" \
    -d "{
          \"username\": \"$username\",
          \"first_name\": \"$first\",
          \"last_name\": \"$last\",
          \"email\": \"$email\",
          \"password\": \"redhat123\"
        }" | jq .

  # Fetch user & group IDs
  UID=$(curl -s -H "$auth_header" "${HUB_API}v3/users/?username=$username" | jq -r '.results[0].id')
  GID=$(curl -s -H "$auth_header" "${HUB_API}v3/groups/?name=$group" | jq -r '.results[0].id')

  echo "➕ Adding $username to $group"
  curl -s -X POST "${HUB_API}v3/groups/$GID/users/" \
    -H "Content-Type: application/json" \
    -H "$auth_header" \
    -d "[\"$UID\"]" | jq .
}

# Add UOB-style users
create_user "alice" "Alice" "Tan" "alice@uob.local" "DevTeam"
create_user "bala"  "Bala"  "Krishna" "bala@uob.local" "DevTeam"
create_user "irene" "Irene" "Lau" "irene@uob.local" "OpsTeam"
create_user "ian"   "Ian"   "Tan" "ian@uob.local" "OpsTeam"
create_user "azmi"  "Azmi"  "Hassan" "azmi@uob.local" "SecTeam"

echo "✅ All users and groups created."