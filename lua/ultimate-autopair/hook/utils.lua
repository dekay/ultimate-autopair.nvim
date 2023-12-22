local M={}
---@param hash ua.hook.hash
---@return {mode:string,type:string,key:string,hash:string}
function M.get_hash_info(hash)
    local mode,type,key=hash:match('^(.-);(.-);(.*)$')
    return {mode=mode,type=type,key=key,hash=hash}
end
return M
