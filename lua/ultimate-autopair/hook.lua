---@class ua.hook.info_au
---@field type 'au'
---@field au string
---@class ua.hook.info_key
---@field type 'key'
---@field mode string
---@field key string
---@field [number] ua.module
---@class ua.hook.hook_map
---@field prev_map? table
---@field lhs string
---@field type 'key'
---@field [number] ua.module
---@class ua.hook.hook_au
---@field type 'au'
---@alias ua.hook.info ua.hook.info_au|ua.hook.info_key
---@alias ua.hook.hook ua.hook.hook_map|ua.hook.hook_au
---@alias ua.hook.hash string

local utils=require'ultimate-autopair.utils'
local M={}
---@type ua.hook.hook[]
M.hooks={}
M.I={}
---@param mode string
---@param key string
---@return table?
function M.I.get_map(mode,key)
    local maps=vim.api.nvim_get_keymap(mode)
    for _,keyinfo in ipairs(maps) do
        if vim.fn.keytrans(keyinfo.lhsraw)==key then return keyinfo end
    end
end
---@param id ua.id
function M.clear(id)
    _=id
end
---@param info ua.hook.info
---@return ua.hook.hash
function M.get_hash(info)
    if info.type=='key' then return ('key%s;%s'):format(info.mode,info.key) end
    error()
end
---@param info ua.hook.info
---@return ua.hook.hash
function M.get_default_hash(info)
    local hash=M.get_hash(info)
    if M.hooks[hash] then
    elseif info.type=='key' then
        M.hooks[hash]={prev_map=M.I.get_map(info.mode,info.key),lhs=vim.fn.keytrans(info.key),type='key'}
    else error() end
    return hash
end
---@param hash ua.hook.hash
---@param m ua.module
function M.append_to_hash(hash,m)
    table.insert(M.hooks[hash],m)
end
---@param hash ua.hook.hash
---@return string
function M.hash_run_to_viml(hash)
    return ('v:lua.%s.run("%s")'):format(M.global_name,hash:gsub('[\\"]','\\%1'))
end
---@param hash ua.hook.hash
---@return string
function M.get_hook_desc(hash)
    local descs={}
    for _,v in ipairs(M.hooks[hash]) do
        descs[#descs+1]=v.desc
    end
    return table.concat(descs,'\n\t\t ')
end
---@param info ua.hook.info
---@param m ua.module
function M.create_map_hook(info,m)
    local hash=M.get_default_hash(info)
    M.append_to_hash(hash,m)
    vim.keymap.set(info.mode,vim.fn.keytrans(info.key),M.hash_run_to_viml(hash),{
        noremap=true,
        expr=true,
        replace_keycodes=false,
        desc=M.get_hook_desc(hash)
    })
end
---@param mem ua.module[]
function M.init(mem)
    for _,v in pairs(mem) do
        for _,i in pairs(v.get and v.get() or {}) do
            if i.type=='key' then
                M.create_map_hook(i,v)
            end
        end
    end
end
---@param hash ua.hook.hash
---@return string
function M.run(hash)
    local hook=M.hooks[hash]
    local o=utils.get_o_creator(hash)
    for _,v in ipairs(hook) do
        local ret=v.check(o(v))
        if ret then return ret end
    end
    return hook.lhs
end
M.global_name='_'..vim.fn.rand()..'_ULTIMATE_AUTOPAIR_HASH'
_G[M.global_name]=M
return M
