local M={}
local utils=require'ultimate-autopair.ultils'
---@param o ua.filter
---@return boolean?
function M.call(o)
    return not vim.tbl_contains(o.conf.skip,utils.getcmdtype(o))
end
M.conf={
    skip='string[]',
}
return M
