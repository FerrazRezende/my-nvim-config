#!/bin/bash

echo "Iniciando configuração do meu ambiente"

mkdir -p ~/.config/nvim
chmod -R u+w ~/.config/nvim

sudo dnf update -y

sudo dnf install -y neovim

git clone https://github.com/LazyVim/starter ~/.config/nvim

echo "Instalando plugins do LazyVim..."
nvim --headless "+Lazy sync" +qa

echo "Instalando Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
wget -q "$FONT_URL" -O Hack.zip
unzip -q Hack.zip -d "$FONT_DIR"
fc-cache -fv
rm Hack.zip

echo "Nerd Font instalada com sucesso!"

echo "Adicionando LazyGit e vim-be-good ao LazyVim..."
cat <<EOF >>~/.config/nvim/lua/config/plugins.lua
return {
  -- LazyGit plugin
  {
    "kdheepak/lazygit.nvim",
    config = function()
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })
    end,
  },
  -- vim-be-good plugin
  {
    "ThePrimeagen/vim-be-good",
    config = function()
      vim.keymap.set("n", "<leader>vb", ":VimBeGood<CR>", { desc = "Vim Be Good" })
    end,
  },
}
EOF

echo "Sincronizando LazyVim com LazyGit e vim-be-good..."
nvim --headless "+Lazy sync" +qa

echo "Configuração concluída!"
