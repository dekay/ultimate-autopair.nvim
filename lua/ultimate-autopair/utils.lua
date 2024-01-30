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
M.tslang2lang={
    markdown_inline='markdown',
    bash='sh',
    javascript='javascript',
    markdown='markdown',
    html='html',
    xml='xml',
    scala='scala',
    latex='tex',
    ini='ini',
    glimmer='handlebars',
    verilog='verilog',
    tsx='typescriptreact',
}
---@param o ua.filter
---@return string
function M.get_filetype(o)
    local range={o.rows-1,o.cols-1,o.rowe-1,o.cole-1} --MAY: wrong offset
    local tree=true --TODO: local tree=o.opt.treesitter
    if not tree then return o.source.o.filetype end
    local parser=o.source.get_parser()
    if not parser then return o.source.o.filetype end
    local tslang=parser:language_for_range(range):lang()
    return M.tslang2lang[tslang] or vim.treesitter.language.get_filetypes(tslang)[1]
end
---@param opt any|fun(o:ua.filter):any
---@param o ua.filter
function M.opt_eval(opt,o)
    if type(opt)=='function' then return opt(o) end
    return opt
end
---@param str string
---@param col number
---@return string
function M.get_char(str,col)
    if col>#str or col<=0 then return '' end
    return str:sub(
        vim.str_utf_start(str,col)+col,
        vim.str_utf_end(str,col)+col)
end
---@param filters table<string,table>
---@param o ua.info
---@param _coloff number? --TODO: temp
---@param _coloffe number? --TODO: temp
---@return boolean
function M.run_filters(filters,o,_coloff,_coloffe)
    local po={
        cols=o.col-(_coloff or 0),
        cole=o.col-(_coloffe or 0),
        line=o.line,
        lines=o.lines,
        rows=o.row,
        rowe=o.row,
        source=o.source,
    }
    for filter,conf in pairs(filters) do
        filter=filter:gsub('_*%d*$','')
        if conf.filter==false then goto continue end
        if not require('ultimate-autopair.filter.'..filter).call(setmetatable({conf=conf},{__index=po})) then
            return false
        end
        ::continue::
    end
    return true
end
---@param o ua.filter
---@return boolean
function M.incmd(o)
    return o.source.cmdtype~=nil
end
---@param ft string
---@param option string
function M.ft_get_option(ft,option)
    if vim.o.filetype==ft then
        return vim.o[option]
    else
        return vim.filetype.get_option(ft,option)
    end
end
---@param list string[]
---@param s string
---@param i number?
---@param j number?
---@return string
function M.tbl_concat(list,s,i,j)
    return table.concat(list,s,i,j)
end
return M
