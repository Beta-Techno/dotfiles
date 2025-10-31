# Dotfiles Repository

This repository contains dotfiles managed with [chezmoi](https://www.chezmoi.io/) for Ubuntu.

## Setup on a New Ubuntu Installation

### Quick Setup (Automated)

Run the setup script included in this repository:

```bash
# Clone the repository first
git clone https://github.com/Beta-Techno/dotfiles.git ~/Dev/infra/dotfiles
cd ~/Dev/infra/dotfiles

# Edit the script to set your repository URL
# Then run it:
chmod +x setup-chezmoi.sh
./setup-chezmoi.sh
```

Or set the repository URL via environment variable:
```bash
DOTFILES_REPO="https://github.com/Beta-Techno/dotfiles.git" ./setup-chezmoi.sh
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
# Clone to your preferred location (e.g., ~/Dev/infra/dotfiles)
git clone https://github.com/Beta-Techno/dotfiles.git ~/Dev/infra/dotfiles
cd ~/Dev/infra/dotfiles
# Or use SSH: git clone git@github.com:Beta-Techno/dotfiles.git ~/Dev/infra/dotfiles

# Initialize chezmoi (this makes the current directory the source)
chezmoi init --source ~/Dev/infra/dotfiles

# Apply all dotfiles to your home directory
chezmoi apply
```

### For Your Ubuntu Setup Workflow

Add this section to your Ubuntu setup workflow (recommended: after System Foundation, before terminal tools):

```bash
#!/usr/bin/env bash
# 2) Dotfiles Setup with Chezmoi
set -euo pipefail

# Install chezmoi
if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" || sudo snap install chezmoi --classic
fi

# Clone dotfiles repository
mkdir -p ~/Dev/infra
git clone https://github.com/Beta-Techno/dotfiles.git ~/Dev/infra/dotfiles
# Or use SSH: git clone git@github.com:Beta-Techno/dotfiles.git ~/Dev/infra/dotfiles

# Initialize and apply
chezmoi init --source ~/Dev/infra/dotfiles
chezmoi apply

echo "[OK] Dotfiles configured."
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

### Applying changes to a new machine

```bash
chezmoi init https://github.com/Beta-Techno/dotfiles.git
chezmoi apply
# Or use SSH: chezmoi init git@github.com:Beta-Techno/dotfiles.git
```

### Viewing what chezmoi would change

```bash
chezmoi diff
```

## Directory Structure

After initialization, chezmoi will create:

```
~/.local/share/chezmoi/    # Source directory (managed by git)
├── dot_bashrc             # Maps to ~/.bashrc
├── dot_zshrc              # Maps to ~/.zshrc
├── dot_gitconfig          # Maps to ~/.gitconfig
├── dot_vimrc              # Maps to ~/.vimrc
└── private_*              # Encrypted files (if using encryption)
```

**Note:** The files in this repository are the source files that chezmoi uses. They have a `dot_` prefix instead of `.` to avoid hidden files in git.

## Useful Commands

```bash
# See all managed files
chezmoi managed

# Check status
chezmoi status

# Apply changes
chezmoi apply

# Re-add all files (useful after manual edits)
chezmoi re-add

# Verify configuration
chezmoi verify
```

## Repository Structure

This repository contains the source files that chezmoi uses. Files are named with prefixes:
- `dot_*` → Files that go in your home directory (e.g., `dot_bashrc` → `~/.bashrc`)
- `private_dot_config/*` → Files that go in `~/.config/` (e.g., `private_dot_config/alacritty/alacritty.toml` → `~/.config/alacritty/alacritty.toml`)

## Working with This Repository

### Adding a new dotfile from your machine

After setting up chezmoi on a machine:

```bash
# Add a file to be managed
chezmoi add ~/.bashrc

# Commit the changes
cd ~/.local/share/chezmoi  # or wherever your source directory is
git add .
git commit -m "Add .bashrc"
git push
```

### Editing a managed dotfile

```bash
# Edit using chezmoi (recommended - edits the source)
chezmoi edit ~/.bashrc

# Commit changes
cd ~/.local/share/chezmoi
git add .
git commit -m "Update .bashrc"
git push
```

## Resources

- [Chezmoi Documentation](https://www.chezmoi.io/docs/)
- [Chezmoi GitHub](https://github.com/twpayne/chezmoi)
- [Chezmoi Quick Start Guide](https://www.chezmoi.io/quick-start/)

