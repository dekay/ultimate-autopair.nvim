local hookutils=require'ultimate-autopair.hook.utils'
local putils=require'ultimate-autopair.profile.pair.utils'
---@class ua.prof.pair.cr.info
---@field pairs ua.prof.pair.pair[]
---@class ua.prof.pair.cr:ua.object
---@field info ua.prof.pair.cr.info
---@class ua.prof.pair.cr.conf:ua.prof.pair.map.conf

local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    if o.source.mode=='c' then return end
    local m=o.m --[[@as ua.prof.pair.cr]]
    local info=m.info
    local spairs=putils.backwards_get_start_pairs(o,info.pairs)
    for _,p in ipairs(spairs) do
        local opair=setmetatable({m=p},{__index=o})
        if o.line:sub(o.col,o.col+#p.info.end_pair-1)==p.info.end_pair
            and putils.run_end_pair_filter(opair)
            and putils.pair_balansed_start(opair)
        then
            return {
                '\n',
                {'pos',o.col,o.row},
                '\n',
            }
        end
    end
end
---@param somepairs ua.prof.pair.pair
---@param conf ua.prof.pair.cr.conf
---@return ua.prof.pair.cr
function M.init(somepairs,conf)
    --TODO: each pair may have it's own backspace config defined
    ---@type ua.prof.pair.cr
    return putils.create_obj(conf,{
        run=M.run,
        info={pairs=somepairs},
        doc='autopairs newline',
    })
end
return M
