---@class ua.prof.def.pair.info
---@field start_pair string
---@field _filter table --TODO: the problem: extension.tsnode can be initialized for specific positions, which means that filter may change, MAYBE?: have a filter initialize function which initializes the filters for a position
---@field end_pair string
---@field main_pair? string
---@field multiline? boolean
---@field start_pair_filter table
---@field end_pair_filter table
---@class ua.prof.def.pair:ua.object
---@field info ua.prof.def.pair.info
---@alias ua.prof.pair.conf table
---@alias ua.prof.pair.conf.pair table

local M={}
---@param conf ua.prof.pair.conf
---@param objects ua.instance
function M.init(conf,objects)
    local somepairs={}
    M.init_pairs(somepairs,conf,conf)
    M.pair_sort_len(somepairs)
    for _,v in ipairs(somepairs) do
        table.insert(objects,v)
    end
end
---@param somepairs ua.prof.def.pair
function M.pair_sort_len(somepairs)
    local len={}
    for _,v in ipairs(somepairs) do
        local l=-(#v.info.main_pair or -1)
        if not len[l] then len[l]={} end
        table.insert(len[l],v)
    end
    local k=1
    for _,v in vim.spairs(len) do
        for _,i in ipairs(v) do
            somepairs[k]=i
            k=k+1
        end
    end
end
---@param objects ua.instance
---@param conf ua.prof.conf
---@param somepairs ua.prof.def.pair
function M.init_pairs(objects,conf,somepairs)
    for _,pair in ipairs(somepairs or {}) do
        for _,module in ipairs(M.init_pair(conf,pair)) do
            table.insert(objects,module)
        end
    end
end
---@param pair ua.prof.pair.conf.pair
---@param conf ua.prof.pair.conf
---@return ua.prof.pair.conf.pair
function M.merge_fn(pair,conf)
    --TODO: maybe move to init.lua instead (as a configuration system)
    if not vim.F.if_nil(pair.merge,conf.merge,true) then return pair end
    local function merge_list(l1,l2)
        if not l2 then return l1 end
        if not l1 then return l2 end
        if not vim.F.if_nil(l1.merge,l2.merge,true) then return l1 end
        return vim.list_extend(vim.list_extend({},l1),l2)
    end
    local function merge_list_no(l1,l2)
        if not l2 then return l1 end
        if not l1 then return l2 end
        return vim.list_extend(vim.list_extend({},l1),l2)
    end
    local function merge_tbls(t1,t2)
        if t1 and t2 and not vim.F.if_nil(t1.merge,t2.merge,true) then return t1 end
        return vim.tbl_extend('force',t2 or {},t1 or {})
    end
    local p=setmetatable({},{__index=pair})
    p.start_pair_filter={}
    p.end_pair_filter={}
    for k,_ in pairs(merge_tbls(pair.filter,conf.filter)) do
        local sfconf=merge_tbls(
            vim.tbl_get(pair,'start_pair','filter',k),
            merge_tbls(vim.tbl_get(pair,'filter',k),vim.tbl_get(conf,'filter',k)))
        local efconf=merge_tbls(
            vim.tbl_get(pair,'end_pair','filter',k),
            merge_tbls(vim.tbl_get(pair,'filter',k),vim.tbl_get(conf,'filter',k)))
        if k=='filetype' then
            if pair.ft then
                local pairft=merge_list_no(pair.ft,vim.tbl_get(pair,'filter','filetype','ft'))
                sfconf.ft=merge_list(pairft,conf.filter.filetype.ft)
                efconf.ft=merge_list(pairft,conf.filter.filetype.ft)
            end
        end
        p.start_pair_filter[k]=sfconf
        p.end_pair_filter[k]=efconf
    end
    return p
end
---@param conf ua.prof.pair.conf
---@param pair ua.prof.pair.conf.pair
---@return ua.prof.def.pair[]
function M.init_pair(conf,pair)
    local p=(pair.merge_fn or conf.merge_fn or M.merge_fn)(pair,conf) --TODO: temp
    return require('ultimate-autopair.profile.pair.pair').init(p)
end
return M
