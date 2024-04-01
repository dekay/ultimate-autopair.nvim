local putils=require'ultimate-autopair.profile.pair.utils'
---@class ua.prof.pair.fastwarp.info
---@field pairs ua.prof.pair.pair[]
---@class ua.prof.pair.fastwarp:ua.object
---@field info ua.prof.pair.fastwarp.info
---@class ua.prof.pair.fastwarp.conf:ua.prof.pair.map.conf

local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    local m=o.m --[[@as ua.prof.pair.fastwarp]]
    local info=m.info
    local epairs=putils.forward_get_end_pairs(o,info.pairs)
    for _,epair in ipairs(epairs) do
        if o.col~=#o.line then
            return {
                {'delete',0,#epair.info.end_pair},
                {'pos',#o.line},
                epair.info.end_pair,
                {'pos',o.col},
            }
        else
            return {
                {''},
            }
        end
    end
end

---@param somepairs ua.prof.pair.pair
---@param conf ua.prof.pair.fastwarp.conf
---@return ua.prof.pair.fastwarp
function M.init(somepairs,conf)
    ---@type ua.prof.pair.fastwarp
    return putils.create_obj(conf,{
        run=M.run,
        info={pairs=somepairs},
        doc='autopairs fastwarp',
    })
end
return M
