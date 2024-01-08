local M={}
local utils=require'ultimate-autopair.utils'
---@param o ua.filter
---@return boolean?
function M.call(o)
    return not vim.tbl_contains(o.conf.skip,utils.getcmdtype(o))
end
M.conf={
    skip='string[]',
}
return M
