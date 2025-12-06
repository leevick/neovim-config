return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread" },
  keys = {
    { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
    { "<leader>gd", "<cmd>Gvdiffsplit<CR>", desc = "Git diff vertical split" },
    { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
    { "<leader>gl", "<cmd>Git log<CR>", desc = "Git log" },
  },
}
