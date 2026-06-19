return {
  "stevearc/conform.nvim",
  version = "v9.*",
  opts = {
    formatters_by_ft = {
      verilog = { "verible" },
      systemverilog = { "verible" },
      python = { "ruff_format" },
      -- "_" is conform.nvim's fallback key: it runs for any filetype that has
      -- no specific formatter configured above. prettier is the default here,
      -- so e.g. markdown/json/yaml/js/css all get formatted with prettier
      -- without needing their own entry.
      ["_"] = { "prettier" },
    },
    formatters = {
      verible = {
        command = "verible-verilog-format",
        args = {
          "--indentation_spaces=2",
          "--column_limit=100",
          "--assignment_statement_alignment=infer",
          "-",
        },
        stdin = true,
      },
    },
    format_on_save = false,
  },
}
