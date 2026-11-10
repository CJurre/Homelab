test_node_load() {
  TEST_BULK_SERIAL=""
  case "$1" in
  pve-test)
    TEST_NAME=pve-test
    TEST_VMID=999
    TEST_MAC=BC:24:11:00:00:99
    TEST_IP=192.168.0.55
    TEST_BOOT_SERIAL=PVETEST001
    TEST_BULK_SERIAL=PVETESTBULK
    ;;
  pve-test2)
    TEST_NAME=pve-test2
    TEST_VMID=998
    TEST_MAC=BC:24:11:00:00:98
    TEST_IP=192.168.0.56
    TEST_BOOT_SERIAL=PVETEST002
    TEST_BULK_SERIAL=PVETESTBULK2
    ;;
  pve-test3)
    TEST_NAME=pve-test3
    TEST_VMID=997
    TEST_MAC=BC:24:11:00:00:97
    TEST_IP=192.168.0.57
    TEST_BOOT_SERIAL=PVETEST003
    ;;
  *)
    echo "Unknown test node: $1 (known: $TEST_NODES)" >&2
    return 1
    ;;
  esac
}

test_resolve() {
  if [ "$1" = "all" ]; then
    echo "$TEST_NODES"
  else
    echo "$1"
  fi
}

test_vm_exists() {
  ssh root@$TEST_PVE_HOST "qm status $TEST_VMID" &>/dev/null
}

test_vm_running() {
  ssh root@$TEST_PVE_HOST "qm status $TEST_VMID" 2>/dev/null | grep -q "status: running"
}

test_has_snapshot() {
  ssh root@$TEST_PVE_HOST "qm listsnapshot $TEST_VMID" 2>/dev/null | awk -v n="$1" '$2 == n {f=1} END {exit !f}'
}

test_skip() {
  if [ "${TEST_ARG:-}" = "all" ]; then
    echo "skip $TEST_NAME: $1"
  else
    echo "error $TEST_NAME: $1" >&2
    exit 1
  fi
}
