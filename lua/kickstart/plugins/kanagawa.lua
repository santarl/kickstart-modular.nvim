return {
  { 
    'rebelot/kanagawa.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Set the background option to light
      vim.o.background = "light"

      -- Default options:
      require('kanagawa').setup({
          compile = false,             -- enable compiling the colorscheme
          undercurl = true,            -- enable undercurls
          commentStyle = { italic = true },
          functionStyle = {},
          keywordStyle = { italic = true },
          statementStyle = { bold = true },
          typeStyle = {},
          transparent = false,         -- do not set background color
          dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
          terminalColors = true,       -- define vim.g.terminal_color_{0,17}
          colors = {                   -- add/modify theme and palette colors
              palette = {},
              theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
          },
          overrides = function(colors) -- add/modify highlights
              return {}
          end,
          theme = "lotus",             -- Load "lotus" theme for light background
          background = {               -- map the value of 'background' option to a theme
              dark = "wave",           -- try "dragon" !
              light = "lotus"          -- Set light theme to "lotus"
          },
      })

      -- Load the colorscheme here.
      vim.cmd("colorscheme kanagawa")

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
