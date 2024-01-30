local M={}
function M.merge(def,conf,val)
    assert(def.merge~=false)
    assert(conf.merge~=false)
    if conf[val]~=nil then return conf[val] end
    return def[val]
end
function M._merge(def,conf,val)
    assert(def.merge~=false)
    assert(conf.merge~=false)
    local v=vim.F.if_nil(conf[val],def[val])
    if type(v)=='table' then
        return M.merge_tbl(def,conf,val)
    else
        return M.merge(def,conf,val)

    end
end
function M.merge_tbl2(tbl1,tbl2)
    if tbl2 and tbl2.merge==false then tbl1=nil end
    local out={}
    local keys={}
    for k,_ in pairs(tbl2 or {}) do keys[k]=true end
    for k,_ in pairs(tbl1 or {}) do keys[k]=true end
    for k,_ in pairs(keys) do
        if type(k)=='number' then
        else
            out[k]=M._merge(tbl1 or {},tbl2 or {},k)
        end
    end
    return out
end
function M.merge_tbl(def,conf,val)
    assert(def.merge~=false)
    assert(conf.merge~=false)
    local td=def[val] or {}
    local tc=conf[val] or {}
    assert(td.merge~=false)
    if tc.merge==false then td={} end
    local out={}
    local keys={}
    for k,_ in pairs(td) do keys[k]=true end
    for k,_ in pairs(tc) do keys[k]=true end
    local ikeys={}
    for k,_ in pairs(keys) do
        if type(k)=='number' then
            ikeys[k]=true
        else
            out[k]=M._merge(td,tc,k)
        end
    end
    for k,_ in ipairs(ikeys) do
        table.insert(out,tc[k])
        table.insert(out,td[k])
    end
    return out
end
function M.merge_list(l1,l2)
    local out={}
    if l2.merge==false then l1={} end
    local has={}
    for _,v in ipairs(l1) do
        has[v]=true
        table.insert(out,v)
    end
    for _,v in ipairs(l2) do
        if not has[v] then
            table.insert(out,v)
        end
    end
    return out
end
---@param def ua.prof.pair.conf
---@param conf ua.prof.pair.conf?
function M.merge_configs(def,conf)
    if conf==nil then return def end
    if conf.mrege_fn then return conf.mrege_fn(def,conf) end
    assert(def.merge~=false)
    assert(conf.profile==nil or conf.profile=='default')
    assert(def.profile==nil or def.profile=='default')
    if conf.merge==false then return conf end
    local out={}
    local function o(idx) return out[idx] end
    local function eq(val1,val2) return val1~=false and val2~=false and (val1 or val2) end
    local function call(val,fn,fall)
        local ret=fn(def,conf,val)
        if ret==nil and fall~=nil then ret=fall end
        out[val]=ret
    end
    call('multiline',M.merge)
    call('map',M.merge)
    call('cmap',M.merge,o'map')
    call('pair_map',M.merge,o'map')
    call('pair_cmap',M.merge,eq(o'cmap',o'pair_map'))
    out.filter={}
    call('filter',M.merge_tbl)
    call('extension',M.merge_tbl)
    call('integration',M.merge_tbl)
    vim.list_extend(out,def)
    vim.list_extend(out,conf)
    return out
end
---@param conf ua.prof.pair.conf
---@param pair ua.prof.pair.conf.pair
function M.pair_init(conf,pair,sub)
    assert(conf.merge~=false)
    if pair.merge==false then return pair end
    local out={}
    local filters={}
    for k,_ in pairs(conf.filter) do
        filters[k]=pair[k]
    end
    out.filter=M.merge_tbl2(conf.filter,filters)
    if pair.ft and vim.tbl_get(out,'filter','filetype') then
        out.filter.filetype.ft=M.merge_list(out.filter.filetype.ft or {},pair.ft)
    end
    if pair.nft and vim.tbl_get(out,'filter','filetype') then
        out.filter.filetype.nft=M.merge_list(out.filter.filetype.nft or {},pair.nft)
    end
    if sub then return out end
    vim.list_extend(out,pair)
    out.start_pair_filter=out.filter
    if pair.start_pair then
        out.start_pair_filter=M.merge_tbl(pair,M.pair_init(conf,pair.start_pair,true),'filter')
    end
    out.end_pair_filter=out.filter
    if pair.end_pair then
        out.end_pair_filter=M.merge_tbl(pair,M.pair_init(conf,pair.end_pair,true),'filter')
    end
    out.multiline=M.merge(conf,pair,'multiline')
    return out
end
return M
