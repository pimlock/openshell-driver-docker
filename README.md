# OpenShell Docker driver

Experimental repo for the multi-repo OpenShell docs v0. It holds only the
driver's documentation under `docs/`; the site is built by
[pimlock/openshell-docs](https://github.com/pimlock/openshell-docs), which
fetches `docs/` from this repo's release tags at build time.

- `docs/docset.yml`: docset id, title, description and navigation.
- `docs/*.mdx`: pages. Link to other repos with `core://<page>` or
  `driver-<name>://<page>`; the build resolves them to each repo's latest release.

## Build the docs

Needs git and Node.js 24.

```shell
scripts/docs.sh build   # into build/docs/
scripts/docs.sh serve   # build, then serve at http://127.0.0.1:4410/
```

The script fetches the website build pinned in `docs/website.env` once, into
`.cache/docs-website/`, and builds only this repo's docs with it. Links to
other repos' docs are checked against the live site. Netlify runs the same
script (`netlify.toml`) for deploy previews.

To try website changes, point the script at a checkout of the website repo:
`WEBSITE_DIR=../openshell-docs scripts/docs.sh serve`.

The GitHub Pages preview workflows pin the same website commit in their
`uses:` lines; bump them together with `docs/website.env`.
