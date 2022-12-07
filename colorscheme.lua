-- FILE: Configs related to color scheme.

-- vim.opt.background = 'light' -- Default: 'dark'.
vim.opt.termguicolors = true

-- Plugin: One Dark for Neovim
vim.g.onedark_config = {
	style = 'warmer', -- 'dark' (default), 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'.
}

local ok, _ = pcall(vim.cmd, 'colorscheme onedark')
-- local ok, _ = pcall(vim.cmd, 'colorscheme gruvbox')
-- local ok, _ = pcall(vim.cmd, 'colorscheme wwdc16')
if not ok then
	vim.cmd [[colorscheme default]]
end

-- Plugin: Lightline
vim.g.lightline = {
	colorscheme = 'one' -- Notable: Tomorrow_Night_Eighties, solarized, one
	-- All color scheme: https://github.com/itchyny/lightline.vim/blob/master/colorscheme.md
}
vim.opt.showmode = false -- to hide mode status.
