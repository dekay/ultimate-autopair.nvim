---@class ua.prof.def.conf:ua.prof.conf
---@class ua.prof.def.conf.pair

local M={}
---@param id ua.id
---@param mem ua.module[]
---@param conf ua.prof.def.conf
function M.init(conf,mem,id)
    M.init_pairs(mem,conf,conf)
end

---@param mem core.module[]
---@param conf ua.prof.def.conf
---@param somepairs ua.prof.def.conf.pair[]
function M.init_pairs(mem,conf,somepairs)
    for _,pair in ipairs(somepairs or {}) do
        for _,module in ipairs(M.init_pair(conf,pair)) do
            table.insert(mem,module)
        end
    end
end
---@param conf ua.prof.def.conf
---@param pair ua.prof.def.conf.pair
function M.init_pair(conf,pair)

end
return M
