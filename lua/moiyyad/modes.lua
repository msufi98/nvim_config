local colors = {
    normal    = "#a3be8c",
    insert    = "#9ccfd8",
    visual    = "#f6c177",
    command   = "#eb6f92",
    replace   = "#c4a7e7",
    selection = "#6e5a3a",
    dark      = "#191724",
    text      = "#e0def4",
    bar       = "#1f1d2e",
}

local function set_highlights()
    for name, color in pairs({
        Normal = colors.normal, Insert = colors.insert, Visual = colors.visual,
        Command = colors.command, Replace = colors.replace,
    }) do
        vim.api.nvim_set_hl(0, "Mode" .. name, { bg = color, fg = colors.dark, bold = true })
        vim.api.nvim_set_hl(0, "Mode" .. name .. "Bar", { bg = color, fg = colors.dark })
        vim.api.nvim_set_hl(0, "Cursor" .. name, { bg = color, fg = colors.dark })
    end
    vim.api.nvim_set_hl(0, "Visual", { bg = colors.selection })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bar, fg = colors.text })
end

set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })

vim.opt.guicursor = table.concat({
    "n:block-CursorNormal",
    "o:hor50-CursorNormal",
    "v-ve:block-CursorVisual",
    "i-ci:ver25-CursorInsert",
    "t:ver25-CursorInsert",
    "c:block-CursorCommand",
    "r-cr:hor20-CursorReplace",
}, ",")

local mode_map = {
    n = { "NORMAL", "ModeNormal" },
    i = { "INSERT", "ModeInsert" },
    v = { "VISUAL", "ModeVisual" },
    V = { "V-LINE", "ModeVisual" },
    ["\22"] = { "V-BLOCK", "ModeVisual" },
    c = { "COMMAND", "ModeCommand" },
    R = { "REPLACE", "ModeReplace" },
    t = { "TERMINAL", "ModeInsert" },
}

function MoiStatusline()
    if vim.g.statusline_winid ~= vim.api.nvim_get_current_win() then
        return " %f %m"
    end
    local mode = vim.api.nvim_get_mode().mode
    local entry = mode_map[mode:sub(1, 1)] or mode_map.n
    return "%#" .. entry[2] .. "# " .. entry[1] .. " %#" .. entry[2] .. "Bar# %f %m%r%=%l:%c  %p%% "
end

vim.o.statusline = "%!v:lua.MoiStatusline()"

vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function() vim.cmd.redrawstatus() end,
})
