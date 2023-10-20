local M={}
M.conf={
    profile='map',p=10,
    {'i','(','()'..vim.keycode'<Left>'},
    {'i',')',function ()
        return vim.api.nvim_get_current_line():sub(vim.fn.col'.',vim.fn.col'.')==')' and vim.keycode'<Right>'
    end},
}
return M
