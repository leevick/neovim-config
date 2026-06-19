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

    -- Use git_files (git ls-files) when inside a git repo — much faster than
    -- walking the filesystem. Falls back to find_files outside git repos.
    local function find_files()
      vim.fn.system("git rev-parse --git-dir")
      if vim.v.shell_error == 0 then
        builtin.git_files({ show_untracked = true, recurse_submodules = false })
      else
        builtin.find_files()
      end
    end

    map("<leader>ff", find_files,                    "Find files (git-aware)")
    map("<leader>fg", builtin.live_grep,             "Live grep")
    map("<leader>fb", builtin.buffers,               "Buffers")
    map("<leader>fh", builtin.help_tags,             "Help tags")
    map("<leader>fo", builtin.oldfiles,              "Recent files")
    map("<leader>fr", builtin.lsp_references,        "LSP references")
    map("<leader>fs", builtin.lsp_document_symbols,  "Document symbols")
    map("<leader>fw", builtin.lsp_workspace_symbols, "Workspace symbols")
    map("<leader>fd", builtin.diagnostics,           "Diagnostics")
    map("<leader>fc", builtin.git_commits,           "Git commits")
    map("<C-p>",      find_files,                    "Find files (git-aware)")
  end,
}
