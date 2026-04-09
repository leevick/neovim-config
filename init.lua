-- Basic settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers (useful for movements)
vim.opt.tabstop = 2           -- Render tabs as 2 spaces
vim.opt.shiftwidth = 2        -- Use 2 spaces for each step of (auto)indent
vim.opt.softtabstop = 2       -- Insert/delete 2 spaces when pressing Tab/Backspace
vim.opt.expandtab = true      -- Insert spaces instead of literal tab characters
-- Use vim.opt.relativenumber = false if you want absolute numbers only

-- Code folding settings
-- Disable folding in diff mode to avoid conflicts with zo/zc
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    if vim.wo.diff then
      vim.opt_local.foldenable = false
    else
      vim.opt_local.foldenable = true
    end
  end,
})

vim.opt.foldmethod = "expr"           -- Use expression-based folding
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"  -- Use LSP for folding
vim.opt.foldtext = "v:lua.vim.lsp.foldtext()"  -- Use LSP for fold text
vim.opt.foldlevel = 99                -- Start with all folds open
vim.opt.foldlevelstart = 99           -- Start with all folds open
vim.opt.foldenable = true             -- Enable folding

vim.filetype.add({
  extension = {
    v = "verilog",
    vh = "verilog",
    sv = "systemverilog",
    svh = "systemverilog",
  },
})

require("config.lazy")

-- Auto-reload LSP when compile_commands.json changes
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "compile_commands.json",
  callback = function()
    vim.cmd("LspRestart")
  end,
})

-- LSP keybindings (attached per-buffer on LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(k, f, desc)
      vim.keymap.set("n", k, f, { buffer = ev.buf, desc = desc })
    end
    map("gd",         vim.lsp.buf.definition,     "Go to definition")
    map("gi",         vim.lsp.buf.implementation, "Go to implementation")
    map("gy",         vim.lsp.buf.type_definition,"Go to type definition")
    map("gr",         vim.lsp.buf.references,     "References")
    map("K",          vim.lsp.buf.hover,          "Hover docs")
    map("<leader>rn", vim.lsp.buf.rename,         "Rename")
    map("<leader>ca", vim.lsp.buf.code_action,    "Code action")
    map("<leader>e",  vim.diagnostic.open_float,  "Show diagnostics")
    map("]d",  function() vim.diagnostic.jump({ count =  1 }) end, "Next diagnostic")
    map("[d",  function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
  end,
})

-- Format
vim.keymap.set({ "n", "v" }, "<leader>fm", function()
  local ok, conform = pcall(require, "conform")
  local opts = { lsp_fallback = true }
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    local start_pos = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos   = vim.api.nvim_buf_get_mark(0, ">")
    opts.range = {
      start  = { start_pos[1], start_pos[2] },
      ["end"] = { end_pos[1],  end_pos[2]  },
    }
  end
  if ok then
    conform.format(opts)
  else
    vim.lsp.buf.format(opts)
  end
end, { desc = "Format buffer/selection" })

vim.opt.autoread = true  -- auto-reload files changed outside nvim

-- Save
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>checktime | write<CR>", { desc = "Save" })

-- Restore cursor position when reopening files
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
