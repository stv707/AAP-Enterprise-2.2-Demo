#!/bin/bash

# === CONFIG ===
CONTROLLER_HOST="https://controller.lab.example.com"
USERNAME="admin"
PASSWORD="redhat"
CONFIG_DIR="$HOME/.config/awx"
CONFIG_FILE="$CONFIG_DIR/cli.cfg"

echo "🔐 Logging in to Automation Controller..."
# Run login command and capture token
LOGIN_OUTPUT=$(awx --conf.host $CONTROLLER_HOST \
                  --conf.username $USERNAME \
                  --conf.password $PASSWORD \
                  --conf.insecure login)

TOKEN=$(echo "$LOGIN_OUTPUT" | jq -r '.token')

if [[ -z "$TOKEN" || "$TOKEN" == "null" ]]; then
  echo "❌ Login failed. Check credentials or controller URL."
  exit 1
fi

# Create CLI config manually
echo "📝 Saving token and host config to $CONFIG_FILE"
mkdir -p "$CONFIG_DIR"
cat > "$CONFIG_FILE" <<EOF
host = $CONTROLLER_HOST
token = $TOKEN
format = json
conf.insecure = True
EOF

echo "✅ Login success. CLI configured."

# === Create Teams ===
echo "👥 Creating teams..."
awx team create --name DevTeam --organization Default || true
awx team create --name OpsTeam --organization Default || true
awx team create --name SecTeam --organization Default || true

# === Create Users and Assign to Teams ===
create_user_and_assign() {
  local username="$1"
  local fname="$2"
  local lname="$3"
  local email="$4"
  local team="$5"

  echo "👤 Creating user: $username"
  awx user create \
    --username "$username" \
    --password "redhat123" \
    --first-name "$fname" \
    --last-name "$lname" \
    --email "$email" \
    --is-superuser false || true

  echo "➕ Assigning $username to $team"
  awx team associate --team "$team" --user "$username"
}

# === UOB-Style Users ===
create_user_and_assign "alice" "Alice" "Tan" "alice@uob.local" "DevTeam"
create_user_and_assign "bala"  "Bala"  "Krishna" "bala@uob.local" "DevTeam"
create_user_and_assign "irene" "Irene" "Lau" "irene@uob.local" "OpsTeam"
create_user_and_assign "ian"   "Ian"   "Tan" "ian@uob.local" "OpsTeam"
create_user_and_assign "azmi"  "Azmi"  "Hassan" "azmi@uob.local" "SecTeam"

echo "🎉 All users and teams created successfully."
