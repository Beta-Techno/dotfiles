#!/usr/bin/env bash
# chezmoi-dotfiles-setup.sh — Install chezmoi and load dotfiles repository
# Insert this into your Ubuntu setup workflow (recommended: after System Foundation, before terminal tools)

set -euo pipefail

# Configuration - Repository URL (HTTPS for initial setup, SSH also available)
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/Beta-Techno/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Dev/infra/dotfiles}"

log() { printf "\n\033[1;32m[%s]\033[0m %s\n" "$(date +%H:%M:%S)" "$*"; }
warn() { printf "\n\033[1;33m[warn]\033[0m %s\n" "$*"; }
die() { printf "\n\033[1;31m[err]\033[0m %s\n" "$*"; exit 1; }

install_chezmoi() {
  if command -v chezmoi >/dev/null 2>&1; then
    log "Chezmoi already installed: $(chezmoi --version | head -n1)"
    return
  fi

  log "Installing chezmoi…"
  
  # Option 1: Install script (recommended)
  if sh -c "$(curl -fsLS get.chezmoi.io)" -- --version >/dev/null 2>&1; then
    log "Installing via official script…"
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply "$DOTFILES_REPO"
    return
  fi

  # Option 2: Snap (Ubuntu fallback)
  if command -v snap >/dev/null 2>&1; then
    log "Installing via snap…"
    sudo snap install chezmoi --classic
    return
  fi

  # Option 3: Manual download (fallback)
  warn "Install script and snap unavailable, attempting manual install…"
  tmpd="$(mktemp -d)"
  pushd "$tmpd" >/dev/null
  ARCH="$(uname -m)"
  VERSION="2.66.1"  # Update as needed
  curl -fL "https://github.com/twpayne/chezmoi/releases/download/v${VERSION}/chezmoi_${VERSION}_linux_${ARCH}.tar.gz" -o chezmoi.tar.gz
  tar -xzf chezmoi.tar.gz
  sudo mv chezmoi /usr/local/bin/chezmoi
  chmod +x /usr/local/bin/chezmoi
  popd >/dev/null
  rm -rf "$tmpd"
}

ensure_git() {
  if ! command -v git >/dev/null 2>&1; then
    log "Installing git (prerequisite)…"
    sudo apt update
    sudo apt install -y git
  fi
}

clone_dotfiles() {
  log "Setting up dotfiles repository…"
  
  # Ensure ~/Dev/infra directory exists
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log "Repository already exists at $DOTFILES_DIR, pulling latest…"
    git -C "$DOTFILES_DIR" fetch --all --tags
    git -C "$DOTFILES_DIR" pull --ff-only || warn "Pull failed, continuing with existing state"
  else
    log "Cloning dotfiles repository to $DOTFILES_DIR…"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi
}

initialize_chezmoi() {
  log "Initializing chezmoi with dotfiles repository…"
  
  # Initialize chezmoi to use our repository as the source
  chezmoi init --source "$DOTFILES_DIR"
  
  # Apply all dotfiles
  log "Applying dotfiles to home directory…"
  chezmoi apply
  
  log "Dotfiles applied. Review changes with: chezmoi diff"
}

create_tmux_symlink() {
  # If tmux config is in ~/.config/tmux/, create ~/.tmux.conf symlink if it doesn't exist
  if [[ -f "$HOME/.config/tmux/tmux.conf" ]] && [[ ! -e "$HOME/.tmux.conf" ]]; then
    log "Creating ~/.tmux.conf symlink to ~/.config/tmux/tmux.conf…"
    ln -sf "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
  fi
}

post_setup() {
  log "Verifying chezmoi setup…"
  chezmoi --version || die "Chezmoi verification failed"
  
  log "Managed files:"
  chezmoi managed | head -n 10 || true
  
  log "Setup complete!"
  echo
  echo "Useful commands:"
  echo "  chezmoi status     # See what would change"
  echo "  chezmoi diff       # Preview changes before applying"
  echo "  chezmoi edit FILE  # Edit a managed file"
  echo "  chezmoi apply      # Apply changes from repository"
}

main() {
  ensure_git
  install_chezmoi
  clone_dotfiles
  initialize_chezmoi
  create_tmux_symlink
  post_setup
}

main "$@"

