local M={}
local utils=require'ultimate-autopair.ultils'
---@param o ua.filter
function M.call(o)
    return not vim.tbl_contains(o.conf.skip,utils.getcmdtype(o))
end
M.conf={
    skip='string[]',
}
return M
