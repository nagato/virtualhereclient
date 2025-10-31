#!/command/with-contenv bashio
# ==============================================================================
# VirtualHere Client 2.0: Configure client settings
# ==============================================================================

set -euo pipefail

# Configure AutoFind and ClientId behavior in the VirtualHere UI file
autofind_default=true
if bashio::config.has_value 'autofind'; then
  autofind_default=$(bashio::config 'autofind')
fi

AUTO_FIND_VALUE=1
if bashio::var.has_value "${autofind_default}" && [ "${autofind_default}" != "true" ]; then
  AUTO_FIND_VALUE=0
fi

CLIENT_ID=""
if bashio::config.has_value 'client_id'; then
  CLIENT_ID=$(bashio::config 'client_id')
fi

CFG_FILE="/vhclient/.vhui"
if [ -f "${CFG_FILE}" ]; then
  if grep -q '^AutoFind=' "${CFG_FILE}"; then
    sed -i "s/^AutoFind=.*/AutoFind=${AUTO_FIND_VALUE}/" "${CFG_FILE}"
  else
    printf "\nAutoFind=%s\n" "${AUTO_FIND_VALUE}" >> "${CFG_FILE}"
  fi
  if [ -n "${CLIENT_ID}" ]; then
    if grep -q '^ClientId=' "${CFG_FILE}"; then
      sed -i "s/^ClientId=.*/ClientId=${CLIENT_ID}/" "${CFG_FILE}"
    else
      printf "\nClientId=%s\n" "${CLIENT_ID}" >> "${CFG_FILE}"
    fi
  fi
else
  printf "[General]\nAutoFind=%s\n" "${AUTO_FIND_VALUE}" > "${CFG_FILE}"
  if [ -n "${CLIENT_ID}" ]; then
    printf "ClientId=%s\n" "${CLIENT_ID}" >> "${CFG_FILE}"
  fi
fi

bashio::log.info "Configured AutoFind=${AUTO_FIND_VALUE} in ${CFG_FILE}"
if [ -n "${CLIENT_ID}" ]; then
  bashio::log.info "Configured ClientId in ${CFG_FILE}"
fi
