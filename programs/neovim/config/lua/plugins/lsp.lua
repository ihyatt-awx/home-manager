local lspconfig = require('lspconfig')
local navic = require("nvim-navic")
local keybinds = require('keybinds')
local utils = require('utils')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local server = { "pyright", "ts_ls", "bashls", "lua_ls", "nil_ls",
  "html", "jsonls", "yamlls", "ltex", "clangd", "sqls", "cssls",
  "docker_compose_language_service", "dockerls"}

local excluded_fts = { "rust", "haskell" }

local settings = {
  rust_analyzer = {
    ['rust-analyzer'] = {
      imports = {
        granularity = {
          group = "module",
        }
      }
    }
  },
  lua_ls = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  },
  jsonls = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    }
  },
  yamlls = {
    yaml = {
      hover = true,
      completion = true,
      validate = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = require("schemastore").yaml.schemas(),
    }
  },
  ltex = {
    ltex = {
      language = "en-US",
      enabled = { "bibtex", "gitcommit", "markdown", "org", "tex", "restructuredtext", "rsweave", "latex", "quarto", "rmd", "context", "text" },
    }
  },
  sqls = {
    sqls = {
      connections = {
        {
          driver = 'postgresql',
          dataSourceName = 'host=127.0.0.1 port=5432 user=fms password=1234567 dbname=fms sslmode=disable'
        }
      }
    }
  },
}
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

for _, lsp in ipairs(server) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    settings = settings[lsp] or {},
    on_attach = on_attach,
  }
end

local function lsp_keybinds(buf, overrides, leader_l_overrides)
  overrides = overrides or {}
  leader_l_overrides = leader_l_overrides or {}
  local bindings = { -- defaults
    ["[d"] = vim.diagnostic.goto_prev,
    ["]d"] = vim.diagnostic.get_next,
    K = vim.lsp.buf.hover,
    gD = vim.lsp.buf.definition,
    gd = vim.lsp.buf.definition,
    gi = vim.lsp.buf.implementation,
    gr = vim.lsp.buf.references,
    ["<C-k>"] = vim.lsp.buf.signature_help,
  }
  utils.tconcat(bindings, overrides)
  keybinds.bind(bindings, { buffer = buf })
  keybinds.register_lsp(buf, leader_l_overrides)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    if vim.tbl_contains(excluded_fts, vim.bo.filetype) then
      return
    end
    lsp_keybinds(ev.buf)
  end,
})

-- Special Rust stuff

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
    -- executor = "toggleterm",
  },
  -- LSP configuration
  server = {
    on_attach = function(_, buf)
      local addtional_binds = {
        gp = "<cmd>RustLsp parentModule<cr>",
      }
      local additonal_leader_l_binds = {
        a = { "<cmd>RustLsp codeAction<cr>", "Code Action" },
        R = { "<cmd>RustLsp runnables<cr>", "Runnables" },
        T = { "<cmd>RustLsp testables<cr>", "Testables" },
        E = { "<cmd>RustLsp expandMacro<cr>", "Expand Macro" },
        D = { "<cmd>RustLsp renderDiagnostic<cr>", "Render Diagnostics" },
        K = { "<cmd>RustLsp openDocs<cr>", "Open docs.rs docs for item" },
        C = { "<cmd>RustLsp openCargo<cr>", "Open Cargo.toml" },
        L = { "<cmd>RustLsp explainError<cr>", "Explain Error" },
        H = { "<cmd>RustLsp hover actions<cr>", "Hover Actions" },
      }
      lsp_keybinds(buf, addtional_binds, additonal_leader_l_binds)
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
        imports = {
          granularity = {
            group = "module",
          }
        }
      },
    },
  },
  -- DAP configuration
  -- dap = {
  -- },
}

vim.g.haskell_tools = {
  hls = {
    on_attach = function (_, buf, ht)
      local addtional_binds = {
      }
      local additonal_leader_l_binds = {
        h = { ht.hoogle.hoogle_signature, "Hoogle Signature" }
      }
      lsp_keybinds(buf, addtional_binds, additonal_leader_l_binds)
    end
  }
}
