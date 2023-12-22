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
return M
