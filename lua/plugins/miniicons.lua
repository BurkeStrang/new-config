local htmlIcon = require("mini.icons").get("extension", "html")
return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    {
        "echasnovski/mini.icons",
        version = false,
        lazy = false,
        config = function()
            require("mini.icons").setup({
                extension = {
                    ["razor"] = {
                        glyph = htmlIcon,
                        hl = "MiniIconsOrange",
                    },
                    ["cshtml"] = {
                        glyph = htmlIcon,
                        hl = "MiniIconsOrange",
                    },
                },
            })
            MiniIcons.mock_nvim_web_devicons()
        end,
    },
}
