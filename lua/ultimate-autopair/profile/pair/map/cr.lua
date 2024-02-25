local hookutils=require'ultimate-autopair.hook.utils'
local putils=require'ultimate-autopair.profile.pair.utils'
---@class ua.prof.def.cr.info
---@field pairs ua.prof.def.pair[]
---@class ua.prof.def.cr:ua.object
---@field info ua.prof.def.cr.info

local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    local m=o.m --[[@as ua.prof.def.cr]]
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
---@param somepairs ua.prof.def.pair
---@return ua.prof.def.bs
function M.init(somepairs)
    --TODO: each pair may have it's own backspace config defined
    return {
        hooks={hookutils.to_hash('map','<cr>',{mode='i'})},
        docs='autopairs newline',
        run=M.run,
        info={
            pairs=somepairs
        },
    }
end
return M
