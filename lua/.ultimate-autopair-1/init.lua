local hook=require'ultimate-autopair.hook'
local prof=require'ultimate-autopair.prof'
local default=require'ultimate-autopair.default'
local M={_id={},_mem={}}
---@param conf ua.prof.conf
function M.setup(conf)
    if vim.fn.has('nvim-0.9.0')~=1 then error('Requires at least version nvim-0.9.0') end
    M.init({M.extend_default(conf or {})})
end
---@param configs ua.prof.conf[]
function M.init(configs)
    M._configs=configs
    hook.clear(M._id)
    M._mem=prof.init(M._id,configs)
    hook.init(M._mem)
end
---@param conf ua.prof.conf
---@return ua.prof.conf
function M.extend_default(conf)
    return vim.tbl_deep_extend('force',default.conf,conf or {})
end
return M
