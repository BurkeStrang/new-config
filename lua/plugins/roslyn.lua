return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor", "cshtml" },

    dependencies = {
      "tris203/rzls.nvim",
    },

    init = function()
      vim.filetype.add({
        extension = {
          razor = "razor",
          cshtml = "razor",
        },
      })
    end,

    config = function()
      local rzls_path = vim.fn.expand("$MASON/packages/roslyn/libexec/.razorExtension")

      local cmd = {
        "roslyn",
        "--stdio",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
        "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets/Microsoft.NET.Sdk.Razor.DesignTime.targets"),
        "--extension",
        vim.fs.joinpath(rzls_path, "Microsoft.VisualStudioCode.RazorExtension.dll"),
      }

      require("roslyn").setup({
        cmd = cmd,
        handlers = require("rzls.roslyn_handlers"),
        single_file_support = false,
      })
    end,
  },
}
