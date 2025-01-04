return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    debounce = 100,
    indent = { char = '|' },
    whitespace = { highlight = { 'Whitespace', 'NonText' } },
    scope = { exclude = { language = { '' } } },
    smart_indent_cap = false,
    use_treesitter = true,
    buftype_exclude = { 'terminal', 'nofile', 'quickfix' },
    strict_tabs = true,
  },
}
