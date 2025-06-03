#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clone_or_update_repo() {
    local url="$1"
    local target_dir="$2"

    if [ -d "$target_dir/.git" ]; then
        echo "Updating $target_dir..."
        git -C "$target_dir" pull
    else
        echo "Cloning into $target_dir..."
        git clone "$url" "$target_dir"
    fi
}

# install system packages
sudo apt-get update -y
sudo apt-get install -y python3-pip python3-venv unzip curl

# install GNU Stow
if ! command -v stow &> /dev/null; then
	echo "Stow not detected. Installing..."
	sudo apt-get install -y stow
	# confirm installation
    if ! command -v stow &> /dev/null; then
        echo "Stow installation failed. Exiting."
        exit 1
    fi
else
    echo "Stow is already installed."
fi

# install Deno 
if ! command -v deno &> /dev/null; then
	echo "Deno not detected. Installing..."
	curl -fsSL https://deno.land/install.sh | sh
	export DENO_INSTALL="${HOME}/.deno"
  export PATH="${DENO_INSTALL}/bin:${PATH}"
	# confirm installation
    if ! command -v deno &> /dev/null; then
        echo "Deno installation failed. Exiting."
        exit 1
    fi
else
    echo "Deno is already installed."
fi

# install Neovim with snap
if ! command -v nvim &> /dev/null; then
	echo "Neovim not detected. Installing..."
	
	# check presence of snap
  if ! command -v snap &> /dev/null; then
    echo "Snap not detected. Installing..."
    sudo apt-get install -y snapd
    
    # confirm installation of snap
    if ! command -v snap &> /dev/null; then
      echo "Snap installation failed. Exiting."
      exit 1
    fi
  fi
  export PATH="/snap/bin:$PATH"
	sudo snap install nvim --classic
	# confirm installation of Neovim
    if ! command -v nvim &> /dev/null; then
        echo "Neovim installation failed. Exiting."
        exit 1
    fi
else
    echo "Neovim is already installed."
fi


mkdir -p "$HOME/.config"


# make symbolic links with GNU Stow
stow -R -v -d "$DOTFILES_DIR" -t "$HOME" bash zsh xmodmap profile
stow -R -v -d "$DOTFILES_DIR" -t "$HOME/.config" nvim alacritty

# install denops.vim, dpp.vim, and its extensions
DPP_ROOT="$HOME/.cache/dpp/repos/github.com"

mkdir -p "${DPP_ROOT}/Shougo"
mkdir -p "${DPP_ROOT}/vim-denops"

for repo in \
    "https://github.com/Shougo/dpp.vim" \
    "https://github.com/Shougo/dpp-ext-installer" \
    "https://github.com/Shougo/dpp-protocol-git" \
    "https://github.com/Shougo/dpp-ext-lazy" \
    "https://github.com/Shougo/dpp-ext-toml"; do
    name="$(basename "$repo")"  # dpp.vim, dpp-ext-installer, …
    clone_or_update_repo "$repo" "${DPP_ROOT}/Shougo/$name"
done

clone_or_update_repo "https://github.com/vim-denops/denops.vim" "${DPP_ROOT}/vim-denops/denops.vim"

