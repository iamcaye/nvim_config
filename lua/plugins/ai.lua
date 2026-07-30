vim.g.copilot_enabled = false

local sidekick_ok, sidekick = pcall(require, "sidekick")
if sidekick_ok then
	sidekick.setup({
		cli = {
			mux = {
				backend = "zellij",
				enabled = true,
			},
		},
	})
end

local nes_ok, nes = pcall(require, "sidekick.nes")
if nes_ok then
	nes.disable()
end

vim.keymap.set("n", "<leader>cp", function()
	vim.g.copilot_enabled = not vim.g.copilot_enabled
	if nes_ok then
		if vim.g.copilot_enabled then
			nes.enable()
		else
			nes.disable()
		end
	end
	vim.notify("Copilot " .. (vim.g.copilot_enabled and "enabled" or "disabled"))
end, { desc = "Toggle Copilot" })

if sidekick_ok then
	vim.keymap.set({ "n", "v" }, "<leader>aa", function()
		require("sidekick.cli").toggle()
	end, { desc = "Sidekick toggle CLI" })
	vim.keymap.set("n", "<leader>as", function()
		require("sidekick.cli").select()
	end, { desc = "Sidekick select CLI" })
	vim.keymap.set("v", "<leader>as", function()
		require("sidekick.cli").send({ selection = true })
	end, { desc = "Sidekick send visual selection" })
	vim.keymap.set({ "n", "v" }, "<leader>ap", function()
		require("sidekick.cli").prompt()
	end, { desc = "Sidekick select prompt" })
	vim.keymap.set({ "n", "x", "i", "t" }, "<C-.>", function()
		require("sidekick.cli").focus()
	end, { desc = "Sidekick switch focus" })
	vim.keymap.set("n", "<Tab>", function()
		if not require("sidekick").nes_jump_or_apply() then
			return "<Tab>"
		end
	end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })
	vim.keymap.set("n", "<leader>ad", function()
		require("sidekick.cli").close()
	end, { desc = "Sidekick detach a CLI session" })
	vim.keymap.set({ "n", "x" }, "<leader>at", function()
		require("sidekick.cli").send({ msg = "{this}" })
	end, { desc = "Sidekick send this" })
	vim.keymap.set("n", "<leader>af", function()
		require("sidekick.cli").send({ msg = "{file}" })
	end, { desc = "Sidekick send file" })
	vim.keymap.set("x", "<leader>av", function()
		require("sidekick.cli").send({ msg = "{selection}" })
	end, { desc = "Sidekick send visual selection" })
	vim.keymap.set("n", "<leader>ac", function()
		require("sidekick.cli").toggle({ name = "claude", focus = true })
	end, { desc = "Sidekick toggle Claude" })
end
