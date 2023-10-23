---@class ua.prof.cond.conf:ua.prof.conf
---@field filter? ua.filter-fn
---@field check? ua.check-fn

local prof=require'ultimate-autopair.prof'
local M={}
---@param id ua.id
---@param mem ua.module[]
---@param conf ua.prof.cond.conf
function M.init(conf,mem,id)
    local lmem=prof.init(id,conf)
    for _,v in ipairs(lmem) do
        if v.filter and conf.filter then
            local filter=v.filter
            v.filter=function (o)
                if not conf.filter(o) then return end
                return filter(o)
            end
        end
        if v.check and conf.check then
            local check=v.check
            v.check=function (o)
                if not conf.check(o) then return end
                return check(o)
            end
        end
        table.insert(mem,v)
    end
end
return M
