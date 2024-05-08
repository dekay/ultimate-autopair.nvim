local hookmem=require'ultimate-autopair.hook.mem'
local hookutils=require'ultimate-autopair.hook.utils'
local utils=require'ultimate-autopair.utils'
local M={}
---@param hash ua.hook.hash
function M.del(hash)
    local info=hookutils.get_hash_info(hash)
    assert(info.type=='map')
    local conf=info.conf
    assert(type(conf)=='string')
    if _G.UA_DEV then
        assert(vim.fn.mapcheck(info.key,conf)~='')
    end
    vim.keymap.del(conf,info.key)
end
---@param hash ua.hook.hash
function M.set(hash)
    local info=hookutils.get_hash_info(hash)
    assert(info.type=='map')
    local conf=info.conf
    assert(type(conf)=='string')
    if _G.UA_DEV then
        assert(vim.fn.mapcheck(info.key,conf)=='')
        assert(utils.key_normalize(info.key)==info.key)
    end
    local objs=hookmem[hash]
    local desc={}
    for _,obj in ipairs(objs) do
        table.insert(desc,obj.doc)
    end
    if info.key:find'\0' then
        error('Null byte found in pair, exiting before a crash can happen')
    end
    vim.keymap.set(conf,info.key,function ()
        local act,subconf=hookutils.get_act(hash,conf)
        return hookutils.act_to_keys(act,conf,subconf)
    end,{noremap=true,expr=true,replace_keycodes=false,desc=table.concat(desc,'\n\t\t ')})
end
return M
