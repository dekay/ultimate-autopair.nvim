---@class ua.prof.def.pair.conf
---@field multiline? boolean
---@class ua.prof.def.pair.info
---@field start_pair string
---@field _filter table --TODO: the problem: extension.tsnode can be initialized for specific positions, which means that filter may change, MAYBE?: have a filter initialize function which initializes the filters for a position
---@field end_pair string
---@field main_pair? string
---@field conf ua.prof.def.pair.conf
---@class ua.prof.def.pair:ua.object
---@field info ua.prof.def.pair.info
local M={}
---@param conf ua.prof.conf
---@param objects ua.instance
function M.init(conf,objects)
    local somepairs={}
    M.init_pairs(somepairs,conf,conf)
    M.pair_sort_len(somepairs)
    for _,v in ipairs(somepairs) do
        table.insert(objects,v)
    end
end
---@param somepairs ua.prof.def.pair
function M.pair_sort_len(somepairs)
    local len={}
    for _,v in ipairs(somepairs) do
        local l=-(#v.info.main_pair or -1)
        if not len[l] then len[l]={} end
        table.insert(len[l],v)
    end
    local k=1
    for _,v in vim.spairs(len) do
        for _,i in ipairs(v) do
            somepairs[k]=i
            k=k+1
        end
    end
end
---@param objects ua.instance
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
        require('ultimate-autopair.profile.pair.end_pair').init(pair[1],pair[2]),
        require('ultimate-autopair.profile.pair.start_pair').init(pair[1],pair[2]),
    }
end
return M
