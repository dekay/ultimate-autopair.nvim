local utils=require'ultimate-autopair.utils'
local M={}
---@param o ua.filter
function M.in_lisp(o)
    local ft=utils.get_filetype(o)
    return utils.ft_get_option(ft,'lisp')
end
---@param o ua.filter
function M.in_string(o)
    return false --TODO
end
---@param o ua.filter
function M.in_comment(o)
    return false --TODO
end
return M
