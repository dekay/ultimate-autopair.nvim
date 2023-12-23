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
    local oindex={
        line=vim.api.nvim_get_current_line(),
        col=vim.fn.col'.',
        gsave={},
    }
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
return M
