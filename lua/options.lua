-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Remap 'jk' to exit insert mode
vim.keymap.set('i', 'jk', '<C-[>', { noremap = true, silent = true })

-- Map 'jk' to exit terminal mode in terminal buffers
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { noremap = true, silent = true })

-- neovide settings
if vim.g.neovide then
  vim.keymap.set('n', '<C-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<C-c>', '"+y') -- Copy
  vim.keymap.set('n', '<C-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<C-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<C-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<C-v>', '<ESC>l"+Pli') -- Paste insert mode

  -- change scale
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set('n', '<C-=>', function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set('n', '<C-->', function()
    change_scale_factor(1 / 1.25)
  end)

  vim.g.neovide_padding_top = 20
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_right = 20
  vim.g.neovide_padding_left = 20

  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_trail_size = 0.4
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_refresh_rate = 144
end

-- Enable line numbers
vim.wo.number = true -- Show absolute line number for the current line
vim.wo.relativenumber = true -- Show relative line numbers for other line

-- No line numbers in terminal
vim.api.nvim_create_augroup('Terminal', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  group = 'Terminal',
  pattern = '*',
  command = 'setlocal nonumber norelativenumber',
})

-- Set the shell to PowerShell
vim.o.shell = 'powershell.exe -NoExit -Command "cd ~"'
-- vim.o.shell = 'echo test'
vim.o.shellxquote = ''

-- Set shell command flag
vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '

-- Set shell quote
vim.o.shellquote = ''

-- Set shell pipe and redirection
vim.o.shellpipe = '| Out-File -Encoding UTF8 %s'
vim.o.shellredir = '| Out-File -Encoding UTF8 %s'

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 14

-- vim: ts=2 sts=2 sw=2 et

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<C-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<C-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-v>', '<C-R>+', { noremap = true, silent = true })

vim.api.nvim_create_autocmd({ 'TermRequest' }, {
  desc = 'Handles OSC 7 dir change requests',
  callback = function(ev)
    if string.sub(vim.v.termrequest, 1, 4) == '\x1b]7;' then
      local dir = string.gsub(vim.v.termrequest, '\x1b]7;file://[^/]*', '')
      if vim.fn.isdirectory(dir) == 0 then
        vim.notify('invalid dir: ' .. dir)
        return
      end
      vim.api.nvim_buf_set_var(ev.buf, 'osc7_dir', dir)
      if vim.o.autochdir and vim.api.nvim_get_current_buf() == ev.buf then
        vim.cmd.cd(dir)
      end
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'DirChanged' }, {
  callback = function(ev)
    if vim.b.osc7_dir and vim.fn.isdirectory(vim.b.osc7_dir) == 1 then
      vim.cmd.cd(vim.b.osc7_dir)
    end
  end,
})
