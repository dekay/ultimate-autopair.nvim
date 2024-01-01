local M={}
local utils=require'ultimate-autopair.ultils'
---@param o ua.filter
function M.call(o)
    local conf=o.conf
    local ft=utils.get_filetype(o,not conf.tree)
    if conf.ft and not vim.tbl_contains(conf.ft,ft) then
    elseif conf.nft and vim.tbl_contains(conf.nft,ft) then
    else return true end
end
M.conf={
    ft='string[]',
    nft='string[]',
    tree='boolean',
}
return M
