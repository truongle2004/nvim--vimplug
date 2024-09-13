if vim.g.neovide then
  vim.o.guifont = "FiraCode Nerd Font:h10"
end
local opt = vim.opt
vim.g.mapleader = " "
-- opt.cmdheight = 0
opt.shell = "pwsh"
opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
opt.shellquote = ""
opt.shellxquote = ""
opt.termguicolors = true
opt.relativenumber = true
opt.number = true
opt.scrolloff = 10
opt.laststatus = 3
vim.o.undofile = true


vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4"
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4"
})

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
opt.splitbelow = true -- split windows below
opt.splitright = true -- split windows right
-- opt.colorcolumn = "79"
vim.o.wrap = true

-- Enable lazyredraw for better performance during macros and complex operations
vim.o.lazyredraw = true

-- Assume fast terminal connection
vim.o.ttyfast = true

-- Set the update time for writing to the swap file and triggering CursorHold events (in milliseconds)
vim.o.updatetime = 300

vim.o.termguicolors = true

