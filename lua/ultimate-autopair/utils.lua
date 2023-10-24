local M={}
---@param hash ua.hook.hash
---@return fun(m:ua.module):ua.o
function M.get_o_creator(hash)
    local go=M.create_go(hash)
    return function (m)
        local o=setmetatable({m=m},{__index=go})
        return setmetatable({},{__index=o})
    end
end
---@param hash ua.hook.hash
---@return table
function M.create_go(hash)
    return {hash=hash}
end
return M
