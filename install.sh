#!/usr/bin/env bash
set -euo pipefail

# --- Config ---
REPO_DIR="$HOME/dotfiles"
STOW_DIRS=(bin helix kitty shell zsh yazi)

# --- Helpers ---
backup_and_stow() {
	local dir=$1
	local target="$HOME/.$dir"

    # If a conflicting real file/dir exists (not a symlink), back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
	    echo "Backing up $target → ${target}.bak"
        mv "$target" "${target}.bak"
    fi

    echo "Stowing $dir → $HOME"
    stow -d "$REPO_DIR" -t "$HOME" "$dir"
}

# --- Safety: Ensure user always has a shell ---
ORIGINAL_SHELL="$SHELL"
cleanup() {
    echo "An error occurred. Falling back to your original shell: $ORIGINAL_SHELL"
    exec "$ORIGINAL_SHELL"
}
trap cleanup ERR

# --- Main ---
echo ">>> Installing essentials"
sudo apt update
sudo apt upgrade -y
sudo apt install -y zsh curl build-essential eza fzf bat fd-find highlight neovim kitty git stow

echo ">>> Ensuring XDG directories exist"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

mkdir -p \
  "$XDG_DATA_HOME/zsh/plugins" \
  "$XDG_CACHE_HOME/zsh" \
  "$XDG_CONFIG_HOME/zsh" \
  "$XDG_CONFIG_HOME/shell" \
  "$XDG_STATE_HOME/zsh" \
  "$HOME/.local/bin"

# Backup existing zprofile if present
if [ -f "$HOME/.zprofile" ]; then
    echo "Backing up existing .zprofile → .zprofile.bak"
    cp "$HOME/.zprofile" "$HOME/.zprofile.bak"
fi

echo '. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile"' > ~/.zprofile
touch "$XDG_STATE_HOME/zsh/history"

echo ">>> Applying stow configs"
for dir in "${STOW_DIRS[@]}"; do
    backup_and_stow "$dir"
done

echo ">>> Installing zsh plugins"
PLUGIN_DIR="$XDG_DATA_HOME/zsh/plugins"
declare -A plugins=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  ["zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search.git"
  ["zsh-you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use.git"
)

for name in "${!plugins[@]}"; do
    dest="$PLUGIN_DIR/$name"
    if [ ! -d "$dest/.git" ]; then
        echo "Cloning plugin: $name"
        git clone "${plugins[$name]}" "$dest"
    else
        echo "Updating plugin: $name"
        git -C "$dest" pull --ff-only
    fi
done


# --- Set Zsh as default shell safely ---
if [ -t 0 ]; then
  if sudo chsh -s "$(command -v zsh)" "$USER"; then
    echo "Default shell changed to zsh (log out/in to apply)."
  else
    echo "Failed to change shell. You may need to do it manually."
  fi
else
  echo "Non-interactive shell detected; please run:"
  echo "  chsh -s $(command -v zsh)"
fi

# --- Final touches ---
chmod +x ~/.local/bin/shortcuts

# Source profile to apply changes in current session
if [ -f ~/.zprofile ]; then
    source ~/.zprofile || true
fi


# Disable error trap since we finished safely
trap - ERR
echo ">>> Done! 🚀"
