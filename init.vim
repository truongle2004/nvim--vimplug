call plug#begin(stdpath('config').'/plugged')
  Plug 'phaazon/hop.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-tree/nvim-tree.lua', {'on': 'NvimTreeToggle'}
   "Plug 'voldikss/vim-floaterm'                  " Float terminal
  Plug 'neoclide/coc.nvim', 
    \ {'branch': 'release'}                     " Language server protocol (LSP) 
  Plug 'mattn/emmet-vim' 
  Plug 'preservim/nerdcommenter'                " Comment code 
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim' 
  Plug 'alvan/vim-closetag', 
    \  { 
    \ 'do': 'yarn install '
              \ .'--frozen-lockfile '
              \ .'&& yarn build',
      \ 'branch': 'main'}

  "Plug 'sheerun/vim-polyglot'
  "Plug 'puremourning/vimspector'                " Vimspector
  "Plug 'tpope/vim-fugitive'                     " Git infomation 
  "Plug 'tpope/vim-rhubarb' 
  "Plug 'airblade/vim-gitgutter'           
  "Plug 'samoshkin/vim-mergetool'                " Git merge
  "Plug 'tmhedberg/SimpylFold'
  Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }

  "Plug 'echasnovski/mini.icons'
  "Plug 'Pocco81/auto-save.nvim'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  "Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
  "Plug 'folke/tokyonight.nvim'
  "Plug 'joshdick/onedark.vim'
" Using Vim-Plug
  Plug 'navarasu/onedark.nvim'
  "Plug 'ellisonleao/gruvbox.nvim'
  Plug 'kylechui/nvim-surround'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  "Plug 'sainnhe/everforest'
  "Plug 'Mofiqul/vscode.nvim'
  "Plug 'yuezk/vim-js' 
  "Plug 'MaxMEllon/vim-jsx-pretty' 
  "Plug 'HerringtonDarkholme/yats.vim'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
colorscheme retrobox
"colorscheme tokyonight
"colorscheme everforest
"colorscheme evening
"colorscheme vscode
"colorscheme onedark
"colorscheme gruvbox
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
command! -nargs=0 Eslint :CocCommand eslint.executeAutofix

nnoremap <silent> <leader>bd :bp \| sp \| bn \| bd<CR>
set termguicolors


"set statusline^=%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}

xmap <leader>fo  <Plug>(coc-format-selected)
nmap <leader>fo  <Plug>(coc-format-selected)
lua<<EOF
local map = vim.keymap.set
require('onedark').setup  {
    
}
--require("auto-save").setup {}
--require("mini.fuzzy").setup()
--require("mini.surround").setup()
require("mini.git").setup()
require("mini.statusline").setup()
--require("mini.ai").setup()
--require("mini.icons").setup()
require("nvim-surround").setup()
--require("mini.cursorword").setup()
require("mini.indentscope").setup()
--require("mini.diff").setup()
require("mini.move").setup()
--require("mini.pairs").setup()
require("nvim-tree").setup({
view = {
  width = 45
  }
})

require('mini.tabline').setup()

local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
  highlight = {
    enable = true    
  }
})

if vim.g.neovide then
  vim.o.guifont = ""
end
local opt = vim.opt
vim.g.mapleader = " "
--opt.cmdheight = 0
opt.shell = "pwsh"
opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
opt.shellquote = ""
opt.shellxquote = ""
opt.termguicolors = true
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
vim.opt.splitbelow = true -- split windows below
vim.opt.splitright = true -- split windows right


map("i", "<C-j>", "<down>")
map("i", "<C-k>", "<up>")
map("i", "<C-h>", "<left>")
map("i", "<C-l>", "<right>")
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")
map("i", "jk", "<ESC>")
map("n", "<leader>m", ":NvimTreeToggle<CR>")
map("n", "<leader>n", ":NvimTreeFocus<CR>")
map("n", "<esc>", ":noh<cr>")
map("n", "<M-right>", ":vertical resize +1<CR>")
map("n", "<M-left>", ":vertical resize -1<CR>")
map("n", "<M-Down>", ":resize +1<CR>")
map("n", "<M-Up>", ":resize -1<CR>")
map("n", "ee", "$")
map("n", "<space>h", "<c-w>h")
map("n", "<space>j", "<c-w>j")
map("n", "<space>k", "<c-w>k")
map("n", "<space>l", "<c-w>l")
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
map("n", "<leader>tt" , ":FloatermToggle<cr>")
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

--keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
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

--vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

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


EOF

"syntax match CustomDot "\."
"syntax match CustomValue "\<[a-zA-Z_][a-zA-Z0-9_]*\(\.[a-zA-Z_][a-zA-Z0-9_]*\)\+\>"
"highlight link CustomDot Identifier
"highlight link CustomValue Constant

highlight CustomDot ctermfg=Yellow guifg=Yellow
highlight CustomValue ctermfg=Green guifg=LightMagenta

augroup CustomSyntaxHighlighting
  autocmd!
  autocmd BufRead,BufNewFile * source ~/Appdata/local/nvim/after/syntax/custom.vim
augroup END

" Disable automatic comment in newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
