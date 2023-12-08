local objmem=require'ultimate-autopair.objmem'
local log=require'ultimate-autopair.log'
local imap=require'ultimate-autopair.hook.imap'
local M={}
---@type table<ua.id,ua.hook[]>
M.id_hooked_info={}
function M.clear(...)
    ---@TODO
end
---@param id ua.id
function M.init(id)
    assert(not M.id_hooked_info[id])
    M.id_hooked_info[id]={}
    local objects=objmem[id]
    for _,obj in ipairs(objects) do
        for _,v in ipairs(obj.get_hook and obj.get_hook() or {}) do
            M.register_hook(v,id)
        end
    end
end
---@param request ua.hook.request
---@param id ua.id
function M.register_hook(request,id)
    if request.type=='au' then
        if request.mode~='i' then
            return log.error('autocmd hook only support insert mode')
        end
        ---@TODO
    elseif request.type=='map' then
        if request.mode=='i' then
            imap.map(request,id)
        elseif request.mode=='c' then
            ---@TODO
        else
            log.error('map hook only support insert or command mode')
        end
    end
end
return M
