-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Configure JetBrains Mono font
vim.opt.guifont = "JetBrainsMono Nerd Font:h12"

-- Preserve terminal background transparency
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Disable background color override to preserve terminal transparency
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNrAbove", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNrBelow", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "Folded", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" })
  end,
})

-- Apply transparency immediately
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNrAbove", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNrBelow", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "Folded", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" })
  end,
})
