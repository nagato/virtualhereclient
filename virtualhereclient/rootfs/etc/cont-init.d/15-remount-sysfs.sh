#!/command/with-contenv bashio
# ==============================================================================
# VirtualHere Client 2.0: Remount /sys read-write (always)
# ==============================================================================

set -euo pipefail

bashio::log.info "Remounting /sys as read-write for vhci operations"
if mount -o remount,rw -t sysfs sysfs /sys 2>/dev/null; then
  bashio::log.info "Remounted /sys read-write"
else
  bashio::log.warning "Failed to remount /sys read-write; device attach may fail"
fi
