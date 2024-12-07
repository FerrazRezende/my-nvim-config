#!/bin/bash
echo "Iniciando configuração do meu ambiente"

# Atualizando o sistema
sudo dnf update -y

# Instalando dependências
sudo dnf install -y neovim git wget unzip

# Permissões para o diretório de configuração do Neovim
chmod -R u+w ~/.config/nvim

# Clonando o repositório LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Instalando o LazyGit
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit

# Criando o arquivo de configuração para o LazyGit
touch ~/.config/lazygit/config.yml

# Adicionando plugins e configurações ao Neovim
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
  -- Alpha.nvim plugin for the ASCII banner
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      opts.section.header.val = vim.split([[
  __  __   _______    _____  __      __  _____   __  __ 
 |  \/  | |__   __|  / ____| \ \    / / |_   _| |  \/  |
 | \  / |    | |    | (___    \ \  / /    | |   | \  / |
 | |\/| |    | |     \___ \    \ \/ /     | |   | |\/| |
 | |  | |    | |     ____) |    \  /     _| |_  | |  | |
 |_|  |_|    |_|    |_____/      \/     |_____| |_|  |_|
                                                        
      ]], "\n")
    end,
  },
}
EOF

# Instalando fontes Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
wget -q "$FONT_URL" -O Hack.zip
unzip -q Hack.zip -d "$FONT_DIR"
fc-cache -fv
rm Hack.zip

# Sincronizando LazyVim com plugins
echo "Sincronizando LazyVim com plugins..."
nvim --headless "+Lazy sync" +qa

echo "Configuração concluída!"
