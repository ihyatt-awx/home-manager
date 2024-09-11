local utils = require('utils')

local M = {}

-- Keybinding helper functions

local function vim_bind(mode, k, v, opts)
  vim.keymap.set(mode, k, v, opts)
end

local function add_group(prefix, name)
  require('which-key').add({{ prefix, group = name }})
end

local function is_bind(array)
	if type(array) ~= "table" then
		return false
	end
	if #array == 1 then
		return type(array[1]) == "string" or type(array[1]) == "function"
	elseif #array == 2 then
		return (type(array[1]) == "string" or type(array[1]) == "function")
				and type(array[2]) == "string"
	else
		return false
	end
end

local function bind_interal(prefix, bt, mode, opts)
	if type(bt) == "string" or type(bt) == "function" then
			vim_bind(mode, prefix, bt, opts)
	elseif is_bind(bt) then
		if #bt == 2 then
			vim_bind(mode, prefix, bt[1], utils.tconcat({desc = bt[2]}, opts))
		else
			vim_bind(mode, prefix, bt[1], opts)
		end
	else
		for k,v in pairs(bt) do
			if k == "name" then
				add_group(prefix, v)
			else
				bind_interal(prefix .. k, v, mode, opts)
			end
		end
	end
end

function M.bind(binds, opts)
	local prefix = ""
	local mode = "n"
	if opts["prefix"] ~= nil then
		prefix = opts["prefix"]
		opts["prefix"] = nil
	end
	if opts["mode"] ~= nil then
		mode = opts["mode"]
		opts["mode"] = nil
	end
	bind_interal(prefix, binds, mode, opts)
end

-- # Keybindings

-- Unmap Shift-Q, I hit it by accident and don't use that feature
vim.api.nvim_set_keymap("n", "Q", "<NOP>", { noremap = true, silent = true })

-- Change buffer
vim.keymap.set({ "n", "i" }, "<C-Left>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set({ "n", "i" }, "<C-h>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set({ "n", "i" }, "<C-Right>", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set({ "n", "i" }, "<C-l>", "<cmd>BufferLineCycleNext<cr>")

vim.keymap.set({ "n", "i" }, "<C-M-h>", "<cmd>wincmd h<cr>")
vim.keymap.set({ "n", "i" }, "<C-M-j>", "<cmd>wincmd j<cr>")
vim.keymap.set({ "n", "i" }, "<C-M-k>", "<cmd>wincmd k<cr>")
vim.keymap.set({ "n", "i" }, "<C-M-l>", "<cmd>wincmd l<cr>")


-- Reorder buffers
vim.keymap.set({ "n", "i" }, "<C-,>", "<cmd>BufferLineMovePrev<cr>")
vim.keymap.set({ "n", "i" }, "<C-.>", "<cmd>BufferLineMoveNext<cr>")

-- Move selected lines up or down in various modes
-- https://vim.fandom.com/wiki/Moving_lines_up_or_down
vim.keymap.set("n", "<M-j>", ":m .+1<cr>==")
vim.keymap.set("n", "<M-k>", ":m .-2<cr>==")
vim.keymap.set("i", "<M-j>", "<esc>:m .+1<cr>==gi")
vim.keymap.set("i", "<M-k>", "<esc>:m .-2<cr>==gi")
vim.keymap.set("v", "<M-j>", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "<M-k>", ":m '<-2<cr>gv=gv")

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- ReplaceWithRegister keybginds
vim.keymap.set("n", "<leader>r", "<Plug>ReplaceWithRegisterOperator")
vim.keymap.set("n", "<leader>rr", "<Plug>ReplaceWithRegisterLine")
vim.keymap.set("x", "<leader>r", "<Plug>ReplaceWithRegisterVisual")


M.bind({
  w = { "<cmd>w!<CR>", "Save" },
  q = {
    name = "Quit",
    ["q"] = { "<cmd>x<CR>", "Save and Quit" },
    ["a"] = { "<cmd>xa<CR>", "Save and Quit All Buffers" },
  },
  ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
  c = { utils.buf_kill, "Close Buffer" },
  f = {
    function()
      require("plugins.telescope").find_project_files { previewer = false }
    end,
    "Find File",
  },
  h = { "<cmd>nohlsearch<CR>", "No Highlight" },
  e = { "<cmd>NvimTreeToggle<CR>", "Explorer" },

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
  G = { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", "Live Grep" },
}, {
  prefix = "<leader>",
  nowait = true,
})

M.bind({
  ["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
  t = { "<cmd>TextCaseOpenTelescope<cr>", "Change Text Case" },
}, {
  mode = "v",    -- VISUAL mode
  prefix = "<leader>",
  nowait = true,
})

-- # Conditional bind functions

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
  M.bind({
    l = bindings,
  }, {
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
    b = { function() gitsigns.blame_line { full = true } end, "Blame Line" },
    B = { gitsigns.toggle_current_line_blame, "Toggle Blame Current Line" },
    d = { gitsigns.diffthis, "Diff Against Index" },
    D = { function() gitsigns.diffthis('~') end, "Diff Against Last Commit" },
    c = { "<cmd>TermExec cmd=\"git commit\"<cr>", "Commit" },
  }
  M.bind({
    g = bindings,
  }, {
    prefix = "<leader>",
    nowait = true,
    buffer = buf,
  })
  M.bind({
    g = {
      name = "Git",
      s = { function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, "Stage Hunk" },
      r = { function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, "Reset Hunk" },
    }
  }, {
    mode = "v",
    prefix = "<leader>",
    nowait = true,
    buffer = buf,
  })
end

return M
