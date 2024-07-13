-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
--
-- Set the default tab width to  4 spaces for everything except HTML
vim.cmd [[
  autocmd FileType * setlocal shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType python,go,rust setlocal shiftwidth=4 softtabstop=4 expandtab
]]

