return {
    "rebelot/kanagawa.nvim",
    config = function()
        require("kanagawa").setup(
            {
                commentStyle = { italic = false, },
                keywordStyle = { italic = false, bold = true, },
                statementStyle = { bold = false, },
                dimInactive = true,
                transparent = true,
                theme = "dragon",
                background = {
                    dark = "dragon",
                    light = "wave",
                },
            }
        )

        vim.cmd("colorscheme kanagawa")
    end,
}
