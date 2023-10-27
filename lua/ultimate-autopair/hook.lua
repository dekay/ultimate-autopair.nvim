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
---@field key string
---@field mode string
---@field type 'key'
---@field [number] ua.module
---@class ua.hook.hook_au
---@field type 'au'
---@alias ua.hook.info ua.hook.info_au|ua.hook.info_key
---@alias ua.hook.hook ua.hook.hook_map|ua.hook.hook_au
---@alias ua.hook.hash string

local utils=require'ultimate-autopair.utils'
local core=require'ultimate-autopair.core'
local M={}
---@type table<ua.hook.hash,ua.hook.hook>
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
---@param info ua.hook.hook
---@return string
function M.get_hook_desc(info)
    local descs={}
    for _,v in ipairs(info) do
        descs[#descs+1]=v.desc
    end
    return table.concat(descs,'\n\t\t ')
end
---@param hash ua.hook.hash
---@param info ua.hook.hook
function M.create_map_hook(hash,info)
    vim.keymap.set(info.mode,vim.fn.keytrans(info.key),M.hash_run_to_viml(hash),{
        noremap=true,
        desc=M.get_hook_desc(info)
    })
end
---@param mem ua.module[]
function M.init(mem)
    for _,v in pairs(mem) do
        for _,i in pairs(v.get and v.get() or {}) do
            local hash=M.get_default_hash(i)
            M.append_to_hash(hash,v)
        end
    end
    for hash,info in pairs(M.hooks) do
        M.create_map_hook(hash,info)
    end
end
---@param hash ua.hook.hash
---@return string|table
function M.get(hash)
    local hook=M.hooks[hash]
    local o=utils.get_o_creator(hash)
    return core._eval(hook,o,hook.key)
end
---@param hash ua.hook.hash
function M.run(hash)
    local s=M.get(hash)
    if type(s)=='string' then
        vim.api.nvim_input(s)
    end
end
M.global_name='_'..vim.fn.rand()..'_ULTIMATE_AUTOPAIR_HASH'
_G[M.global_name]=M
return M
