#!/bin/bash

# Base path: current directory
BASE_DIR=$(pwd)

# List of all subdirectories to create
DIRS=(
  "01-installation/aap-installation-bundle"
  "01-installation/controller-hub-cert-lab"
  "02-user-access/rbac-teams-users"
  "03-inventories-credentials/static-inventory"
  "03-inventories-credentials/dynamic-inventory"
  "03-inventories-credentials/credential-examples"
  "04-projects-job-templates/git-projects"
  "04-projects-job-templates/job-template-launch"
  "04-projects-job-templates/playbook-examples"
  "05-advanced-job-config/fact-caching"
  "05-advanced-job-config/surveys"
  "05-advanced-job-config/notifications-schedules"
  "06-workflows/multi-job-workflows"
  "06-workflows/approvals"
  "07-advanced-inventories/smart-inventory"
  "07-advanced-inventories/plugins"
  "08-aap-automation/webhook-trigger"
  "08-aap-automation/api-control-jobs"
  "08-aap-automation/configure-aap-via-collections"
  "09-maintenance/troubleshooting"
  "09-maintenance/backup-restore"
  "10-insights-analytics/insights-cloud-data"
  "10-insights-analytics/reports-metrics"
  "11-mesh-ha/automation-mesh"
  "11-mesh-ha/large-scale-arch"
  "12-final-review/review-labs"
  "12-final-review/comprehensive-exercise"
  "custom-labs/lab-api-automation"
  "custom-labs/lab-dynamic-inventory-plugin"
  "custom-labs/lab-surveys-approvals"
  "custom-labs/lab-gitops-hook"
  "diagrams"
)

echo "Creating structure in: $BASE_DIR"

# Create directories and populate README.md with "BUILD"
for dir in "${DIRS[@]}"; do
  mkdir -p "$BASE_DIR/$dir"
  echo "BUILD" > "$BASE_DIR/$dir/README.md"
done

echo "✅ All folders and README.md created with BUILD marker"

