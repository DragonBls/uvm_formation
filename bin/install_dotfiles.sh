#!/usr/bin/env bash

set -e

install_latest_neovim() {
  local url
  local filename
  url=https://github.com/neovim/neovim/releases/download/stable
  filename=nvim-linux64.tar.gz
  mkdir -p ~/src
  curl -sSL "${url}/${filename}" | tar -C "${HOME}/src" -xz -f -
}

cd ~
git clone http://github.com/antoinemadec/dotfiles
cd dotfiles
sed -i '/.fzf.bash/d' deploy
./deploy
sed -i '/coc-clangd/d' ~/.vim/plugins_config/coc.nvim.vim
cat << EOF > ~/.gitconfig
[color]
  ui = auto
EOF

install_latest_neovim
pip3.8 install neovim --user
pip3.8 install neovim-remote --user

cat <<EOF > ~/.bashrc.local
pre_path ~/src/nvim-linux64/bin
EOF
