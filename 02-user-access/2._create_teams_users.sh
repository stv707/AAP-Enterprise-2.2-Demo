#!/bin/bash

CONTROLLER_URL="https://controller.lab.example.com"
ADMIN_USER="admin"
ADMIN_PASS="redhat"
DEFAULT_PASS="redhat123"

tower-cli config host "$CONTROLLER_URL"
tower-cli config username "$ADMIN_USER"
tower-cli config password "$ADMIN_PASS"
tower-cli config verify_ssl false

declare -A ORG_TEAMS=(
  [IT]="SysOps Infra"
  [Dev]="DevTeam DevSecOps"
  [Network]="NetOps FWTeam"
)

mkdir -p generated_users

for ORG in "${!ORG_TEAMS[@]}"; do
  echo "🏢 Organization: $ORG"

  for TEAM in ${ORG_TEAMS[$ORG]}; do
    echo "👥 Creating team: $TEAM under $ORG"
    tower-cli team create --name "$TEAM" --organization "$ORG" || echo "⚠️  $TEAM may already exist."

    USERS=()
    for i in 1 2; do
      USERNAME="${TEAM,,}_user$((RANDOM % 90 + 10))"
      USERS+=("$USERNAME")

      echo "👤 Creating user: $USERNAME"
      tower-cli user create \
        --username "$USERNAME" \
        --password "$DEFAULT_PASS" \
        --first-name "$USERNAME" \
        --last-name "$TEAM" \
        --email "$USERNAME@lab.local" \
        --is-superuser false || echo "⚠️  $USERNAME may already exist."

      echo "➕ Assigning $USERNAME to $TEAM"
      tower-cli team associate --team "$TEAM" --user "$USERNAME" || echo "⚠️  Failed to associate $USERNAME"
    done

    # Save users to file for role assignment
    echo "${USERS[0]}:admin" >> "generated_users/${ORG}.txt"
    echo "${USERS[1]}:auditor" >> "generated_users/${ORG}.txt"

    echo ""
  done
done

echo "✅ All teams and users created + mapped for org-level RBAC."
