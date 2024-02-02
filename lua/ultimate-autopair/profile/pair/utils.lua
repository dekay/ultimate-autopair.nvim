local M={}
---@param o ua.info
---@param somepairs ua.prof.def.pair[]
function M.backwards_get_start_pair(o,somepairs)
    for _,v in ipairs(somepairs) do
        if v.info.start_pair==o.line:sub(o.col-#v.info.start_pair+1,o.col-1) then
            return v
        end
    end
end
---@param o ua.info
---@param somepairs ua.prof.def.pair[]
function M.backwards_get_end_pair(o,somepairs)
    for _,v in ipairs(somepairs) do
        if v.info.end_pair==o.line:sub(o.col-#v.info.end_pair+1,o.col-1) then
            return v
        end
    end
end
return M
