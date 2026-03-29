-- Basic settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers (useful for movements)
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

-- Format keybindings
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format file" })
vim.keymap.set("v", "<leader>f", vim.lsp.buf.format, { desc = "Format selection" })

-- Git change navigation (hunks)
vim.keymap.set("n", "]c", function()
  if vim.wo.diff then
    vim.cmd.normal({"]c", bang = true})
  else
    require("gitsigns").nav_hunk("next")
  end
end, { desc = "Next change/hunk" })

vim.keymap.set("n", "[c", function()
  if vim.wo.diff then
    vim.cmd.normal({"[c", bang = true})
  else
    require("gitsigns").nav_hunk("prev")
  end
end, { desc = "Previous change/hunk" })

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
