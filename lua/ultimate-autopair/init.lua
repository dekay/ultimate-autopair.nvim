local M={_id=0}
local objman=require('ultimate-autopair.objman')
local default=require('ultimate-autopair.default')
local _
---@param conf ua.prof.conf?
---@param id ua.id?
function M.setup(conf,id)
    if vim.fn.has('nvim-0.9.0')~=1 then error('Requires at least version nvim-0.9.0') end
    M.init({M.extend_default(conf)},id)
end
---@param configs ua.prof.conf[]
---@param id ua.id?
function M.init(configs,id)
    id=id or M._id
    --configs=_.config_manager.init(configs)
    local objects=objman.create_objs(id,{init=_.hook.init,clear=_.hook.clear})
    _.profile.create_objects_from_config(configs,objects)
    objman.init(id)
end
---@param conf ua.prof.conf?
---@return ua.prof.conf
function M.extend_default(conf)
    return vim.tbl_deep_extend('force',default.conf,conf)
end
return M
