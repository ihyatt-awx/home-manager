local icons = require("icons")
local wk = require("which-key")
local utils = require("utils")

local M = {}

wk.setup({
  plugins = {
    marks = false,     -- shows a list of your marks on ' and `
    registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true,
      suggestions = 20,
    }, -- use which-key for spelling hints
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false,    -- adds help for operators like d, y, ...
      motions = false,      -- adds help for motions
      text_objects = false, -- help for text objects triggered after entering an operator
      windows = false,      -- default bindings on <c-w>
      nav = false,          -- misc bindings to work with windows
      z = false,            -- bindings for folds, spelling and others prefixed with z
      g = false,            -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = icons.ui.DoubleChevronRight, -- symbol used in the command line area that shows your active key combo
    separator = icons.ui.BoldArrowRight,      -- symbol used between a key and it's label
    group = icons.ui.Plus,                    -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>",   -- binding to scroll up inside the popup
  },
  window = {
    border = "single",        -- none, single, double, shadow
    position = "bottom",      -- bottom, top
    margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 },                                             -- min and max height of the columns
    width = { min = 20, max = 50 },                                             -- min and max width of the columns
    spacing = 3,                                                                -- spacing between columns
    align = "left",                                                             -- align columns left, center or right
  },
  ignore_missing = true,                                                        -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true,                                                             -- show help message on the command line when the popup is visible
  show_keys = true,                                                             -- show the currently pressed key and its label as a message in the command line
  triggers = "auto",                                                            -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
  -- disable the WhichKey popup for certain buf types and file types.
  -- Disabled by default for Telescope
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
  },
})

wk.register({
  ["w"] = { "<cmd>w!<CR>", "Save" },
  q = {
    name = "Quit",
    ["q"] = { "<cmd>x<CR>", "Save and Quit" },
    ["a"] = { "<cmd>xa<CR>", "Save and Quit All Buffers" },
  },
  ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
  ["c"] = { utils.buf_kill, "Close Buffer" },
  ["f"] = {
    function()
      require("plugins.telescope").find_project_files { previewer = false }
    end,
    "Find File",
  },
  ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
  ["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },

  -- " Available Debug Adapters:
  -- "   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
  -- " Adapter configuration and installation instructions:
  -- "   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  -- " Debug Adapter protocol:
  -- "   https://microsoft.github.io/debug-adapter-protocol/
  -- " Debugging
  s = {
    name = "Search",
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    t = { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", "Text" },
    w = { "<cmd>lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<cr>", "Word under cursor" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    l = { "<cmd>Telescope resume<cr>", "Resume last search" },
    p = {
      "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
      "Colorscheme with Preview",
    },
    S = { "<cmd>lua require('spectre').open()<CR>", "Find & Replace" },
  },
  t = {
    name = "Text Manipulation",
    c = { "<cmd>TextCaseOpenTelescope<cr>", "Change Text Case" },
    i = { "viw<cmd>B !sed 's/0x//' | sed 's/../0x& /g' | tr ' ' '\n' | tac | tr '\n' ' ' | xargs printf '%d.%d.%d.%d\n'" , "Hex to IP"}
  },
  g = { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", "Live Grep" },
}, {
  mode = "n",    -- NORMAL mode
  prefix = "<leader>",
  nowait = true, -- use `nowait` when creating keymaps
})

wk.register({
  ["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
  t = { "<cmd>TextCaseOpenTelescope<cr>", "Change Text Case" },
}, {
  mode = "v",    -- VISUAL mode
  prefix = "<leader>",
  nowait = true, -- use `nowait` when creating keymaps
})

function M.register_lsp(buf, overrides)
  overrides = overrides or {}
  local bindings = {
    name = "LSP",
    a = { vim.lsp.buf.code_action, "Code Action" },
    d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
    w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
    f = { vim.lsp.buf.format, "Format" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    j = {
      vim.diagnostic.goto_next,
      "Next Diagnostic",
    },
    k = {
      vim.diagnostic.goto_prev,
      "Prev Diagnostic",
    },
    l = { vim.lsp.codelens.run, "CodeLens Action" },
    q = { vim.diagnostic.setloclist, "Quickfix" },
    r = { vim.lsp.buf.rename, "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
    e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
  }
  for k, v in pairs(overrides) do bindings[k] = v end
  wk.register({
    l = bindings,
  }, {
    mode = "n",    -- NORMAL mode
    prefix = "<leader>",
    nowait = true, -- use `nowait` when creating keymaps
    buffer = buf,
  })
end

function M.register_git(buf)
  local gitsigns = require('gitsigns')
  local bindings = {
    name = "Git",
    s = { gitsigns.stage_hunk, "Stage Hunk" },
    r = { gitsigns.reset_hunk, "Reset Hunk" },
    S = { gitsigns.stage_buffer, "Stage Buffer" },
    R = { gitsigns.reset_buffer, "Reset Buffer" },
    u = { gitsigns.undo_stage_hunk, "Undo Stage Hunk" },
    p = { gitsigns.preview_hunk, "Preview Hunk" },
    b = { function() gitsigns.blame_line{full=true} end, "Blame Line" },
    B = { gitsigns.toggle_current_line_blame, "Toggle Blame Current Line" },
    d = { gitsigns.diffthis, "Diff Against Index" },
    D = { function() gitsigns.diffthis('~') end, "Diff Against Last Commit" },
    c = { "<cmd>TermExec cmd=\"git commit\"<cr>", "Commit"},
  }
  wk.register({
    g = bindings,
  }, {
    mode = "n",
    prefix = "<leader>",
    nowait = true,
    buffer = buf,
  })
  wk.register({
    g = {
      name = "Git",
      s = { function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Stage Hunk" },
      r = { function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Reset Hunk" },
    }
  }, {
    mode = "v",
    prefix = "<leader>",
    nowait = true,
    buffer = buf,
  })
end

return M
