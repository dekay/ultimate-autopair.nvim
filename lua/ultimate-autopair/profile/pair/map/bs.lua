---@class ua.prof.def.bs.info
---@field pairs? ua.prof.def.pair[]
---@class ua.prof.def.bs:ua.object
---@field info ua.prof.def.bs.info

local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    --local m=o.m --[[@as ua.prof.def.bs]]
    --local info=m.info
    if o.line:sub(o.col-1,o.col)=='[]'
        or o.line:sub(o.col-1,o.col)=='""' then
        return {{'delete',1,1}}
    end
    if o.line:sub(o.col-2,o.col-1)=='""' then
        return {{'delete',2}}
    end
    return {{'delete'}}
end
---@param hooks ua.hook.hash[]
---@return ua.prof.def.bs
function M.init(hooks)
    return {
        hooks=hooks,
        docs='autopairs backspace',
        run=M.run,
        info={},
    }
end
return M
