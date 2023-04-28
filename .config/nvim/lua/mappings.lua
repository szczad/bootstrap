local map = vim.keymap.set

-- Shifts
map('n', ">", ">>")
map('n', "<", "<<")

-- Line operations
map('n', '<leader>lw', ':set wrap!<CR>')
map('n', '<leader>lp', ':set paste!<CR>')

