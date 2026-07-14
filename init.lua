-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Size of an indent (for commands like << and >>)
vim.opt.shiftwidth = 2

-- Number of spaces that a <Tab> counts for while editing
vim.opt.softtabstop = 2

-- Number of spaces that a <Tab> in the file counts for
vim.opt.tabstop = 2

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  "https://github.com/paretje/nvim-man"
})

-- configuration
require("nvim-treesitter-textobjects").setup {
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      -- ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- If you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. Succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  },
}

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.g.mapleader = " "
vim.keymap.set({ "x", "o" }, "am", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "im", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
end)

vim.keymap.set("n", "<leader>ft", require("telescope.builtin").treesitter, { desc = "Search Functions (File)" })

-- 1. Find files by name
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find Files by Name" })

-- 2. Find text inside files (Live Grep)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Find Text (Live Grep)" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
  desc = "Set clang-format as the default formatter for C-family languages",
  callback = function(ev)
    -- Tell clang-format to read from stdin and assume the current file's extension 
    -- so it picks up the correct formatting rules from your .clang-format file
    vim.bo[ev.buf].formatprg = "clang-format --assume-filename=" .. vim.api.nvim_buf_get_name(ev.buf)
  end,
})

vim.lsp.enable('zls');
