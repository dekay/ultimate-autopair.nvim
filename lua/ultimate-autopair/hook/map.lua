local hookmem=require'ultimate-autopair.mem.hook'
local hookutils=require'ultimate-autopair.hook.utils'
local M={}
---@param hash ua.hook.hash
function M.del(hash)
    local info=hookutils.get_hash_info(hash)
    assert(info.type=='map')
    vim.keymap.del(info.mode,info.key)
end
---@param hash ua.hook.hash
function M.set(hash)
    local info=hookutils.get_hash_info(hash)
    assert(info.type=='map')
    local objs=hookmem[hash]
    local desc={}
    for _,obj in ipairs(objs) do
        table.insert(desc,obj.doc)
    end
    vim.keymap.set(info.mode,info.key,function ()
        for _,obj in ipairs(objs) do
            local o={
                m=obj,
                line=vim.api.nvim_get_current_line(),
                col=vim.fn.col'.',
            }
            local ret=obj.run(o)
            if ret then return ret end
        end
        return info.key
    end,{noremap=true,expr=true,replace_keycodes=false,desc=table.concat(desc,'\n\t\t ')})
end
return M
