return {
  "lewis6991/gitsigns.nvim",
  version = "v2.*",
  event = "BufReadPre",
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true
      },
      auto_attach = true,
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(mode, k, f, desc)
          vim.keymap.set(mode, k, f, { buffer = bufnr, desc = desc })
        end

        -- Hunk navigation
        map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk,                                                    "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk,                                                    "Reset hunk")
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer,                                                  "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer,                                                  "Reset buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk,                                               "Undo stage hunk")
        map("n", "<leader>hp", gs.preview_hunk,                                                  "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end,                    "Blame line")
        map("n", "<leader>hd", gs.diffthis,                                                      "Diff this")
      end,
    })
  end,
}
