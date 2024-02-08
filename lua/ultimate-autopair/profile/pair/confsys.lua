--TODO: like redo the whole file
local M={}
function M.merge(def,conf,val)
    assert(def.merge~=false)
    assert(conf.merge~=false)
    if conf[val]~=nil then return conf[val] end
    return def[val]
end
function M.merge2(tbl1,tbl2,val)
    if tbl2.merge==false then return tbl2[val] end
    if tbl2[val]~=nil then return tbl2[val] end
    return tbl1[val]
end
function M._merge(def,conf,val)
    local v=vim.F.if_nil(conf[val],def[val])
    if type(v)=='table' then
        return M.merge_tbl(def,conf,val)
    else
        return M.merge(def,conf,val)

    end
end
function M._merge3(def,conf,val)
    local v=vim.F.if_nil(conf[val],def[val])
    if type(v)=='table' then
        return M.merge_tbl3(def,conf,val)
    else
        return M.merge2(def,conf,val)

    end
end
function M._merge2(tbl1,tbl2,val)
    local v=vim.F.if_nil(tbl2[val],tbl1[val])
    if type(v)=='table' then
        return M.merge_tbl22(tbl1[val],tbl2[val])
    else
        return M.merge2(tbl1,tbl2,val)

    end
end
function M.merge_tbl21(tbl1,tbl2)
    if tbl2 and tbl2.merge==false then tbl1=nil end
    local out={}
    local keys={}
    for k,_ in pairs(tbl2 or {}) do keys[k]=true end
    for k,_ in pairs(tbl1 or {}) do keys[k]=true end
    for k,_ in pairs(keys) do
        if type(k)=='number' then
        else
            out[k]=M._merge2(tbl1 or {},tbl2 or {},k)
        end
    end
    return out --TODO: remove merge if only tbl1.merge==false
end
function M.merge_tbl22(tbl1,tbl2)
    tbl1=tbl1 or {}
    tbl2=tbl2 or {}
    if tbl2.merge==false then
        return tbl2
    end
    local out={}
    local keys={}
    for k,_ in pairs(tbl1) do keys[k]=true end
    for k,_ in pairs(tbl2) do keys[k]=true end
    local ikeys={}
    for k,_ in pairs(keys) do
        if type(k)=='number' then
            ikeys[k]=true
        else
            out[k]=M._merge2(tbl1,tbl2,k)
        end
    end
    for k,_ in ipairs(ikeys) do
        table.insert(out,tbl2[k])
        table.insert(out,tbl1[k])
    end
    return out --TODO: remove merge if only tbl1.merge==false
end
function M.merge_tbl(def,conf,val)
    assert(def.merge~=false)
    assert(conf.merge~=false)
    local td=def[val] or {}
    local tc=conf[val] or {}
    assert(td.merge~=false)
    if tc.merge==false then
        return tc
    end
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
function M.merge_tbl3(def,conf,val)
    local td=def[val] or {}
    local tc=conf[val] or {}
    if tc.merge==false then
        return tc
    end
    local out={}
    local keys={}
    for k,_ in pairs(td) do keys[k]=true end
    for k,_ in pairs(tc) do keys[k]=true end
    local ikeys={}
    for k,_ in pairs(keys) do
        if type(k)=='number' then
            ikeys[k]=true
        else
            out[k]=M._merge3(td,tc,k)
        end
    end
    for k,_ in ipairs(ikeys) do
        table.insert(out,tc[k])
        table.insert(out,td[k])
    end
    return out --TODO: remove merge if only td.merge==false
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
    if conf==nil then
        return setmetatable(def,{__index={pair_map_modes=def.map_modes}})
    end
    if conf.mrege_fn then return conf.mrege_fn(def,conf) end
    assert(def.merge~=false)
    assert(conf.profile==nil or conf.profile=='default')
    assert(def.profile==nil or def.profile=='default')
    if conf.merge==false then return conf end
    local out={}
    local function call(val,fn,fall)
        if type(conf[val])=='table' and conf[val].merge==false then
            out[val]=conf[val]
            return
        end
        local ret=fn(def,conf,val)
        if ret==nil and fall~=nil then ret=fall end
        out[val]=ret
    end
    call('multiline',M.merge)
    call('map_modes',M.merge)
    call('pair_map_modes',M.merge,out['map_modes'])
    out.filter={}
    call('filter',M.merge_tbl)
    call('extension',M.merge_tbl)
    call('integration',M.merge_tbl)
    vim.list_extend(out,def)
    vim.list_extend(out,conf)
    local pairs=vim.defaulttable(function() return {} end)
    for k,v in ipairs(conf) do
        table.insert(pairs[v[1]:gsub(';',';;')..';-'..v[2]],k)
    end
    for k,v in ipairs(def) do
        table.insert(pairs[v[1]:gsub(';',';;')..';-'..v[2]],k)
    end
    for _,v in ipairs(conf.change or {}) do
        assert(pairs[v[1]:gsub(';',';;')..';-'..v[2]],('ultimate-autopair: configuration: trying to change pair %s,%s which does not exist'):format(v[1],v[2]))
        for _,key in ipairs(pairs[v[1]:gsub(';',';;')..';-'..v[2]]) do
            out[key]=M.merge_tbl21(out[key],v)
            out[key][1]=v[1]
            out[key][2]=v[2]
        end
    end
    for _,v in ipairs(def.change or {}) do
        assert(not _G.UA_DEV or pairs[v[1]:gsub(';',';;')..';-'..v[2]])
    end
    return out
end
---@param conf ua.prof.pair.conf
---@param pair ua.prof.pair.conf.pair
---@return ua.prof.pair.conf.pair
function M.pair_init(conf,pair,_sub)
    assert(conf.merge~=false)
    if pair.merge==false then return pair end
    local out={}
    local filters={}
    for k,_ in pairs(conf.filter) do
        filters[k]=pair[k]
    end
    out.filter=M.merge_tbl21(conf.filter,filters)
    if pair.ft and vim.tbl_get(out,'filter','filetype') then
        out.filter.filetype.ft=M.merge_list(out.filter.filetype.ft or {},pair.ft)
    end
    if pair.nft and vim.tbl_get(out,'filter','filetype') then
        out.filter.filetype.nft=M.merge_list(out.filter.filetype.nft or {},pair.nft)
    end
    if _sub then return out end
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
    out.map_modes=pair.map_modes or conf.pair_map_modes
    return out
end
return M
