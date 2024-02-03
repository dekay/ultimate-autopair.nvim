local hookutils=require'ultimate-autopair.hook.utils'
local putils=require'ultimate-autopair.profile.pair.utils'
---@class ua.prof.def.bs.info
---@field pairs ua.prof.def.pair[]
---@class ua.prof.def.bs:ua.object
---@field info ua.prof.def.bs.info

local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    local m=o.m --[[@as ua.prof.def.bs]]
    local info=m.info
    local spairs=putils.backwards_get_start_pairs(o,info.pairs)
    for _,p in ipairs(spairs) do
        if o.line:sub(o.col,o.col+#p.info.end_pair-1)==p.info.end_pair
            and putils.pair_balansed_start(setmetatable({m=p},{__index=o}))
        then
            return {{'delete',#p.info.start_pair,#p.info.end_pair}}
        end
    end
    local epairs=putils.backwards_get_end_pairs(o,info.pairs)
    for _,p in ipairs(epairs) do
        if o.line:sub(o.col-#p.info.end_pair-#p.info.start_pair,o.col-#p.info.end_pair-1)==p.info.start_pair
            and putils.pair_balansed_end(setmetatable({m=p},{__index=o}))
        then
            return {{'delete',#p.info.start_pair+#p.info.end_pair}}
        end
    end
end
---@param somepairs ua.prof.def.pair
---@return ua.prof.def.bs
function M.init(somepairs)
    return {
        hooks={hookutils.to_hash('map','<bs>',{mode='i'})},
        docs='autopairs backspace',
        run=M.run,
        info={
            pairs=somepairs
        },
    }
end
return M
