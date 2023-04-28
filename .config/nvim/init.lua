local g = vim.g
local cmd = vim.cmd
local map = vim.keymap.set

g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0
g.loaded_netrw = 0
g.loaded_netrwPlugin = 0

g.mapleader = '.'
g.maplocalleader = '.'

-- pcall as a workaround if using `impatient` for the first time
pcall(require, 'impatient')

require('mappings')
require('plugins')
require('options')
require('utils')

local packer = require('packer')
map('n', '<leader>ps', packer.sync, {})
map('n', '<leader>pc', packer.compile, {})

-- -- Colorscheme
-- require('catppuccin').setup({
--   flavour = 'macchiato',
--   dim_inactive = {
--     enabled = true,
--     persentage = 0.50
--   }
-- })
cmd.colorscheme 'dracula'


-- Better Digraphs
map('i', '<C-k><C-d>', '<Cmd>lua require("better-digraphs").digraphs("insert")<CR>', {})

-- Vim Notify - patch notification framework
vim.notify = require("notify")

-- Comment
require('Comment').setup()

-- Auto pairs
require('nvim-autopairs').setup()

-- Git integration
local neogit = require('neogit')
neogit.setup({
  -- kind = 'popup',
  disable_builtin_notifications = true,
  integrations = {
    diffview = true
  },
  sections = {

  }
})
map('n', '<F3>', neogit.open, {})
require('gitsigns').setup()

-- Lualine
require('lualine').setup({
  options = {
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = { 'statusline', 'tabline', 'winbar', 'NvimTree' },
  }
})

-- NvimTree
local function nvim_tree_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, remap = true, silent = true, nowait = true }
  end


  -- Default mappings. Feel free to modify or remove as you wish.
  --
  -- BEGIN_DEFAULT_ON_ATTACH
  map('n', 't',     api.node.open.tab,                     opts('Open: New Tab'))
  map('n', 'v',     api.node.open.vertical,                opts('Open: Vertical Split'))
  map('n', 's',     api.node.open.horizontal,              opts('Open: Horizontal Split'))

  map('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  map('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
  map('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  map('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
  map('n', '<CR>',  api.node.open.edit,                    opts('Open'))
  map('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  map('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  map('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  map('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  map('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
  map('n', '+',     api.tree.change_root_to_node,          opts('CD'))
  map('n', 'a',     api.fs.create,                         opts('Create'))
  map('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  map('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  map('n', 'c',     api.fs.copy.node,                      opts('Copy'))
  map('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
  -- map('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
  -- map('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
  map('n', 'd',     api.fs.remove,                         opts('Delete'))
  map('n', 'D',     api.fs.trash,                          opts('Trash'))
  map('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
  -- map('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
  -- map('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  -- map('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
  map('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  map('n', 'f',     api.live_filter.start,                 opts('Filter'))
  map('n', 'g?' ,   api.tree.toggle_help,                  opts('Help'))
  map('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  map('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  -- map('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  -- map('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
  map('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  -- map('n', 'o',     api.node.open.edit,                    opts('Open'))
  -- map('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  map('n', 'p',     api.fs.paste,                          opts('Paste'))
  map('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
  map('n', 'q',     api.tree.close,                        opts('Close'))
  map('n', 'r',     api.fs.rename,                         opts('Rename'))
  map('n', 'R',     api.tree.reload,                       opts('Refresh'))
  -- map('n', 's',     api.node.run.system,                   opts('Run System'))
  map('n', 'S',     api.tree.search_node,                  opts('Search'))
  map('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  map('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
  map('n', 'x',     api.fs.cut,                            opts('Cut'))
  map('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
  map('n', 'Y',     api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  -- map('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  map('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  map('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- END_DEFAULT_ON_ATTACH
end

require('nvim-tree').setup({
  on_attach = nvim_tree_on_attach,
  view = {
    width = 40,
    float = {
      enable = false
    },
  },
  renderer = {
    indent_markers = {
      enable = true
    }
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      }
    }
  }
})
local tree = require('nvim-tree.api').tree
map('n', '<C-n>', function() tree.focus() end, {})
map('n', '<C-n><C-n>', function() tree.toggle() end, {})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    tree.toggle({
      focus = true,
    })
  end
})

-- If you want insert `(` after select function or method item
require('nvim-autopairs').setup({
  fast_wrap = {}
})

-- File types
require('filetype').setup {
  overrides = {
    extensions = {
      tf = 'terraform',
      tfvars = 'terraform',
      tfstate = 'json',
    },
  },
}

-- Null LS
local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    -- code actions
    null_ls.builtins.code_actions.gomodifytags,
    null_ls.builtins.code_actions.gitsigns,
    -- formatters
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.google_java_format,
    null_ls.builtins.formatting.hclfmt,
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.lua_format,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.formatting.trim_newlines,
    null_ls.builtins.formatting.trim_whitespace,
    null_ls.builtins.formatting.yq,
    -- diagnostics
    null_ls.builtins.diagnostics.buf,
    null_ls.builtins.diagnostics.buildifier,
    null_ls.builtins.diagnostics.checkmake,
    null_ls.builtins.diagnostics.commitlint,
    null_ls.builtins.diagnostics.eslint,
    -- completion
    -- null_ls.builtins.completion.luasnip,
    -- null_ls.builtins.completion.spell,
    -- Hovers
    null_ls.builtins.hover.dictionary,
    null_ls.builtins.hover.printenv,
  },
})

-- Telescope
local telescope = require('telescope')
local builtin = require('telescope.builtin')
telescope.setup({
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown({})
    }
  }
})
telescope.load_extension('ui-select')
telescope.load_extension('gh')
telescope.load_extension('fzf')
telescope.load_extension('emoji')
telescope.load_extension('terraform_doc')
telescope.load_extension('gitmoji')
telescope.load_extension('packer')

map('n', '<leader>ff', builtin.find_files, {})
map('n', '<leader>fg', builtin.live_grep, {})
map('n', '<leader>fb', builtin.buffers, {})
map('n', '<leader>fh', builtin.help_tags, {})
map('n', '<F12>', ':Telescope notify<CR>')

-- Tree-sitter
require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  highlight = {
    enable = true
  },
  indent = {
    enable = false
  }
})
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = {"src/parser.c"}
  },
  filetype = "gotmpl",
  used_by = {"gohtmltmpl", "gotexttmpl", "gotmpl", "yaml"}
}


-- LSP servers
require('mason').setup({
  ui = {
    icons = {
      package_installed = '',
      package_pending = '',
      package_uninstalled = '',
    },
  }
})
require('mason-lspconfig').setup({
  automatic_installation = true,
  ensure_installed = {
    'lua_ls',
    'bashls',
    'dockerls',
    'gopls',
    'gradle_ls',
    'jsonnet_ls',
    'marksman',
    'rust_analyzer',
    'taplo',
    'terraformls',
    'tflint',
    'yamlls',
  }
})
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp = require('lspconfig')
lsp.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
          globals = { 'vim' }
      }
    }
  }
}
lsp.bashls.setup {}
lsp.dockerls.setup {}
lsp.gopls.setup {}
lsp.gradle_ls.setup {}
lsp.jsonnet_ls.setup {}
lsp.marksman.setup {}
lsp.rust_analyzer.setup {}
lsp.taplo.setup {}
lsp.terraformls.setup {}
lsp.tflint.setup {}
lsp.yamlls.setup {}
require('go').setup({
  format = 'gopls',
  lsp_cfg = {
    capabilities = capabilities
  }
})
-- require('plugins.lsp-java')

-- CMP
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local handlers = require('nvim-autopairs.completion.handlers')

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done({
    filetypes = {
      -- "*" is a alias to all filetypes
      ["*"] = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method,
          },
          handler = handlers["*"]
        }
      },
    }
  })
)
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 2 },      -- from language server
    { name = 'nvim_lsp_signature_help' },           -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2 },      -- complete neovim's Lua runtime API such vim.lsp.*
    -- { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc' },                              -- source for math calculationa
    { name = 'git' },                               -- git commits
    { name = 'treesitter' }                         -- treesitter integration
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- Terraform
vim.g.terraform_fmt_on_save = 1


-- vim.cmd([[
-- augroup jdtls_lsp
--     autocmd!
--     autocmd FileType java lua require'jdtls.setup'.setup()
-- augroup end
-- ]])
