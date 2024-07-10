local icons = require('icons')
local utils = require('utils')

local function is_ft(b, ft)
  return vim.bo[b].filetype == ft
end

local function diagnostics_indicator(_, _, diagnostics, _)
  local result = {}
  local symbols = {
    error = icons.diagnostics.Error,
    warning = icons.diagnostics.Warning,
    info = icons.diagnostics.Information,
  }
  for name, count in pairs(diagnostics) do
    if symbols[name] and count > 0 then
      table.insert(result, symbols[name] .. " " .. count)
    end
  end
  result = table.concat(result, " ")
  return #result > 0 and result or ""
end

local function custom_filter(buf, buf_nums)
  local logs = vim.tbl_filter(function(b)
    return is_ft(b, "log")
  end, buf_nums or {})
  if vim.tbl_isempty(logs) then
    return true
  end
  local tab_num = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr "$"
  local is_log = is_ft(buf, "log")
  if last_tab == 1 then
    return true
  end
  -- only show log buffers in secondary tabs
  return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

require("bufferline").setup {
  options = {
    close_command = function(bufnr) -- can be a string | function, see "Mouse actions"
      utils.buf_kill("bd", bufnr, false)
    end,
    indicator = {
      icon = icons.ui.BoldLineLeft, -- this should be omitted if indicator style is not 'icon'
      style = "icon",               -- can also be 'underline'|'none',
    },
    buffer_close_icon = icons.ui.Close,
    modified_icon = icons.ui.Circle,
    close_icon = icons.ui.BoldClose,
    left_trunc_marker = icons.ui.ArrowCircleLeft,
    right_trunc_marker = icons.ui.ArrowCircleRight,
    -- name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
    --   -- remove extension from markdown files for example
    --   if buf.name:match "%.md" then
    --     return vim.fn.fnamemodify(buf.name, ":t:r")
    --   end
    -- end,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = diagnostics_indicator,
    custom_filter = custom_filter,
    offsets = {
      {
        filetype = "undotree",
        text = "Undotree",
        highlight = "PanelHeading",
        padding = 1,
      },
      {
        filetype = "NvimTree",
        text = "Explorer",
        highlight = "PanelHeading",
        padding = 1,
      },
      {
        filetype = "DiffviewFiles",
        text = "Diff View",
        highlight = "PanelHeading",
        padding = 1,
      },
      {
        filetype = "flutterToolsOutline",
        text = "Flutter Outline",
        highlight = "PanelHeading",
      },
    },
    always_show_bufferline = false,
    hover = {
      enabled = false,   -- requires nvim 0.8+
      delay = 200,
      reveal = { "close" },
    },
  }
}
