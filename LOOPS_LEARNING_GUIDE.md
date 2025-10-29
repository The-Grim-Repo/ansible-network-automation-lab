# Ansible Loops Learning Guide

## 🔄 Understanding Loop Execution Order

### Visual Diagram: How Loops Work

```
PLAYBOOK EXECUTION ORDER
========================

Playbook targets: hosts: dc1_core (2 devices)
Interface list: 5 items

┌─────────────────────────────────────────────────────────────┐
│                    START PLAYBOOK                           │
│                  (targets: dc1_core)                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│         DEVICE 1: nx_dc1_core_01                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TASK 1: "Show which interfaces we'll configure"           │
│  ├─ Loop iteration 1: Eth1/1                              │
│  ├─ Loop iteration 2: Eth1/2                              │
│  ├─ Loop iteration 3: Eth1/3                              │
│  ├─ Loop iteration 4: Eth1/4                              │
│  └─ Loop iteration 5: Eth1/5                              │
│     (5 iterations total for Device 1)                      │
│                                                             │
│  TASK 2: "Get current interface status"                    │
│  ├─ Loop iteration 1: Show Eth1/1                         │
│  ├─ Loop iteration 2: Show Eth1/2                         │
│  ├─ Loop iteration 3: Show Eth1/3                         │
│  ├─ Loop iteration 4: Show Eth1/4                         │
│  └─ Loop iteration 5: Show Eth1/5                         │
│     (5 iterations total for Device 1)                      │
│                                                             │
│  TASK 3, 4, 5... (Same pattern - 5 loops each)            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│         DEVICE 2: nx_dc1_core_02                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TASK 1: "Show which interfaces we'll configure"           │
│  ├─ Loop iteration 1: Eth1/1                              │
│  ├─ Loop iteration 2: Eth1/2                              │
│  ├─ Loop iteration 3: Eth1/3                              │
│  ├─ Loop iteration 4: Eth1/4                              │
│  └─ Loop iteration 5: Eth1/5                              │
│     (5 iterations total for Device 2)                      │
│                                                             │
│  TASK 2: "Get current interface status"                    │
│  ├─ Loop iteration 1: Show Eth1/1                         │
│  ├─ Loop iteration 2: Show Eth1/2                         │
│  ├─ Loop iteration 3: Show Eth1/3                         │
│  ├─ Loop iteration 4: Show Eth1/4                         │
│  └─ Loop iteration 5: Show Eth1/5                         │
│     (5 iterations total for Device 2)                      │
│                                                             │
│  TASK 3, 4, 5... (Same pattern - 5 loops each)            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    END PLAYBOOK                             │
│              Total Loop Iterations: 10                      │
│            (5 interfaces × 2 devices)                       │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 Order of Operations (Step by Step)

### The Three Layers of Iteration

```
LAYER 1: Device Iteration (Outer Layer)
├─ For each host in the playbook target (dc1_core = 2 devices)
│
└─ LAYER 2: Task Iteration (Middle Layer)
   ├─ For each task defined in the playbook (6 tasks)
   │
   └─ LAYER 3: Loop Iteration (Inner Layer)
      └─ For each item in the loop (5 interfaces)
```

### Detailed Execution Timeline

```
STEP 1: Device 1 (nx_dc1_core_01)
  ├─ Task 1: Show interfaces
  │   ├─ Loop 1: Process Eth1/1
  │   ├─ Loop 2: Process Eth1/2
  │   ├─ Loop 3: Process Eth1/3
  │   ├─ Loop 4: Process Eth1/4
  │   └─ Loop 5: Process Eth1/5
  │
  ├─ Task 2: Get interface status
  │   ├─ Loop 1: Show Eth1/1
  │   ├─ Loop 2: Show Eth1/2
  │   ├─ Loop 3: Show Eth1/3
  │   ├─ Loop 4: Show Eth1/4
  │   └─ Loop 5: Show Eth1/5
  │
  └─ Tasks 3-6: (same pattern, 5 loops each)

STEP 2: Device 2 (nx_dc1_core_02)
  ├─ Task 1: Show interfaces
  │   ├─ Loop 1: Process Eth1/1
  │   ├─ Loop 2: Process Eth1/2
  │   ├─ Loop 3: Process Eth1/3
  │   ├─ Loop 4: Process Eth1/4
  │   └─ Loop 5: Process Eth1/5
  │
  ├─ Task 2: Get interface status
  │   ├─ Loop 1: Show Eth1/1
  │   ├─ Loop 2: Show Eth1/2
  │   ├─ Loop 3: Show Eth1/3
  │   ├─ Loop 4: Show Eth1/4
  │   └─ Loop 5: Show Eth1/5
  │
  └─ Tasks 3-6: (same pattern, 5 loops each)
```

---

## 🧠 Key Concepts

### Why It Works This Way

**Ansible's Execution Model:**
1. **Hosts are the outer loop** - For EACH host
2. **Tasks are the middle loop** - Run EACH task
3. **Loop items are the inner loop** - Iterate EACH item

**In our example:**
- 2 hosts × 6 tasks × 5 loop items = 60 total operations
- But we see "10 times" because each task shows one per device
- Actually: Task 1 runs 10 times total (5 for device 1, 5 for device 2)

### Important: Loop Behavior

```yaml
# When you use a loop in a task:
- name: "Example task with loop"
  debug:
    msg: "Processing {{ item }}"
  loop: [1, 2, 3, 4, 5]

# For EACH host in the playbook:
#   For EACH task in the playbook:
#     For EACH item in the loop:
#       Execute the task
```

---

## 🎯 Real-World Example: Your Lab

**Your playbook had:**
- Hosts: `dc1_core` (nx_dc1_core_01, nx_dc1_core_02) = 2 devices
- Tasks: 6 different tasks
- Each task with loop: 5 interfaces

**Total executions per device:** 6 tasks × 5 loops = 30 per device
**Total for all devices:** 30 × 2 devices = 60 total operations

**Why you saw "10 times":**
- Task 1 "Show which interfaces" printed output 10 times
- (5 iterations for device 1 + 5 iterations for device 2 = 10 total lines)

---

## 💡 Quick Takeaway

```
Device 1 → Task 1 → Loop 1-5 (5 iterations)
Device 1 → Task 2 → Loop 1-5 (5 iterations)
Device 1 → Task 3 → Loop 1-5 (5 iterations)
...
Device 2 → Task 1 → Loop 1-5 (5 iterations)
Device 2 → Task 2 → Loop 1-5 (5 iterations)
Device 2 → Task 3 → Loop 1-5 (5 iterations)
...
```

**Result:** Everything runs sequentially, one after another, completing all tasks for Device 1 before moving to Device 2.

