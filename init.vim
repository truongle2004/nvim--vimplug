call plug#begin(stdpath('config').'/plugged')
  "Plug 'echasnovski/mini.tabline', { 'branch': 'stable' }
  Plug 'phaazon/hop.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-tree/nvim-tree.lua', {'on':'NvimTreeToggle'}
  "Plug 'voldikss/vim-floaterm'                  " Float terminal
  Plug 'neoclide/coc.nvim', 
    \ {'branch': 'release'}                     " Language server protocol (LSP) 
  Plug 'mattn/emmet-vim' 
  Plug 'preservim/nerdcommenter'                " Comment code 
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'alvan/vim-closetag', 
    \ { 
      \ 'do': 'yarn install '
              \ .'--frozen-lockfile '
              \ .'&& yarn build',
      \ 'branch': 'main' 
    \ }

  Plug 'sheerun/vim-polyglot'
  "Plug 'puremourning/vimspector'                " Vimspector
  Plug 'tpope/vim-fugitive'                     " Git infomation 
  Plug 'tpope/vim-rhubarb' 
  Plug 'airblade/vim-gitgutter'           
  Plug 'samoshkin/vim-mergetool'                " Git merge
  "Plug 'tmhedberg/SimpylFold'
  Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }
  "Plug 'Pocco81/auto-save.nvim'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'nvim-lua/plenary.nvim'
  Plug 'tjdevries/express_line.nvim'
  Plug 'joshdick/onedark.vim'
call plug#end()

"let g:UltiSnipsJumpForwardTrigger="<Tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
colorscheme onedark
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
command! -nargs=0 Eslint :CocCommand eslint.executeAutofix

lua<<EOF
local map = vim.keymap.set
--require("auto-save").setup {}
--require("mini.fuzzy").setup()
require("mini.surround").setup()
--require("mini.git").setup()
require("mini.ai").setup()
require("mini.cursorword").setup()
--require("mini.diff").setup()
--require("mini.indentscope").setup()
require("mini.move").setup()
require("mini.pairs").setup()
require("nvim-tree").setup({
view = {
  width = 30
  }
})

require('mini.tabline').setup()

if vim.g.neovide then
  vim.o.guifont = ""
end
local opt = vim.opt
vim.g.mapleader = " "
opt.cmdheight = 0
opt.shell = "pwsh"
opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
opt.shellquote = ""
opt.shellxquote = ""
opt.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwPlugin = 1
opt.relativenumber = true
opt.number = true
opt.scrolloff = 10
opt.laststatus = 3
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true
opt.swapfile = false



map("i", "<C-j>", "<down>")
map("i", "<C-k>", "<up>")
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")
map("n", "<leader>m", ":NvimTreeToggle<CR>")
map("n", "<leader>n", ":NvimTreeFocus<CR>")
map("n", "<esc>", ":noh<cr>")
map("n", "<M-right>", ":vertical resize +1<CR>")
map("n", "<M-left>", ":vertical resize -1<CR>")
map("n", "<M-Down>", ":resize +1<CR>")
map("n", "<M-Up>", ":resize -1<CR>")
map("n", "ee", "$")
map("n", "<c-h>", "<c-w>h")
map("n", "<c-l>", "<c-w>l")
map("n", "<C-a>", "ggVG")
map("n", "<C-k>", "<C-u>")
map("v", "<C-k>", "<C-u>")
map("n", "<C-j>", "<C-d>")
map("v", "<C-j>", "<C-d>")
map("n", "<A-,>", ":bNext<CR>")
map("n", "<A-.>", ":bnext<CR>")
map("n", "<leader>s", ":w!<cr>")
map("n", "<leader>ff" , ":FZF<cr>")
map("n", "<leader>to" , ":FloatermNew<cr>")
map("n", "<leader><leader>f", ":Rg<cr>")

local keyset = vim.keymap.set

function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})


function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})


-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})


-- Formatting selected code
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})


-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

local opts = {silent = true, nowait = true}
keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("o", "ic", "<Plug>(coc-classobj-i)", pts)
keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)


local opts = {silent = true, nowait = true, expr = true}
keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keyset("i", "<C-f>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keyset("i", "<C-b>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})


vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

local opts = {silent = true, nowait = true}
keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)


require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
local hop = require("hop")
local directions = require("hop.hint").HintDirection
vim.keymap.set("n", "f", function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set("n", "F", function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })
map({ "n", "v" }, "<leader><leader>w", ":HopAnywhere<cr>")
map("n", "<leader>w", ":HopWord<cr>")




map({'n','x'}, "zj", "<cmd>MultipleCursorsAddDown<CR>")
map({'n','x'}, "zk", "<cmd>MultipleCursorsAddUp<CR>")
local builtin = require "el.builtin"
local extensions = require "el.extensions"
local subscribe = require "el.subscribe"
local sections = require "el.sections"
local generator = function()
      local segments = {}

      table.insert(segments, extensions.mode)
      table.insert(segments, " ")
     table.insert(
        segments,
        subscribe.buf_autocmd("el-git-changes", "BufWritePost", function(win, buf)
          local changes = extensions.git_changes(win, buf)
          if changes then
            return changes
          end
        end)
      )
     table.insert(segments,
    subscribe.buf_autocmd(
      "el_git_branch",
      "BufEnter",
      function(window, buffer)
        local branch = extensions.git_branch(window, buffer)
        if branch then
          return branch
        end
      end
    ))
         table.insert(segments, sections.split)
      table.insert(segments, "%f")
      table.insert(segments, sections.split)
      table.insert(segments, builtin.filetype)
      table.insert(segments, "[")
      table.insert(segments, builtin.line_with_width(3))
      table.insert(segments, ":")
      table.insert(segments, builtin.column_with_width(2))
      table.insert(segments, "]")

      return segments
    end
    require('el').setup({generator = generator})
EOF


" Disable automatic comment in newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
