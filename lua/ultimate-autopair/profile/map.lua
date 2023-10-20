---@class ua.prof.map.conf:ua.prof.config
---@field [number] ua.prof.map.opt
---@class ua.prof.map.mod:ua.module
---@field mode string[]
---@field lhs string
---@field rhs string
---@field conf ua.prof.map.opt
---@alias ua.prof.map.opt {[1]:string|string[],[2]:string,[3]:function,p?:number}

local M={}
---@param m ua.prof.map.mod
---@return ua.check-fn
function M.check_wrapp(m)
    return function (o)
        if type(m.rhs)=='function' then
            return m.rhs(o,m)
        end
        return m.rhs
    end
end
---@param m ua.prof.map.mod
---@return ua.get-fn
function M.get_map_wrapp(m)
    return function ()
        local ret={}
        for _,v in ipairs(m.mode) do
            table.insert(ret,{type='key',mode=v,key=m.lhs})
        end
        return ret
    end
end
---@param opt ua.prof.map.opt
---@param conf ua.prof.map.conf
---@param id ua.id
---@return ua.prof.map.mod
function M.create_map(opt,conf,id)
    local m={}
    m.p=opt.p or conf.p or 10
    m.id=id
    m.mode=type(opt[1])=='string' and {opt[1]} or opt[1] --[[@as string[] ]]
    m.lhs=opt[2]
    m.rhs=opt[3]
    m.conf=opt
    m.filter=function () return true end
    m.get=M.get_map_wrapp(m)
    m.check=M.check_wrapp(m)
    m.desc=('map %s to %s'):format(vim.inspect(m.lhs),vim.inspect(m.rhs))
    return m
end
---@param id ua.id
---@param mem ua.module[]
---@param conf ua.prof.map.conf
function M.init(conf,mem,id)
    for _,v in ipairs(conf) do
        table.insert(mem,M.create_map(v,conf,id))
    end
end
return M
