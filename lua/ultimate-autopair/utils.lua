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
---@param range Range4
---@param source ua.source
---@param tree boolean?
function M._pos_get_filetype(range,source,tree)
    --TODO: local cache
    --TODO: temp
    local function notree() return source.o.filetype end
    if not tree then return notree() end
    local s,parser=source.get_parser()
    if not s then return notree() end
    parser:parse()
    local tslang=parser:language_for_range(range):lang()
    return M.tslang2lang[tslang] or vim.treesitter.language.get_filetypes(tslang)[1]
end
---@param o ua.filter
function M.get_filetype(o)
    return o.source.o.filetype
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
---@param _coloff number? --TODO: temp
---@return boolean
function M.run_filters(filters,o,_coloff)
    local po={
        cols=o.col-(_coloff or 0),
        cole=o.col,
        line=o.line,
        lines=o.lines,
        rows=o.row,
        rowe=o.row,
        source=o.source,
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
    local regex=vim.regex[=[\c[[=a=][=b=][=c=][=d=][=e=][=f=][=g=][=h=][=i=][=j=][=k=][=l=][=m=][=n=][=o=][=p=][=q=][=r=][=s=][=t=][=u=][=v=][=w=][=x=][=y=][=z=]]]=]
    local regex_keyword=vim.regex[=[\c\k]=]
    function M.is_keywordy(char,o)
        if _cache[char]==true then return true end
        local ft=M.get_filetype(o)
        if _cache[char] and _cache[char][ft]~=nil then return _cache[char][ft] end
        local is_alpha=regex:match_str(char)
        if is_alpha then
            _cache[char]=true
            return true
        end
        if not _cache[char] then _cache[char]={} end
        local is_keyword
        if ft==vim.o.filetype then
            is_keyword=regex_keyword:match_str(char) and true or false
        else
            local opt_keyword=vim.o.iskeyword
            vim.o.iskeyword=vim.filetype.get_option(ft,'iskeyword')
            is_keyword=regex_keyword:match_str(char) and true or false
            vim.o.iskeyword=opt_keyword
        end
        _cache[char][ft]=is_keyword
        return is_keyword
    end
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
return M
