local prof=require'ultimate-autopair.prof'
local M={}
---@param id ua.id
---@param mem ua.module[]
---@param conf ua.prof.conf
function M.init(conf,mem,id)
    vim.list_extend(mem,prof.init(id,conf))
end
return M
