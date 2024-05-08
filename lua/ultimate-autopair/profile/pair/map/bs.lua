local putils=require'ultimate-autopair.profile.pair.utils'
---@class ua.prof.pair.bs:ua.object
---@field get_pairs fun():ua.prof.pair.pair[]
---@class ua.prof.pair.bs.conf:ua.prof.pair.map.conf

local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    local m=o.m --[[@as ua.prof.pair.bs]]
    local spairs=putils.backwards_get_start_pairs(o,m.get_pairs())
    for _,p in ipairs(spairs) do
        local opair=setmetatable({m=p},{__index=o})
        if o.line:sub(o.col,o.col+#p.end_pair-1)==p.end_pair
            and putils.run_end_pair_filter(opair)
            and putils.pair_balansed_start(opair)
        then
            return {{'delete',#p.start_pair,#p.end_pair}}
        end
        local col,row=putils.next_open_end_pair(opair)
        if col and row
            and putils.pair_balansed_start(opair)
        then
            return {
                {'pos',col,row},
                {'delete',0,#p.end_pair},
                {'pos',o.col,o.row},
                {'delete',#p.start_pair},
            }
        end
    end
    local epairs=putils.backwards_get_end_pairs(o,m.get_pairs())
    for _,p in ipairs(epairs) do
        local opair=setmetatable({m=p},{__index=o})
        if o.line:sub(o.col-#p.end_pair-#p.start_pair,o.col-#p.end_pair-1)==p.start_pair
            and putils.run_start_pair_filter(setmetatable({col=o.col-#p.end_pair-#p.start_pair},{__index=opair}))
            and putils.pair_balansed_end(opair)
        then
            return {{'delete',#p.start_pair+#p.end_pair}}
        end
    end
end
---@param objects ua.instance
---@param conf ua.prof.pair.bs.conf
---@return ua.prof.pair.bs
function M.init(objects,conf)
    --TODO: each pair may have it's own backspace config defined
    ---@type ua.prof.pair.bs
    return putils.create_obj(conf,{
        run=M.run,
        get_pairs=function () return putils.get_pairs(objects) end,
        doc='autopairs backspace',
    })
end
return M
