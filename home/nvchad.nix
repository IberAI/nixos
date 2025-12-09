{ config, pkgs, lib, inputs, ... }:

{
  ############################
  # Import nix4nvchad HM module
  ############################
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  ############################
  # NvChad / Neovim config
  ############################
  programs.nvchad = {
    enable = true;

    # Extra tools / language servers available inside Neovim
    extraPackages = with pkgs; [
      # General editor helpers
      nixd                    # Nix LSP
      lua-language-server     # Lua (for Neovim / NvChad config)
      ripgrep                 # live grep
      fd                      # fast file finder
      tree-sitter             # better syntax parsing

      # JavaScript / TypeScript / React / Web
      nodejs_22               # Node runtime for all the JS tools
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted  # html / css / json etc.
      nodePackages.prettier   # formatter (JS/TS/JSON/Markdown/etc.)

      # Rust
      rustc
      cargo
      clippy
      rust-analyzer           # Rust LSP

      # C / C++
      clang
      gcc
    ];

    # Extra Lua config applied after NvChad loads
    extraConfig = ''
      vim.opt.relativenumber = true
      vim.opt.scrolloff = 5

      -- use system clipboard
      vim.opt.clipboard = "unnamedplus"
    '';

    # Let HM copy NvChad into ~/.config/nvim instead of symlinking
    hm-activation = true;

    # Keep backups of old configs (e.g. ~/.config/nvim_YYYY_MM_DD_HH_MM_SS.bak)
    backup = true;
  };
}

