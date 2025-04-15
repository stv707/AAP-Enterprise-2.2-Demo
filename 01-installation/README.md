# Red Hat Ansible Automation Platform 2.2 – Architecture Overview

Red Hat Ansible Automation Platform (AAP) is an enterprise framework for building and operating IT automation at scale.

## 🧠 Core Components

### 1. **Ansible Core**
- CLI tools like `ansible`, `ansible-playbook`, `ansible-doc`
- Uses YAML-based Playbooks
- Supports conditionals, loops, blocks, etc.

### 2. **Automation Execution Environments (EE)**
- Container images that bundle:
  - Ansible Core
  - Required Collections
  - Python dependencies
- Ensures consistent automation from dev to prod
- Custom EEs can be built with `ansible-builder`

### 3. **Automation Controller** (formerly Ansible Tower)
- Central UI and API to manage automation
- Features:
  - Role-Based Access Control (RBAC)
  - Inventory & job scheduling
  - Workflow orchestration
  - Notification & logging
  - REST API for integrations

### 4. **Private Automation Hub**
- Internal registry for Ansible Collections and Execution Environments
- Enables secure sharing of curated automation content across teams

### 5. **Red Hat Insights for AAP**
- Cloud-based service to track automation usage
- Provides performance metrics and ROI visibility

---

## 🔗 Component Interaction


![AAP Architecture](../diagrams/image.png)
