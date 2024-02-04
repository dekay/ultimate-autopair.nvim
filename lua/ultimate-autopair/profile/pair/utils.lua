local open_pair=require'ultimate-autopair._lib.open_pair' --TODO:make user be able to chose the open_pair detector (separately for open_pair/find_pair/...)
local utils=require'ultimate-autopair.utils'
local M={}
---@param o ua.info
---@param somepairs ua.prof.def.pair[]
---@return ua.prof.def.pair[]
function M.backwards_get_start_pairs(o,somepairs)
    local ret={}
    for _,v in ipairs(somepairs) do
        if v.info.type=='start'
            and v.info.start_pair==o.line:sub(o.col-#v.info.start_pair,o.col-1)
            and M.run_start_pair_filter(setmetatable({m=v,col=o.col-#v.info.start_pair},{__index=o}))
        then
            table.insert(ret,v)
        end
    end
    return ret
end
---@param o ua.info
---@param somepairs ua.prof.def.pair[]
---@return ua.prof.def.pair[]
function M.backwards_get_end_pairs(o,somepairs)
    local ret={}
    for _,v in ipairs(somepairs) do
        if v.info.type=='end'
            and v.info.end_pair==o.line:sub(o.col-#v.info.end_pair,o.col-1)
            and M.run_end_pair_filter(setmetatable({m=v,col=o.col-#v.info.end_pair},{__index=o}))
        then
            table.insert(ret,v)
        end
    end
    return ret
end
---@param o ua.info
---@return boolean
function M.pair_balansed_start(o)
    local info=(o.m --[[@as ua.prof.def.pair]]).info
    if info.start_pair==info.end_pair then
        return not open_pair.count_ambiguous_pair(o,'both')
    end
    local count=open_pair.count_start_pair(o)
    return not open_pair.count_start_pair(o,true,count,true)
end
---@param o ua.info
---@return boolean
function M.pair_balansed_end(o)
    local info=(o.m --[[@as ua.prof.def.pair]]).info
    if info.start_pair==info.end_pair then
        return not open_pair.count_ambiguous_pair(o,'both')
    end
    local count=open_pair.count_end_pair(o)
    return not open_pair.count_end_pair(o,true,count,true)
end
---@param o ua.info
---@param col number?
function M.run_end_pair_filter(o,col)
    col=col or o.col
    local info=(o.m --[[@as ua.prof.def.pair]]).info
    return utils.run_filters(info.end_pair_filter,o,nil,-#info.end_pair)
end
---@param o ua.info
function M.run_start_pair_filter(o)
    local info=(o.m --[[@as ua.prof.def.pair]]).info
    return utils.run_filters(info.start_pair_filter,o,nil,-#info.start_pair)
end
return M
