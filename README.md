# Home Assistant add-on: Tinyproxy

A lightweight HTTP/HTTPS forward proxy ([tinyproxy](https://tinyproxy.github.io/))
running on the host network of your Home Assistant machine.

Typical use case: give remote machines (e.g. a cloud VPS reachable over
Tailscale or a VPN) egress through your residential IP — for services that
block or throttle datacenter IP ranges.

## Installation

1. **Settings → Add-ons → Add-on store → ⋮ → Repositories**, add:
   `https://github.com/craqs/ha-tinyproxy`
2. Install **Tinyproxy** from the store.
3. Review the configuration (especially `allowed_clients`) and start the add-on.

## Configuration

| Option | Default | Description |
|---|---|---|
| `port` | `8888` | TCP port the proxy listens on (all host interfaces). |
| `allowed_clients` | `["100.64.0.0/10"]` | IPs/CIDRs allowed to use the proxy. **Empty list = open to every client that can reach the host — don't do that.** Default covers the Tailscale CGNAT range. |
| `connect_ports` | `[443, 80]` | Destination ports allowed for HTTPS `CONNECT`. Empty list = any port. |
| `disable_via_header` | `true` | Don't add the `Via:` header (reduces proxy fingerprinting). |
| `log_level` | `Notice` | One of `Critical`, `Error`, `Warning`, `Notice`, `Connect`, `Info`. |
| `max_clients` | `20` | Maximum simultaneous client connections. |
| `timeout` | `600` | Idle connection timeout in seconds. |

## Example

A cloud server on your tailnet uses the proxy with:

```bash
export https_proxy=http://<ha-tailscale-ip>:8888
```

Restrict access to that single machine:

```yaml
allowed_clients:
  - "100.84.217.105"
```
