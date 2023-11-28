local objmem=require'ultimate-autopair.objmem'
local M={}
---@type table<ua.id,boolean>
M.id_hooked={} ---@TODO: duplicate, maybe remove?
function M.clear(...)
    ---@TODO
end
---@param id ua.id
function M.init(id)
    assert(not M.id_hooked[id])
    M.id_hooked[id]=true
    local objects=objmem[id]
    for _,v in ipairs(objects) do
        ---@TODO
    end
end
return M
