return {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
        -- You will not need this if you installed the
        -- parsers manually
        -- Or if the parsers are in your $RUNTIMEPATH
        "nvim-treesitter/nvim-treesitter",

        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require('markview').setup(
            {
                latex = {
                    enable = true,
                    inline = {
                        enable = true,
                    },
                    operators = {
                        enable = true,
                    },
                    symbols = {
                        enable = true,
                        -- symbols not yet in markview
                        overwrite = {
                            dots = "…",
                            quad = "  ",
                            [" "] = " ",
                            enspace = " ",
                            thinspace = "",
                            iff = "⇔",
                            leftrightarrows = "⇆",
                            to = "→",
                            forall = "∀",
                            emptyset = "∅",
                            Chi = "Χ",
                            choose = "C",
                            coloneqq = "≔",
                            E = "E",
                            Var = "Var",
                        },
                    },
                }
            }
        )
    end
}
