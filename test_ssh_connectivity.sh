#!/bin/bash

# Test SSH connectivity to all Nexus switches
# Username: admin, Password: admin

echo "Testing SSH connectivity to all Nexus switches..."
echo "================================================"

# Array of all switch IPs
switches=(
    "10.0.100.10"  # NX_DC1_Core_01
    "10.0.100.11"  # NX_DC1_Core_02
    "10.0.100.12"  # NX_DC1_Dis_01
    "10.0.100.13"  # NX_DC1_Dis_02
    "10.0.100.14"  # NX_DC1_ACC_01
    "10.0.100.15"  # NX_DC1_ACC_02
    "10.0.100.16"  # NX_BDR_01
    "10.0.100.17"  # NX_DC2_Core_01
    "10.0.100.18"  # NX_DC2_Core_02
    "10.0.100.19"  # NX_DC2_Dis_01
    "10.0.100.20"  # NX_DC2_Dis_02
    "10.0.100.21"  # NX_DC2_ACC_01
    "10.0.100.22"  # NX_DC2_ACC_02
)

# Test each switch
for ip in "${switches[@]}"; do
    echo -n "Testing $ip... "
    
    # Use sshpass with improved options for better compatibility
    if timeout 15 sshpass -p admin ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o ConnectTimeout=10 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 admin@$ip "show hostname" 2>/dev/null; then
        echo "✓ SUCCESS"
    else
        echo "✗ FAILED"
    fi
done

echo "================================================"
echo "SSH connectivity test completed!"
