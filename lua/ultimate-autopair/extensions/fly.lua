local utils=require'ultimate-autopair.utils'
local default=require'ultimate-autopair.configs.default.utils'
local M={}
--TODO: implement undo fly keymap
function M.check(conf,o,m)
    local next_char_index
    local line=conf.nofilter and o.wline or o.line
    local col=conf.nofilter and o.wcol or o.col
    if line:sub(col,col)==o.key then return end
    for i=col,#line do
        local char=line:sub(i,i)
        if vim.tbl_contains(conf.other_char,char)
            or vim.tbl_get(default.get_pair(char) or {},'conf','fly') then
            if char==o.key then
                next_char_index=i
                break
            end
        else
            return
        end
    end
    if not next_char_index then return end
    if m.fn.check_end_pair(m.start_pair,m.pair,line,col) then
        return utils.movel(next_char_index-col+1)
    end
end
function M.call(m,ext)
    local check=m.check
    local conf=ext.conf
    if not m.conf.fly then return end
    if not default .get_type_opt(m,{'end','ambigous-end'}) then return end
    m.check=function (o)
        local ret=M.check(conf,o,m)
        if ret then return ret end
        return check(o)
    end
end
return M
