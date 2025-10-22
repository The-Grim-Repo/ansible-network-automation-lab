# Ansible Network Automation Lab

## 🎯 Project Overview

This project demonstrates network automation using Ansible to manage 13 Cisco Nexus switches across two data centers. The lab environment provides hands-on experience with:

- **Ansible Installation**: Virtual environment setup and best practices
- **Inventory Management**: Hierarchical device organization
- **Network Automation**: Device configuration and management
- **Best Practices**: Security, documentation, and version control

## 🏗️ Lab Environment

### Network Topology
```
┌─────────────────────────────────────────────────────────────────┐
│                    LAB NETWORK TOPOLOGY                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    DATA CENTER 1                       │   │
│  │                                                         │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │              CORE LAYER                         │   │   │
│  │  │  NX_DC1_Core_01 (10.0.100.10)                  │   │   │
│  │  │  NX_DC1_Core_02 (10.0.100.11)                  │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  │                                                         │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │           DISTRIBUTION LAYER                    │   │   │
│  │  │  NX_DC1_Dis_01 (10.0.100.12)                    │   │   │
│  │  │  NX_DC1_Dis_02 (10.0.100.13)                    │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  │                                                         │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │             ACCESS LAYER                        │   │   │
│  │  │  NX_DC1_ACC_01 (10.0.100.14)                   │   │   │
│  │  │  NX_DC1_ACC_02 (10.0.100.15)                   │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  │                                                         │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │             BORDER ROUTER                       │   │   │
│  │  │  NX_BDR_01 (10.0.100.16)                       │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    DATA CENTER 2                       │   │
│  │                                                         │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │              CORE LAYER                         │   │   │
│  │  │  NX_DC2_Core_01 (10.0.100.17)                  │   │   │
│  │  │  NX_DC2_Core_02 (10.0.100.18)                  │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  │                                                         │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │           DISTRIBUTION LAYER                    │   │   │
│  │  │  NX_DC2_Dis_01 (10.0.100.19)                   │   │   │
│  │  │  NX_DC2_Dis_02 (10.0.100.20)                   │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  │                                                         │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │             ACCESS LAYER                        │   │   │
│  │  │  NX_DC2_ACC_01 (10.0.100.21)                   │   │   │
│  │  │  NX_DC2_ACC_02 (10.0.100.22)                   │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Device Inventory
| Device Name | IP Address | Role | Data Center |
|--------------|------------|------|-------------|
| NX_DC1_Core_01 | 10.0.100.10 | Core | DC1 |
| NX_DC1_Core_02 | 10.0.100.11 | Core | DC1 |
| NX_DC1_Dis_01 | 10.0.100.12 | Distribution | DC1 |
| NX_DC1_Dis_02 | 10.0.100.13 | Distribution | DC1 |
| NX_DC1_ACC_01 | 10.0.100.14 | Access | DC1 |
| NX_DC1_ACC_02 | 10.0.100.15 | Access | DC1 |
| NX_BDR_01 | 10.0.100.16 | Border Router | DC1 |
| NX_DC2_Core_01 | 10.0.100.17 | Core | DC2 |
| NX_DC2_Core_02 | 10.0.100.18 | Core | DC2 |
| NX_DC2_Dis_01 | 10.0.100.19 | Distribution | DC2 |
| NX_DC2_Dis_02 | 10.0.100.20 | Distribution | DC2 |
| NX_DC2_ACC_01 | 10.0.100.21 | Access | DC2 |
| NX_DC2_ACC_02 | 10.0.100.22 | Access | DC2 |

## 🚀 Getting Started

### Prerequisites
- Ubuntu Server with Python 3.12+
- SSH access to all network devices
- Basic understanding of YAML and network concepts

### Environment Setup

#### 1. Activate Virtual Environment
```bash
# Navigate to project directory
cd ~/ansible_training

# Activate virtual environment
source ~/ansible-env/bin/activate

# Verify Ansible installation
ansible --version
```

#### 2. Test Connectivity
```bash
# Test all devices
ansible all -i inventory.yml -m ping

# Test specific groups
ansible dc1_core -i inventory.yml -m ping
ansible dc2_access -i inventory.yml -m ping
```

## 📁 Project Structure

```
ansible_training/
├── inventory.yml                 # Device inventory
├── test_ssh_connectivity.sh      # SSH connectivity test script
├── ANSIBLE_INSTALLATION_GUIDE.md # Installation documentation
├── INVENTORY_STRUCTURE.md       # Inventory structure guide
├── README.md                     # This file
└── ~/ansible-env/               # Virtual environment (outside project)
    ├── bin/
    │   ├── ansible
    │   ├── python3
    │   └── activate
    └── lib/python3.12/site-packages/
        ├── ansible/
        ├── jinja2/
        └── ...
```

## 🎯 Learning Objectives

### Phase 1: Foundation (Completed ✅)
- [x] Understand virtual environments
- [x] Install Ansible in isolated environment
- [x] Create hierarchical inventory structure
- [x] Test connectivity to all devices
- [x] Understand security considerations

### Phase 2: Basic Automation (Next)
- [ ] Create first playbook
- [ ] Run basic network commands
- [ ] Gather device information
- [ ] Understand Ansible modules

### Phase 3: Advanced Automation (Future)
- [ ] Configuration management
- [ ] Template-based configurations
- [ ] Role-based organization
- [ ] Error handling and validation

## 🔧 Common Commands

### Connectivity Testing
```bash
# Test all devices
ansible all -i inventory.yml -m ping

# Test specific data center
ansible dc1 -i inventory.yml -m ping
ansible dc2 -i inventory.yml -m ping

# Test specific layer
ansible dc1_core -i inventory.yml -m ping
ansible dc2_access -i inventory.yml -m ping
```

### Device Information Gathering
```bash
# Get device hostnames
ansible all -i inventory.yml -m nxos_command -a "show hostname"

# Get device versions
ansible all -i inventory.yml -m nxos_command -a "show version"

# Get interface information
ansible all -i inventory.yml -m nxos_command -a "show interface brief"
```

### Inventory Management
```bash
# List all devices
ansible-inventory -i inventory.yml --list

# List specific group
ansible-inventory -i inventory.yml --list --host dc1_core
```

## 📚 Documentation

- **[Ansible Installation Guide](ANSIBLE_INSTALLATION_GUIDE.md)**: Complete installation process with visual aids
- **[Inventory Structure Guide](INVENTORY_STRUCTURE.md)**: Understanding hierarchical inventory organization
- **[SSH Connectivity Script](test_ssh_connectivity.sh)**: Automated connectivity testing

## 🔒 Security Considerations

### Current Setup (Lab Environment)
- **Authentication**: Password-based SSH
- **Security Level**: Low (lab environment)
- **Purpose**: Learning and development

### Production Recommendations
- **SSH Key Authentication**: Use SSH keys instead of passwords
- **Ansible Vault**: Encrypt sensitive data
- **Role-Based Access**: Implement proper user permissions
- **Audit Logging**: Track all automation activities

## 🎓 Key Concepts Learned

### Virtual Environments
- **Isolation**: Separate Python environment from system
- **Dependencies**: Manage package versions independently
- **Clean Removal**: Easy to delete entire environment
- **Best Practices**: Industry standard for Python projects

### Ansible Inventory
- **Hierarchical Structure**: Logical device organization
- **Group Targeting**: Run commands on specific device groups
- **Variable Inheritance**: Global, group, and host variables
- **Scalability**: Easy to add new devices and groups

### Network Automation
- **Connection Methods**: SSH-based device management
- **Module Usage**: Specialized network modules
- **Error Handling**: Timeout and connection management
- **Security**: Authentication and encryption considerations

## 🚀 Next Steps

1. **Create First Playbook**: Learn playbook structure and syntax
2. **Device Information Gathering**: Use Ansible to collect device data
3. **Configuration Management**: Automate device configurations
4. **Advanced Features**: Roles, templates, and error handling
5. **Security Implementation**: SSH keys and Ansible Vault

## 📖 Study Guide

This project serves as a comprehensive study guide for network automation with Ansible. Each file contains detailed explanations, visual aids, and practical examples to reinforce learning concepts.

### Recommended Learning Path:
1. **Read Installation Guide**: Understand virtual environments
2. **Study Inventory Structure**: Learn device organization
3. **Practice Commands**: Test connectivity and basic operations
4. **Create Playbooks**: Build automation workflows
5. **Implement Security**: Apply production best practices

---

*This project demonstrates practical network automation skills using industry-standard tools and best practices. Use this as a reference for future automation projects and as a foundation for advanced Ansible concepts.*
