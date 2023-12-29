local hookmem=require'ultimate-autopair.mem.hook'
local hookutils=require'ultimate-autopair.hook.utils'
local M={}
---@param hash ua.hook.hash
function M.del(hash)
    local info=hookutils.get_hash_info(hash)
    assert(info.type=='map')
    local conf=info.conf
    assert(type(conf.mode)=='string')
    vim.keymap.del(conf.mode,info.key)
end
---@param hash ua.hook.hash
---@param conf ua.hook.conf
function M.set(hash,conf)
    if conf=='expr' then
        M.expr_set(hash)
    else
        error()
    end
end
---@param hash ua.hook.hash
function M.expr_set(hash)
    local info=hookutils.get_hash_info(hash)
    assert(info.type=='map')
    local conf=info.conf
    assert(type(conf.mode)=='string')
    local objs=hookmem[hash]
    local desc={}
    for _,obj in ipairs(objs) do
        table.insert(desc,obj.doc)
    end
    vim.keymap.set(conf.mode,info.key,function ()
        local act,subconf=hookutils.get_act(hash,conf.mode)
        return hookutils.act_to_keys(act,conf.mode,subconf)
    end,{noremap=true,expr=true,replace_keycodes=false,desc=table.concat(desc,'\n\t\t ')})
end
return M
