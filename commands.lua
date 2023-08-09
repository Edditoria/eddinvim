-- File: Some customized convenient commands.

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

