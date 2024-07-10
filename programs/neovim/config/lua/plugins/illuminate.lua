require('illuminate').configure({
  delay = 120,
  filetypes_denylist = {
    "dirbuf",
    "dirvish",
    "fugitive",
    "alpha",
    "NvimTree",
    "lazy",
    "neogitstatus",
    "Trouble",
    "lir",
    "Outline",
    "spectre_panel",
    "toggleterm",
    "DressingSelect",
    "TelescopePrompt",
  },
})
