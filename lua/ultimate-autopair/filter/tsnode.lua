local query=require'ultimate-autopair._lib.query'
local M={}
---@param o ua.filter
---@return boolean?
function M.call(o)
    local range={o.rows-1,o.cols-1,o.rowe-1,o.cole-1}
    local parser=o.source.get_parser()
    if not parser then return true end
    local nodes=query.find_all_node_types(parser,{})
    for _,node in ipairs(nodes) do
        local trange={node:range()}
        if (trange[1]<range[1] or (trange[1]==range[1] and trange[2]<range[2])) and
            (trange[3]>range[3] or (trange[3]==range[3] and trange[4]>range[4])) then
            return false
        end
    end
    return true
end
return M
