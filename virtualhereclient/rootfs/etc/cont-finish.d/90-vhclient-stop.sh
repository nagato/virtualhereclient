#!/command/with-contenv bashio

# Gracefully detach all devices on container shutdown
/vhclient/vhclient -t "STOP ALL" >/dev/null 2>&1 || true
