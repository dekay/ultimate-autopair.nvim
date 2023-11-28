---This is the OBJect MANager
---It manages objects return by profiles
local M={}
---@type table<ua.id,ua.object[]>
M.list={}
---@param id ua.id
---@param conf table
---@return ua.object[]
function M.create_objs(id,conf)
    M.remove(id)
    local ret={conf=conf,id=id}
    M.list[id]=ret
    return ret
end
function M.init()

end
---@param id ua.id
function M.remove(id)
    local obj=assert(M.list[id])
    if obj.conf.init then obj.conf.init() end
    M.list[id]=nil
end
---@param id ua.id
---@return ua.object[]
function M.get(id)
    return assert(M.list[id])
end
return M
