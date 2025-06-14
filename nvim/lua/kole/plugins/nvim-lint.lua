return {
	"mfussenegger/nvim-lint",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local lint = require("lint")
		local eslint = lint.linters.eslint_d
		local flake8 = lint.linters.flake8

		lint.linters_by_ft = {
			javascript = { "eslint" },
			typescript = { "eslint" },
			vue = { "eslint" },
			python = { "flake8" },
			go = { "golangcilint" },
		}
		eslint.args = {
			"--no-warn-ignored", -- <-- this is the key argument
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
			"--no-color",
		}
		flake8.args = {
			"--max-line-length",
			"88", -- Set line length (PEP8 default is 79, but black uses 88)
			"--ignore",
			"E203,W503", -- Ignore specific warnings (adjust based on your preferences)
			"--format",
			"default", -- You can choose a custom format if needed
			"--stdin-display-name",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
			"-",
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>li", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
--return {
--	"mfussenegger/nvim-lint",
--	event = { "BufReadPre", "BufNewFile" },
--	config = function()
--		local lint = require("lint")
--		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
--		local eslint = lint.linters.eslint_d
--
--		lint.linters_by_ft = {
--			javascript = { "eslint_d" },
--			typescript = { "eslint_d" },
--			javascriptreact = { "eslint_d" },
--			typescriptreact = { "eslint_d" },
--			svelte = { "eslint_d" },
--			python = { "pylint" },
--		}
--
--		eslint.args = {
--			--"--no-warn-ignored", -- <-- this is the key argument
--			"--format",
--			"json",
--			"--stdin",
--			"--stdin-filename",
--			function()
--				return vim.api.nvim_buf_get_name(0)
--			end,
--		}
--
--		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
--			group = lint_augroup,
--			callback = function()
--				lint.try_lint()
--			end,
--		})
--
--		vim.keymap.set("n", "<leader>l", function()
--			lint.try_lint()
--		end, { desc = "Trigger linting for current file" })
--	end,
--}
