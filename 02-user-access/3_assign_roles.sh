#!/bin/bash

CONTROLLER_URL="https://controller.lab.example.com"
ADMIN_USER="admin"
ADMIN_PASS="redhat"

# Setup CLI config
tower-cli config host "$CONTROLLER_URL"
tower-cli config username "$ADMIN_USER"
tower-cli config password "$ADMIN_PASS"
tower-cli config verify_ssl false

echo "📦 Creating placeholder resources..."

# === Create Dummy Inventory for Each Org
for ORG in IT Dev Network; do
  echo "📦 Creating inventory for $ORG"
  tower-cli inventory create --name "${ORG}_Inventory" --organization "$ORG" || echo "⚠️  Inventory exists"
done

# === Create Dummy Project
echo "📁 Creating shared dummy project"
tower-cli project create \
  --name "SharedProject" \
  --organization Dev \
  --scm-type git \
  --scm-url https://github.com/ansible/ansible-tower-samples.git \
  --scm-branch main || echo "⚠️  Project may already exist"

# === Create Dummy Job Template
echo "🚀 Creating job templates"
tower-cli job_template create --name "DeployApp" --inventory "Dev_Inventory" --project "SharedProject" --playbook hello_world.yml || echo "⚠️  Job template may already exist"
tower-cli job_template create --name "NetScan"   --inventory "Network_Inventory" --project "SharedProject" --playbook hello_world.yml || echo "⚠️  Job template may already exist"

echo "🔐 Assigning roles to teams..."

# === Assign Roles
tower-cli role grant --type admin   --team SysOps     --inventory IT_Inventory || true
tower-cli role grant --type admin   --team Infra      --inventory IT_Inventory || true
tower-cli role grant --type execute --team DevTeam    --job-template DeployApp || true
tower-cli role grant --type use     --team DevSecOps  --project SharedProject || true
tower-cli role grant --type execute --team NetOps     --job-template NetScan || true
tower-cli role grant --type use     --team FWTeam     --inventory Network_Inventory || true

echo "✅ Role assignments complete. Demo environment is ready!"
