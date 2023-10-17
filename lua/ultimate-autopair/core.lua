---@class core.o
---@field key string|core.okey
---@field line string
---@field lines string[]
---@field _offset number
----@field incheck boolean
----@field inoinit boolean?
---@field col number
---@field row number
---@field mode 'c'|'i'|string
---@field __core_mem? fun():core.imodule[]
---@field true_pos? core.o.true_pos
---@class core.o.true_pos
---@field buffer number
---@field col number
---@field row number
---@class core.module:core.imodule
---@field save table
---@class core.imodule
---@field get_map? core.get_map-fn
---@field oinit? core.oinit-fn
---@field check? core.check-fn
---@field doc? string
---@field sort? core.sort-fn
---@field filter? core.filter-fn
---@field p number
---@alias core.get_map-fn fun(mod:string):string[]?
---@alias core.check-fn fun(o:core.o):string?
---@alias core.filter-fn fun(o:core.o):boolean?
---@alias core.oinit-fn fun(delete:boolean?)
---@alias core.sort-fn fun(a:core.imodule,b:core.imodule):boolean?
---@class core.okey
---@field autocmd? string|string[]

local debug=require'ultimate-autopair.debug'
local utils=require'ultimate-autopair.utils'
local M={}
---@type core.imodule[]
M.mem={}
---@type table<string,table<string,table|false>>
M.map={}
M.modes={'i','c'}
M.funcs={}
M.I={}
---@param mode string
---@return table<string,table>
function M.I.get_maps(mode)
    local maps=vim.api.nvim_get_keymap(mode)
    local ret={}
    for _,keyinfo in ipairs(maps) do
        ret[keyinfo.lhs]=keyinfo
    end
    return ret
end
---@param mode string
function M.delete_mem_map(mode)
    local mapps=M.I.get_maps(mode)
    for key,old_map in pairs(M.map[mode] or {}) do
        if mapps[vim.fn.keytrans(key)] and M.funcs[key] and
            mapps[vim.fn.keytrans(key)].callback==M.funcs[key] then
            vim.keymap.del(mode,vim.fn.keytrans(key),{})
            if old_map then vim.fn.mapset(mode,false,old_map) end
        end
    end
end
function M.clear()
    vim.api.nvim_create_augroup('UltimateAutopair',{clear=true})
    for _,mode in ipairs(M.modes) do
        M.delete_mem_map(mode)
    end
    M.mem={}
    M.map={}
    M.funcs={}
end
return M
