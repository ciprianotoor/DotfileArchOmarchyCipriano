return {
  { "LazyVim/LazyVim", opts = { colorscheme = "habamax" } },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = { style = "night", on_colors = function(c) c.bg = "#08090D"; c.bg_dark = "#08090D"; c.bg_highlight = "#11131A"; c.fg = "#F5F7FA"; c.red = "#E53935"; c.blue = "#FF5252" end, config = function(_, opts) require("tokyonight").setup(opts); vim.cmd.colorscheme("tokyonight-night") end } },
}
