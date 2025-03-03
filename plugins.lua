-- FILE: Plugins and their configs.

-- Plugin Loader
-- =============

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

-- Important
-- ---------

-- Plug 'editorconfig/editorconfig-vim' -- does not work.
-- Plug 'gpanders/editorconfig.nvim' -- is now built-in in nvim v0.9.0.
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim' -- Many utils and dep of plugin:telescope.nvim.
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })
-- NOTE: Run `checkhealth telescope` regularly.

-- LSP
-- ---
Plug 'williamboman/mason.nvim' -- instead of nvim-lsp-installer.
Plug 'williamboman/mason-lspconfig.nvim' -- as bridge of mason.nvim and nvim-lspconfig.
Plug 'neovim/nvim-lspconfig' -- Wrapper of vim.lsp.* functions.

-- Auto-Completion
-- ---------------

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/nvim-cmp' -- for auto-completion. TODO: Need setup in details.

-- UI/UX
-- -----

local disable_devicons = os.getenv('DISABLE_DEVICONS')
if not (disable_devicons == 'true' or disable_devicons == '1') then
	Plug 'nvim-tree/nvim-web-devicons'
end
Plug 'numToStr/Comment.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'itchyny/lightline.vim' -- for status line.
Plug 'folke/which-key.nvim'
-- NOTE: Run `checkhealth which_key` regularly.
Plug('nvim-treesitter/nvim-treesitter') -- , { ['do'] = vim.cmd [[TSUpdate]] })
-- NOTE: Run `checkhealth nvim-treesitter` regularly.
Plug 'folke/todo-comments.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'

-- Color Scheme
-- ------------

Plug 'navarasu/onedark.nvim' -- instead of 'joshdick/onedark.vim'
Plug 'lifepillar/vim-wwdc16-theme'
Plug 'morhetz/gruvbox'

vim.call('plug#end')


-- Plugin Configs
-- ==============

local function setup_gitsigns()
	local ok, gitsigns = pcall(require, 'gitsigns')
	if not ok then
		print('<Plug>gitsigns not loaded.')
		return -- early.
	end
	gitsigns.setup()
end
setup_gitsigns()

-- NOTE: Keymaps are set in setup_telescope_keymap()
local function setup_telescope()
	local ok, telescope = pcall(require, 'telescope')
	if not ok then
		print('<Plug>telescope not loaded.')
		return -- early.
	end
	telescope.setup({
		defaults = {
			mappings = {
				i = {
					['<C-i>'] = require('telescope.actions.layout').toggle_preview,
				},
				n = {
					['<C-i>'] = require('telescope.actions.layout').toggle_preview,
				},
			},
			layout_strategy = 'flex',
			layout_config = {
				horizontal = { preview_cutoff = 60, preview_width = 0.6 },
				vertical = { preview_cutoff = 25, preview_height = 0.5 },
				width = 0.9,
			},
			file_ignore_patterns = {
				'.git/',
				'node_modules/',
				'vendor/bundle/',
				'.bundle/bin/',
				'plugged/',
			},
		},
		pickers = {
			find_files = {
				hidden = true, -- to show hidden files.
			},
			current_buffer_fuzzy_find = {
				sorting_strategy = 'ascending',
			},
		},
		extensions = {
			file_browser = {
				display_stat = false, -- originally a table.
				grouped = true,
				hidden= { file_browser = true, folder_browser = true },
				hijack_netrw = true,
				respect_gitignore = false,
				select_buffer = true,
			},
		},
	})
end
setup_telescope()

local function setup_telescope_file_browser()
	local tsOk, telescope = pcall(require, 'telescope')
	if not tsOk then
		print('<Plug>telescope-file-browser: Telescope not loaded.')
		return
	end
	local ok, _ = pcall(require, 'telescope._extensions.file_browser')
	if not ok then
		print('<Plug>telescope-file-browser not loaded.')
		return
	end
	telescope.load_extension('file_browser')
end
setup_telescope_file_browser()

local function setup_cmp()
	local ok, cmp = pcall(require, 'cmp')
	if not ok then
		print('<Plug>cmp not loaded.')
		return -- early.
	end
	-- vim.opt.completeopt={ 'menu', 'menuone', 'noselect' }
	cmp.setup({
		experimental = { ghost_text = true },
		snippet = {
			expand = function(args)
				vim.fn['vsnip#anonymous'](args.body)
			end,
		},
		window = {
			-- completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			['<C-Space>'] = cmp.mapping.complete(), -- to invoke cmp menu.
			['<CR>'] = cmp.mapping.confirm({ select = false }), --Recommended by nvim-cmp: <CR>.
			['<C-e>'] = cmp.mapping.abort(), -- As default.
			['<C-n>'] = cmp.mapping.select_next_item(), -- As default.
			['<C-p>'] = cmp.mapping.select_prev_item(), -- As default.
			-- TODO: <C-f> and <C-b> not working:
			['<C-f>'] = cmp.mapping.scroll_docs(4), -- Recommended by nvim-cmp: <C-f>.
			['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Recommended by nvim-cmp: <C-b>.
		}),
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
			-- { name = 'path' },
		}, {
			{ name = 'buffer' },
		}) -- depends on other <Plug>.
	})
	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' },
		},
	})
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' },
		}, {
			{ name = 'cmdline' },
		}),
		matching = { disallow_symbol_nonprefix_matching = false },
	})
end
setup_cmp()

local function on_attach_lsp(client, bufnr)
	vim.keymap.set('n', '<Leader>K', vim.lsp.buf.hover, { buffer = bufnr, desc = '<LSP>Hover doc' })
	vim.keymap.set('n', '<Leader>lD', vim.lsp.buf.definition, { buffer = bufnr, desc = '<LSP>Go definition' })
	vim.keymap.set('n', '<Leader>lI', vim.lsp.buf.implementation, { buffer = bufnr, desc = '<LSP>Go implementation' })
	vim.keymap.set('n', '<Leader>lT', vim.lsp.buf.type_definition, { buffer = bufnr, desc = '<LSP>Go type-definition' })
	vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.rename, { buffer = bufnr, desc = '<LSP>Rename symbol' })
	vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action, { buffer = bufnr, desc = '<LSP>Code action' })
	vim.keymap.set('n', '<Leader>lr', '<cmd>Telescope lsp_references<CR>', { desc = '<Tel>References...' })
end

local function setup_lsp(on_attach_fn)
	local ok, mason, lspconfig, mason_lspconfig, cmp_nvim_lsp
	ok, mason = pcall(require, 'mason')
	if not ok then
		print('<Plug>mason not loaded.')
		return -- early.
	end
	ok, lspconfig = pcall(require, 'lspconfig')
	if not ok then
		print('<Plug>lspconfig not loaded.')
		return -- early.
	end
	ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
	if not ok then
		print('<Plug>mason-lspconfig not loaded.')
		return -- early.
	end
	ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
	if not ok then
		print('<Plug>cmp_nvim_lsp not loaded.')
		return -- early.
	end

	local capabilities = cmp_nvim_lsp.default_capabilities()
	-- TODO: Not sure this capabilities do:
	local capabilities_vscode = vim.lsp.protocol.make_client_capabilities()
	capabilities_vscode.textDocument.completion.completionItem.snippetSupport = true

	-- NOTE: Have to setup in order of: mason, mason_lspconfig, lspconfig. Requires cmp-nvim-lsp to run properly.
	mason.setup()
	mason_lspconfig.setup({
		ensure_installed = {
			'gopls', 'lua_ls',
			-- Coop with vscode-langservers-extracted via npm:
			'html', 'cssls', 'jsonls', 'eslint',
			-- For more web dev env:
			'ts_ls', 'denols', 'svelte',
		},
	})
	lspconfig.gopls.setup({
		capabilities = capabilities,
		on_attach = on_attach_fn,
	})
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach_fn,
		settings = {
			Lua = { diagnostics = { globals = { 'vim' } } },
		},
	})
	-- Ref for html, cssls, jsonls and eslint: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	lspconfig.html.setup({
		capabilities = capabilities_vscode,
		on_attach = on_attach_fn,
	})
	lspconfig.cssls.setup({
		capabilities = capabilities_vscode,
		on_attach = on_attach_fn,
	})
	lspconfig.jsonls.setup({
		capabilities = capabilities_vscode,
		on_attach = on_attach_fn,
	})
	lspconfig.eslint.setup({
		on_attach = function(client, bufnr)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				command = "EslintFixAll",
			})
		end,
	})
	lspconfig.ts_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach_fn,
		root_dir = lspconfig.util.root_pattern({ 'package.json', 'tsconfig.json', 'jsconfig.json' }),
	})
	lspconfig.denols.setup({
		capabilities = capabilities,
		on_attach = on_attach_fn,
		root_dir = lspconfig.util.root_pattern({ 'deno.json', 'deno.jsonc' }),
	})
	lspconfig.svelte.setup({
		capabilities = capabilities,
		on_attach = on_attach_fn,
	})
end
setup_lsp(on_attach_lsp)

local function setup_comment_plug()
	local ok, comment_plug = pcall(require, 'Comment')
	if not ok then
		print('<Plug>Comment not loaded.')
	end
	comment_plug.setup({
		ignore = '^$', -- to ignore empty lines.
	})
end
setup_comment_plug()

local function setup_autopairs()
	local ok, autopairs = pcall(require, 'nvim-autopairs')
	if not ok then
		print('<Plug>autopairs not loaded.')
	end
	autopairs.setup()
end
setup_autopairs()

local function setup_treesitter()
	local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
	if not ok then
		print('<Plug>treesitter not loaded.')
		return -- early.
	end
	local configs = {
		ensure_installed = {
			'go', 'lua', 'vim',
			'html', 'css', 'javascript', 'jsdoc',
			'typescript', 'tsx',
			'svelte',
		},
		sync_install = true,
		highlight = {
			enable = true, -- as default.
			-- disable = {}, -- List of lang(s) in case of any problem.
		},
		indent = {
			enable = true,
			disable = { 'yaml' }, -- List of lang(s) in case of any problem.
		},
	}
	treesitter.setup(configs)
	-- vim.cmd [[TSUpdate]] -- TODO: Vim:E492: Not an editor command: TSUpdate.
end
setup_treesitter()

local function setup_todo_comments()
	local ok, todo_comments = pcall(require, 'todo-comments')
	if not ok then
		print('<Plug>todo-comments not loaded.')
		return
	end
	todo_comments.setup({ highlight = { after = '' } }) -- '' or 'bg'.
end
setup_todo_comments()

-- Setup in other files:

-- <Plug>lightline : colorscheme.lua
-- <Plug>which-key : keymap.lua
-- <Plug>telescope keymap : keymap.lua
-- Color schemes : colorscheme.lua
