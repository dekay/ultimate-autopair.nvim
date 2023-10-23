local M={}
---@param id ua.id
---@param mem ua.module[]
---@param conf ua.prof.conf
function M.init(conf,mem,id)
    for _,v in ipairs(conf) do
        v.id=id
        table.insert(mem,v)
    end
end
return M
