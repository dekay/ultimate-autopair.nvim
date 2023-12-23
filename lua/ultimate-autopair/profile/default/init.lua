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
        require('ultimate-autopair.profile.default.start_pair').init(pair[1],pair[2]),
        require('ultimate-autopair.profile.default.end_pair').init(pair[1],pair[2])
    }
end
return M
