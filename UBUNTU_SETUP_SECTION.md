## 2) Dotfiles Setup with Chezmoi

```bash
#!/usr/bin/env bash
# Dotfiles setup with chezmoi (idempotent)
# Place after System Foundation and before terminal tooling
set -euo pipefail

log() { printf "\n\033[1;32m[%s]\033[0m %s\n" "$(date +%H:%M:%S)" "$*"; }
warn() { printf "\n\033[1;33m[warn]\033[0m %s\n" "$*"; }

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/Beta-Techno/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.local/share/chezmoi}"

# Install chezmoi if missing (prefer local install, fall back to snap)
if ! command -v chezmoi >/dev/null 2>&1; then
  log "Installing chezmoi…"
  if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi
  if ! command -v chezmoi >/dev/null 2>&1 && command -v snap >/dev/null 2>&1; then
    sudo snap install chezmoi --classic
  fi
fi

command -v chezmoi >/dev/null 2>&1 || { warn "chezmoi installation failed"; exit 1; }

# Clone or update the dotfiles repository
log "Syncing dotfiles repository…"
mkdir -p "$(dirname "$DOTFILES_DIR")"
if [ -d "$DOTFILES_DIR/.git" ]; then
  git -C "$DOTFILES_DIR" fetch --all --tags
  git -C "$DOTFILES_DIR" pull --ff-only || warn "git pull failed, continuing with local copy"
else
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Initialize chezmoi using the cloned repository and apply
log "Initializing chezmoi source → $DOTFILES_DIR"
chezmoi init --source "$DOTFILES_DIR"
log "Applying dotfiles…"
chezmoi apply

echo "[OK] Dotfiles configured. Review with: chezmoi status"
```

**What this does:**
- Installs chezmoi (tries official script, falls back to snap)
- Clones this dotfiles repository to `~/Dev/infra/dotfiles`
- Initializes chezmoi with the repository as the source
- Applies all dotfiles (Alacritty, Ghostty, tmux, Neovim/LazyVim configs)
- Creates tmux symlink if needed

**Placement recommendation:** Insert this **after Section 1 (System Foundation)** and **before Section 3 (Neovim + LazyVim)**. This way, when terminal tools are installed, they'll immediately use your configs.

