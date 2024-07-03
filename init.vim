call plug#begin(stdpath('config').'/plugged')
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
  "Plug 'Pocco81/auto-save.nvim'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  "Plug 'nvim-lua/plenary.nvim'
  "Plug 'tjdevries/express_line.nvim'
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
require("mini.git").setup()
require("mini.ai").setup()
--require("mini.cursorword").setup()
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

local cache = {}

local function refresh_cache(key)
    if cache[key] then cache[key].value = cache[key].fn() end
end

local function cache_get(key, compute_fn)
    local cached = cache[key]
    if cached then return cached.value end
    local value = compute_fn()
    cache[key] = {value = value, fn = compute_fn}
    return value
end

function SpellToggle()
    if vim.opt.spell:get() then
        vim.opt_local.spell = false
        vim.opt_local.spelllang = "en"
    else
        vim.opt_local.spell = true
        vim.opt_local.spelllang = {"en_us"}
    end
end

local function spell_status()
    local spellLang = vim.opt_local.spelllang:get()
    if type(spellLang) == "table" then
        spellLang = table.concat(spellLang, ", ")
    end
    return string.upper(spellLang)
end

local function git_branch()
    return cache_get("git_branch", function()
        if vim.g.loaded_fugitive then
            local branch = vim.fn.FugitiveHead()
            if branch ~= "" then
                if vim.api.nvim_win_get_width(0) <= 80 then
                    return " " .. string.upper(branch:sub(1, 2))
                end
                return " " .. string.upper(branch)
            end
        end
        return ""
    end)
end

local function update_status_for_file(file_path)
    -- Get number of lines added and deleted using git diff --numstat
    local diff_stats = vim.fn.system("git diff --numstat " ..
                                         vim.fn.shellescape(file_path))
    if vim.v.shell_error ~= 0 or diff_stats == "" then return "" end

    local added, deleted = diff_stats:match("(%d+)%s+(%d+)%s+%S+")
    added, deleted = tonumber(added), tonumber(deleted)
    local delta = math.min(added, deleted)

    local status = {
        changed = delta,
        added = added - delta,
        removed = deleted - delta
    }

    -- Format the status for display
    local status_txt = {}
    if status.added > 0 then table.insert(status_txt, "+" .. status.added) end
    if status.changed > 0 then
        table.insert(status_txt, "~" .. status.changed)
    end
    if status.removed > 0 then
        table.insert(status_txt, "-" .. status.removed)
    end

    if #status_txt > 1 then
        for i = 2, #status_txt do status_txt[i] = "," .. status_txt[i] end
    end

    local formatted_status = ""
    if #status_txt > 0 then
        formatted_status = string.format("[%s]", table.concat(status_txt))
    else
        formatted_status = ""
    end

    return formatted_status
end

local function status_for_file()
    return cache_get("file_status", function()
        local file_path = vim.api.nvim_buf_get_name(0)

        if file_path == "" then return "" end
        return update_status_for_file(file_path)
    end)
end

local function human_file_size()
    return cache_get("file_size", function()
        local file = vim.api.nvim_buf_get_name(0)
        if file == "" then return "" end

        local size = vim.fn.getfsize(file)
        local suffixes = {"B", "KB", "MB", "GB"}
        local i = 1
        while size > 1024 do
            size = size / 1024
            i = i + 1
        end

        return size <= 0 and "" or string.format("[%.0f%s]", size, suffixes[i])
    end)
end

local function smart_file_path()
    return cache_get("file_path", function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local is_wide = vim.api.nvim_win_get_width(0) > 80
        if buf_name == "" then return "[No Name]" end

        local file_dir = buf_name:sub(1, 5):find("term") and vim.env.PWD or
                             vim.fs.dirname(buf_name)
        file_dir = file_dir:gsub(vim.env.HOME, "~", 1)

        if not is_wide then file_dir = vim.fn.pathshorten(file_dir) end

        if buf_name:sub(1, 5):find("term") then
            return file_dir .. " "
        else
            return string.format("%s/%s ", file_dir, vim.fs.basename(buf_name))
        end
    end)
end

local function word_count()
    local words = vim.fn.wordcount()
    if words.visual_words ~= nil then
        return string.format("[%s]", words.visual_words)
    else
        return string.format("[%s]", words.words)
    end
end

local modes = setmetatable({
    ["n"] = {"NORMAL", "N"},
    ["no"] = {"N·OPERATOR", "N·P"},
    ["v"] = {"VISUAL", "V"},
    ["V"] = {"V·LINE", "V·L"},
    [""] = {"V·BLOCK", "V·B"},
    [""] = {"V·BLOCK", "V·B"},
    ["s"] = {"SELECT", "S"},
    ["S"] = {"S·LINE", "S·L"},
    [""] = {"S·BLOCK", "S·B"},
    ["i"] = {"INSERT", "I"},
    ["ic"] = {"INSERT", "I"},
    ["R"] = {"REPLACE", "R"},
    ["Rv"] = {"V·REPLACE", "V·R"},
    ["c"] = {"COMMAND", "C"},
    ["cv"] = {"VIM·EX", "V·E"},
    ["ce"] = {"EX", "E"},
    ["r"] = {"PROMPT", "P"},
    ["rm"] = {"MORE", "M"},
    ["r?"] = {"CONFIRM", "C"},
    ["!"] = {"SHELL", "S"},
    ["t"] = {"TERMINAL", "T"}
}, {
    __index = function()
        return {"UNKNOWN", "U"} -- handle edge cases
    end
})

local function get_current_mode()
    local mode = modes[vim.api.nvim_get_mode().mode]
    if vim.api.nvim_win_get_width(0) <= 80 then
        return string.format("%s ", mode[2]) -- short name
    else
        return string.format("%s ", mode[1]) -- long name
    end
end

local function file_type()
    return cache_get("file_type", function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local width = vim.api.nvim_win_get_width(0)

        local ft = vim.bo.filetype
        if ft == "" then
            return "[None]"
        else
            if width > 80 then
                return string.format("[%s]", ft)
            else
                local ext = vim.fn.fnamemodify(buf_name, ":e")
                local shorter = (string.len(ft) < string.len(ext)) and ft or ext
                return string.format("[%s]", shorter)
            end
        end
    end)
end

---@diagnostic disable-next-line: lowercase-global
function status_line()
    return table.concat({
        get_current_mode(), -- get current mode
        spell_status(), -- display language and if spell is on
        git_branch(), -- branch name
        " %<", -- spacing
        smart_file_path(), -- smart full path filename
        "%h%m%r%w", -- help flag, modified, readonly, and preview
        "%=", -- right align
        status_for_file(), -- git status for file
        word_count(), -- word count
        "[%-3.(%l|%c]", -- line number, column number
        human_file_size(), -- file size
        file_type() -- file type
    })
end

vim.api.nvim_create_augroup("StatusLineCache", {})
vim.api.nvim_create_autocmd({"BufEnter"}, {
    pattern = "*",
    group = "StatusLineCache",
    callback = function()
        refresh_cache("git_branch") -- this should be another event
        refresh_cache("file_status")
        refresh_cache("file_size")
        refresh_cache("file_path")
        refresh_cache("file_type")
    end
})

vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = "*",
    group = "StatusLineCache",
    callback = function()
        refresh_cache("file_status")
        refresh_cache("file_size")
        refresh_cache("file_path")
    end
})

vim.api.nvim_create_autocmd({"WinResized"}, {
    pattern = "*",
    group = "StatusLineCache",
    callback = function()
        refresh_cache("git_branch")
        refresh_cache("file_path")
        refresh_cache("file_type")
    end
})

vim.opt.statusline = "%!luaeval('status_line()')"

vim.wo.fillchars = "eob:~"
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
--opt.laststatus = 3
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



map({'n','x'}, "zj", "<cmd>MultipleCursorsAddDown<CR>")
map({'n','x'}, "zk", "<cmd>MultipleCursorsAddUp<CR>")
--[[local builtin = require "el.builtin"
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
--]]
EOF


" Disable automatic comment in newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
