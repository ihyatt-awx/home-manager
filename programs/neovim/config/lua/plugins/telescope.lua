local M = {}
local icons = require('icons')
local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local lga_actions = require('telescope-live-grep-args.actions')

telescope.setup {
  theme = "dropdown",
  defaults = {
    prompt_prefix = icons.ui.Telescope .. " ",
    selection_caret = icons.ui.Forward .. " ",
    file_ignore_patterns = {
      "BUILD_AREA",
      ".hg",
      ".idea",
      "thirdparty",
      "Android-Reach",
      "iOS-Reach",
      "Battleship-DSP",
      ".cache"
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/",
      "--glob=!.hg/",
      "--glob=!.idea/",
      "--glob=!BUILD_AREA/",
      "--glob=!thirdparty/",
      -- "--glob=!Android-Reach/",
      "--glob=!iOS-Reach/",
      "--glob=!Battleship-DSP/",
      "--glob=!.cache/",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      theme = "dropdown",
    },
    git_files = {
      theme = "dropdown",
      hidden = true,
      show_untracked = true,
    },
    grep_string = {
      theme = "dropdown",
    },
    live_grep = {
      --@usage don't include the filename in the search results
      only_sort_text = true,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          -- freeze the current list and start a fuzzy search in the frozen list
          ["<C-space>"] = actions.to_fuzzy_refine,
        },
      },
      only_sort_text = true,
      -- theme = "dropdown",
    },
  },
}
telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
telescope.load_extension("frecency")

-- Smartly opens either git_files or find_files, depending on whether the working directory is
-- contained in a Git repo.
function M.find_project_files(opts)
  opts = opts or {}
  local ok = pcall(builtin.git_files, opts)

  if not ok then
    builtin.find_files(opts)
  end
end

return M
