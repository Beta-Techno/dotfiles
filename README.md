# Dotfiles Repository

This repository contains dotfiles managed with [chezmoi](https://www.chezmoi.io/) for Ubuntu.

## Setup on a New Ubuntu Installation

### Quick Setup (Automated)

Run the setup script included in this repository:

```bash
# Clone the repository first
git clone https://github.com/Beta-Techno/dotfiles.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi

# Edit the script to set your repository URL
# Then run it:
chmod +x setup-chezmoi.sh
./setup-chezmoi.sh
```

Or set the repository URL via environment variable:
```bash
DOTFILES_REPO="https://github.com/Beta-Techno/dotfiles.git" ./setup-chezmoi.sh
# Override destination if you keep dotfiles elsewhere
DOTFILES_DIR="$HOME/Dev/infra/dotfiles" ./setup-chezmoi.sh
# Or use SSH if you have keys set up:
DOTFILES_REPO="git@github.com:Beta-Techno/dotfiles.git" ./setup-chezmoi.sh
```

### Manual Setup

**1. Install chezmoi**

On Ubuntu, you can install chezmoi using one of these methods:

**Option A: Using the install script (recommended)**
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- --version
```

**Option B: Using snap**
```bash
sudo snap install chezmoi --classic
```

**2. Clone and initialize from this repository**

```bash
# Clone to the default chezmoi source directory
git clone https://github.com/Beta-Techno/dotfiles.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
# Or use SSH: git clone git@github.com:Beta-Techno/dotfiles.git ~/.local/share/chezmoi
# To keep the repo elsewhere, set DOTFILES_DIR before running setup-chezmoi.sh

# Initialize chezmoi (this makes the current directory the source)
chezmoi init --source ~/.local/share/chezmoi

# Apply all dotfiles to your home directory
chezmoi apply
```

### For Your Ubuntu Setup Workflow

Add this section to your Ubuntu setup workflow (recommended: after System Foundation, before terminal tools):

```bash
#!/usr/bin/env bash
# 2) Dotfiles Setup with Chezmoi
# Place after System Foundation and before terminal tooling
set -euo pipefail

log() { printf "\n\033[1;32m[%s]\033[0m %s\n" "$(date +%H:%M:%S)" "$*"; }
warn() { printf "\n\033[1;33m[warn]\033[0m %s\n" "$*"; }

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/Beta-Techno/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.local/share/chezmoi}"

# Install chezmoi if missing (install locally first, fall back to snap)
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

## Common Workflow

### Adding a new dotfile

```bash
# Add a file to be managed by chezmoi
chezmoi add ~/.bashrc

# This copies ~/.bashrc to the chezmoi source directory
# Commit and push the changes
cd ~/.local/share/chezmoi
git add .
git commit -m "Add .bashrc"
git push
```

### Editing a managed dotfile

```bash
# Edit using chezmoi (recommended)
chezmoi edit ~/.bashrc

# Or edit directly, then tell chezmoi to update
chezmoi re-add ~/.bashrc
```