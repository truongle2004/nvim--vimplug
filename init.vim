syntax on
set signcolumn=yes
set shada="NONE"
 
call plug#begin(stdpath('config').'/plugged')
  Plug 'phaazon/hop.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-tree/nvim-tree.lua', {'on': 'NvimTreeToggle'}
  Plug 'neoclide/coc.nvim', 
    \ {'branch': 'release'}                     " Language server protocol (LSP) 
  Plug 'mattn/emmet-vim'
  Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
  Plug 'alvan/vim-closetag', 
    \  { 
    \ 'do': 'yarn install '
              \ .'--frozen-lockfile '
              \ .'&& yarn build',
      \ 'branch': 'main'}

  Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }

  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'kylechui/nvim-surround'
   Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'Exafunction/codeium.vim'
  Plug 'navarasu/onedark.nvim'
  " Plug 'craftzdog/solarized-osaka.nvim'
  Plug 'lualine/lualine.nvim'
    Plug 'numToStr/Comment.nvim'
  Plug 'folke/ts-comments.nvim'
   Plug 'JoosepAlviste/nvim-ts-context-commentstring'
cal plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
command! -nargs=0 Eslint :CocCommand eslint.excuteAutofix

nnoremap <silent> <leader>bd :bp \| sp \| bn \| bd<CR>
set termguicolors
set foldmethod=indent

set statusline^=%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}

autocmd CursorHold * silent call CocActionAsync('highlight')



lua<<EOF

require('ts-comments').setup()

require('ts_context_commentstring').setup {
  enable_autocmd = false,
}

require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

require('onedark').setup  {
     transparent = true,  -- Show/hide background
 }

vim.cmd[[ colorscheme onedark ]]
-- require("solarized-osaka").setup({
--   -- your configuration comes here
--   -- or leave it empty to use the default settings
--   transparent = true, -- Enable this to disable setting the background color
--   terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
--   styles = {
--     -- Style to be applied to different syntax groups
--     -- Value is any valid attr-list value for `:help nvim_set_hl`
--     comments = { italic = false},
--     keywords = { italic = false},
--   },
-- })
-- vim.cmd[[colorscheme solarized-osaka]]
require('core')
require('coc_config')
require('config')

EOF

" Disable automatic comment in newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
