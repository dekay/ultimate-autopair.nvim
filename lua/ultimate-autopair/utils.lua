---@alias ua._.str_buf string.buffer
local M={I={}}
M.I.len=vim.api.nvim_strwidth
---@generic T:string|string?
---@param str T
---@return T
function M.I.keycode(str)
    return str and vim.api.nvim_replace_termcodes(str,true,true,true)
end
M.I.key_bs=M.I.keycode'<bs>'
M.I.key_del=M.I.keycode'<del>'
M.I.key_left=M.I.keycode'<left>'
M.I.key_right=M.I.keycode'<right>'
M.I.key_end=M.I.keycode'<end>'
M.I.key_home=M.I.keycode'<home>'
M.I.key_up=M.I.keycode'<up>'
M.I.key_down=M.I.keycode'<down>'
M.I.key_noundo=M.I.keycode'<C-g>U'
---@param minsize number
---@return ua._.str_buf
function M.new_str_buf(minsize)
    return require'string.buffer'.new(minsize)
end
---@param len string|number|nil
---@param noundo boolean?
---@return string
function M.key_left(len,noundo)
    len=type(len)=='string' and M.I.len(len) or len or 1
    return ((noundo and M.I.key_noundo or '')..M.I.key_left):rep(len --[[@as number]])
end
---@param len string|number|nil
---@param noundo boolean?
---@return string
function M.key_right(len,noundo)
    len=type(len)=='string' and M.I.len(len) or len or 1
    return ((noundo and M.I.key_noundo or '')..M.I.key_right):rep(len --[[@as number]])
end
---@param o ua.filter
---@param tree? boolean
function M.get_filetype(o,tree)
    if (o.conf.option or {}).filetype~=nil then
        return M.opt_eval(o.conf.option.filetype,o)
    end
    if o.buf then return vim.bo[o.buf].filetype end
    do return vim.o.filetype end --TODO: temp
    if _G.UA_DEV then error() end
    return vim.o.filetype
end
---@param opt any|fun(o:ua.filter):any
---@param o ua.filter
function M.opt_eval(opt,o)
    if type(opt)=='function' then return opt(o) end
    return opt
end
---@param str string
---@param col number
function M.get_char(str,col)
    if col>#str then return '' end
    return str:sub(
        vim.str_utf_start(str,col)+col,
        vim.str_utf_end(str,col)+col)
end
---@param filters table<string,table>
---@param o ua.info
---@return boolean
function M.run_filters(filters,o)
    local po={
        cols=o.col,
        cole=o.col,
        line=o.line,
        lines=o.lines,
        rows=o.row,
        rowe=o.row,
    }
    for filter,conf in pairs(filters) do
        if not require('ultimate-autopair.filter.'..filter).call(setmetatable({conf=conf},{__index=po})) then
            return false
        end
    end
    return true
end
do
    local _cache={}
    local regex=vim.regex[=[\c[[=a=][=b=][=c=][=d=][=e=][=f=][=g=][=h=][=i=][=j=][=k=][=l=][=m=][=n=][=o=][=p=][=q=][=r=][=s=][=t=][=u=][=v=][=w=][=x=][=y=][=z=][:keyword:]]]=]
    function M.is_alpha(char)
        if _cache[char]==nil then
            _cache[char]=regex:match_str(char) and true or false
        end
        return _cache[char]
    end
end
return M
