local colors = require("dracula").colors();

vim.cmd("colorscheme dracula")

require("hlargs").setup {
    color = colors.orange,
}

require("scrollbar").setup({
    marks = {
        Search = { color = colors.orange },
        Error = { color = colors.red },
        Warn = { color = colors.yellow },
        Info = { color = colors.pink },
        Hint = { color = colors.cyan },
        Misc = { color = colors.purple },
    },
    handlers = {
        cursor = false,
        handle = false,
    },
})

local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
    self.status = ''
    self.applied_separator = ''
    self:apply_highlights(default_highlight)
    self:apply_section_separators()
    return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
    for name, section in pairs(sections) do
        local left = name:sub(9, 10) < 'x'
        for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
            table.insert(section, pos * 2, {
                empty,
                color = {
                    fg = colors.white,
                    bg = colors.white,
                },
            })
        end
        for id, comp in ipairs(section) do
            if type(comp) ~= 'table' then
                comp = { comp }
                section[id] = comp
            end
            comp.separator = left and { right = '' } or { left = '' }
        end
    end
    return sections
end

local function modified()
    if vim.bo.modified then
        return '+'
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
        return '-'
    end
    return ''
end

local transparent = require'lualine.themes.dracula'
transparent.inactive.c.bg = 'nil'
transparent.visual.c.bg = 'nil'
transparent.replace.c.bg = 'nil'
transparent.normal.c.bg = 'nil'
transparent.insert.c.bg = 'nil'
transparent.command.c.bg = 'nil'

require('lualine').setup {
    options = {
        theme = transparent,
        component_separators = '',
        section_separators = { left = '', right = '' },
    },
    sections = process_sections {
        lualine_a = {'mode'},
        lualine_b = {
            'branch',
            'diff',
            { 'filename', file_status = false, path = 1 },
            {
                'diagnostics',
                source = { 'nvim' },
                sections = { 'error' },
                symbols = { error = 'E ' },
                diagnostics_color = {
                    error = {
                        bg = colors.red,
                        fg = colors.black,
                        gui = 'bold',
                    },
                },
                -- on_click = function()
                --     vim.diagnostic.goto_prev()
                -- end
            },
            {
                'diagnostics',
                source = { 'nvim' },
                sections = { 'warn' },
                symbols = { warn = 'W ' },
                diagnostics_color = {
                        warn = {
                            bg = colors.orange,
                            fg = colors.black,
                            gui = 'bold',
                        },
                    },
                -- on_click = function()
                --     vim.diagnostic.goto_next()
                -- end
            },
            { modified, color = { bg = colors.purple } },
            {
                '%w',
                cond = function()
                    return vim.wo.previewwindow
                end,
            },
            {
                '%r',
                cond = function()
                    return vim.bo.readonly
                end,
            },
            {
                '%q',
                cond = function()
                    return vim.bo.buftype == 'quickfix'
                end,
            },
        },
        lualine_c = {},
        lualine_x = { 'fileformat' },
        lualine_y = { 'filetype', 'progress' },
        lualine_z = { 'location' },
    },
}
