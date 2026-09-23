require("moiyyad.set")
require("moiyyad.remap")
require("moiyyad.lazy_init")
require("moiyyad.modes")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.hl.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = augroup('MoiyyadTrimWhitespace', {}),
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.opt.isfname:append("@-@")
