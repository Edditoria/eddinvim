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
vim.keymap.set('n', '<Leader>dD', '<cmd>Telescope diagnostics<CR>', { desc = '<Tel>Workspace diag...', noremap = true })
vim.keymap.set('n', '<Leader>h<C-t>', '<cmd>pop<CR>', { desc = 'Go prev :tags', noremap = true })
vim.keymap.set('n', '<Leader>h<C-o>', '<C-o>', { desc = 'Go prev :jumps', noremap = true })
vim.keymap.set('n', '<Leader>h<C-i>', '<C-i>', { desc = 'Go next :jumps', noremap = true })

local function setup_telescope_keymap()
	local ok, telescope = pcall(require, 'telescope')
	if not ok then return end -- early.
	local builtin = require('telescope.builtin')
	local themes = require('telescope.themes')

	-- Quick Open view using `telescope.builtin.find_files`.
	local function quick_open()
		builtin.find_files(themes.get_dropdown({
			prompt_title = 'Quick Open', previewer = false
		}))
	end

	-- Find All Files view using `telescope.builtin.find_files`.
	local function find_all_files()
		builtin.find_files({
			prompt_title = 'Find All Files',
			no_ignore = true,
		})
	end

	vim.keymap.set('n', '<Leader>o', quick_open, { desc = 'Quick open...', noremap = true })
	vim.keymap.set('n', '<Leader>bb', builtin.buffers, { desc = '<Tel>Buffers...', noremap = true })
	vim.keymap.set('n', '<Leader>bf', builtin.current_buffer_fuzzy_find, { desc = '<Tel>Current fuzzy...', noremap = true })
	vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = '<Tel>Find files...', noremap = true })
	vim.keymap.set('n', '<Leader>fF', find_all_files, { desc = '<Tel>Find all...', noremap = true })
	vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { desc = '<Tel>Live-Grep...', noremap = true })
	vim.keymap.set('n', '<Leader>fs', builtin.grep_string, { desc = '<Tel>Grep string...', noremap = true })
	vim.keymap.set('n', '<Leader>fb', '<cmd>Telescope file_browser<CR>', { desc = '<Tel>Browse...', noremap = true })
	vim.keymap.set('n', '<Leader>fr', builtin.oldfiles, { desc = '<Tel>Recent files...', noremap = true })
	vim.keymap.set('n', '<Leader>ht', builtin.help_tags, { desc = '<Tel>Tags...', noremap = true })
	vim.keymap.set('n', '<Leader>hc', builtin.commands, { desc = '<Tel>Commands...', noremap = true })
	vim.keymap.set('n', '<Leader>hk', builtin.keymaps, { desc = '<Tel>Keymaps...', noremap = true })
end
setup_telescope_keymap()

local function setup_whichkey()
	local ok, whichkey = pcall(require, 'which-key')
	if not ok then
		print('<Plug>which-key not loaded.')
		return -- early.
	end
	local setupOpts = {
		delay = 500, -- ms; Instead of vim.opt.timeoutlen
		-- TODO: Add <Leader> during 'x' mode. Disable v-key in 'n' mode.
		-- triggers = {{ '<auto>', mode = 'nso' },{ '<Leader>', mode = { 'n', 'x' }}},
	}
	local mappings = {
		{ '<Leader>', group = '<Which-Key>' },
		{ '<Leader>b', group = 'Buffers' },
		{ '<Leader>d', group = 'Diagnostics' },
		{ '<Leader>f', group = 'Files' },
		{ '<Leader>h', group = 'Help' },
		{ '<Leader>l', group = 'LSP' },
		{ '[', group = 'Previous' },
		{ ']', group = 'Next' },
	}
	local mappingOpts = {
		-- prefix = '<Leader>',
	}
	whichkey.setup(setupOpts)
	whichkey.add(mappings, mappingOpts)
end
setup_whichkey()
