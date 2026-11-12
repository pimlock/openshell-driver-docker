# OpenShell Docker driver

Experimental repo for the multi-repo OpenShell docs v0. It holds only the
driver's documentation under `docs/`; the site is built by
[pimlock/openshell-docs](https://github.com/pimlock/openshell-docs), which
fetches `docs/` from this repo's release tags at build time.

- `docs/docset.yml`: docset id, title, description and navigation.
- `docs/*.mdx`: pages. Link to other repos with `core://<page>` or
  `driver-<name>://<page>`; the build resolves them to each repo's latest release.
