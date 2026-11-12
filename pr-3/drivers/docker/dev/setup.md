---
title: Docker Driver
description: Run OpenShell sandboxes as containers on a Docker daemon.
url: /openshell-driver-docker/pr-3/drivers/docker/dev/setup/
docset: driver-docker
version: dev
latest_version: 0.2.0
source: "pimlock/openshell-driver-docker@PR #3, 89c8fd4:docs/setup.mdx"
---

> Documentation index: /openshell-driver-docker/pr-3/drivers/docker/dev/llms.txt. This page is for Docker driver dev.
> Preview build of pimlock/openshell-driver-docker (PR #3, 89c8fd4); not published. Published version (0.2.0): https://pimlock.github.io/openshell-docs/drivers/docker/0.2.0/setup.md

# Docker Driver

[Docker](https://www.docker.com/get-started/) runs sandboxes as containers on the Docker daemon host. The gateway accesses the daemon through its configured Unix socket.

```toml
[openshell.gateway]
compute_driver = "docker"

[openshell.drivers.docker]
socket_path = "/var/run/docker.sock"
```

Common options in `[openshell.drivers.docker]` are `socket_path`, `grpc_endpoint`, `supervisor_network_mode`, `host_gateway_ip`, `sandbox_runtime_image`, `supervisor_image`, `image_pull_policy`, and `sandbox_pids_limit`. When `socket_path` is unset, the driver uses the socket found by auto-detection.

`supervisor_network_mode` defaults to `host`. Set `bridge` to use Docker bridge networking; `auto` also selects host. The workload always retains `network=none`.

Host mode on Docker Desktop requires host networking enabled. Bridge mode automatically uses `host.docker.internal` for a gateway on the Desktop host. On native Linux, the gateway and host services must listen on bridge-reachable addresses. Set `grpc_endpoint` for remote gateways, remapped published ports, or other custom layouts. Endpoint selection preserves TLS verification and does not change the gateway's listener. See [Docker configuration](https://pimlock.github.io/openshell-docs/dev/how-it-works/gateways/configuration/#docker).

OpenShell discovers Docker's host address automatically in bridge mode. Set `host_gateway_ip` only to override discovery.

The sandbox must pass its Landlock and seccomp qualification in either network mode. For GPU sandboxes, configure Docker CDI before starting the gateway.

## Corporate Proxy Egress

For proxy-required networks, the Docker driver accepts `https_proxy`,
`no_proxy`, `proxy_auth_file`, `proxy_auth_allow_insecure`,
`proxy_connect_by_hostname`, and `proxy_ca_bundle`. The companion supervisor
chains policy-approved TLS tunnels through the proxy with HTTP CONNECT.

`proxy_ca_bundle` is an operator-owned gateway-host PEM path. Docker validates
and copies the bundle into its supervisor-only named volume, so this also works
with remote Docker daemons and does not expose the host path to the workload.
The supervisor uses the bundle for an HTTPS proxy connection and for upstream
certificates re-signed by a TLS-intercepting proxy. Workload processes receive
the same corporate roots through their generated combined trust bundle.

Sandbox environment, image contents, and `template.driver_config.docker`
cannot alter these settings. Invalid proxy relationships or CA files prevent
the gateway or sandbox from starting and never degrade to direct egress. See
the [Gateway Configuration File](https://pimlock.github.io/openshell-docs/dev/how-it-works/gateways/configuration/) for URL,
authentication, `NO_PROXY`, hostname CONNECT, and CA validation details.

## Mounts

Mount existing named volumes or `tmpfs` through driver config. Label volumes so resource admission accepts them:

```shell
docker volume create --label openshell.ai/sandbox-attachable=true \
  --label openshell.ai/sandbox-attachable-workspace=default openshell-work

openshell sandbox create \
  --from registry.example.com/team/claude-code:1.0 \
  --driver-config-json '{"docker":{"mounts":[{"type":"volume","source":"openshell-work","target":"/sandbox/work","read_only":false}]}}' \
  -- claude
```

| Type     | Fields                                                                                                    |
| -------- | --------------------------------------------------------------------------------------------------------- |
| `volume` | `source`, `target`, optional `read_only` (default `true`), optional `subpath`.                            |
| `tmpfs`  | `target`, optional `options`, `size_bytes`, `mode`.                                                       |
| `bind`   | `source` (absolute host path), `target`, optional `read_only` (default `true`), optional `selinux_label`. |

> **Warning:** Bind mounts expose gateway-host files to the sandbox and can bypass workspace isolation and filesystem policy. They require `enable_bind_mounts = true` and disabling resource admission for the driver:
>
> ```toml
> [openshell.drivers.docker]
> allow_driver_config = true
> enable_bind_mounts = true
>
> [openshell.drivers.docker.resource_admission]
> enabled = false
> ```

Mount targets cannot replace the workspace root, the container root, or OpenShell paths under `/opt/openshell`, `/etc/openshell`, and `/run/openshell`.
