local M={}
---@param hash ua.hook.hash
---@return {mode:string,type:string,key:string,hash:string}
function M.get_hash_info(hash)
    local mode,type,key=hash:match('^(.-);(.-);(.*)$')
    return {mode=mode,type=type,key=key,hash=hash}
end
---@return fun(ua.object):ua.info
function M.create_o_wrapper()
    --TODO: move to utils
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
function M.sort(tbl)
    --TODO: move to utils
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
return M
