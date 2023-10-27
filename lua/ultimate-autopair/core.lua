local M={}
---@param modules ua.module[]
---@param o fun(m:ua.module):ua.o
---@param fallback string|table
---@return string|table
---@overload fun(modules:ua.module[],o:fun(m:ua.module):ua.o):string|table|nil
function M._eval(modules,o,fallback)
    for _,mod in ipairs(modules) do
        local ret=mod.check(o(mod))
        if ret then return ret end
    end
    return fallback
end
return M
