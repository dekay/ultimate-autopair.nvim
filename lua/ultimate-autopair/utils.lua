---@alias ua._.str_buf string.buffer
local M={I={}}
M.I.len=vim.api.nvim_strwidth
---@generic T:string|string?
---@param str T
---@return T
function M.keycode(str)
    return str and vim.api.nvim_replace_termcodes(str,true,true,true)
end
M.I.key_bs=M.keycode'<bs>'
M.I.key_del=M.keycode'<del>'
M.I.key_left=M.keycode'<left>'
M.I.key_right=M.keycode'<right>'
M.I.key_end=M.keycode'<end>'
M.I.key_home=M.keycode'<home>'
M.I.key_up=M.keycode'<up>'
M.I.key_down=M.keycode'<down>'
M.I.key_noundo=M.keycode'<C-g>U'
M.I.key_i_ctrl_o=M.keycode'<C-\\><C-o>'
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
---@param pre? number
---@param pos? number
---@return string
function M.key_del(pre,pos)
    return M.I.key_bs:rep(pre or 1)..M.I.key_del:rep(pos or 0)
end
---@param col number
---@param row number?
---@return string
function M.key_pos_nodot(col,row,cmd)
    if not row then return M.I.key_i_ctrl_o..col..'|' end
    return M.I.key_i_ctrl_o..row..'gg'..M.I.key_i_ctrl_o..col..'|'
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
    muttrc='muttrc',
    sql='sql',
    tcl='tcl',
}
---@param o ua.filter
---@return string
function M.get_filetype(o)
    ---@param ltree LanguageTree
    local function lang_for_range(ltree,range)
        local query=vim.treesitter.query.get(ltree:lang(),'injections')
        if not query then return ltree:lang() end
        for _,tree in pairs(ltree:trees()) do
            for _,match,metadata in query:iter_matches(tree:root(),o.source.source,0,-1) do
                local lang=metadata['injection.language']
                if metadata['injection.parent'] then lang=ltree:lang() end
                local trange
                for id, node in pairs(match) do
                    local name=query.captures[id]
                    if name=='injection.language' then
                        lang=vim.treesitter.get_node_text(node,o.source.source)
                    elseif name=='injection.content' then
                        trange={node:range()}
                    end
                end
                if (trange[1]<range[1] or (trange[1]==range[1] and trange[2]<=range[2])) and
                    (trange[3]>range[3] or (trange[3]==range[3] and trange[4]>=range[4])) then
                    local child=ltree:children()[lang]
                    if child then
                        return lang_for_range(child,range),true
                    else
                        return lang,true
                    end
                end
            end
        end
        return ltree:lang()
    end
    local tree=true --TODO: local tree=o.opt.treesitter
    if not tree then return o.source.o.filetype end
    local parser=o.source.get_parser()
    if not parser then return o.source.o.filetype end
    local range={o.rows-1,o.cols-1,o.rowe-1,o.cole-1}
    local tslang,childlang=lang_for_range(parser,range)
    if not childlang then return o.source.o.filetype end
    return M.tslang2lang[tslang] or vim.treesitter.language.get_filetypes(tslang)[1] or tslang
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
        lsave=o._lsave,
        _o=o, --TODO: temp (only for debugging)
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
---@param range number[]
---@param contains_range number[]
---@param inclusive boolean?
---@return boolean
function M.range_in_range(range,contains_range,inclusive)
    local crange=contains_range
    --TODO: if crange is zero width then and only then have inclusive influence the result
    --So [f(oo)] is always true and [foo()] is true depending on if inclusive is set
    if inclusive then
        return (range[1]<crange[1] or (range[1]==crange[1] and range[2]<=crange[2])) and
            (range[3]>crange[3] or (range[3]==crange[3] and range[4]>=crange[4]))
    end
    return (range[1]<crange[1] or (range[1]==crange[1] and range[2]<crange[2])) and
        (range[3]>crange[3] or (range[3]==crange[3] and range[4]>crange[4]))
end
return M
