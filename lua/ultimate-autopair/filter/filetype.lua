local M={}
local utils=require'ultimate-autopair.utils'
---@param o ua.filter
---@return boolean?
function M.call(o)
    local conf=o.conf
    local ft=utils.get_filetype(o)
    if conf.ft and not vim.tbl_contains(conf.ft,ft) then
    elseif conf.nft and vim.tbl_contains(conf.nft,ft) then
    else return true end
end
M.conf={
    ft='string[]',
    nft='string[]',
    tree='boolean', --TODO
}
return M
