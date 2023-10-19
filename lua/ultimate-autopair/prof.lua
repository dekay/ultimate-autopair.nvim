---@class ua.prof.config
---@field profile? string
---@field p? number

local M={}
---@param profile string|function
---@return function
function M.get_profile_init(profile)
    if type(profile)=='function' then return profile end
    return require('ultimate-autopair.profile.'..profile).init
end
---@param conf ua.prof.config
---@param mem ua.module[]
---@param id ua.id
function M.init_conf(id,conf,mem)
    if type(conf)=='function' then
        conf({profile='_function'},mem,id) return
    end
    M.get_profile_init(conf.profile or 'default')(conf,mem,id)
end
---@param confs ua.prof.config[]
---@param id ua.id
---@return ua.module[]
function M.init(id,confs)
    local mem={}
    for _,conf in ipairs(confs) do
        M.init_conf(id,conf,mem)
    end
    return mem
end
return M
