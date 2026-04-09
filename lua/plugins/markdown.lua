return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = "cd app && npm install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Markdown preview toggle" },
    },
    config = function()
      vim.g.mkdp_auto_close = 1       -- close preview when buffer closes
      vim.g.mkdp_combine_preview = 1  -- reuse single preview tab
      vim.g.mkdp_theme = "dark"
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      heading = { enabled = true },
      code    = { enabled = true },
      bullet  = { enabled = true },
    },
  },
}
