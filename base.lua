-- FILE: Base configs for Neovim.

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'


-- Features
-- ========

-- vim.g.mapleader = ','
-- vim.g.maplocalleader = ','
vim.g.mapleader = ' ' -- <Space> -- TODO: Will trigger <Space> in visual mode.
vim.g.maplocalleader = ' ' -- <Space>

vim.opt.mouse = 'a'
-- vim.opt.mouse = 'nvi' -- to exclude Command-line mode.

vim.opt.tabstop = 2 -- aka the tab width.
vim.opt.shiftwidth = 2 -- for autoindents.
-- vim.opt.expandtab = true -- to use space instead of tab.

vim.cmd [[autocmd BufEnter * set formatoptions-=r]] -- to disable auto comment.
vim.cmd [[autocmd BufEnter * setlocal formatoptions-=r]] -- to disable auto comment.
vim.opt.ignorecase = true -- for search.
vim.opt.smartcase = true -- to override `ignorecase` when search capital letters.


-- UI
-- ==

vim.opt.linebreak = true -- to wrap line by words.
vim.opt.showbreak = '  ↪' -- for wrapped lines.
vim.opt.cc = '80,100,120' -- colorcolumn (line limit).
vim.opt.number = true -- to display line number.
vim.opt.relativenumber = true -- for line number.
vim.opt.cursorline = true -- to highlight vertically.
-- vim.opt.cursorcolumn = true -- to highlight horizontally.
vim.opt.listchars = {
	tab = '→ ', -- Overrided default.
	trail = '•', -- Overrided default.
	nbsp = '␣', -- Overrided default.
	space = '·',
	precedes = '«',
	extends = '»',
	-- eol = '¶',
}
vim.opt.list = true -- to display special characters.

-- Just copy from `~/.vim/vimrc`:
vim.cmd [[
" Editor Command: Toogle Showing EOL Character:
let g:is_showing_eol = 0
function ToggleShowEOL()
	if g:is_showing_eol
		let g:is_showing_eol = 0
		setlocal listchars=tab:→\ ,space:·,nbsp:␣,trail:•,precedes:«,extends:» ",eol:¶
	else
		let g:is_showing_eol = 1
		setlocal listchars=tab:→\ ,space:·,nbsp:␣,trail:•,precedes:«,extends:»,eol:¶
	endif
endfunction
command ToggleShowEOL call ToggleShowEOL()
]]

-- Nvim Defaults
-- =============

-- These options are probably default in Nvim (`:h vim-differences`):

-- set nocompatible
-- syntax on

-- vim.opt.autoindent = true
-- vim.opt.hlsearch = true

-- vim.opt.showcmd = true
-- vim.opt.wildmenu = true
-- vim.opt.wildmode seems work fine.
