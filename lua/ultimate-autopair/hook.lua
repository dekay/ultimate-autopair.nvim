---@class ua.hook.info_au
---@field type 'au'
---@field au string
---@class ua.hook.info_key
---@field type 'key'
---@field mode string
---@field key string
---@alias ua.hook.info ua.hook.info_au|ua.hook.info_key

local M={}

---@param id ua.id
function M.clear(id)
    _=id
end
---@param mem ua.module[]
function M.init(mem)
    for _,v in pairs(mem) do
        for _,i in pairs(v.get and v.get() or {}) do
            if i.type=='key' then
                vim.keymap.set(i.mode,i.key,v.check,{
                    noremap=true,
                    expr=true,
                    replace_keycodes=false,
                    desc=v.desc
                })
            end
        end
    end
end
M.global_name='_'..vim.fn.rand()..'_ULTIMATE_AUTOPAIR_CORE'
_G[M.global_name]=M
return M
