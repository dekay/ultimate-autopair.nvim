local M={}
---@param o ua.info
---@param somepairs ua.prof.def.pair[]
---@return ua.prof.def.pair[]
function M.backwards_get_start_pairs(o,somepairs)
    local ret={}
    for _,v in ipairs(somepairs) do
        if v.info.start_pair==o.line:sub(o.col-#v.info.start_pair,o.col-1) then
            table.insert(ret,v)
        end
    end
    return ret
end
---@param o ua.info
---@param somepairs ua.prof.def.pair[]
---@return ua.prof.def.pair[]
function M.backwards_get_end_pairs(o,somepairs)
    local ret={}
    for _,v in ipairs(somepairs) do
        if v.info.end_pair==o.line:sub(o.col-#v.info.end_pair,o.col-1) then
            table.insert(ret,v)
        end
    end
    return ret
end
return M
