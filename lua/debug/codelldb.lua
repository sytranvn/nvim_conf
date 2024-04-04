local dap = require('dap')
dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		args = function()
			local args_ = vim.fn.input('Args: ', '', 'file')
			local args = {}
			for arg in args_:gmatch("%S+") do
				table.insert(args, arg)
			end
			return args
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
	},
}

-- If you want to use this for Rust and C, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
