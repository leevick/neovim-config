return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      verilog = { "verible" },
      systemverilog = { "verible" },
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
