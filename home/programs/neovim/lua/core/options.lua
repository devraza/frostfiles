-- Load and use the default colorscheme
use './particle.nvim'
colorscheme = particle

-- Shorten name
local o = vim.opt

-- Clipboard
o.clipboard = "unnamedplus"

-- Completion improvement
o.updatetime = 300

-- Indentation
o.smartindent = true
o.expandtab = true
o.showtabline = 2
o.shiftwidth = 2
o.tabstop = 2

-- General improvements
o.fileencoding = "utf-8"
o.hlsearch = true
o.ignorecase = true
o.mouse = "a"
o.pumheight = 10
o.showmode = false
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.timeoutlen = 1000
o.conceallevel = 0
o.undofile = true
o.cursorline = true
o.number = true
o.numberwidth = 4
o.relativenumber = false
o.signcolumn = "yes"

-- Do not wrap lines
o.wrap = false

-- Disable backups and swapfile
o.backup = false
o.swapfile = false

-- Font
o.guifont = "Iosevka Comfy:h10"

