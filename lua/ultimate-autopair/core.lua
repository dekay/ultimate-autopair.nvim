local M={}
M.I={}
local MAP_MODES={'n','x','s','o','i','c','t'} --'l'
---@alias map_modes 'n'|'x'|'s'|'o'|'i'|'c'|'t'
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
M.hooks={}
---@param hash string
function M.run(hash)
    if not M.hooks[hash] then error('invalid hash') end
    for _,act in ipairs(M.hooks[hash]) do
        act.cb(M.hooks[hash])
    end
end
---@param id any
function M.clear_id(id)
    for _,v in pairs{unpack(M.hooks)} do
        for k,i in ipairs{unpack(v)} do
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
---@param action table
---@param key string
---@param mode map_modes
---@param opt? table
function M.create_map_hook(mode,key,action,opt)
    key=vim.fn.keytrans(key)
    local hash=M.get_key_hash(mode,key)
    if M.hooks[hash] then
        table.insert(M.hooks[hash],action)
        return
    end
    M.hooks[hash]={action,prev_map=M.I.get_map(mode,key),type='key',default=key}
    vim.keymap.set(mode,key,M.wrapp_run_as_vimscript(hash),opt)
end
M.global_name='_'..vim.fn.rand()..'_ULTIMATE_AUTOPAIR_CORE'
_G[M.global_name]=M
return M
