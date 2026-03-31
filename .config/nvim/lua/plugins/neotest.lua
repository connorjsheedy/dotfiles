local configured = false

local function ensure_configured()
	if configured then
		return
	end
	configured = true

	local function python_path()
		if vim.fn.executable("pyenv") == 1 then
			local path = vim.fn.trim(vim.fn.system("pyenv which python"))
			if path ~= "" then
				return path
			end
		end
		return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
	end

	require("neotest").setup({
		adapters = {
			require("neotest-python")({
				dap = { justMyCode = false },
				python = python_path,
				runner = "pytest",
				pytest_discover_instances = true,
			}),
		},
	})
end

vim.keymap.set("n", "<leader>tt", function()
	ensure_configured()
	require("neotest").run.run()
end, { desc = "Test: Run Nearest" })
vim.keymap.set("n", "<leader>tT", function()
	ensure_configured()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Test: Run File" })
vim.keymap.set("n", "<leader>ts", function()
	ensure_configured()
	require("neotest").summary.toggle()
end, { desc = "Test: Toggle Summary" })
vim.keymap.set("n", "<leader>to", function()
	ensure_configured()
	require("neotest").output.open({ enter = true })
end, { desc = "Test: Show Output" })
vim.keymap.set("n", "<leader>tO", function()
	ensure_configured()
	require("neotest").output_panel.toggle()
end, { desc = "Test: Toggle Output Panel" })
vim.keymap.set("n", "<leader>tS", function()
	ensure_configured()
	require("neotest").run.stop()
end, { desc = "Test: Stop" })
vim.keymap.set("n", "<leader>td", function()
	ensure_configured()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "Test: Debug Nearest" })
