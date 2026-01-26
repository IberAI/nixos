{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  programs.nvchad = {
    enable = true;

    # copies into ~/.config/nvim so NvChad can write files
    hm-activation = true;

    # Keep backups of prior configs when switching
    backup = true;

    extraPackages = with pkgs; [
      # ---- build tooling (treesitter/native plugins) ----
      pkg-config
      gnumake
      gcc

      tree-sitter

      # ---- C/C++ tooling ----
      clang-tools
      # Optional but nice for real projects:
      # cmake
      # ninja
      # bear

      # ---- Nix/Lua ----
      nixd
      nil
      lua-language-server
      stylua

      # ---- Web/TS LSPs (these provide the actual binaries) ----
      nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.prettier

      # ---- extras (optional but useful) ----
      shfmt
      shellcheck
      python3Packages.black
      python3Packages.isort
      python3Packages.ruff
    ];

    extraConfig = ''
      -- =========================
      -- Basics
      -- =========================
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.scrolloff = 5
      vim.opt.clipboard = "unnamedplus"
      vim.opt.completeopt = { "menuone", "noselect" }
      vim.opt.swapfile = false
      vim.opt.undofile = true

      -- =========================
      -- Treesitter
      -- =========================
      pcall(function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            -- C/C++
            "c", "cpp",

            "typescript", "tsx",
            "javascript",
            "html", "css",
            "json",
            "lua", "vim", "vimdoc",
          },
          highlight = { enable = true },
          indent = { enable = true },
          auto_install = false,
        })
      end)

      -- =========================
      -- Native LSP config (Neovim 0.11+)
      -- No require("lspconfig") anywhere
      -- =========================

      -- Capabilities for nvim-cmp (NvChad ships cmp)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      pcall(function()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      end)

      -- Run after lazy.nvim has loaded plugins
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Apply defaults to ALL servers
          vim.lsp.config("*", {
            capabilities = capabilities,
            root_markers = { ".git" },
          })

          -- ---- TypeScript / JavaScript ----
          vim.lsp.config("ts_ls", {
            filetypes = {
              "javascript", "javascriptreact",
              "typescript", "typescriptreact",
            },
            root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
          })

          -- ---- ESLint ----
          vim.lsp.config("eslint", {
            settings = {
              workingDirectories = { mode = "auto" },
            },
          })

          -- ---- C / C++ (clangd) ----
          vim.lsp.config("clangd", {
            cmd = { "clangd" },
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
            root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
          })

          -- Enable servers
          vim.lsp.enable({ "ts_ls", "eslint", "html", "cssls", "jsonls", "clangd" })

          -- =========================
          -- Formatting (Conform + clang-format)
          -- Safe if conform isn't installed
          -- =========================
          pcall(function()
            local conform = require("conform")
            conform.setup({
              formatters_by_ft = {
                c = { "clang_format" },
                cpp = { "clang_format" },
                objc = { "clang_format" },
                objcpp = { "clang_format" },
                cuda = { "clang_format" },
              },
              format_on_save = {
                timeout_ms = 1000,
                lsp_fallback = true,
              },
            })
          end)
        end,
      })
    '';
  };
}
