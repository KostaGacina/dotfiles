return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<M-e>]],
			auto_scroll = true, -- automatically scroll to the bottom on terminal output
		})
	end,
}
