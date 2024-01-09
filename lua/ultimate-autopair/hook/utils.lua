local utils=require'ultimate-autopair.utils'
local hookmem=require'ultimate-autopair.mem.hook'
local M={}
M.HASH_SEP1=':'
M.HASH_SEP2=';'
M.HASH_CONF_SEP=','
M.HASH_CONF_SET='='
---@param hash ua.hook.hash
---@return {conf:table<string,string>,type:string,key:string,hash:string}
function M.get_hash_info(hash)
    local type,confstr,key=hash:match(('^(.-)%s(.-)%s(.*)$'):format(M.HASH_SEP1,M.HASH_SEP2))
    local conf={}
    for i in vim.gsplit(confstr,M.HASH_CONF_SEP) do
        local k,v=unpack(vim.split(i,M.HASH_CONF_SET))
        conf[k]=v
    end
    return {conf=conf,type=type,key=key,hash=hash}
end
---@param type string
---@param key string
---@param conf table<string,string>?
---@return string
function M.to_hash(type,key,conf)
    local confstrs={}
    for k,v in vim.spairs(conf or {}) do
        table.insert(confstrs,k..M.HASH_CONF_SET..v)
    end
    return type..M.HASH_SEP1..table.concat(confstrs,M.HASH_CONF_SEP)..M.HASH_SEP2..key
end
---@return fun(ua.object):ua.info
function M.create_o_wrapper()
    local cmdtype=vim.fn.getcmdtype()
    local buf=vim.api.nvim_get_current_buf()
    local lines={vim.api.nvim_get_current_line()}
    local row=1
    local col=vim.fn.col'.'
    local source={
        o=vim.bo[buf],
        get_parser=function () return vim.treesitter.get_parser(buf) end,
        __buf=buf,
    }
    if cmdtype~='' then
        lines={vim.fn.getcmdline()}
        row=1
        col=vim.fn.getcmdpos()
        source={
            o=setmetatable({filetype='vim'},{__index=vim.bo[buf]}),
            cmdtype=cmdtype,
            get_parser=function () return vim.treesitter.get_string_parser(vim.fn.getcmdline(),'vim') end,
        }
    end
    local oindex=setmetatable({
        lines=lines,
        row=row,
        col=col,
        source=source,
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
                M.saveundo={act=act,row=o.row,col=o.col,buf=o.source.__buf,key=info.key,index=index,hash=hash,mode=mode}
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
function M.undo_last_act() --TODO
    if not M.saveundo then return {} end
    local saveundo=M.saveundo
    M.saveundo=nil
    return M.generate_undo(saveundo.act)
end
---@return ua.actions
function M.last_act_cycle() --TODO
    if not M.saveundo then return {} end
    local saveundo=M.saveundo
    M.saveundo=nil
    return vim.list_extend(M.generate_undo(saveundo.act),M.get_act(saveundo.hash,saveundo.can_undo,saveundo.index))
end
---@param act ua.actions
---@param mode string
---@param conf? ua.hook.subconf
---@return string
function M.act_to_keys(act,mode,conf)
    conf=conf or {dot=true,true_dot=false,abbr=true}
    local buf=utils.new_str_buf(#act)
    for _,v in ipairs(act) do
        if type(v)=='string' then v={'ins',v} end
        if v[1]=='ins' then
            if not mode:match'[ic]' then error() end
            buf:put(v[2])
        elseif v[1]=='left' then
            buf:put(utils.key_left(v[2],conf.dot and mode=='i'))
        elseif v[1]=='right' then
            buf:put(utils.key_right(v[2],conf.dot and mode=='i'))
        end
    end
    if conf.abbr and mode:match('[ic]') then
        return M.activate_abbrev(buf:tostring())
    end
    return buf:tostring()
end
return M
