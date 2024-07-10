local icons = require('icons')
local colors = require('colors')
local colors = require('colors')

local window_width_limit = 100

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.o.columns > window_width_limit
  end,
}

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

-- Status line
require('lualine').setup {
  options = {
    disabled_filetypes = { statusline = { "alpha" } },
    globalstatus = true,
    filetype = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha" },
  },
  sections = {
    lualine_a = {
      { -- mode
        function()
          return " " .. icons.ui.Target .. " "
        end,
        padding = { left = 0, right = 0 },
        color = {},
        cond = nil,
      },
    },
    lualine_b = {
      { -- branch
        "b:gitsigns_head",
        icon = icons.git.Branch,
        color = { gui = "bold" },
      },
    },
    lualine_c = {
      { -- diff
        "diff",
        source = diff_source,
        symbols = {
          added = icons.git.LineAdded .. " ",
          modified = icons.git.LineModified .. " ",
          removed = icons.git.LineRemoved .. " ",
        },
        padding = { left = 2, right = 1 },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.yellow },
          removed = { fg = colors.red },
        },
        cond = nil,
      },
      "lsp_progress"
    },
    lualine_x = {
      { -- diagnostics 
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
          error = icons.diagnostics.BoldError .. " ",
          warn = icons.diagnostics.BoldWarning .. " ",
          info = icons.diagnostics.BoldInformation .. " ",
          hint = icons.diagnostics.BoldHint .. " ",
        },
      },
      { -- LSP
        function()
          local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
          if #buf_clients == 0 then
            return "LSP Inactive"
          end

          local buf_ft = vim.bo.filetype
          local buf_client_names = {}

          -- add client
          for _, client in pairs(buf_clients) do
            table.insert(buf_client_names, client.name)
          end

          local unique_client_names = table.concat(buf_client_names, ", ")
          local language_servers = string.format("[%s]", unique_client_names)

          return language_servers
        end,
        color = { gui = "bold" },
        cond = conditions.hide_in_width,
      },
      { -- spaces
        function()
          local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
          return icons.ui.Tab .. " " .. shiftwidth
        end,
        padding = 1,
      },
      { 
        "filetype",
        cond = nil,
        padding = { left = 1, right = 1 },
      },
    },
    lualine_y = { "location" },
    lualine_z = {
      {
        "progress",
        fmt = function()
          return "%P/%L"
        end,
        color = {},
      }
    },
  }
}
