local configured = false

local function ensure_configured()
	if configured then
		return
	end
	configured = true

	local dap = require("dap")
	local dapui = require("dapui")

	dapui.setup()

	-- Auto-open/close UI when a debug session starts and ends
	dap.listeners.after.event_initialized["dapui_config"] = dapui.open
	dap.listeners.before.event_terminated["dapui_config"] = dapui.close
	dap.listeners.before.event_exited["dapui_config"] = dapui.close

	-- debugpy adapter installed via mason
	local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
	dap.adapters.python = {
		type = "executable",
		command = mason_packages .. "/debugpy/venv/bin/python",
		args = { "-m", "debugpy.adapter" },
	}

	-- Resolve the python interpreter via pyenv, falling back to system python
	local function python_path()
		if vim.fn.executable("pyenv") == 1 then
			local path = vim.fn.trim(vim.fn.system("pyenv which python"))
			if path ~= "" then
				return path
			end
		end
		return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
	end

	dap.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			pythonPath = python_path,
		},
		{
			type = "python",
			request = "launch",
			name = "Launch file with arguments",
			program = "${file}",
			args = function()
				return vim.split(vim.fn.input("Arguments: "), " ", { trimempty = true })
			end,
			pythonPath = python_path,
		},
		{
			type = "python",
			request = "attach",
			name = "Attach to process",
			processId = require("dap.utils").pick_process,
			pythonPath = python_path,
		},
	}
end

-- Execution keymaps
vim.keymap.set("n", "<F5>", function()
	ensure_configured()
	require("dap").continue()
end, { desc = "Debug: Continue" })
vim.keymap.set("n", "<F10>", function()
	ensure_configured()
	require("dap").step_over()
end, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", function()
	ensure_configured()
	require("dap").step_into()
end, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F12>", function()
	ensure_configured()
	require("dap").step_out()
end, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>dx", function()
	ensure_configured()
	require("dap").terminate()
end, { desc = "Debug: Terminate" })
vim.keymap.set("n", "<leader>dl", function()
	ensure_configured()
	require("dap").run_last()
end, { desc = "Debug: Run Last" })

-- Breakpoint keymaps
vim.keymap.set("n", "<leader>db", function()
	ensure_configured()
	require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
	ensure_configured()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Conditional Breakpoint" })
vim.keymap.set("n", "<leader>dL", function()
	ensure_configured()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, { desc = "Debug: Log Point" })

-- UI keymaps
vim.keymap.set("n", "<leader>du", function()
	ensure_configured()
	require("dapui").toggle()
end, { desc = "Debug: Toggle UI" })
vim.keymap.set({ "n", "v" }, "<leader>de", function()
	ensure_configured()
	require("dapui").eval()
end, { desc = "Debug: Eval" })
vim.keymap.set("n", "<leader>dr", function()
	ensure_configured()
	require("dap").repl.open()
end, { desc = "Debug: Open REPL" })
