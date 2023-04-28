local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup({function(use)
  -- Basic tools
  use { 'wbthomason/packer.nvim' }  -- Packer manages itself
  use { 'lewis6991/impatient.nvim' }  -- Makes neovim faster

  -- UI
  -- use { 'catppuccin/nvim', as = 'catppuccin' }
  use { 'Mofiqul/dracula.nvim' }
  use { 'nvim-lualine/lualine.nvim' }
  use { 'nvim-tree/nvim-web-devicons' }
  use { 'protex/better-digraphs.nvim' }

  -- Utils
  use { 'nvim-tree/nvim-tree.lua' }
  use { 'numToStr/Comment.nvim' }
  use { 'windwp/nvim-autopairs' }
  use { 'rcarriga/nvim-notify' }
  use { 'norcalli/nvim-terminal.lua' }
  -- use { 'tpope/vim-fugitive', config = function() require('plugins/fugitive') end }
  use {
    'TimUntersberger/neogit',
    requires = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    }
  }

  -- Coding - LSP
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end
  }
  use {
    'williamboman/mason.nvim',
    run = function()
      require('mason.api').MasonUpdate()
    end,
    requires = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig'
    }
  }
  use { 'nvim-lua/lsp-status.nvim' }
  use { 'mfussenegger/nvim-jdtls' }
  use { 'mfussenegger/nvim-dap' }
  use { 'nathom/filetype.nvim' }

  -- Telescope
  use { 'nvim-lua/plenary.nvim' }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-github.nvim' },
      { 'nvim-telescope/telescope-packer.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      },
      { 'ANGkeith/telescope-terraform-doc.nvim' },
      { 'olacin/telescope-gitmoji.nvim' },
      { 'xiyaowong/telescope-emoji.nvim' },
    }
  }

  -- Completion framework:
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = {
      'lewis6991/gitsigns.nvim',
    }
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/vim-vsnip',
      'petertriho/cmp-git',
      'ray-x/cmp-treesitter',
    }
  }

  -- Language support
  use { 'hashivim/vim-terraform' }
  use { 'towolf/vim-helm' }
  use {
    'ray-x/go.nvim',
    requires = 'ray-x/guihua.lua' -- recommended if need floating window support
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}})
