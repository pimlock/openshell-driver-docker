#!/usr/bin/env bash
# Build this repo's docs the way the docs website shows them.
#
#   scripts/docs.sh build    build into build/docs/
#   scripts/docs.sh serve    build, then serve at http://127.0.0.1:4410/
#
# Fetches the website build at the commit pinned in docs/website.env into
# .cache/docs-website/<commit>/ (once), then builds only this repo's docs with
# it. Links to other repos' docs are checked against the live site.
#
# Needs git and Node.js 24. On Netlify it labels the build with the pull
# request. WEBSITE_DIR=<checkout of the website repo> builds with that
# checkout instead, for trying website changes.
set -euo pipefail
cmd=${1:-build}
repo=$(cd "$(dirname "$0")/.." && pwd)
# shellcheck source=/dev/null
. "$repo/docs/website.env"
out=${DOCS_OUT:-$repo/build/docs}

node_major=$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)
if [ "$node_major" -lt 24 ]; then
  echo "scripts/docs.sh needs Node.js 24 or later (found ${node_major})" >&2
  exit 1
fi

site=${WEBSITE_DIR:-$repo/.cache/docs-website/$WEBSITE_REF}
if [ -z "${WEBSITE_DIR:-}" ] && [ ! -e "$site/.ready" ]; then
  echo "fetching $WEBSITE_REPO at ${WEBSITE_REF::7}"
  rm -rf "$site" && mkdir -p "$site"
  git -C "$site" init -q
  git -C "$site" fetch -q --depth 1 "https://github.com/$WEBSITE_REPO.git" "$WEBSITE_REF"
  git -C "$site" checkout -q FETCH_HEAD
  (cd "$site" && npm ci --no-audit --no-fund --loglevel=error)
  touch "$site/.ready"
fi

args=(--docset "$DOCSET" --path "$repo" --out "$out")
if [ "${NETLIFY:-}" = true ]; then
  # Netlify checks out a commit, not a branch: label the build from its env.
  args+=(--branch "$HEAD" --site-url "${DEPLOY_PRIME_URL:-$URL}")
  if [ "${PULL_REQUEST:-}" = true ]; then
    args+=(--ref "PR #$REVIEW_ID, ${COMMIT_REF::7}" --ref-url "$REPOSITORY_URL/pull/$REVIEW_ID")
  else
    args+=(--ref "$HEAD, ${COMMIT_REF::7}")
  fi
fi

case "$cmd" in
  build) node "$site/scripts/docset.mjs" "${args[@]}" ;;
  serve)
    node "$site/scripts/docset.mjs" "${args[@]}"
    node "$site/scripts/serve.mjs" "$out" "${PORT:-4410}" /
    ;;
  *) echo "usage: scripts/docs.sh build|serve" >&2; exit 2 ;;
esac
