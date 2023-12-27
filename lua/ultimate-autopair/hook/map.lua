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
        local handle=function (key) return key end
        if info.mode:match('[ic]') then
            handle=hookutils.activate_abbrev
        end
        for _,obj in ipairs(objs) do
            local ret=obj.run(create_o(obj))
            if ret then
                M.saveundo={act=ret,row=create_o({}).row,col=create_o({}).col,key=info.key}
                return handle(M.expr_handle(ret))
            end
        end
        return handle(info.key)
    end,{noremap=true,expr=true,replace_keycodes=false,desc=table.concat(desc,'\n\t\t ')})
end
---@param act ua.actions
function M.undo(act)
    if not M.saveundo then return end
    local buf=utils.new_str_buf(#act)
    --TODO: write a function which undos the last action
    buf:put(M.saveundo.key)
    return buf:tostring()
end
---@param act ua.actions
---@param conf? {dot:boolean?,true_dot:boolean?}
---@return string?
function M.expr_handle(act,conf)
    conf=conf or {dot=true,true_dot=false}
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
