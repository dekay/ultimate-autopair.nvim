local M={_id=0}
local objmem=require'ultimate-autopair.objmem'
local default=require'ultimate-autopair.default'
local prof=require'ultimate-autopair.profile'
local hook=require'ultimate-autopair.hook'
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
    hook.clear(id)
    objmem[id]={}
    prof.init(configs,objmem[id])
    hook.init(id)
end
---@param conf ua.prof.conf?
---@return ua.prof.conf
function M.extend_default(conf)
    return vim.tbl_deep_extend('force',default.conf,conf or {})
end
return M
