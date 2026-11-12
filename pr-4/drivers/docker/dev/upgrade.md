---
title: Upgrade the Driver
description: Move a gateway to a new Docker driver release without losing sandboxes.
url: /openshell-driver-docker/pr-4/drivers/docker/dev/upgrade/
docset: driver-docker
version: dev
latest_version: 0.2.0
source: "pimlock/openshell-driver-docker@PR #4, 147343b:docs/upgrade.mdx"
---

> Documentation index: /openshell-driver-docker/pr-4/drivers/docker/dev/llms.txt. This page is for Docker driver dev.
> Preview build of pimlock/openshell-driver-docker (PR #4, 147343b); not published. Published version (0.2.0): https://pimlock.github.io/openshell-docs/drivers/docker/0.2.0/setup.md

# Upgrade the Driver

Sandboxes keep running while you upgrade. The gateway reconnects to them when it
starts again.

## Check the Release Notes

Read the notes for every release between your version and the new one. Look
for changed defaults in `[openshell.drivers.docker]`.

## Pull the New Images

```shell
docker pull ghcr.io/nvidia/openshell/supervisor:latest
```

## Restart the Gateway

Restart the gateway with the new version. See
[Gateway Configuration](https://pimlock.github.io/openshell-docs/dev/how-it-works/gateways/configuration/) for where the
driver settings live.
