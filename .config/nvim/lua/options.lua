-- Syntax highlighting
vim.cmd.filetype { args = {'plugin', 'indent', 'on'}}
vim.cmd.syntax('on')

-- Mouse support
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup_setpos"
vim.opt.list = true
vim.opt.listchars = "tab:<->,trail:.,nbsp:+,eol:$,extends:+,precedes:+"
vim.opt.ruler = true
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.showtabline = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.laststatus = 2
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.directory = "$HOME/.vim/swap//,./"
vim.opt.previewheight = 20
vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "78"
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true

-- UI
-- vim.opt.completeopt = "longest,menu,menuone,preview"

