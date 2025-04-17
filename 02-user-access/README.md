# Chapter 2: Silo-Based RBAC with Organizations, Teams, and Users

This lab simulates a real-world enterprise setup in Ansible Automation Platform (AAP) where each department (silo) operates within its own organization. Access is controlled using user-based RBAC.

---

## 🏢 Organizations Created

- **IT**
- **Dev**
- **Network**

---

## 👥 Teams per Organization

| Organization | Teams        |
|--------------|--------------|
| IT           | SysOps, Infra |
| Dev          | DevTeam, DevSecOps |
| Network      | NetOps, FWTeam |

---

## 👤 Users Created

Each team has 2 users. Usernames are generated randomly and assigned roles:

| Team         | Usernames               | Role in Org |
|--------------|--------------------------|--------------|
| SysOps       | sysops_user32, sysops_user70 | `admin`, `auditor` |
| Infra        | infra_user63, infra_user84   | `admin`, `auditor` |
| DevTeam      | devteam_user11, devteam_user36 | `admin`, `auditor` |
| DevSecOps    | devsecops_user65, devsecops_user88 | `admin`, `auditor` |
| NetOps       | netops_user48, ...         | `admin`, `auditor` |
| FWTeam       | fwteam_user51, fwteam_user61 | `admin`, `auditor` |

> All users use the default password: `redhat123`

---

## 🔐 Access Model

- Each user only sees their assigned **organization**
- Users with:
  - `admin` role can create/edit projects, inventories, credentials, job templates
  - `auditor` role can only view within their organization
- Teams are used for grouping users, but only users are granted organization-level roles

---

## ✅ Verification Script

You can verify all role assignments using:

```bash
./verify_roles.sh
