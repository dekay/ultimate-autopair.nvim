local query=require'ultimate-autopair._lib.query'
local M={}
---@param o ua.filter
---@return boolean?
function M.call(o)
    local parser=o.source.get_parser()
    if not parser then return true end
    local nodes=query.find_all_node_types(parser,{'string'})
    _=nodes
    return true
end
return M
