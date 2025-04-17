#!/bin/bash

CONTROLLER_URL="https://controller.lab.example.com"
ADMIN_USER="admin"
ADMIN_PASS="redhat"
DEFAULT_PASS="redhat123"

# Configure tower-cli
tower-cli config host "$CONTROLLER_URL"
tower-cli config username "$ADMIN_USER"
tower-cli config password "$ADMIN_PASS"
tower-cli config verify_ssl false

# Define structure
declare -A ORG_TEAMS=(
  [IT]="SysOps Infra"
  [Dev]="DevTeam DevSecOps"
  [Network]="NetOps FWTeam"
)

generate_usernames() {
  local team_prefix="$1"
  echo "${team_prefix,,}user$((RANDOM % 90 + 10))"
  echo "${team_prefix,,}user$((RANDOM % 90 + 10))"
}

for ORG in "${!ORG_TEAMS[@]}"; do
  echo "🏢 Organization: $ORG"

  for TEAM in ${ORG_TEAMS[$ORG]}; do
    echo "👥 Creating team: $TEAM under $ORG"
    tower-cli team create --name "$TEAM" --organization "$ORG" || echo "⚠️  $TEAM may already exist."

    # Generate and create 2 users
    for USERNAME in $(generate_usernames "$TEAM"); do
      echo "👤 Creating user: $USERNAME"
      tower-cli user create \
        --username "$USERNAME" \
        --password "$DEFAULT_PASS" \
        --first-name "$USERNAME" \
        --last-name "$TEAM" \
        --email "$USERNAME@lab.local" \
        --is-superuser false || echo "⚠️  $USERNAME may already exist."

      echo "➕ Assigning $USERNAME to team $TEAM"
      tower-cli team associate --team "$TEAM" --user "$USERNAME" || echo "⚠️  Failed to associate $USERNAME"
    done
    echo ""
  done
done

echo "✅ All teams and users created + assigned."
