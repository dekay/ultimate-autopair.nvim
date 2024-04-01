local putils=require'ultimate-autopair.profile.pair.utils'
---@class ua.prof.pair.bs.info
---@field pairs ua.prof.pair.pair[]
---@class ua.prof.pair.bs:ua.object
---@field info ua.prof.pair.bs.info
---@class ua.prof.pair.bs.conf:ua.prof.pair.map.conf

local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    local m=o.m --[[@as ua.prof.pair.bs]]
    local info=m.info
    local spairs=putils.backwards_get_start_pairs(o,info.pairs)
    for _,p in ipairs(spairs) do
        local opair=setmetatable({m=p},{__index=o})
        if o.line:sub(o.col,o.col+#p.info.end_pair-1)==p.info.end_pair
            and putils.run_end_pair_filter(opair)
            and putils.pair_balansed_start(opair)
        then
            return {{'delete',#p.info.start_pair,#p.info.end_pair}}
        end
        local col,row=putils.next_open_end_pair(opair)
        if col and row
            and putils.pair_balansed_start(opair)
        then
            return {
                {'pos',col,row},
                {'delete',0,#p.info.end_pair},
                {'pos',o.col,o.row},
                {'delete',#p.info.start_pair},
            }
        end
    end
    local epairs=putils.backwards_get_end_pairs(o,info.pairs)
    for _,p in ipairs(epairs) do
        local opair=setmetatable({m=p},{__index=o})
        if o.line:sub(o.col-#p.info.end_pair-#p.info.start_pair,o.col-#p.info.end_pair-1)==p.info.start_pair
            and putils.run_start_pair_filter(setmetatable({col=o.col-#p.info.end_pair-#p.info.start_pair},{__index=opair}))
            and putils.pair_balansed_end(opair)
        then
            return {{'delete',#p.info.start_pair+#p.info.end_pair}}
        end
    end
end
---@param somepairs ua.prof.pair.pair[]
---@param conf ua.prof.pair.bs.conf
---@return ua.prof.pair.bs
function M.init(somepairs,conf)
    --TODO: each pair may have it's own backspace config defined
    ---@type ua.prof.pair.bs
    return putils.create_obj(conf,{
        run=M.run,
        info={pairs=somepairs},
        doc='autopairs backspace',
    })
end
return M
