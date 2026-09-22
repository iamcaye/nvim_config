vim.g.copilot_enabled = false

vim.keymap.set("n", "<leader>cp", function()
	vim.g.copilot_enabled = not vim.g.copilot_enabled
	vim.notify("Copilot " .. (vim.g.copilot_enabled and "enabled" or "disabled"))
end, { desc = "Toggle Copilot" })
