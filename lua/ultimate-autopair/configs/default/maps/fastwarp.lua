local default=require 'ultimate-autopair.configs.default.utils'
local utils=require'ultimate-autopair.utils'
local M={}
M.ext={}
function M.ext.fastwarp_over_pair(o,ind,p)
    if o.col+1~=ind then return end
    local pair=default.get_pair(o.line:sub(ind,ind))
    if not pair then return end
    if pair.rule and not pair.rule() then return end
    if not default.get_type_opt(pair,'start') then return end
    local matching_pair_pos=pair.fn.find_end_pair(pair.start_pair,pair.end_pair,o.line,ind+1)
    if not matching_pair_pos then return end
    return utils.delete(0,1)..utils.movel(matching_pair_pos-o.col)..p..utils.moveh(),matching_pair_pos-1
end
function M.ext.fastwarp_next_to_start_pair(o,ind,p)
    if o.col+1==ind then return end
    local pair=default.get_pair(o.line:sub(ind,ind))
    if not pair then return end
    if pair.rule and not pair.rule() then return end
    if not default.get_type_opt(pair,'start') then return end
    return utils.delete(0,1)..utils.movel(ind-o.col-1)..p..utils.moveh(),ind-2
end
function M.ext.fastwarp_next_to_end_pair(o,ind,p,m)
    if o.col+1==ind and m.iconf.hopout then return end
    local pair=default.get_pair(o.line:sub(ind,ind))
    if not pair then return end
    if pair.rule and not pair.rule() then return end
    if not default.get_type_opt(pair,'end') then return end
    if o.col+1==ind then return not m.iconf.hopout and 1 end
    return utils.delete(0,1)..utils.movel(ind-o.col-1)..p..utils.moveh(),ind-2
end
function M.ext.fastwarp_over_word(o,ind,p)
    local regex=vim.regex([[\w]])
    if not regex:match_str(o.line:sub(ind,ind)) then return end
    while regex:match_str(o.line:sub(ind,ind)) do
        ind=ind+1
    end
    return utils.delete(0,1)..utils.movel(ind-o.col-1)..p..utils.moveh(),ind-2
end
function M.fastwarp_end(o,p,m)
    if o.col~=#o.line then
        return utils.delete(0,1)..utils.movel(#o.line-o.col)..p..utils.moveh(),#o.line-o.col-1
    end
    if not m.iconf.multiline then return end
    if vim.fn.line('.')==vim.fn.line('$') or o.incmd then return end
    return utils.delete(0,1)..'<down><home>'..p..utils.moveh(),0,1
end
function M.fastwarp(o,m)
    local p=o.line:sub(o.col,o.col)
    local pair=default.get_pair(p)
    if not pair then return end
    if not default.get_type_opt(pair,'end') then return end
    if pair.rule and not pair.rule() then return end
    for i=o.col+1,#o.line do
        local ind=i
        for _,v in pairs(M.ext) do
            local ret=v(o,ind,p,m)
            if ret==1 then return end
            if ret then return ret end
        end
    end
    return M.fastwarp_end(o,p,m)
end
function M.wrapp_fastwarp(m)
    return function (o)
        if default.key_check_cmd(o,m.map,m.map,m.cmap,m.cmap) then
            return M.fastwarp(o,m)
        end
    end
end
function M.init(conf,mconf,ext)
    if not conf.enable then return end
    local m={}
    m.iconf=conf
    m.conf=conf.conf or {}
    m.map=mconf.map~=false and conf.map
    m.cmap=mconf.cmap~=false and conf.cmap
    m.p=conf.p or 10
    m.extensions=ext
    m._type={[default.type_pair]={'fastwarp'}}
    m.check=M.wrapp_fastwarp(m)
    m.get_map=default.get_mode_map_wrapper(m.map,m.cmap)
    m.rule=function () return true end
    default.init_extensions(m,m.extensions)
    local check=m.check
    m.check=function (o)
        o.wline=o.line
        o.wcol=o.coll
        if not default.key_check_cmd(o,m.map,m.map,m.cmap,m.cmap) then return end
        check(o)
        if not m.rule() then return end
        return check(o)
    end
    if conf.do_nothing_if_fail then
        local n={}
        n.get_map=default.get_mode_map_wrapper(m.map,m.cmap)
        n.p=-1
        n.check=function (o)
            if default.key_check_cmd(o,m.map,m.map,m.cmap,m.cmap) then
                return ''
            end
        end
        return m,n
    end
    return m
end
return M
