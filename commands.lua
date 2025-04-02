-- File: Some customized convenient commands.

-- Quick Open File: view list of files using `telescope.builtin.find_files`.
function QuickOpenFile()
	local ok, _ = pcall(require, 'telescope')
	if not ok then
		print('<Plug>telescope not loaded.')
		return -- early.
	end
	local builtin = require('telescope.builtin')
	local themes = require('telescope.themes')
	builtin.find_files(themes.get_dropdown({
		prompt_title = 'Quick Open', previewer = false
	}))
end

vim.api.nvim_create_user_command('QuickOpenFile', QuickOpenFile, {
	desc = 'Open file list in current directory',
})

vim.api.nvim_create_autocmd('VimEnter', {
	pattern = '*',
	-- once = true,
	callback = function()
		local args = vim.fn.argv()
		if #args == 0 then
			QuickOpenFile()
		elseif args[1] == '.' then
			if vim.fn.bufname() == '.' then
				vim.cmd('bwipeout') -- as a bandage to remove the "." buffer.
			end
			QuickOpenFile()
		end
	end,
})

function GrepString()
	local ok, _ = pcall(require, 'telescope')
	if not ok then
		print('<Plug>telescope not loaded.')
		return
	end
	vim.ui.input({ prompt = 'grep_string: ' }, function(input)
		require('telescope.builtin').grep_string({ search = input })
	end)
end

vim.api.nvim_create_user_command('GrepString', GrepString, {
	desc = 'Prompt for string, then :Telescope grep_string.',
})

