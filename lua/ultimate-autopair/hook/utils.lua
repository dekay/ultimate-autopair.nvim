local utils=require'ultimate-autopair.utils'
local hookmem=require'ultimate-autopair.mem.hook'
local M={}
---@param hash ua.hook.hash
---@return {mode:string,type:string,key:string,hash:string}
function M.get_hash_info(hash)
    local mode,type,key=hash:match('^(.-);(.-);(.*)$')
    return {mode=mode,type=type,key=key,hash=hash}
end
---@param mode string
---@param type string
---@param key string
---@return string
function M.to_hash(mode,type,key)
    return ('%s;%s;%s'):format(mode,type,key)
end
---@return fun(ua.object):ua.info
function M.create_o_wrapper()
    local oindex=setmetatable({
        lines={vim.api.nvim_get_current_line()},
        row=1,
        col=vim.fn.col'.',
        gsave={},
    },{__index=function (t,index) return index=='line' and t.lines[t.row] or nil end })
    return function (obj)
        return setmetatable({
            m=obj,
            lsave={},
        },{__index=oindex})
    end
end
---@param tbl ua.object[]
function M.stable_sort(tbl)
    local col={}
    for _,v in ipairs(tbl) do
        if not col[v.p or 0] then col[v.p or 0]={} end
        table.insert(col[v.p or 0],v)
    end
    local i=1
    for _,t in vim.spairs(col) do
        for _,v in ipairs(t) do
            tbl[i]=v
            i=i+1
        end
    end
end
---@param key string
---@return string
function M.activate_abbrev(key)
    if key:sub(1,1)=='\r' then
        return '\x1d'..key
    elseif vim.regex('^[^[:keyword:][:cntrl:]\x80]'):match_str(key) then
        return '\x1d'..key
    end
    return key
end
---@param hash ua.hook.hash
---@param mode string
---@param skip_index number?
---@return ua.actions
---@return ua.hook.subconf?
---@return boolean?
function M.get_act(hash,mode,skip_index)
    local info=M.get_hash_info(hash)
    local objs=hookmem[hash]
    local create_o=M.create_o_wrapper()
    for index,obj in ipairs(objs) do
        if skip_index and index<=skip_index then goto continue end
        local o=create_o(obj)
        local act=obj.run(o)
        if act then
            if mode=='i' then
                M.saveundo={act=act,row=o.row,col=o.col,buf=o.buf,key=info.key,index=index,hash=hash,mode=mode}
            end
            return act,obj.__hook_subconf
        end
        ::continue::
    end
    return {info.key},{},true --TODO: be able to set default subconf (which could also be a function)
end
---@param act ua.actions
function M.generate_undo(act)
    return {}
end
---@return ua.actions
function M.undo_last_act() --TODO: test
    if not M.saveundo then return {} end
    local saveundo=M.saveundo
    M.saveundo=nil
    return M.generate_undo(saveundo.act)
end
---@return ua.actions
function M.last_act_cycle() --TODO: test
    if not M.saveundo then return {} end
    local saveundo=M.saveundo
    M.saveundo=nil
    return vim.list_extend(M.generate_undo(saveundo.act),M.get_act(saveundo.hash,saveundo.can_undo,saveundo.index))
end
---@param act ua.actions
---@param mode string
---@param conf? ua.hook.subconf
---@return string?
function M.act_to_keys(act,mode,conf)
    conf=conf or {dot=true,true_dot=false,abbr=true}
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
            buf:put(utils.key_left(args[1],conf.dot and mode=='i'))
        elseif kind=='right' then
            buf:put(utils.key_right(args[1],conf.dot and mode=='i'))
        end
    end
    if conf.abbr and mode:match('[ic]') then
        return M.activate_abbrev(buf:tostring())
    end
    return buf:tostring()
end
return M
