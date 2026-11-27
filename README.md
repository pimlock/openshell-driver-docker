# OpenShell Docker driver

Experimental repo for the multi-repo OpenShell docs v0. It holds only the
driver's documentation under `docs/`; the site is built by
[pimlock/openshell-docs](https://github.com/pimlock/openshell-docs), which
fetches `docs/` from this repo's release tags at build time.

- `docs/docset.yml`: docset id, title, description and navigation.
- `docs/*.mdx`: pages. Link to other repos with `core://<page>` or
  `driver-<name>://<page>`; the build resolves them to each repo's latest release.

## Build the docs

Needs Node.js 24.

```shell
npm ci
npm run docs:check   # check links only
npm run docs:build   # build the site into build/docs/
npm run docs:serve   # build, then serve at http://127.0.0.1:4410/
```

The build comes from the `@pimlock/openshell-docs-build` package, pinned in
`package-lock.json`. It builds only this repo's docs; links to other repos'
docs are checked against the live site, and so are their links into these
docs. CI runs the same commands (`.github/workflows/docs.yml`), and Netlify
runs `docs:build` for deploy previews (`netlify.toml`).
