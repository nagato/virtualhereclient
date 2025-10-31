# VirtualHere Client (Home Assistant Add-on)

This add-on runs the VirtualHere USB client and automatically attaches configured USB devices from a VirtualHere server so they appear on the host for other Home Assistant add-ons.

## Features
- s6‑supervised client with a lightweight rule loop
- Discovery (Auto‑Find) control at runtime
- Explicit attachments via `USE` (optional Auto‑Use All)
- Devices appear under `/dev` and `/dev/serial/by-id` for other add-ons

## Configuration

- `usb_devices` (list, optional): identifiers from the `LIST` output. Use a bus path (e.g., `USB 1-1`), product name (e.g., `ConBee II`), or server‑qualified ID (e.g., `server.111`). These are used with `USE,<id>`.
- `autofind` (bool, default `true`): enable/disable discovery. When `false`, the client starts with auto‑find off and the service enforces it at runtime.
- `manual_hubs` (list, optional): manually add hubs by IP:port or EasyFind address via `MANUAL HUB ADD,<addr>`. Discovery is usually sufficient; use this if broadcasts are blocked.
- `auto_use_all` (bool, default `false`): toggle the global Auto‑Use All mode. When enabled, the client auto‑attaches newly discovered devices.
- `clear_auto_use_rules` (bool, default `false`): clear all auto‑use rules once at startup via `AUTO USE CLEAR ALL`.
- `client_id` (string, optional): set the client “In‑use by” label; applied via the client UI config file.
- `prefer_ipv6` (bool, default `false`): start the client with `-p` (Prefer IPv6/IPv4 dual‑stack).
- `language` (string, optional): pass a language code to the client with `-q`. Allowed values per client: `EN-US, ZH-CN, FR-FR, RU-RU, DE-DE, IT-IT, ES-AR, JP-JP, KO-KO, BG-BG`.

Example:

```
usb_devices:
  - "USB 1-1"           # bus path from LIST
  - "ConBee II"         # product name from LIST
autofind: true            # keep discovery enabled (recommended)
manual_hubs:
  - "192.168.1.10:7575"  # optional; use if discovery is blocked
auto_use_all: false       # let client auto-attach new devices
clear_auto_use_rules: false
client_id: ""              # optional client label
prefer_ipv6: false
language: "EN-US"         # optional; leave empty to use default
```

## Notes
- Auto-Find is set at runtime based on your `autofind` option. Server addition via IPC is not required; use identifiers from the `LIST` output (bus path, product name, or `server.device`).
- Host access is requested; keep Protection mode enabled if it works for you. If you see `/sys` remount warnings or missing device nodes, try turning Protection mode off for this add-on.
- The add-on attempts to load `vhci_hcd` via `modprobe`. Ensure your host allows kernel module loading for USB/IP (or pre-load on the host).
- Host networking is enabled to support discovery broadcasts.
- The client binary is downloaded at build time for your architecture.

## Services
- `vhclient`: runs `/vhclient/vhclient -n` (the VirtualHere client)
- `vhrules`: periodically applies `AUTO USE ALL` and `USE` rules

## Logs
All runtime logs are visible in the Home Assistant add-on logs. Configuration validation and actions use `bashio::log.*` for consistency.

## Troubleshooting
- If devices don’t attach, check that `vhci_hcd` is loaded on the host and that the VirtualHere server is reachable.
- Use the add-on logs to confirm discovery is enabled, see the `LIST` block, and verify successful `USE` lines.
- Try using device names instead of bus IDs if IDs appear unstable across restarts.
