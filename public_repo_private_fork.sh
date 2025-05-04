#!/usr/bin/env bash
# private_fork.sh — mirror ANY public GitHub repo into your own private repo
# requires: git, bash; optional: GitHub CLI `gh` for auto‑creating the private repo

set -euo pipefail
echo "⚙️  Private‑fork helper"

# 1️⃣  Gather inputs
read -rp "Source repo (org/name or full URL): " SRC
[[ "$SRC" != https://github.com/* ]] && SRC="https://github.com/${SRC}.git"

DEFAULT_NAME=$(basename "${SRC%.git}")
read -rp "Private repo name [${DEFAULT_NAME}]: " NEW_NAME
NEW_NAME=${NEW_NAME:-$DEFAULT_NAME}

read -rp "Your GitHub username: " GH_USER
read -rp "Local workspace dir [~/code]: " WORK_DIR
WORK_DIR=${WORK_DIR:-~/code}

TEMP="${NEW_NAME}.git"
DEST_SSH="git@github.com:${GH_USER}/${NEW_NAME}.git"

# 2️⃣  Bare‑clone the source
echo "📥  Cloning (bare)…"
git clone --quiet --bare "$SRC" "$TEMP"

# 3️⃣  Create private repo (via gh or manually)
if command -v gh >/dev/null 2>&1; then
  gh repo create "${GH_USER}/${NEW_NAME}" --private --confirm >/dev/null
else
  echo "⚠️  Manually create a private repo named '${NEW_NAME}' under ${GH_USER}, then press <Enter>."
  read -r
fi

# 4️⃣  Mirror‑push to your private repo
echo "🚚  Pushing mirror to ${DEST_SSH}…"
cd "$TEMP"
git push --quiet --mirror "$DEST_SSH"
cd ..

# 5️⃣  Clean up temp clone
rm -rf "$TEMP"
echo "🧹  Temp clone removed."

# 6️⃣  Fresh working clone & set remotes
mkdir -p "$WORK_DIR"
git clone --quiet "$DEST_SSH" "$WORK_DIR/$NEW_NAME"
cd "$WORK_DIR/$NEW_NAME"
git remote add upstream "$SRC"
git remote set-url --push upstream DISABLE

echo -e "\n🔗 Remotes:"
git remote -v
echo -e "\n✅  Done.  Work in '$WORK_DIR/$NEW_NAME'.\n   • Push ⇒ git push origin\n   • Pull upstream ⇒ git fetch upstream && git rebase upstream/$(git symbolic-ref --short HEAD)"