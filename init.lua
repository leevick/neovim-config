-- Use the terminal emulator's own 16-color ANSI palette instead of nvim's
-- built-in 24-bit RGB. This makes syntax highlighting follow your terminal
-- theme. Must be set before lazy.nvim loads plugins.
vim.opt.termguicolors = false

-- Basic settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers (useful for movements)
vim.opt.tabstop = 2           -- Render tabs as 2 spaces
vim.opt.shiftwidth = 2        -- Use 2 spaces for each step of (auto)indent
vim.opt.softtabstop = 2       -- Insert/delete 2 spaces when pressing Tab/Backspace
vim.opt.expandtab = true      -- Insert spaces instead of literal tab characters
-- Use vim.opt.relativenumber = false if you want absolute numbers only

-- Sync the default yank/paste register with the system clipboard so that
-- ordinary y/p (no "+ prefix) round-trips through the OS clipboard and can be
-- pasted outside the terminal. Uses the wl-clipboard provider (wl-copy/wl-paste)
-- on this Wayland session.
vim.opt.clipboard = "unnamedplus"

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

-- Allow git to operate in SSHFS-mounted directories.
-- SSHFS presents remote files with a different UID, causing git 2.35.2+ to
-- refuse with "dubious ownership". Overriding safe.directory here only affects
-- git processes spawned by neovim (not the system-wide git config).
vim.env.GIT_CONFIG_COUNT = "1"
vim.env.GIT_CONFIG_KEY_0 = "safe.directory"
vim.env.GIT_CONFIG_VALUE_0 = "*"

require("config.lazy")

-- Make nvim's background transparent so the terminal's own theme (e.g. your
-- blue background) shows through instead of nvim painting its own color on top.
-- Registered as a ColorScheme autocmd so it survives any future scheme change,
-- then triggered once for the scheme that is already active.
local function use_terminal_background()
  -- ":highlight <group> ... NONE" only modifies the background attributes,
  -- leaving each group's foreground color intact (unlike nvim_set_hl, which
  -- replaces the whole group).
  for _, group in ipairs({
    "Normal", "NormalNC", "NormalFloat", "SignColumn", "EndOfBuffer",
    "LineNr", "FoldColumn", "MsgArea",
  }) do
    vim.cmd(("highlight %s guibg=NONE ctermbg=NONE"):format(group))
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = use_terminal_background,
})
use_terminal_background()

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
  local opts = { lsp_format = "fallback" }
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
