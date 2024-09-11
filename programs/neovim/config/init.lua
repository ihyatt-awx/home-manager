local utils = require('utils')

local undodir = utils.join_paths(utils.get_cache_dir(), "undo")

if not utils.is_directory(undodir) then
  vim.fn.mkdir(undodir, "p")
end

local opts = {
  spell = true,
  relativenumber = true,
  ruler = true,
  cc = "101",
  tabstop = 4,
  shiftwidth = 4,
  guifont = "mono:h13",
  textwidth = 100,
  --
  backup = false,            -- creates a backup file
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  cmdheight = 1,             -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" },
  conceallevel = 0,          -- so that `` is visible in markdown files
  fileencoding = "utf-8",    -- the encoding written to a file
  foldmethod = "manual",     -- folding, set to "expr" for treesitter based folding
  foldexpr = "",             -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
  hidden = true,             -- required to keep multiple buffers and open multiple buffers
  hlsearch = true,           -- highlight all matches on previous search pattern
  ignorecase = true,         -- ignore case in search patterns
  mouse = "a",               -- allow the mouse to be used in neovim
  pumheight = 10,            -- pop up menu height
  showmode = false,          -- we don't need to see things like -- INSERT -- anymore
  smartcase = true,          -- smart case
  splitbelow = true,         -- force all horizontal splits to go below current window
  splitright = true,         -- force all vertical splits to go to the right of current window
  swapfile = false,          -- creates a swapfile
  termguicolors = true,      -- set term gui colors (most terminals support this)
  timeoutlen = 1000,         -- time to wait for a mapped sequence to complete (in milliseconds)
  title = true,              -- set the title of window to the value of the titlestring
  undodir = undodir,         -- set an undo directory
  undofile = true,           -- enable persistent undo
  updatetime = 100,          -- faster completion
  writebackup = false,       -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,          -- convert tabs to spaces
  cursorline = true,         -- highlight the current line
  number = true,             -- set numbered lines
  numberwidth = 4,           -- set number column width to 2 {default 4}
  signcolumn = "yes",        -- always show the sign column, otherwise it would shift the text each time
  wrap = false,              -- display lines as one long line
  shadafile = utils.join_paths(utils.get_cache_dir(), "shada"),
  scrolloff = 8,             -- minimal number of screen lines to keep above and below the cursor.
  sidescrolloff = 8,         -- minimal number of screen lines to keep left and right of the cursor.
  showcmd = false,
  laststatus = 3,
  showtabline = 2,
  formatoptions = "jcroql"
}

vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.gitblame_enabled = 0

for k, v in pairs(opts) do
  vim.opt[k] = v
end

-- Two space for some langs
utils.ftcmd({ "lua", "hs", "html", "css", "json", "nix" }, function()
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
end)

utils.ftcmd({ "make", "modsim3" }, function()
  vim.opt.expandtab = false
end)

-- Highligh yanked text
vim.api.nvim_set_hl(0, "YankH", {
  reverse = true,
})
vim.api.nvim_create_augroup("TextYankPost", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "TextYankPost",
  pattern = "*",
  desc = "Highlight text on yank",
  callback = function()
    vim.highlight.on_yank { higroup = "YankH", timeout = 300 }
  end,
})

require('keybinds')

vim.cmd([[
  " SpellBad underline
  hi clear SpellBad
  hi SpellBad cterm=underline
  hi SpellBad gui=undercurl

  " Save place in file
  if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  endif

  " Select color scheme
  colorscheme tokyonight-night
]])

-- utils.ftcmd("lua", function()
--   vim.opt.tabstop = 2
--   vim.opt.shiftwidth = 2
-- end)

-- Plugin configs

require('plugins.flatten')
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})
require('crates').setup()
require('plugins.lsp')

-- require('plugins.which-key')
require('which-key').setup {
  preset = "modern",
}

require('nvim-autopairs').setup()
require("nvim-surround").setup()
require('guess-indent').setup()

require('plugins.gitsigns')
require('plugins.lualine')
require('plugins.bufferline')
require('plugins.treesitter')
require('plugins.tabs-n-rainbows')
require('plugins.illuminate')
require('plugins.filetree')
require('plugins.breadcrumbs')
-- require('colorizer').setup({})

-- require("scope").setup({})
require('Comment').setup {
  mappings = false,
}

require('plugins.cmp')

require("toggleterm").setup {
  open_mapping = [[<c-\>]],
  direction = "float",
  float_opts = {
    border = "curved",
  },
}
require("spectre").setup()
require('plugins.telescope')
require("image").setup()
require("nvim-lightbulb").setup({
  autocmd = { enabled = true }
})
require('plugins.alpha')
require('textcase').setup {
  default_keymappings_enabled = false,
}
require('telescope').load_extension('textcase')
require('kitty-scrollback').setup()
