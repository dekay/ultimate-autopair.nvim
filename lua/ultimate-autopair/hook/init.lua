local hookmem=require'ultimate-autopair.mem.hook'
local maphook=require'ultimate-autopair.hook.map'
local hookutils=require'ultimate-autopair.hook.utils'
local M={}
---@param objects ua.instance
function M.unregister(objects)
    if not objects then return end
    for _,obj in ipairs(objects) do
        for _,v in pairs(obj.hooks) do
            M.unregister_hook(obj,v)
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
            return
        end
    end
    error()
end
---@param objects ua.instance
function M.register(objects)
    for _,obj in ipairs(objects) do
        for _,v in ipairs(obj.hooks) do
            M.register_hook(obj,v)
        end
    end
    M.update()
end
---@param obj ua.object
---@param hash ua.hook.hash
---@param conf ua.hook.conf? --TODO
function M.register_hook(obj,hash,conf)
    if not hookmem[hash] then hookmem[hash]={} end
    local mem=hookmem[hash]
    if vim.tbl_contains(mem,obj) then return end
    mem.dirty=true
    if conf then
        if #mem>0 and conf~=mem.conf then
            error'tried to register hook with different configs'
        end
        mem.conf=conf
    end
    table.insert(mem,obj)
end
function M.update()
    for hash,v in pairs(hookmem) do
        if not v.dirty then goto continue end
        v.dirty=false
        local info=hookutils.get_hash_info(hash)
        if #v==0 then
            hookmem[hash]=nil
            if info.type=='map' then
                maphook.del(hash)
            else
                error()
            end
            goto continue
        end
        hookutils.stable_sort(hookmem[hash])
        if info.type=='map' then
            maphook.set(hash,'expr')
        else
            error()
        end
        ::continue::
    end
end
return M
