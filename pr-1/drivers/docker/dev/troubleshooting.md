---
title: Troubleshooting
description: Diagnose common Docker driver problems.
url: /openshell-driver-docker/pr-1/drivers/docker/dev/troubleshooting/
docset: driver-docker
version: dev
latest_version: 0.2.0
source: "pimlock/openshell-driver-docker@PR #1, 027e246:docs/troubleshooting.mdx"
---

> Documentation index: /openshell-driver-docker/pr-1/drivers/docker/dev/llms.txt. This page is for Docker driver dev.
> Preview build of pimlock/openshell-driver-docker (PR #1, 027e246); not published. Published version (0.2.0): https://pimlock.github.io/openshell-docs/drivers/docker/0.2.0/setup.md

# Troubleshooting

## Sandbox Can't Reach the Gateway

On native Linux, the gateway must listen on an address the Docker bridge can
reach. Check `grpc_endpoint` in the [Docker configuration](https://pimlock.github.io/openshell-docs/dev/how-it-works/gateways/configuration/#docker)
and confirm the port is published.

## Proxy Settings Are Ignored

Proxy settings come only from the gateway TOML file. Sandbox environment
variables and `template.driver_config.docker` can't change them. See
[Corporate Proxy Egress](/openshell-driver-docker/pr-1/drivers/docker/dev/setup/#corporate-proxy-egress).
