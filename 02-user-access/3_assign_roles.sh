#!/bin/bash

CONTROLLER_URL="https://controller.lab.example.com"
ADMIN_USER="admin"
ADMIN_PASS="redhat"

tower-cli config host "$CONTROLLER_URL"
tower-cli config username "$ADMIN_USER"
tower-cli config password "$ADMIN_PASS"
tower-cli config verify_ssl false

echo "🔐 Assigning org-level roles to teams..."

# IT Org
tower-cli role grant --type admin   --team SysOps    --organization IT || true
tower-cli role grant --type auditor --team Infra     --organization IT || true

# Dev Org
tower-cli role grant --type admin   --team DevTeam   --organization Dev || true
tower-cli role grant --type auditor --team DevSecOps --organization Dev || true

# Network Org
tower-cli role grant --type admin   --team NetOps    --organization Network || true
tower-cli role grant --type auditor --team FWTeam    --organization Network || true

echo "✅ All team roles assigned at org level. Users will only see & operate within their silo."
