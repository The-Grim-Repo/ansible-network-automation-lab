# Ansible Troubleshooting Guide

## Overview
This directory contains troubleshooting files and examples created during the learning process. These files demonstrate common issues and solutions when working with Ansible and network devices.

## Files in this Directory

### Playbooks
- `test_nxos_facts.yml` - Testing nxos_facts module (failed due to compatibility issues)
- `test_simple_nxos.yml` - Testing nxos_command without full namespace
- `raw_test.yml` - Testing raw module approach
- `simple_test.yml` - Basic connectivity test
- `working_hostname.yml` - Working hostname retrieval using raw module
- `get_hostnames_raw.yml` - Alternative hostname retrieval approach

### Documentation
- `NXOS_MODULE_COMPATIBILITY_FIX.md` - Complete resolution guide for NX-OS module compatibility issues

## Common Issues Encountered

### Issue 1: NX-OS Module Compatibility
**Error**: `ActionBase._parse_returned_data() missing 1 required positional argument: 'profile'`

**Cause**: Version compatibility issues between Ansible core 2.19.3 and cisco.nxos collection 11.0.0

**Solution**: Downgraded to stable versions (Ansible 8.0.0, cisco.nxos 4.0.0) ✅

### Issue 2: Concurrency/Timing Issues
**Error**: `ConnectionResetError: [Errno 104] Connection reset by peer`

**Cause**: Running against many devices simultaneously can overwhelm some devices

**Solution**: Retry the playbook - individual device testing works fine ✅

### Issue 2: Module Syntax
**Problem**: Commands parameter format

**Solution**: Use list format for commands:
```yaml
commands: "show hostname"  # String format
# vs
commands: ["show hostname"]  # List format (preferred)
```

## Working Solutions

### Raw Module Approach
```yaml
- name: "Get device hostname"
  raw: "show hostname"
  register: hostname_output
```

**Pros**: Simple, reliable, works with any command
**Cons**: Less error handling, no built-in parsing

### Ping Module for Connectivity
```yaml
- name: "Test connectivity"
  ping:
```

**Pros**: Simple, reliable connectivity test
**Cons**: Only tests reachability, no device information

## Best Practices for Troubleshooting

1. **Start Simple**: Begin with basic connectivity tests
2. **Test Incrementally**: Add complexity gradually
3. **Use Verbose Output**: Add `-v` flag for detailed error information
4. **Test on Subset**: Use `--limit` to test on fewer devices
5. **Check Module Documentation**: Use `ansible-doc` to verify syntax

## Commands for Troubleshooting

```bash
# Check Ansible version
ansible --version

# List available modules
ansible-doc -l | grep nxos

# Check module documentation
ansible-doc cisco.nxos.nxos_command

# Test with verbose output
ansible-playbook -i inventory.yml playbook.yml -v

# Test on specific group
ansible-playbook -i inventory.yml playbook.yml --limit dc1_core
```

## Learning Notes

- **Module Compatibility**: Newer collections may have different syntax requirements
- **Fallback Options**: Raw module provides reliable alternative when specialized modules fail
- **Version Management**: Keep track of Ansible and collection versions for compatibility
- **Testing Strategy**: Always test on small subset before running on all devices

---

*This troubleshooting guide documents the learning process and common issues encountered while working with Ansible network automation.*
