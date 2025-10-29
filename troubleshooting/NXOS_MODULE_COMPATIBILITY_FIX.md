# NX-OS Module Compatibility Issue - Resolution Guide

## Problem Summary
The `cisco.nxos.nxos_command` module was failing with the error:
```
ActionBase._parse_returned_data() missing 1 required positional argument: 'profile'
```

## Root Cause Analysis

### Initial Setup (Problematic)
- **Ansible Core**: 2.19.3 (cutting-edge version)
- **cisco.nxos collection**: 11.0.0 (cutting-edge version)
- **Python**: 3.12.3

### Why It Failed
1. **Version Incompatibility**: The very latest versions of Ansible and NX-OS collection had compatibility issues
2. **API Changes**: The newer collection version had internal API changes that weren't compatible with the newer Ansible core
3. **Profile Parameter**: The error suggested a missing 'profile' parameter in the module's internal parsing logic

## Solution Applied

### Downgraded to Stable Versions
```bash
# Downgrade Ansible to stable version
pip install ansible==8.0.0

# Install compatible NX-OS collection
ansible-galaxy collection install cisco.nxos:4.0.0
```

### Final Working Configuration
- **Ansible Core**: 2.15.13 (stable)
- **cisco.nxos collection**: 4.0.0 (stable)
- **Python**: 3.12.3 (unchanged)

## Verification Steps

### Test Command
```bash
ansible-playbook -i inventory.yml playbooks/get_hostnames.yml --limit dc1_core
```

### Expected Output
```
PLAY [Get hostnames from all devices] ******************************************

TASK [Get device hostname] *****************************************************
ok: [nx_dc1_core_01]
ok: [nx_dc1_core_02]

TASK [Display hostname] ********************************************************
ok: [nx_dc1_core_01] => {
    "msg": "Device hostname: ['NX_DC1_Core_01']"
}
ok: [nx_dc1_core_02] => {
    "msg": "Device hostname: ['NX_DC2_Core_02']"
}

PLAY RECAP *********************************************************************
nx_dc1_core_01             : ok=2    changed=0    unreachable=0    failed=0    skipped=0
nx_dc1_core_02             : ok=2    changed=0    unreachable=0    failed=0    skipped=0
```

## Key Learning Points

### 1. Version Compatibility is Critical
- **Don't always use the latest versions** in production environments
- **Test compatibility** between Ansible core and collection versions
- **Stable versions** are often more reliable than cutting-edge releases

### 2. Troubleshooting Approach
- **Identify the root cause** rather than working around it
- **Check version compatibility** when modules fail unexpectedly
- **Document the working combination** for future reference

### 3. Network Automation Best Practices
- **Use virtual environments** to isolate dependencies
- **Pin specific versions** in requirements files
- **Test with small subsets** before running on all devices

## Alternative Approaches Tried (Before Fix)

### 1. Raw Module with SSH
```yaml
- name: "Get device hostname"
  raw: "show hostname"
  register: hostname_output
  vars:
    ansible_connection: ssh
```
**Result**: Worked but was slower and less feature-rich

### 2. Different Connection Types
- `network_cli` with NX-OS module: Failed with profile error
- `ssh` with NX-OS module: Failed with "Connection type ssh is not valid"
- `ssh` with raw module: Worked but not optimal

## Prevention for Future

### 1. Version Management
```bash
# Create requirements file
echo "ansible==8.0.0" > requirements.txt
echo "cisco.nxos==4.0.0" >> requirements.txt

# Install from requirements
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.txt
```

### 2. Testing Strategy
- Always test new versions in isolated environments first
- Use `--limit` to test on small device subsets
- Document working version combinations

### 3. Monitoring
- Check Ansible and collection release notes for breaking changes
- Subscribe to security advisories for the collections you use
- Maintain a test environment that mirrors production

## Conclusion

The issue was resolved by downgrading to stable, tested versions of both Ansible core and the NX-OS collection. This demonstrates the importance of version compatibility in network automation environments and the value of using proven, stable releases rather than always chasing the latest features.

---

*This document serves as a reference for future troubleshooting of similar NX-OS module compatibility issues.*
