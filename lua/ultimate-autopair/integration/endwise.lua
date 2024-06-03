local M={}
---@param name string
---@param func function
---@return function?
---@return number?
local function extract_val_with_name(name,func)
    local i=1
    while true do
        local val_name,val=debug.getupvalue(func,i)
        if val_name==name then
            return val,i
        end
        if not val then
            return nil
        end
        i=i+1
    end
end
---@return string|fun(o:ua.info):string
function M.extract_functions()
    if not pcall(require,'nvim-treesitter-endwise') then
        return 'nvim-treesitter-endwise not found'
    end
    local _,fns=debug.getupvalue(vim.on_key,1)
    if type(fns)~='table' then
        return 'could not extract endwise functions from on_key'
    end
    for _,fn in pairs(fns) do
        if type(fn)~='function' then
            return 'could not extract functions from on_key'
        end
    end
    local endwise,tracking
    for _,fn in pairs(fns) do
        if vim.endswith(debug.getinfo(fn).source,'/endwise.lua') then
            endwise=extract_val_with_name('endwise',fn)
            tracking=extract_val_with_name('tracking',fn)
            break
        end
    end
    if type(endwise)~='function' then
        return 'could not extract function "endwise"'
    end
    if type(tracking)~='table' then
        return 'could not extract table "tracking"'
    end
    local add_end_node,idx=extract_val_with_name('add_end_node',endwise)
    if not add_end_node or not idx then
        return 'could not extract function "add_end_node"'
    end
    return function (o)
        local buf=vim.api.nvim_get_current_buf()
        if _G.UA_DEV then
            assert(buf==o.source.source)
            local cursor=vim.api.nvim_win_get_cursor(0)
            assert(cursor[1]==o.row) --TODO: might be off by one
            assert(cursor[2]==o.col)
        end
        if not tracking[buf] then return '' end
        local ret
        debug.setupvalue(endwise,idx,function (...) ret=vim.F.pack_len(...) end)
        local s,mes=pcall(endwise,buf)
        debug.setupvalue(endwise,7,add_end_node)
        if not s then error(mes) end
        if not ret then return '' end
        local _,_,end_text=vim.F.unpack_len(ret)
        return end_text or ''
    end
end
local _cache
---@param o ua.info
---@return string
function M.get_endwise(o)
    if _cache then
        return _cache(o)
    end
    local fn=M.extract_functions()
    if type(fn)=='string' then
        return ''
    end
    _cache=fn
    return _cache(o)
end
return M
