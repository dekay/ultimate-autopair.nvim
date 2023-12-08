local objmem=require'ultimate-autopair.mem.obj'
local M={}
M.hooks={
    require'ultimate-autopair.hook.imap',
}
function M.clear(...)
    ---@TODO
end
---@param id ua.id
function M.init(id)
    local objects=objmem[id]
    for _,obj in ipairs(objects) do
        for _,v in ipairs(obj.get_hook and obj.get_hook() or {}) do
            M.register_hook(obj,v,id)
        end
    end
end
---@param obj ua.object
---@param request ua.hook.request
---@param id ua.id
function M.register_hook(obj,request,id)
    for _,v in ipairs(M.hooks) do
        if v.check(request) then
            return v.init(request,id)
        end

    end
    error(('no hook creator could create hook from hook request `%s`'):format(vim.inspect(request)))
end
---@TODO: instead of initilizing each object, collect all the similar objects and create once
return M
