return {
  "nvim-telescope/telescope.nvim",
  version = "v0.2.*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {},
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- Load fzf extension
    telescope.load_extension("fzf")

    local builtin = require("telescope.builtin")
    local map = function(k, f, desc) vim.keymap.set("n", k, f, { desc = desc }) end

    map("<leader>ff", builtin.find_files,            "Find files")
    map("<leader>fg", builtin.live_grep,             "Live grep")
    map("<leader>fb", builtin.buffers,               "Buffers")
    map("<leader>fh", builtin.help_tags,             "Help tags")
    map("<leader>fo", builtin.oldfiles,              "Recent files")
    map("<leader>fr", builtin.lsp_references,        "LSP references")
    map("<leader>fs", builtin.lsp_document_symbols,  "Document symbols")
    map("<leader>fw", builtin.lsp_workspace_symbols, "Workspace symbols")
    map("<leader>fd", builtin.diagnostics,           "Diagnostics")
    map("<leader>fc", builtin.git_commits,           "Git commits")
    map("<C-p>",      builtin.find_files,            "Find files")
  end,
}
