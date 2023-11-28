local M={}
---@param conf ua.prof.conf
---@param objects ua.object[]
function M.init_conf(conf,objects)
    if type(conf)=='function' then
        conf({profile='_function'},objects)
    end
    M.get_profile_init(conf.profile or 'default')(conf,objects)
end
---@param confs ua.prof.conf[]
---@return ua.object[]
function M.init(confs,objects)
    objects=objects or {}
    for _,conf in ipairs(confs) do
        M.init_conf(conf,objects)
    end
    return objects
end
return M
