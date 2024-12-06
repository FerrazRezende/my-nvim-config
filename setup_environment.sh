#!/bin/bash
echo "Iniciando configuração do meu ambiente"

sudo dnf update -y

sudo dnf install -y neovim git wget unzip

mkdir -p ~/.config/nvim/lua/plugins
chmod -R u+w ~/.config/nvim

git clone https://github.com/LazyVim/starter ~/.config/nvim

cat <<EOF >~/.config/nvim/lua/plugins/extras.lua
return {
  -- LazyGit plugin
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
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

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
wget -q "$FONT_URL" -O Hack.zip
unzip -q Hack.zip -d "$FONT_DIR"
fc-cache -fv
rm Hack.zip

echo "Sincronizando LazyVim com plugins..."
nvim --headless "+Lazy sync" +qa

echo "Configuração concluída!"
