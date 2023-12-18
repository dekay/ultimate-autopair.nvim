local objmem=require'ultimate-autopair.mem.obj'
local hookmem=require'ultimate-autopair.mem.hook'
local M={}
---@param id ua.id
function M.clear(id)
    local objects=objmem[id]
    if not objects then return end
    for _,obj in ipairs(objects) do
        for k,v in pairs(obj.hooks) do
            M.unregister_hook(obj,v)
            obj[k]=nil
        end
    end
    M.update()
end
---@param obj ua.object
---@param hash ua.hook.hash
function M.unregister_hook(obj,hash)
    if not hookmem[hash] then return end
    local mem=hookmem[hash]
    for k,v in ipairs(mem) do
        if v==obj then
            table.remove(mem,k)
            mem.dirty=true
            break
        end
    end
end
---@param id ua.id
function M.init(id)
    local objects=objmem[id]
    for _,obj in ipairs(objects) do
        for _,v in ipairs(obj.hooks) do
            M.register_hook(obj,v)
        end
    end
    M.update()
end
---@param obj ua.object
---@param hash ua.hook.hash
function M.register_hook(obj,hash)
    if not hookmem[hash] then hookmem[hash]={} end
    local mem=hookmem[hash]
    if vim.tbl_contains(mem,obj) then return end
    mem.dirty=true
    table.insert(mem,obj)
    --table.insert(obj.hooks,hash)
end
function M.update()
    for k,v in pairs(hookmem) do
        if not v.dirty then goto continue end
        v.dirty=false
        if #v==0 then
            hookmem[k]=nil
            goto continue
        end
        local mode,type,key=k:match('^(.-);(.-);(.*)$')
        if type=='map' then
            vim.keymap.set(mode,key,function ()
                for _,obj in ipairs(v) do
                    local o={
                        m=obj,
                        line=vim.api.nvim_get_current_line(),
                        col=vim.fn.col'.',
                    }
                    local ret=obj.run(o)
                    if ret then return ret end
                end
                return key
            end,{noremap=true,expr=true,replace_keycodes=false})
        end
        ::continue::
    end
end
return M
