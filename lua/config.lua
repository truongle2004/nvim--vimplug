
local map = vim.keymap.set

require('lualine').setup()
require'nvim-treesitter.configs'.setup {
   highlight = {
      enable = true 
   },
 }
require("nvim-surround").setup()
local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
require("mini.move").setup()
-- require("mini.comment").setup()
require("nvim-tree").setup({
view = {
  width = 30
  }
})

require('mini.tabline').setup()



require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
local hop = require("hop")
local directions = require("hop.hint").HintDirection
map("n", "f", function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })
map("n", "F", function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })
map({ "n", "v" }, "<leader><leader>w", ":HopAnywhere<cr>")
map("n", "<leader>w", ":HopWord<cr>")
