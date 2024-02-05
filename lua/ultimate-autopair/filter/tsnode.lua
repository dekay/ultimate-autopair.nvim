local query=require'ultimate-autopair._lib.query'
local M={}
---@param o ua.filter
---@return boolean?
function M.call(o)
    local parser=o.source.get_parser()
    if not parser then return true end
    ----TODO: May error if note_types is not a valid node type in lang
    --local nodes=query.find_all_node_types(parser,{'string'})
    return true
end
return M
