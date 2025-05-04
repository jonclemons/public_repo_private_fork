# public_repo_private_fork.sh

Create your **own private copy** of any public GitHub repository—without the hassle of manual mirroring.

---

## ✨ What it does

1. **Bare‑clones** the public repo you specify.  
2. **Creates** a new **private** repo under your GitHub account (uses the `gh` CLI if available; otherwise pauses for manual creation).  
3. **Mirror‑pushes** all branches, tags, and history.  
4. **Deletes** the temporary bare clone.  
5. **Clones** the private repo into your workspace and adds the public repo as a **read‑only `upstream`** remote.

---

## 🛠  Requirements

| Tool | Purpose |
|------|---------|
| **git** | clone / push / rebase |
| **bash** | shell script (tested on bash 4+) |
| **GitHub CLI `gh`**<br><sub>optional but recommended</sub> | auto‑creates the private repo if installed & authenticated. If absent, you’ll be prompted to create the empty repo manually. |

### Install GitHub CLI `gh`

<details>
<summary>macOS (Homebrew)</summary>

```bash
brew install gh