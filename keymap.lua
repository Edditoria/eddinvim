-- FILE: Configs for key-bindings / key map.
-- NOTE: `desc` is used for <Plug>which-key.
-- NOTE: Some keymaps about LSP: on_attach_lsp() in plugins.lua file.

vim.keymap.set('n', 'q', '<Nop>', { noremap = true, silent = true }) -- to prevent qq-recording.
vim.keymap.set('x', 'q', '<Nop>', { noremap = true, silent = true }) -- to prevent qq-recording.
vim.keymap.set('', 'x', '"_x', { desc = '<Del>', noremap = true }) -- to prevent write to clipboard.
vim.keymap.set('', 'X', '"_X', { desc = '<BS>', noremap = true }) -- to prevent write to clipboard.
vim.keymap.set('', '<Del>', '"_x', { desc = '<Del>', noremap = true }) -- to prevent write to clipboard.

vim.keymap.set('x', 'K', ":move '<-2<CR>gv-gv", { desc = 'Move line up', noremap = true, silent = true })
vim.keymap.set('x', '<A-k>', ":move '<-2<CR>gv-gv", { desc = 'Move line up', noremap = true, silent = true })
vim.keymap.set('x', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move line down', noremap = true, silent = true })
vim.keymap.set('x', '<A-j>', ":move '>+1<CR>gv-gv", { desc = 'Move line down', noremap = true, silent = true })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diag', noremap = true })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diag', noremap = true })
vim.keymap.set('n', '<Leader>d[', vim.diagnostic.goto_prev, { desc = 'Prev diag, [d', noremap = true })
vim.keymap.set('n', '<Leader>d]', vim.diagnostic.goto_next, { desc = 'Next diag, ]d', noremap = true })
vim.keymap.set('n', '<Leader>dd', vim.diagnostic.open_float, { desc = 'Popup diag', noremap = true })
vim.keymap.set('n', '<Leader>h<C-t>', '<cmd>pop<CR>', { desc = 'Go prev :tags', noremap = true })
vim.keymap.set('n', '<Leader>h<C-o>', '<C-o>', { desc = 'Go prev :jumps', noremap = true })
vim.keymap.set('n', '<Leader>h<C-i>', '<C-i>', { desc = 'Go next :jumps', noremap = true })

local function setup_telescope_keymap()
	local ok, telescope = pcall(require, 'telescope')
	if not ok then return end -- early.

	local builtin = require('telescope.builtin')
	local themes = require('telescope.themes')
	vim.keymap.set('n', '<Leader>o', function()
		builtin.find_files(themes.get_dropdown({
			prompt_title = 'Quick Open', previewer = false
		}))
		end, { desc = 'Quick open...', noremap = true })
	vim.keymap.set('n', '<Leader>bb', '<cmd>Telescope buffers<CR>', { desc = '<Tel>Buffers...', noremap = true })
	vim.keymap.set('n', '<Leader>bf', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = '<Tel>Current fuzzy...', noremap = true })
	vim.keymap.set('n', '<Leader>ff', '<cmd>Telescope find_files<CR>', { desc = '<Tel>Find files...', noremap = true })
	vim.keymap.set('n', '<Leader>fF', function()
		builtin.find_files({
			prompt_title = 'Find All Files',
			no_ignore = true,
		})
		end, { desc = '<Tel>Find all...', noremap = true })
	vim.keymap.set('n', '<Leader>fg', '<cmd>Telescope live_grep<CR>', { desc = '<Tel>Live-Grep...', noremap = true })
	vim.keymap.set('n', '<Leader>fs', '<cmd>Telescope grep_string<CR>', { desc = '<Tel>Grep string...', noremap = true })
	vim.keymap.set('n', '<Leader>fb', '<cmd>Telescope file_browser<CR>', { desc = '<Tel>Browse...', noremap = true })
	vim.keymap.set('n', '<Leader>fr', '<cmd>Telescope oldfiles<CR>', { desc = '<Tel>Recent files...', noremap = true })
	vim.keymap.set('n', '<Leader>ht', '<cmd>Telescope help_tags<CR>', { desc = '<Tel>Tags...', noremap = true })
	vim.keymap.set('n', '<Leader>hc', '<cmd>Telescope commands<CR>', { desc = '<Tel>Commands...', noremap = true })
	vim.keymap.set('n', '<Leader>hk', '<cmd>Telescope keymaps<CR>', { desc = '<Tel>Keymaps...', noremap = true })
end
setup_telescope_keymap()

vim.opt.timeoutlen = 500 -- ms; Default: 1000.
local function setup_whichkey()
	local ok, whichkey = pcall(require, 'which-key')
	if not ok then
		print('<Plug>which-key not loaded.')
		return -- early.
	end
	local configs = {
		triggers_blacklist = {
			-- n = { 'v' }, -- to ignore when entering Visual mode from Normal mode.
		},
	}
	local mappings = {
		['<Leader>'] = { name = '<Which-Key>' },
		['['] = { name = 'Previous' },
		[']'] = { name = 'Next' },
		['<Leader>b'] = { name = 'Buffers' },
		['<Leader>d'] = { name = 'Diagnostics' },
		['<Leader>f'] = { name = 'Files' },
		['<Leader>h'] = { name = 'Help' },
		['<Leader>l'] = { name = 'LSP' },
	}
	local options = {
		-- prefix = '<Leader>',
	}
	whichkey.setup(configs)
	whichkey.register(mappings, options)
end
setup_whichkey()
