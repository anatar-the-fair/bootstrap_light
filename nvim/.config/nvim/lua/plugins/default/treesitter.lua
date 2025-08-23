-- https://github.com/nvim-treesitter/nvim-treesitter

-- Filename: ~/.config/nvim/lua/plugins/default/treesitter.lua

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'lua',
        'sql',
        'go',
        'regex',
        'bash',
        'markdown',
        'markdown_inline',
        'yaml',
        'json',
        'jsonc',
        'cpp',
        'csv',
        'java',
        'javascript',
        'python',
        'dockerfile',
        'html',
        'css',
        'templ',
        'php',
        'promql',
        'glsl',
      },
      ignore_install = { 'org' }, -- Prevent Treesitter from attempting org parser
      highlight = {
        enable = true,
        disable = { 'org' }, -- Disable Treesitter highlighting for org files
      },
      indent = {
        enable = true,
        disable = { 'org' }, -- Disable Treesitter indentation for org files
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
