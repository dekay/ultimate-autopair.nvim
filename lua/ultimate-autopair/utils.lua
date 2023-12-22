---@alias ua._.str_buf string.buffer
local M={I={}}
M.I.len=vim.api.nvim_strwidth
---@generic T:string|string?
---@param str T
---@return T
function M.I.keycode(str)
    return str and vim.api.nvim_replace_termcodes(str,true,true,true)
end
M.I.key_bs=M.I.keycode'<bs>'
M.I.key_del=M.I.keycode'<del>'
M.I.key_left=M.I.keycode'<left>'
M.I.key_right=M.I.keycode'<right>'
M.I.key_end=M.I.keycode'<end>'
M.I.key_home=M.I.keycode'<home>'
M.I.key_up=M.I.keycode'<up>'
M.I.key_down=M.I.keycode'<down>'
M.I.key_noundo=M.I.keycode'<C-g>U'
---@param minsize number
---@return ua._.str_buf
function M.new_str_buf(minsize)
    local buf=require'string.buffer'
    return buf.new(minsize)
end
---@param len string|number|nil
---@param noundo boolean?
---@return string
function M.key_left(len,noundo)
    len=type(len)=='string' and M.I.len(len) or len or 1
    return ((noundo and M.I.key_noundo or '')..M.I.key_left):rep(len --[[@as number]])
end
---@param len string|number|nil
---@param noundo boolean?
---@return string
function M.key_right(len,noundo)
    len=type(len)=='string' and M.I.len(len) or len or 1
    return ((noundo and M.I.key_noundo or '')..M.I.key_right):rep(len --[[@as number]])
end
return M
