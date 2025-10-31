## 2) Dotfiles Setup with Chezmoi

```bash
#!/usr/bin/env bash
# chezmoi-dotfiles-setup.sh — Install chezmoi and load dotfiles repository
# Recommended placement: After System Foundation (section 1), before terminal tools

set -euo pipefail

log() { printf "\n\033[1;32m[%s]\033[0m %s\n" "$(date +%H:%M:%S)" "$*"; }
warn() { printf "\n\033[1;33m[warn]\033[0m %s\n" "$*"; }

# Configuration - Repository URL
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/Beta-Techno/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Dev/infra/dotfiles}"

# Install chezmoi
log "Installing chezmoi…"
if ! command -v chezmoi >/dev/null 2>&1; then
  # Try official install script first
  if sh -c "$(curl -fsLS get.chezmoi.io)" -- --version >/dev/null 2>&1; then
    sh -c "$(curl -fsLS get.chezmoi.io)" || true
    export PATH="$HOME/.local/bin:$PATH"
  else
    # Fallback to snap
    sudo snap install chezmoi --classic || warn "Chezmoi installation failed"
  fi
fi

# Ensure chezmoi is in PATH
if ! command -v chezmoi >/dev/null 2>&1; then
  export PATH="$HOME/.local/bin:$PATH"
fi

chezmoi --version | head -n1 || die "Chezmoi not found after installation"

# Clone dotfiles repository
log "Setting up dotfiles repository…"
mkdir -p "$(dirname "$DOTFILES_DIR")"

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  log "Repository exists, pulling latest…"
  git -C "$DOTFILES_DIR" fetch --all --tags
  git -C "$DOTFILES_DIR" pull --ff-only || warn "Pull failed, continuing"
else
  log "Cloning dotfiles repository…"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Initialize chezmoi with repository as source
log "Initializing chezmoi with dotfiles…"
chezmoi init --source "$DOTFILES_DIR"

# Apply all dotfiles
log "Applying dotfiles to home directory…"
chezmoi apply

# Create tmux symlink if needed
if [[ -f "$HOME/.config/tmux/tmux.conf" ]] && [[ ! -e "$HOME/.tmux.conf" ]]; then
  log "Creating ~/.tmux.conf symlink…"
  ln -sf "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
fi

# Verify
log "Verifying setup…"
chezmoi managed | head -n 5 || true

echo "[OK] Dotfiles configured. Your terminal configs (Alacritty, Ghostty, tmux, Neovim) are ready."
```

**What this does:**
- Installs chezmoi (tries official script, falls back to snap)
- Clones this dotfiles repository to `~/Dev/infra/dotfiles`
- Initializes chezmoi with the repository as the source
- Applies all dotfiles (Alacritty, Ghostty, tmux, Neovim/LazyVim configs)
- Creates tmux symlink if needed

**Placement recommendation:** Insert this **after Section 1 (System Foundation)** and **before Section 3 (Neovim + LazyVim)**. This way, when terminal tools are installed, they'll immediately use your configs.

