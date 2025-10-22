# Ansible Inventory Structure Guide

## Visual Representation of Your Lab Environment

```
┌─────────────────────────────────────────────────────────────────┐
│                    ANSIBLE INVENTORY STRUCTURE                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  all:                                                           │
│  ├── dc1: (Data Center 1)                                      │
│  │   ├── dc1_core:                                             │
│  │   │   ├── nx_dc1_core_01 (10.0.100.10)                     │
│  │   │   └── nx_dc1_core_02 (10.0.100.11)                     │
│  │   │                                                         │
│  │   ├── dc1_distribution:                                     │
│  │   │   ├── nx_dc1_dis_01 (10.0.100.12)                     │
│  │   │   └── nx_dc1_dis_02 (10.0.100.13)                     │
│  │   │                                                         │
│  │   ├── dc1_access:                                           │
│  │   │   ├── nx_dc1_acc_01 (10.0.100.14)                     │
│  │   │   └── nx_dc1_acc_02 (10.0.100.15)                     │
│  │   │                                                         │
│  │   └── dc1_border:                                           │
│  │       └── nx_bdr_01 (10.0.100.16)                         │
│  │                                                             │
│  └── dc2: (Data Center 2)                                     │
│      ├── dc2_core:                                             │
│      │   ├── nx_dc2_core_01 (10.0.100.17)                     │
│      │   └── nx_dc2_core_02 (10.0.100.18)                     │
│      │                                                         │
│      ├── dc2_distribution:                                     │
│      │   ├── nx_dc2_dis_01 (10.0.100.19)                     │
│      │   └── nx_dc2_dis_02 (10.0.100.20)                     │
│      │                                                         │
│      └── dc2_access:                                           │
│          ├── nx_dc2_acc_01 (10.0.100.21)                     │
│          └── nx_dc2_acc_02 (10.0.100.22)                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Key Inventory Concepts

### 1. **Hierarchical Structure**
- **Groups**: Logical collections of devices (dc1, dc2, core, distribution, access)
- **Children**: Sub-groups within larger groups
- **Hosts**: Individual network devices

### 2. **Connection Parameters**
Each device has these key settings:
```yaml
ansible_host: 10.0.100.10        # IP address
ansible_user: admin               # SSH username
ansible_ssh_pass: admin           # SSH password
ansible_connection: network_cli   # Connection method
ansible_network_os: nxos          # Network OS type
```

### 3. **SSH Security Settings**
```yaml
ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
```
- **StrictHostKeyChecking=no**: Don't verify SSH host keys
- **UserKnownHostsFile=/dev/null**: Don't store host keys

### 4. **Timeout Settings**
```yaml
ansible_command_timeout: 30       # Max time for commands
ansible_connect_timeout: 10      # Max time for connections
```

## Benefits of This Structure

### **Targeting Flexibility**
```bash
# Target all devices
ansible all -i inventory.yml -m ping

# Target specific data center
ansible dc1 -i inventory.yml -m ping

# Target specific tier
ansible dc1_core -i inventory.yml -m ping

# Target specific device
ansible nx_dc1_core_01 -i inventory.yml -m ping
```

### **Organized Management**
- **Geographic**: Separate DC1 and DC2
- **Functional**: Core, Distribution, Access layers
- **Scalable**: Easy to add new devices or groups

### **Variable Inheritance**
- **Global vars**: Apply to all devices
- **Group vars**: Apply to specific groups
- **Host vars**: Apply to individual devices

## Common Ansible Commands with This Inventory

```bash
# Test connectivity to all devices
ansible all -i inventory.yml -m ping

# Test connectivity to DC1 only
ansible dc1 -i inventory.yml -m ping

# Test connectivity to core switches only
ansible dc1_core:dc2_core -i inventory.yml -m ping

# Run a command on all devices
ansible all -i inventory.yml -m nxos_command -a "show version"

# Run a command on specific group
ansible dc1_access -i inventory.yml -m nxos_command -a "show interface brief"
```

## Learning Objectives

- [ ] Understand hierarchical inventory structure
- [ ] Know how to target different device groups
- [ ] Understand connection parameters for network devices
- [ ] Learn SSH security settings for lab environments
- [ ] Practice using different targeting methods
