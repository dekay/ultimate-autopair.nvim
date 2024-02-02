local M={}
---@param o ua.info
function M.backwards_get_start_pair(o)
    local info=(o.m --[[@as ua.prof.def.bs]]).info
    for _,v in ipairs(info.pairs) do
        if v.info.start_pair==o.line:sub(o.col-#v.info.start_pair+1,o.col-1) then
            return v
        end
    end
end
return M
