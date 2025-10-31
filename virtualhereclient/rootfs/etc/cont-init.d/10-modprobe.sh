#!/command/with-contenv bashio
# ==============================================================================
# VirtualHere Client 2.0: Load kernel modules (vhci-hcd) if available
# ==============================================================================

set -euo pipefail

if lsmod 2>/dev/null | grep -q '^vhci_hcd'; then
  bashio::log.debug "Kernel module vhci_hcd already loaded"
else
  if modprobe vhci-hcd 2>/dev/null; then
    bashio::log.info "Loaded kernel module vhci_hcd"
  else
    bashio::log.warning "Could not load vhci_hcd; continuing. VirtualHere may not function without it."
  fi
fi
