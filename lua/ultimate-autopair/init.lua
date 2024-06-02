local M={_id=0}
---@type table<ua.id,ua.instance>
local instances={}
M['~get_instances']=function() return instances end
---@type ua.config[]?
local _configs
M['~get_configs']=function() return _configs end
local default=require'ultimate-autopair.default'
local prof=require'ultimate-autopair.profile'
local hook=require'ultimate-autopair.hook'
---@param conf ua.prof.conf?
---@param id ua.id?
function M.setup(conf,id)
    if vim.fn.has('nvim-0.9.2')~=1 then error('Requires at least version nvim-0.9.2') end
    M.init({M.extend_default(conf)},id)
    _configs={conf}
end
---@param configs ua.prof.conf[]
---@param id ua.id?
function M.init(configs,id)
    _configs=configs
    id=id or M._id
    M.deinit(id)
    instances[id]=prof.init(configs)
    hook.register(instances[id])
end
---@param id ua.id?
function M.deinit(id)
    id=id or M._id
    if instances[id] then hook.unregister(instances[id]) end
    instances[id]=nil
end
---@param conf ua.prof.conf?
---@return ua.prof.conf
function M.extend_default(conf)
    if conf and conf.profile and conf.profile~='pair' then
        return conf
    end
    local confspec=require'ultimate-autopair.profile.pair.confspec'
    local merged=confspec.merge(default.conf,conf,true,'main')
    return confspec.inherit(merged)
end
return M
