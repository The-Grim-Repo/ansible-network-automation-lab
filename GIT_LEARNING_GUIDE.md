# Git Learning Guide: Complete Workflow

## 🎯 Overview

This guide documents the complete Git workflow we used to set up version control for the Ansible Network Automation Lab. It covers everything from initial setup to pushing to GitHub with SSH authentication.

## 📚 Table of Contents

1. [Initial Git Setup](#initial-git-setup)
2. [Repository Configuration](#repository-configuration)
3. [File Management](#file-management)
4. [Branching Workflow](#branching-workflow)
5. [GitHub Integration](#github-integration)
6. [SSH Authentication](#ssh-authentication)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)

## 🚀 Initial Git Setup

### Step 1: Initialize Repository
```bash
# Navigate to project directory
cd /home/ray/ansible_training

# Initialize Git repository
git init

# Configure user information
git config user.name "The-Grim-Repo"
git config user.email "the-grim-repo@example.com"
```

### Step 2: Create .gitignore
```bash
# Create comprehensive .gitignore file
cat > .gitignore << 'EOF'
# Virtual Environment
ansible-env/
venv/
env/
.venv/
.env/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Ansible
.ansible/
*.retry
ansible.cfg
hosts
hosts.yml
group_vars/
host_vars/
roles/
playbooks/*.retry

# SSH Keys and Secrets
*.pem
*.key
id_rsa*
*.ppk
secrets.yml
vault.yml
*.vault

# Logs
*.log
logs/
ansible.log

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Temporary files
*.tmp
*.temp
.cache/

# Backup files
*.bak
*.backup
*.old

# Network device backups
backups/
config_backups/
EOF
```

## 🔧 Repository Configuration

### Step 3: Initial Commit
```bash
# Check status
git status

# Add all files
git add .

# Make initial commit
git commit -m "Initial commit: Ansible Network Automation Lab

- Virtual environment setup with Ansible 12.1.0
- Complete inventory for 13 Nexus switches
- Hierarchical device organization (DC1/DC2, Core/Distribution/Access)
- Comprehensive documentation and study guides
- SSH connectivity testing scripts
- Security considerations and best practices"
```

### Step 4: Verify Setup
```bash
# Check commit history
git log --oneline

# Check repository status
git status

# List all files
ls -la
```

## 📁 File Management

### Step 5: Making Changes and Commits
```bash
# Check what files have changed
git status

# See specific changes
git diff README.md

# Add specific files
git add README.md

# Add all changes
git add .

# Commit with descriptive message
git commit -m "Add Git workflow documentation and GitHub setup script

- Updated README with repository information and Git workflow
- Added comprehensive Git commands for daily workflow
- Created github_setup.sh script for easy repository connection
- Documented branching strategy for feature development"
```

## 🌿 Branching Workflow

### Step 6: Create and Use Feature Branches
```bash
# Create and switch to feature branch
git checkout -b feature/git-exercises

# Verify branch creation
git branch

# Make changes (create files, edit files)
# ... work on feature ...

# Add and commit changes
git add .
git commit -m "Add Git exercises documentation

- Created comprehensive Git exercises guide
- Documented branching workflow
- Added learning objectives and best practices
- Demonstrated feature branch development process"
```

### Step 7: Merge Feature Branch
```bash
# Switch back to main branch
git checkout main

# Verify file doesn't exist on main (yet)
ls -la GIT_EXERCISES.md

# Merge feature branch
git merge feature/git-exercises

# Verify file now exists on main
ls -la GIT_EXERCISES.md

# Clean up feature branch
git branch -d feature/git-exercises

# Verify branch is deleted
git branch
```

## 🔗 GitHub Integration

### Step 8: Create GitHub Repository
1. Go to [GitHub.com](https://github.com)
2. Click "+" → "New repository"
3. Repository name: `ansible-network-automation-lab`
4. Description: `Network automation lab with Ansible managing 13 Cisco Nexus switches`
5. Make it **Public**
6. **Don't** initialize with README (we already have one)
7. Click "Create repository"

### Step 9: Connect Local Repository to GitHub
```bash
# Add GitHub remote
git remote add origin https://github.com/The-Grim-Repo/ansible-network-automation-lab.git

# Rename default branch to main
git branch -M main

# Verify remote configuration
git remote -v
```

## 🔐 SSH Authentication

### Step 10: Generate SSH Key
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your-email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add ~/.ssh/id_ed25519

# Display public key
cat ~/.ssh/id_ed25519.pub
```

### Step 11: Add SSH Key to GitHub
1. Copy the SSH public key from the previous command
2. Go to GitHub.com → Settings → SSH and GPG keys
3. Click "New SSH key"
4. Paste the key and give it a title
5. Click "Add SSH key"

### Step 12: Test SSH Connection
```bash
# Test SSH connection to GitHub
ssh -T git@github.com

# Expected output: "Hi The-Grim-Repo! You've successfully authenticated..."
```

### Step 13: Configure Repository for SSH
```bash
# Switch to SSH URL
git remote set-url origin git@github.com:The-Grim-Repo/ansible-network-automation-lab.git

# Verify remote URL
git remote -v
```

## 🚀 Push to GitHub

### Step 14: Push Code to GitHub
```bash
# Push to GitHub
git push -u origin main

# Expected output: "To github.com:The-Grim-Repo/ansible-network-automation-lab.git"
# Expected output: "* [new branch]      main -> main"
# Expected output: "branch 'main' set up to track 'origin/main'"
```

### Step 15: Verify on GitHub
- Go to your repository: https://github.com/The-Grim-Repo/ansible-network-automation-lab
- Verify all files are present
- Check commit history
- Verify README.md displays correctly

## 🔧 Troubleshooting

### Common Issues and Solutions

#### Issue: "fatal: could not read Username for 'https://github.com'"
**Solution**: Switch to SSH authentication
```bash
git remote set-url origin git@github.com:The-Grim-Repo/ansible-network-automation-lab.git
```

#### Issue: "Permission denied (publickey)"
**Solution**: Add SSH key to GitHub account
1. Copy public key: `cat ~/.ssh/id_ed25519.pub`
2. Add to GitHub: Settings → SSH and GPG keys

#### Issue: "Host key verification failed"
**Solution**: Add GitHub to known hosts
```bash
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
```

#### Issue: "could not read Username"
**Solution**: Use SSH instead of HTTPS
```bash
git remote set-url origin git@github.com:The-Grim-Repo/ansible-network-automation-lab.git
```

## 📋 Best Practices

### Commit Messages
- **Format**: `Type: Brief description`
- **Examples**:
  - `feat: Add new playbook for device configuration`
  - `docs: Update README with installation guide`
  - `fix: Resolve SSH connection timeout issue`
  - `refactor: Reorganize inventory structure`

### Branch Naming
- **Feature branches**: `feature/description`
- **Bug fixes**: `fix/description`
- **Documentation**: `docs/description`
- **Examples**:
  - `feature/device-backup-playbook`
  - `fix/ssh-timeout-issue`
  - `docs/ansible-modules-guide`

### File Organization
```
project/
├── .gitignore          # Files to ignore
├── README.md           # Project documentation
├── inventory.yml       # Ansible inventory
├── playbooks/          # Ansible playbooks
├── roles/              # Ansible roles
├── group_vars/         # Group variables
├── host_vars/          # Host variables
└── scripts/            # Utility scripts
```

### Daily Workflow
```bash
# Start of day
git pull origin main

# Make changes
# ... work on code ...

# Check status
git status

# Add changes
git add .

# Commit changes
git commit -m "Descriptive message"

# Push changes
git push origin main
```

## 🎓 Learning Objectives Checklist

- [ ] Understand Git repository initialization
- [ ] Know how to create and use .gitignore
- [ ] Practice making commits with descriptive messages
- [ ] Learn feature branch workflow
- [ ] Understand merging and branch cleanup
- [ ] Set up GitHub repository
- [ ] Configure SSH authentication
- [ ] Push code to GitHub
- [ ] Troubleshoot common Git issues
- [ ] Follow Git best practices

## 🔄 Complete Workflow Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                    COMPLETE GIT WORKFLOW                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Initialize Repository                                      │
│     git init                                                    │
│     git config user.name "Your-Name"                           │
│     git config user.email "your-email@example.com"            │
│                                                                 │
│  2. Create .gitignore                                          │
│     # Exclude virtual environments, secrets, etc.               │
│                                                                 │
│  3. Initial Commit                                             │
│     git add .                                                  │
│     git commit -m "Initial commit: Project description"        │
│                                                                 │
│  4. Create Feature Branch                                      │
│     git checkout -b feature/description                        │
│     # Make changes                                             │
│     git add .                                                  │
│     git commit -m "Add feature description"                   │
│                                                                 │
│  5. Merge Feature Branch                                        │
│     git checkout main                                          │
│     git merge feature/description                              │
│     git branch -d feature/description                          │
│                                                                 │
│  6. Set Up GitHub                                              │
│     # Create repository on GitHub.com                          │
│     git remote add origin git@github.com:user/repo.git        │
│                                                                 │
│  7. Configure SSH Authentication                              │
│     ssh-keygen -t ed25519 -C "email@example.com"             │
│     # Add public key to GitHub                                 │
│     ssh -T git@github.com                                      │
│                                                                 │
│  8. Push to GitHub                                             │
│     git push -u origin main                                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 📖 Additional Resources

- **Git Documentation**: https://git-scm.com/doc
- **GitHub SSH Keys**: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- **Git Best Practices**: https://github.com/git/git/blob/master/Documentation/SubmittingPatches
- **Ansible Git Integration**: https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#version-control

---

*This guide serves as a comprehensive reference for Git workflows in network automation projects. Use it as a checklist for future projects and as a learning resource for Git best practices.*
