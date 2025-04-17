#!/bin/bash

# Chapter 1 - Initial Configuration (DO467)
# Automates uploading EE tarballs to Private Automation Hub

set -e

# === CONFIGURATION ===
HUB="hub.lab.example.com"
ORG="ansible-automation-platform-22"
USERNAME="admin"
PASSWORD="redhat"
EE_DIR=~/certified-EEs

# === Check prereqs ===
command -v skopeo >/dev/null 2>&1 || { echo "❌ skopeo not installed. Install it first."; exit 1; }

echo "🔐 Logging into Private Automation Hub..."
skopeo login ${HUB} --username ${USERNAME} --password ${PASSWORD}

# === Upload all EEs ===
cd "${EE_DIR}" || { echo "❌ Directory ${EE_DIR} not found"; exit 1; }

for TARBALL in ee-*.tgz; do
  IMAGE_NAME=$(basename "$TARBALL" .tgz)
  echo "📦 Uploading $IMAGE_NAME to ${HUB}/${ORG}/${IMAGE_NAME}:latest..."
  skopeo copy docker-archive:${TARBALL} docker://${HUB}/${ORG}/${IMAGE_NAME}:latest
done

echo "✅ All EE images uploaded to Private Automation Hub."

# === Reminders for manual GUI steps ===
echo "👨‍🏫 Now continue with manual steps:"
echo "- Login to https://controller.lab.example.com"
echo "- Create Execution Environments pointing to: ${HUB}/${ORG}/<EE>:latest"
echo "- Tag EEs as default for appropriate orgs/projects"
echo "- Use these EEs in a Job Template"

echo "🎯 Chapter 1 CLI setup complete."
