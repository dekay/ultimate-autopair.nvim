---@class core.o
---@field key string|{auevent:table}
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
---@alias core.get_map-fn fun():{mode:string,key:string}[]?
---@alias core.check-fn fun(o:core.o):string?
---@alias core.filter-fn fun(o:core.o):boolean?
---@alias core.oinit-fn fun(delete:boolean?)
---@alias core.sort-fn fun(a:core.imodule,b:core.imodule):boolean?
---@alias core.mem core.imodule[]
---@class core.hook

local M={}
---@type core.mem
M.mem={}
M.funcs={}
M.I={}
---@param mode string
---@return table<string,table>
function M.I.get_maps(mode)
    local maps=vim.api.nvim_get_keymap(mode)
    local ret={}
    for _,keyinfo in ipairs(maps) do
        ret[vim.fn.keytrans(keyinfo.lhsraw)]=keyinfo
    end
    return ret
end
---@param mem core.mem
---@return {mode:string,key:string,m:core.imodule}[]
function M.get_modulo_maps(mem)
    local ret={}
    for _,m in ipairs(mem) do
        for _,k in ipairs(m.get_map and m.get_map() or {}) do
            table.insert(ret,setmetatable({m=m},{__index=k}))
        end
    end
    return ret
end
---@param mem core.mem
---@param hook core.hook
function M.init_modulos(mem,hook)
    local mapdoc=vim.defaulttable()
    for _,v in ipairs(M.get_modulo_maps(mem)) do
        table.insert(mapdoc[v.mode][v.key],v.m)
        table.insert(mapdoc[v.mode][v.key].desc,v.m.doc)
    end
    return mapdoc
end
---@param mem core.mem
function M.init(mem)
    vim.api.nvim_create_augroup('UltimateAutopair',{clear=false})
    M.sort_mem(mem)
    local hook=M.create_hooker(mem)
    M.init_modulos(mem,hook)
    --for _,mode in ipairs{'',unpack(M.modes)} do
    --local mapped=M.get_mem_maps(mode)
    --M.init_mapped(mapped,mode)
    --end
    --M.init_mem_oinits()
end
M.global_name='_'..vim.fn.rand()..'_ULTIMATE_AUTOPAIR_CORE'
_G[M.global_name]=M
return M
