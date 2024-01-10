local M={_id=0}
local objmem=require'ultimate-autopair.mem.obj'
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
    if objmem[id] then hook.unregister(objmem[id]) end
    objmem[id]=prof.init(configs)
    hook.register(objmem[id])
end
---@param conf ua.prof.conf?
---@return ua.prof.conf
function M.extend_default(conf)
    local c=vim.tbl_deep_extend('force',default.conf,conf or {})
    vim.list_extend(c,default.conf)
    return c
end
return M
