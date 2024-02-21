local M = {}
M.setup = function()
	local local_nvimrc = vim.fn.getcwd() .. '/.nvimrc'
	if vim.loop.fs_stat(local_nvimrc) then
		vim.cmd('source ' .. local_nvimrc)
	end
	local local_lua_nvimrc = vim.fn.getcwd() .. '/.nvimrc.lua'
	if vim.loop.fs_stat(local_lua_nvimrc) then
		dofile(local_lua_nvimrc)
	end
end
return M
