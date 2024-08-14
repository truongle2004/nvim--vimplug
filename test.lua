-- require("formatter").setup {
--   logging = false,
  filetype = {
    java = {
      function()
        return {
          exe = "java",
          args = {"-jar", "D:/main/google-java-format-1.23.0.jar", "-"},
          stdin = true

        }
      end
    }
  }
}

-- truong dep trai
vim.api.nvim_exec(
[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.java FormatWrite
augroup END
]],
true
)
