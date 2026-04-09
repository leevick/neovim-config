return {
  "neovim/nvim-lspconfig",
  version = "v2.*",
  dependencies = {
    { "williamboman/mason.nvim", version = "v2.*" },
    { "williamboman/mason-lspconfig.nvim", version = "v2.*" },
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "clangd", "verible", "pyright" },
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Disable treesitter in LSP floating windows to prevent markdown parser errors
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
      stylize_markdown = false, -- Disable treesitter styling
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
      stylize_markdown = false,
    })

    -- Auto-show diagnostics on cursor hold
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "rounded",
          source = "always",
          prefix = " ",
          scope = "cursor",
        }
        vim.diagnostic.open_float(nil, opts)
      end
    })

    -- Set updatetime for CursorHold (default is 4000ms, set to 500ms for faster display)
    vim.opt.updatetime = 500

    -- Override formatting handler to remove timeout
    vim.lsp.handlers["textDocument/formatting"] = vim.lsp.with(
      vim.lsp.handlers["textDocument/formatting"],
      { timeout_ms = 30000 } -- 30 second timeout for formatting
    )

    vim.lsp.handlers["textDocument/rangeFormatting"] = vim.lsp.with(
      vim.lsp.handlers["textDocument/rangeFormatting"],
      { timeout_ms = 30000 }
    )

    vim.lsp.config.clangd = {
      cmd = { 
        "clangd",
        "--limit-results=0",
        "--header-insertion=never",
        "--background-index",
        "-j=20",
        "--enable-config",
      },
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      root_markers = { ".git", ".clangd" },
      capabilities = capabilities,
    }

    vim.lsp.config.verible = {
      cmd = { "verible-verilog-ls" },
      filetypes = { "verilog", "systemverilog" },
      root_markers = { ".git" },
      capabilities = capabilities,
    }

    vim.lsp.config.pyright = {
      cmd = { "pyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          },
        },
      },
      capabilities = capabilities,
    }

    vim.lsp.enable("clangd")
    vim.lsp.enable("verible")
    vim.lsp.enable("pyright")
  end,
}
