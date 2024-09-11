local icons = require('icons')

require('gitsigns').setup {
  signs = {
    add = {
      text = icons.ui.BoldLineLeft,
    },
    change = {
      text = icons.ui.BoldLineLeft,
    },
    delete = {
      text = icons.ui.Triangle,
    },
    topdelete = {
      text = icons.ui.Triangle,
    },
    changedelete = {
      text = icons.ui.BoldLineLeft,
    },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  status_formatter = nil, -- Use default
  update_debounce = 200,
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(buf)
    local gitsigns = require('gitsigns')

    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.next_hunk()
      end
    end, { buffer = buf })

    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.prev_hunk()
      end
    end, { buffer = buf })

    vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = buf })

    require('keybinds').register_git(buf)
  end
}
