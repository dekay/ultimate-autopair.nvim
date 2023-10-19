---@class ua.hook
---@field prev_map table?
---@field cb fun():any
---@field [number] ua.hook.action
---@class ua.hook.action
---@field cb fun(info:ua.hook)
---@field doc? string
---@alias map_modes 'n'|'x'|'s'|'o'|'i'|'c'|'t'

local M={}
M.I={}
local MAP_MODES={'n','x','s','o','i','c','t'} --'l'
---@type table<string,ua.hook>
M.hooks={}
---@param mode string
---@param key string
---@return table?
function M.I.get_map(mode,key)
    local maps=vim.api.nvim_get_keymap(mode)
    for _,keyinfo in ipairs(maps) do
        if vim.fn.keytrans(keyinfo.lhsraw)==key then return keyinfo end
    end
end
---@param hash string
---@return string
function M.wrapp_run_as_vimscript(hash)
    return ('v:lua.%s.run("%s")'):format(M.global_name,hash:gsub('[\\"]','\\%1'))
end
---@param mode string
---@param key string
---@return string
function M.get_key_hash(mode,key)
    return mode..';'..key
end
---@param hash string
function M.run(hash)
    local info=M.hooks[hash]
    if not info then error('invalid hash') end
    for _,act in ipairs(info) do
        local ret=act.cb(info)
        if ret then return ret end
    end
    return info.cb()
end
---@param id ua.id
function M.clear(id)
    for _,v in pairs{unpack(M.hooks)} do
        for k,i in ipairs(v) do
            if i.id==id then
                table.remove(v,k)
            end
        end
    end
    M.gc_keymaps()
end
function M.gc_keymaps()
    for _,mode in ipairs(MAP_MODES) do
        local maps=vim.api.nvim_get_keymap(mode)
        for _,key in ipairs(maps) do
            if not key.rhs then goto continue end
            local hash=key.rhs:match('^v:lua.'..M.global_name..'.run.%("(.*)"%)$')
            if not hash then goto continue end
            hash=hash:gsub('\\([\\"])','%1')
            if #M.hooks[hash]>0 then goto continue end
            local info=M.hooks[hash]
            vim.keymap.del(mode,key.lhs)
            if info.prev_map then vim.fn.mapset(mode,false,info.prev_map) end
            ::continue::
        end
    end
end
---@param info ua.hook
---@return string
function M.get_hook_desc(info)
    local descs={}
    for _,v in ipairs(info) do
        descs[#descs+1]=v.doc
    end
    return table.concat(descs,'\n\t\t ')
end
---@param action ua.hook.action
---@param key string
---@param mode map_modes
function M.create_map_hook(mode,key,action)
    key=vim.fn.keytrans(key)
    local hash=M.get_key_hash(mode,key)
    local info=M.hooks[hash]
    if not info then
        M.hooks[hash]={prev_map=M.I.get_map(mode,key),type='key',cb=function () return key end}
        info=M.hooks[hash]
    end
    table.insert(info,action)
    vim.keymap.set(mode,key,M.wrapp_run_as_vimscript(hash),{
        noremap=true,
        expr=true,
        replace_keycodes=false,
        desc=M.get_hook_desc(info)
    })
end
---@param mem ua.mem
function M.init(mem)
    for _,v in pairs(mem) do
        local mode,key=unpack(v.get())
        M.create_map_hook(mode,key,v)
    end
end
M.global_name='_'..vim.fn.rand()..'_ULTIMATE_AUTOPAIR_CORE'
_G[M.global_name]=M
return M
