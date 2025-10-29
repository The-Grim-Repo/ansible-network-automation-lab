# Ansible Playbook Learning Guide

## 🎯 Overview

This guide teaches you how to create, understand, and execute Ansible playbooks for network automation. You'll learn not just the syntax, but why each component is needed and how it all works together to automate your network devices.

## 📚 Table of Contents

1. [Understanding Playbooks](#understanding-playbooks)
2. [Inventory Structure](#inventory-structure)
3. [Playbook Structure](#playbook-structure)
4. [Jinja2 Templating](#jinja2-templating)
5. [Host Variables & Group Variables](#host-variables--group-variables)
6. [Playbook Targeting](#playbook-targeting)
7. [Creating Your First Playbook](#creating-your-first-playbook)
8. [Running Playbooks](#running-playbooks)
9. [Common Modules](#common-modules)
10. [Best Practices](#best-practices)
11. [Troubleshooting](#troubleshooting)

---

## 🧠 Understanding Playbooks

### What is an Ansible Playbook?

**Why This Concept is Needed:**
Ansible playbooks are the heart of network automation. They're like "recipes" that tell Ansible exactly what to do on your network devices. Without playbooks, you'd have to manually run commands on each device.

**What This Accomplishes:**
- **Automates repetitive tasks**: No more manual configuration on each device
- **Ensures consistency**: Same configuration applied to all devices
- **Enables scalability**: Manage hundreds of devices with one command
- **Provides documentation**: Playbooks serve as living documentation of your network

**Learning Point:** Think of a playbook like a "cooking recipe." Just as a recipe tells you step-by-step how to make a dish, a playbook tells Ansible step-by-step how to configure your network devices.

### Playbook vs. Ad-hoc Commands

**Why This Distinction Matters:**
- **Ad-hoc commands**: Single commands run once (like `ansible all -m ping`)
- **Playbooks**: Complex, multi-step automation (like configuring VLANs, interfaces, etc.)

**What This Accomplishes:**
- **Ad-hoc**: Quick tasks, testing, one-off changes
- **Playbooks**: Complex automation, repeatable processes, production deployments

**Learning Point:** Ad-hoc commands are like "microwave meals" - quick and simple. Playbooks are like "cooking a full dinner" - complex, planned, and repeatable.

---

## 📦 Inventory Structure

### What is an Inventory?

**Why This Concept is Needed:**
Before Ansible can run playbooks, it needs to know:
- **Which devices to manage**: IP addresses or hostnames
- **How to access them**: SSH credentials, connection type
- **How to organize them**: Groups and relationships
- **Device-specific settings**: Variables unique to each device

**What This Accomplishes:**
- Provides a single source of truth for all your devices
- Enables targeting specific groups of devices
- Centralizes credential management
- Supports complex network topologies

### Inventory Hierarchy Visual

```
┌─────────────────────────────────────────────────────────────┐
│                    INVENTORY (all devices)                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                DC1 (Data Center 1)                   │  │
│  ├──────────────────────────────────────────────────────┤  │
│  │  ┌──────────────────┐      ┌──────────────────┐     │  │
│  │  │   DC1_CORE       │      │   DC1_ACCESS     │     │  │
│  │  ├──────────────────┤      ├──────────────────┤     │  │
│  │  │ NX_DC1_Core_01   │      │ NX_DC1_Acc_01    │     │  │
│  │  │ NX_DC1_Core_02   │      │ NX_DC1_Acc_02    │     │  │
│  │  │ NX_DC1_Core_03   │      │ NX_DC1_Acc_03    │     │  │
│  │  └──────────────────┘      └──────────────────┘     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                DC2 (Data Center 2)                   │  │
│  ├──────────────────────────────────────────────────────┤  │
│  │  ┌──────────────────┐      ┌──────────────────┐     │  │
│  │  │   DC2_CORE       │      │   DC2_ACCESS     │     │  │
│  │  ├──────────────────┤      ├──────────────────┤     │  │
│  │  │ NX_DC2_Core_01   │      │ NX_DC2_Acc_01    │     │  │
│  │  │ NX_DC2_Core_02   │      │ NX_DC2_Acc_02    │     │  │
│  │  └──────────────────┘      └──────────────────┘     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Inventory File Example

```yaml
---
# All devices are organized here
all:
  children:
    # First data center
    dc1:
      children:
        dc1_core:
          hosts:
            nx_dc1_core_01:
              ansible_host: 10.0.100.10
              ansible_user: admin
              ansible_ssh_pass: admin
        dc1_access:
          hosts:
            nx_dc1_acc_01:
              ansible_host: 10.0.100.20
    # Second data center
    dc2:
      children:
        dc2_core:
          hosts:
            nx_dc2_core_01:
              ansible_host: 10.1.100.10
  # Global variables (applied to all devices)
  vars:
    ansible_connection: network_cli
    ansible_network_os: nxos
    ansible_command_timeout: 30
```

---

## 📋 Playbook Structure

### Basic Playbook Anatomy

**Why This Structure is Needed:**
Playbooks need to be organized and readable. The YAML structure provides:
- **Clarity**: Easy to read and understand
- **Consistency**: Standard format across all playbooks
- **Maintainability**: Easy to modify and update
- **Collaboration**: Others can understand and contribute

**What This Accomplishes:**
- Creates a logical flow from start to finish
- Makes playbooks self-documenting
- Enables version control and collaboration
- Provides error handling and validation

**Learning Point:** Think of playbook structure like a "movie script." It has a clear beginning, middle, and end, with specific instructions for each "actor" (device).

### Playbook Layers Visual

```
┌──────────────────────────────────────────────────────────────┐
│  PLAYBOOK FILE (targeting_demo.yml)                          │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ PLAY DEFINITION                                        │ │
│  ├────────────────────────────────────────────────────────┤ │
│  │ • name: Describe what this play does                 │ │
│  │ • hosts: all, dc1_core, dc2_access, etc.             │ │
│  │ • gather_facts: true/false                           │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ VARIABLES (Optional)                                  │ │
│  ├────────────────────────────────────────────────────────┤ │
│  │ vars:                                                │ │
│  │   vlan_id: 100                                       │ │
│  │   vlan_name: "Management"                            │ │
│  │   timeout: 30                                        │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ TASKS (The Work)                                     │ │
│  ├────────────────────────────────────────────────────────┤ │
│  │ Task 1: Get hostname                                │ │
│  │ Task 2: Display hostname                            │ │
│  │ Task 3: Get version                                 │ │
│  │ Task 4: Display version                             │ │
│  │ ... (More tasks as needed)                          │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Key Components Explained

**Why Each Component is Needed:**

#### 1. **`name`**: Descriptive Title
- **Purpose**: Documentation and identification
- **Benefit**: Makes playbooks self-documenting
- **Example**: `"Get hostname from all devices"`

#### 2. **`hosts`**: Target Selection
- **Purpose**: Controls which devices the playbook runs on
- **Benefit**: Enables targeted automation
- **Options**: `all`, `dc1_core`, `dc1:dc2`, `!dc1_access`, etc.

#### 3. **`gather_facts`**: System Information Collection
- **Purpose**: Saves time on network devices (usually set to `false`)
- **Benefit**: Faster execution, less network traffic
- **Note**: Network devices don't have traditional "facts" like servers

#### 4. **`vars`**: Playbook Variables
- **Purpose**: Makes playbooks flexible and reusable
- **Benefit**: Same playbook can work with different values
- **Example**: Define VLAN IDs, interface names, timeout values

#### 5. **`tasks`**: The Actual Work
- **Purpose**: Defines the automation steps
- **Benefit**: Clear, sequential execution
- **Structure**: Each task has a name and a module to execute

---

## 🎨 Jinja2 Templating

### What is Jinja2 Templating?

**Why This Concept is Needed:**
Jinja2 templating allows you to:
- **Insert dynamic data**: Replace placeholders with actual values
- **Process variables**: Transform and filter data
- **Create logic**: Use conditionals and loops
- **Format output**: Create readable, customized output

**What This Accomplishes:**
- Makes playbooks flexible and powerful
- Enables dynamic configuration generation
- Provides output formatting and customization
- Supports complex automation logic

### Jinja2 Syntax Examples

```yaml
# Basic Variable Interpolation
msg: "Device hostname is {{ hostname_variable }}"

# Accessing Dictionary Keys
msg: "Device IP: {{ device.management_ip }}"

# Accessing List Indexes
msg: "First output line: {{ output_lines[0] }}"

# Filters (Transform Data)
msg: "Uppercase hostname: {{ hostname | upper }}"
msg: "List length: {{ interfaces | length }}"
msg: "First 3 items: {{ devices[0:3] }}"

# Conditionals (If/Else Logic)
msg: "{% if device_type == 'core' %}Core Device{% else %}Access Device{% endif %}"

# Loops (Repeat for Each Item)
{% for interface in interfaces %}
  - Interface: {{ interface.name }}
    Status: {{ interface.status }}
{% endfor %}
```

### Real-World Example

```yaml
- name: "Display device information"
  debug:
    msg: |
      ╔════════════════════════════════════════╗
      ║  DEVICE INFORMATION                    ║
      ╠════════════════════════════════════════╣
      ║ Hostname: {{ hostname_output.stdout_lines[0] }}
      ║ Device Type: {{ device_type }}
      ║ Management IP: {{ ansible_host }}
      ║ Status: {{ device_status | upper }}
      ╚════════════════════════════════════════╝
```

---

## 🏠 Host Variables & Group Variables

### Host Variables

**Why Host Variables are Needed:**
Some settings are specific to individual devices:
- **Unique identification**: Serial numbers, asset tags
- **Device-specific config**: Performance tuning per device
- **Custom settings**: Device-specific parameters

**What This Accomplishes:**
- Allows device-specific customization
- Overrides group settings for specific hosts
- Enables fine-grained control

**Example:**

```yaml
all:
  children:
    dc1_core:
      hosts:
        nx_dc1_core_01:
          ansible_host: 10.0.100.10
          device_role: "primary"        # HOST VARIABLE
          backup_interval: 4            # HOST VARIABLE
        nx_dc1_core_02:
          ansible_host: 10.0.100.11
          device_role: "secondary"      # HOST VARIABLE (different value)
          backup_interval: 6            # HOST VARIABLE (different value)
```

### Group Variables

**Why Group Variables are Needed:**
Some settings apply to many devices:
- **Common credentials**: Username/password for all devices
- **Connection settings**: Network OS, connection type
- **Standard timeouts**: Consistent across device groups
- **Policy settings**: Security, monitoring settings

**What This Accomplishes:**
- Reduces redundancy (no need to repeat for each device)
- Ensures consistency across device groups
- Makes updates easier (change once for the whole group)
- Supports organizational structure

**Example:**

```yaml
all:
  vars:
    # These apply to ALL devices
    ansible_connection: network_cli
    ansible_network_os: nxos
    ansible_user: admin
    ansible_ssh_pass: admin
  children:
    dc1:
      vars:
        # These apply to all DC1 devices
        region: "us-east"
        datacenter: "DC1"
        ntp_server: "10.0.1.1"
      children:
        dc1_core:
          vars:
            # These apply only to core devices
            device_tier: "core"
            bgp_asn: 65001
```

### Variable Hierarchy (Priority Order)

```
┌─────────────────────────────────────────────────────┐
│  WHICH VARIABLES TAKE PRIORITY?                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  1. HOST VARIABLES (Highest Priority)              │
│     └─ Device-specific: overrides everything       │
│                                                     │
│  2. PLAYBOOK VARIABLES                             │
│     └─ Set in the playbook itself                  │
│                                                     │
│  3. GROUP VARIABLES                                │
│     └─ Applied to device groups                    │
│                                                     │
│  4. INVENTORY VARS (Lowest Priority)               │
│     └─ Global defaults for all devices             │
│                                                     │
└─────────────────────────────────────────────────────┘

EXAMPLE:
If "timeout" is set in all 4 places, Ansible uses HOST VARIABLES value
```

---

## 🎯 Playbook Targeting

### Understanding Target Selection

**Why Targeting is Needed:**
You rarely want to run playbooks on ALL devices. Targeting lets you:
- **Run on specific groups**: All core devices, all access devices
- **Run on specific devices**: Single device for testing
- **Run on multiple groups**: Combine different groups
- **Exclude devices**: Run on all EXCEPT specific devices

**What This Accomplishes:**
- Prevents accidental changes to wrong devices
- Enables targeted testing and validation
- Supports different deployment strategies
- Reduces execution time by limiting scope

### Targeting Methods

#### Method 1: Using `hosts` Parameter

```yaml
# Run on all devices
hosts: all

# Run on specific group
hosts: dc1_core

# Run on multiple groups (colon-separated)
hosts: dc1_core:dc1_access

# Run on all EXCEPT a group
hosts: all:!dc1_access
```

#### Method 2: Using `--limit` Flag (Most Flexible)

```bash
# Run on DC1 core devices only
ansible-playbook -i inventory.yml playbook.yml --limit dc1_core

# Run on multiple groups
ansible-playbook -i inventory.yml playbook.yml --limit "dc1_core,dc2_core"

# Run on specific device
ansible-playbook -i inventory.yml playbook.yml --limit nx_dc1_core_01

# Run on all EXCEPT a group
ansible-playbook -i inventory.yml playbook.yml --limit "all:!dc1_access"

# Run on devices matching a pattern
ansible-playbook -i inventory.yml playbook.yml --limit "dc1*"
```

### Targeting Decision Tree

```
┌────────────────────────────────────────────────────────────┐
│  WHICH TARGETING METHOD SHOULD YOU USE?                    │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Do you want to target the same group every time?         │
│  └─ YES ──> Use 'hosts:' in playbook                      │
│  └─ NO  ──> Use '--limit' flag at runtime                 │
│                                                            │
│  Do you need different targets on different runs?         │
│  └─ YES ──> Use '--limit' flag (more flexible)            │
│  └─ NO  ──> Use 'hosts:' (simpler, self-documenting)      │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## 🚀 Creating Your First Playbook

### Step 1: Create a Simple Information Gathering Playbook

**Why This Step is Needed:**
Before automating configuration changes, you need to understand what's currently on your devices. Information gathering playbooks:
- **Establish baseline**: Know the current state of your devices
- **Validate connectivity**: Ensure Ansible can communicate with devices
- **Test modules**: Verify that Ansible modules work with your devices
- **Build confidence**: Start with safe, read-only operations

**What This Accomplishes:**
- Creates a foundation for more complex automation
- Validates your Ansible setup and inventory
- Provides current device information
- Establishes a safe starting point for learning

**Learning Point:** Think of this like "taking inventory" before reorganizing a warehouse. You need to know what's there before you can make changes.

```yaml
---
- name: "Gather basic information from all network devices"
  hosts: all
  gather_facts: false
  tasks:
    - name: "Get device hostname"
      cisco.nxos.nxos_command:
        commands: "show hostname"
      register: hostname_output

    - name: "Display hostname"
      debug:
        msg: "Device hostname: {{ hostname_output.stdout_lines[0] }}"
```

---

## 🏃 Running Playbooks

### Step 2: Execute Your First Playbook

**Why This Step is Needed:**
Creating a playbook is only half the battle. Running it:
- **Tests the playbook**: Verifies it works correctly
- **Validates connectivity**: Ensures Ansible can reach all devices
- **Shows results**: Displays the output and any errors
- **Builds confidence**: Proves the automation works

**What This Accomplishes:**
- Executes the automation on all target devices
- Provides feedback on success or failure
- Demonstrates the power of Ansible automation
- Establishes a working foundation for more complex playbooks

**Learning Point:** Think of running a playbook like "pressing play on a movie." The playbook is the script, and running it executes the automation.

```bash
# Activate virtual environment (WHY: Ensure Ansible is available)
source ~/ansible-env/bin/activate

# Run the playbook on all devices
ansible-playbook -i inventory.yml playbooks/gather_info.yml

# Run on specific group
ansible-playbook -i inventory.yml playbooks/gather_info.yml --limit dc1_core

# Run with verbose output
ansible-playbook -i inventory.yml playbooks/gather_info.yml -v

# Run with very verbose output (for debugging)
ansible-playbook -i inventory.yml playbooks/gather_info.yml -vvv
```

---

## 🔧 Common Modules

### Network-Specific Modules

**Why These Modules are Needed:**
Network devices are different from servers. They need specialized modules that:
- **Understand network protocols**: Handle routing, switching, VLANs
- **Work with CLI commands**: Execute network-specific commands
- **Handle device states**: Manage configuration and operational states
- **Provide network context**: Understand network topologies and relationships

**What This Accomplishes:**
- Enables network-specific automation
- Provides network-aware functionality
- Simplifies complex network operations
- Ensures proper network device management

### Essential Cisco NX-OS Modules

#### 1. `cisco.nxos.nxos_command` Module

**Why This Module is Needed:**
- **Universal compatibility**: Works with any Cisco NX-OS command
- **Flexibility**: Can execute any CLI command
- **Power**: Enables complex network operations
- **Familiarity**: Uses commands network engineers already know

**What This Accomplishes:**
- Executes any command on Nexus devices
- Captures command output for processing
- Enables complex network automation
- Provides maximum flexibility

```yaml
- name: "Execute NX-OS command"
  cisco.nxos.nxos_command:
    commands:
      - "show interface brief"
      - "show vlan"
  register: command_output

- name: "Display output"
  debug:
    msg: "{{ command_output.stdout_lines }}"
```

#### 2. `cisco.nxos.nxos_config` Module

**Why This Module is Needed:**
- **Configuration management**: Handles device configuration changes
- **State management**: Manages configuration state
- **Validation**: Ensures configuration is applied correctly
- **Rollback**: Enables configuration rollback if needed

**What This Accomplishes:**
- Manages device configuration
- Ensures consistent configuration across devices
- Provides configuration validation
- Enables configuration rollback

```yaml
- name: "Configure device"
  cisco.nxos.nxos_config:
    lines:
      - "interface Ethernet1/1"
      - "description Management Interface"
      - "no shutdown"
```

#### 3. `cisco.nxos.nxos_facts` Module

**Why This Module is Needed:**
- **Device information**: Gathers comprehensive device information
- **Automation context**: Provides data for conditional logic
- **Documentation**: Creates device documentation
- **Validation**: Verifies device capabilities and features

**What This Accomplishes:**
- Collects device information automatically
- Provides data for intelligent automation
- Creates device documentation
- Enables device-specific logic

```yaml
- name: "Gather device facts"
  cisco.nxos.nxos_facts:
    gather_subset: all
  register: device_facts
```

---

## 📋 Best Practices

### Playbook Organization

**Why Organization Matters:**
- **Maintainability**: Easy to find and modify playbooks
- **Collaboration**: Others can understand and contribute
- **Scalability**: Supports growth and complexity
- **Reusability**: Playbooks can be shared and reused

**What This Accomplishes:**
- Creates a logical structure for automation
- Enables team collaboration
- Supports complex automation projects
- Makes playbooks reusable and maintainable

### Recommended Directory Structure

```
ansible_training/
├── README.md                      # Project overview
├── inventory.yml                  # Device inventory
├── ansible.cfg                    # Ansible configuration
├── playbooks/
│   ├── targeting_demo.yml        # Targeting examples
│   ├── get_hostnames.yml         # Hostname gathering
│   ├── device_inventory.yml      # Comprehensive device info
│   └── (more playbooks...)
├── group_vars/
│   ├── dc1.yml                   # Variables for DC1
│   ├── dc1_core.yml              # Variables for DC1 core
│   └── (more group variables...)
├── host_vars/
│   ├── nx_dc1_core_01.yml        # Variables for specific host
│   └── (more host variables...)
└── troubleshooting/
    ├── README.md
    └── playbooks/
```

---

## 🔧 Troubleshooting

### Common Issues and Solutions

#### Issue: "Module not found"
**Why This Happens:**
- Ansible modules aren't installed
- Wrong module name used
- Network modules not available

**Solution:**
```bash
# Install network modules collection
ansible-galaxy collection install cisco.nxos

# Verify module availability
ansible-doc cisco.nxos.nxos_command
```

#### Issue: "Connection timeout"
**Why This Happens:**
- Network connectivity issues
- SSH configuration problems
- Device authentication issues

**Solution:**
```bash
# Test connectivity
ansible all -i inventory.yml -m ping

# Check SSH connection
ssh admin@10.0.100.10

# Verify inventory configuration
ansible-inventory -i inventory.yml --list
```

#### Issue: "Permission denied"
**Why This Happens:**
- SSH key not configured
- Wrong username/password
- Device access restrictions

**Solution:**
```bash
# Verify device access
ssh admin@10.0.100.10

# Check inventory credentials
ansible all -i inventory.yml -m ping -vvv
```

---

## 🎓 Learning Objectives Checklist

- [ ] Understand what Ansible playbooks are and why they're needed
- [ ] Know the basic structure of a playbook
- [ ] Understand inventory organization and hierarchy
- [ ] Create and run your first playbook
- [ ] Master Jinja2 templating for dynamic output
- [ ] Use host and group variables effectively
- [ ] Target specific groups and devices with playbooks
- [ ] Understand common network modules
- [ ] Apply best practices for playbook organization
- [ ] Troubleshoot common playbook issues

---

## 📖 Additional Resources

- **Ansible Documentation**: https://docs.ansible.com/ansible/latest/
- **Network Modules**: https://docs.ansible.com/ansible/latest/collections/cisco/nxos/
- **YAML Syntax**: https://yaml.org/spec/1.2/spec.html
- **Jinja2 Templating**: https://jinja.palletsprojects.com/

---

*This guide provides a comprehensive foundation for Ansible playbook development. Use it as a reference for creating network automation and as a learning resource for Ansible concepts.*
