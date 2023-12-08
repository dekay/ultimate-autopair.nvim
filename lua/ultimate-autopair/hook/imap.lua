local M={}
---@param request ua.hook.request
---@param id ua.id
---@return fun():string
function M.wrapp_run(request,id) --TODO: move somewhere else, also wrong: only activate the objects which have requestedt the hooke
    return function()
        local objmem=require'ultimate-autopair.objmem'
        for _,i in ipairs(objmem[id]) do
            local ret=i.run({request=request,m=setmetatable({},{__index=i})})
            if ret then return ret end
        end
        return request.input
    end
end
---@param request ua.hook.request
---@param id ua.id
function M.init(request,id)
    vim.keymap.set('i',request.input,M.wrapp_run(request,id),{noremap=true,expr=true,replace_keycodes=false})
end

---@param request ua.hook.request
function M.check(request)
    return request.mode=='i' and request.type=='map'
end
return M
