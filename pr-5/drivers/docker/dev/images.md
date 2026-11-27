---
title: Sandbox Images
description: Choose the images the Docker driver runs and control how they are pulled.
url: /openshell-driver-docker/pr-5/drivers/docker/dev/images/
docset: driver-docker
version: dev
latest_version: 0.2.0
source: "pimlock/openshell-driver-docker@PR #5, 21813de:docs/images.mdx"
---

> Documentation index: /openshell-driver-docker/pr-5/drivers/docker/dev/llms.txt. This page is for Docker driver dev.
> Preview build of pimlock/openshell-driver-docker (PR #5, 21813de); not published. Published version (0.2.0): https://pimlock.github.io/openshell-docs/drivers/docker/0.2.0/setup.md

# Sandbox Images

Each sandbox runs two images: the sandbox runtime image, which holds the
workload, and the supervisor image, which enforces policy. Set them in
`[openshell.drivers.docker]`:

```toml
[openshell.drivers.docker]
sandbox_runtime_image = "ghcr.io/example/sandbox:1.2.0"
supervisor_image = "ghcr.io/example/supervisor:1.2.0"
```

Pin images by tag or digest so every gateway host runs the same versions.

## Pulling Images

The Docker daemon pulls the images, so its registry credentials, mirrors and
proxy settings apply. `image_pull_policy` controls when the driver asks the
daemon to pull an image it already has.

For air-gapped hosts, load the images with `docker load` before starting the
gateway. If a pull fails, see
[Sandbox Image Pull Fails](/openshell-driver-docker/pr-5/drivers/docker/dev/troubleshooting/#sandbox-image-pull-fails).
