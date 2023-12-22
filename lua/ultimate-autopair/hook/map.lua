local hookmem=require'ultimate-autopair.mem.hook'
local hookutils=require'ultimate-autopair.hook.utils'
local utils=require'ultimate-autopair.utils'
local M={}
---@param hash ua.hook.hash
function M.del(hash)
    local info=hookutils.get_hash_info(hash)
    assert(info.type=='map')
    vim.keymap.del(info.mode,info.key)
end
---@param hash ua.hook.hash
function M.set(hash)
    M.expr_set(hash)
end
---@param hash ua.hook.hash
function M.expr_set(hash)
    local info=hookutils.get_hash_info(hash)
    assert(info.type=='map')
    local objs=hookmem[hash]
    local desc={}
    for _,obj in ipairs(objs) do
        table.insert(desc,obj.doc)
    end
    vim.keymap.set(info.mode,info.key,function ()
        local create_o=hookutils.create_o_wrapper()
        for _,obj in ipairs(objs) do
            local o={
                m=obj,
                line=vim.api.nvim_get_current_line(),
                col=vim.fn.col'.',
            }
            local ret=M.expr_handle(obj.run(create_o(obj)))
            if ret then return ret end
        end
        return info.key
    end,{noremap=true,expr=true,replace_keycodes=false,desc=table.concat(desc,'\n\t\t ')})
end
---@param act ua.actions?
---@param conf? {dot:boolean?,true_dot:boolean?}
---@return string?
function M.expr_handle(act,conf)
    conf=conf or {dot=true,true_dot=false}
    if act==nil then return end
    local buf=utils.new_str_buf(#act)
    for _,v in ipairs(act) do
        local kind,args
        if type(v)~='string' then
            kind=v[1]
            args={select(2,unpack(v))}
        end
        if type(v)=='string' then
            buf:put(v)
        elseif kind=='left' then
            buf:put(utils.key_left(args[1],conf.dot))
        elseif kind=='right' then
            buf:put(utils.key_right(args[1],conf.dot))
        end
    end
    return buf:tostring()
end
return M
