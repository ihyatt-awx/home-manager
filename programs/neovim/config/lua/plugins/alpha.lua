local button = require('alpha.themes.dashboard').button

local buttons = {
  type = "group",
  val = {
    button("f", "󰈞  Find file",
      [[<cmd>lua require("plugins.telescope").find_project_files { previewer = false }<cr>]]),
    button("t", "󰈬  Find word", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>"),
    button("r", "󰊄  Recently opened files", "<cmd>Telescope oldfiles<cr>"),
    button("q", "  Quit", "<cmd>qa<cr>")
  },
  opts = {
    spacing = 1,
  },
}

local config = {
  layout = {
    { type = "padding", val = 20 },
    buttons,
  },
  opts = {
    margin = 5,
  },
}
require('alpha').setup(config)
