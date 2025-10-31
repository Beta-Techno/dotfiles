# Dotfiles Repository

This repository contains dotfiles managed with [chezmoi](https://www.chezmoi.io/) for Ubuntu.

## Initial Setup

### 1. Install chezmoi

On Ubuntu, you can install chezmoi using one of these methods:

**Option A: Using the install script (recommended)**
```bash
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git
```

**Option B: Using snap**
```bash
sudo snap install chezmoi --classic
```

**Option C: Using apt (if available)**
```bash
# Check if chezmoi is in your repositories
sudo apt update && sudo apt install chezmoi
```

**Option D: Manual binary download**
```bash
# Download from https://github.com/twpayne/chezmoi/releases
# Extract and move to /usr/local/bin/
```

### 2. Initialize chezmoi with this repository

```bash
chezmoi init https://github.com/YOUR_USERNAME/dotfiles.git
chezmoi apply
```

Or if you've already cloned this repo:
```bash
chezmoi init /home/user/Dev/infra/dotfiles
chezmoi apply
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
chezmoi init https://github.com/YOUR_USERNAME/dotfiles.git
chezmoi apply
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

## Next Steps

1. Install chezmoi (see above)
2. Initialize: `chezmoi init /home/user/Dev/infra/dotfiles`
3. Start adding your dotfiles: `chezmoi add ~/.bashrc`
4. Commit changes: `cd ~/.local/share/chezmoi && git add . && git commit -m "Initial dotfiles"`
5. Push to a git remote (GitHub, GitLab, etc.)

## Resources

- [Chezmoi Documentation](https://www.chezmoi.io/docs/)
- [Chezmoi GitHub](https://github.com/twpayne/chezmoi)
- [Chezmoi Quick Start Guide](https://www.chezmoi.io/quick-start/)

