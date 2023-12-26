---@class ua.prof.def.pair.conf
---@field multiline? boolean
---@class ua.prof.def.pair.info
---@field start_pair string
---@field _filter table --TODO: the problem: extension.tsnode can be initialized for specific positions, which means that filter may change, MAYBE?: have a filter initialize function which initializes the filters for a position
---@field end_pair string
---@field conf ua.prof.def.pair.conf
---@class ua.prof.def.pair:ua.object
---@field info ua.prof.def.pair.info
local M={}
---@param conf ua.prof.conf
---@param objects ua.object[]
function M.init(conf,objects)
    M.init_pairs(objects,conf,conf)
end
---@param objects ua.object[]
---@param conf ua.prof.conf
---@param somepairs any
function M.init_pairs(objects,conf,somepairs)
    for _,pair in ipairs(somepairs or {}) do
        for _,module in ipairs(M.init_pair(conf,pair)) do
            table.insert(objects,module)
        end
    end
end
---@param conf ua.prof.conf
---@param pair any
---@return ua.object[]
function M.init_pair(conf,pair)
    return {
        require('ultimate-autopair.profile.default.end_pair').init(pair[1],pair[2]),
        require('ultimate-autopair.profile.default.start_pair').init(pair[1],pair[2]),
    }
end
return M
