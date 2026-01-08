{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  programs.nvchad = {
    enable = true;

    # Use HM activation (copies into ~/.config/nvim so NvChad can write files)
    hm-activation = true;

    # Keep backups of prior configs when switching
    backup = true;

    # (Optional but often helps on NixOS) try a different neovim package if you hit SIGABRT issues
    # Uncomment to test.
    # neovim = pkgs.neovim-unwrapped;

    # Build tools (treesitter parsers + native plugins) + common CLI tools used by NvChad plugins
    extraPackages = with pkgs; [
      # --- build tooling (important for treesitter/native plugins) ---
      pkg-config

      # --- basics ---
      tree-sitter

      # --- Nix / Lua ---
      nixd
      nil # optional; some people prefer nil to nixd, harmless to have both
      lua-language-server
      stylua

      # --- Web / TS ---
      nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted # html/css/json/eslint
      nodePackages.prettier

      # --- Extra helpful formatters/linters ---
      shfmt
      shellcheck
      python3Packages.black
      python3Packages.isort
      python3Packages.ruff
    ];

    extraConfig = ''
      -- sane defaults
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.scrolloff = 5
      vim.opt.clipboard = "unnamedplus"

      -- nicer completion behavior
      vim.opt.completeopt = { "menuone", "noselect" }

      -- less chance of weird swap/backup issues
      vim.opt.swapfile = false
      vim.opt.undofile = true
    '';
  };
}
