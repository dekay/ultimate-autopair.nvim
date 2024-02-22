local M={}
local in_lisp=function (fn)
    return not fn.in_lisp() or fn.in_string() or fn.in_comment()
end
M.conf={ --TODO
    _t='t',
    map_modes={_v={'i','c'},_vc={},_t='t',full_mode={false}},
    pair_map_modes={_v=nil,_vc={_t='s'},_t='t',fallback=function (conf) return conf.map_modes end}, --TODO: _fallbacks should be calculated after the whole config is initialized
    _v={
        {'(',')'},
    },
    _i={'pairs',{
        {'(',')'},
    }},
    _objects={
        pair_1={
            _t='t',
        },
        pairs_2={
            _vc={
                _t='t',
                [1]={nil,_t='s',_r=true},
                [2]={nil,_t='s',_r=true},
                _i={'filters',nil},
                start_pair={
                    _i={'filters',nil},
                },
                end_pair={
                    _i={'filters',nil},
                },
            },
        },
    },
    change={
        _t='t',
        _i={'pairs',{}},
    },
}
function M.merge_val(origin,new)
    assert(type(origin)~='table')
    assert(type(new)~='table')
    if new~=nil then return new end
    return origin
end
function M.merge(origin,new)
    if type(vim.F.if_nil(origin,new))=='table' then
        return M.merge_tbl(origin,new)
    else
        return M.merge_val(origin,new)
    end
end
function M.merge_tbl(origin,new)
    if new==nil then return origin end
    if new.merge==false or origin==nil then
        return new
    end
    local out={}
    local keys={}
    local has={}
    for k,v in pairs(origin) do
        if type(k)=='number' then
            has[v]=true
            table.insert(out,v)
        else
            keys[k]=true
        end
    end
    for k,v in pairs(new) do
        if type(k)=='number' then
            if not has[v] then table.insert(out,v) end
        else
            keys[k]=true
        end
    end
    for k,_ in pairs(keys) do
        out[k]=M.merge(origin[k],new[k])
    end
    return out
end
function M.merge_list(origin,new)
    if new==nil then return origin end
    if new.merge==false or origin==nil then
        return new
    end
    local out={}
    local has={}
    for _,v in ipairs(origin) do
        has[v]=true
        table.insert(out,v)
    end
    for _,v in ipairs(new) do
        if not has[v] then table.insert(out,v) end
    end
    return out
end
---@param def ua.prof.pair.conf
---@param conf ua.prof.pair.conf?
function M.merge_configs(def,conf)
    if conf==nil then
        if def.pair_map_modes==nil then --TODO
            def.pair_map_modes=def.map_modes
        end
        return def
    end
    if conf.merge==false then return conf end
    assert(conf.profile==nil or conf.profile=='default' or conf.profile=='pair')
    assert(def.profile==nil or def.profile=='default' or def.profile=='pair')
    local out={}
    local function merge_idx(index,fallback)
        local ret=M.merge(def[index],conf[index])
        if ret==nil then ret=fallback end
        out[index]=ret
    end
    merge_idx('multiline')
    merge_idx('map_modes')
    merge_idx('pair_map_modes',out.map_modes)
    merge_idx('filter')
    merge_idx('extension')
    merge_idx('integration')
    vim.list_extend(out,M.merge_list(def,conf))
    local pairs=vim.defaulttable(function() return {} end)
    for k,v in ipairs(out) do
        table.insert(pairs[v[1]:gsub(';',';;')..';-'..v[2]],k)
    end
    for _,v in ipairs(conf.change or {}) do
        assert(pairs[v[1]:gsub(';',';;')..';-'..v[2]],('ultimate-autopair: configuration: trying to change pair %s,%s which does not exist'):format(v[1],v[2]))
        for _,key in ipairs(pairs[v[1]:gsub(';',';;')..';-'..v[2]]) do
            out[key]=M.merge_tbl(out[key],v)
            out[key][1]=v[1]
            out[key][2]=v[2]
        end
    end
    for _,v in ipairs(_G.UA_DEV and def.change or {}) do
        assert(pairs[v[1]:gsub(';',';;')..';-'..v[2]])
    end
    return out
end
---@param conf ua.prof.pair.conf
---@param pair ua.prof.pair.conf.pair
---@return ua.prof.pair.conf.pair
function M.pair_init(conf,pair,_sub)
    if pair.merge==false then return pair end
    local out={}
    local filters={}
    for k,_ in pairs(conf.filter or {}) do
        filters[k]=pair[k]
    end
    filters=M.merge_tbl(conf.filter,filters) or {}
    if pair.ft and filters.filetype then
        filters=vim.tbl_extend('force',filters,{})
        filters.filetype=setmetatable({ft=M.merge_list(filters.filetype.ft or {},pair.ft)},{__index=filters.filetype})
    end
    if pair.nft and filters.filetype then
        filters=vim.tbl_extend('force',filters,{})
        filters.filetype=setmetatable({nft=M.merge_list(filters.filetype.nft or {},pair.nft)},{__index=filters.filetype})
    end
    out.filter=filters
    if _sub then
        return out
    end
    --TODO: use out.start_pair.* and out.end_pair.* and have all options merged, so that something like enable-map doesn't require three options
    out.start_pair_filter=filters
    if pair.start_pair then
        out.start_pair_filter=M.merge_tbl(filters,M.pair_init(conf,pair.start_pair,true).filter)
    end
    out.end_pair_filter=filters
    if pair.end_pair then
        out.end_pair_filter=M.merge_tbl(filters,M.pair_init(conf,pair.end_pair).filter)
    end
    out[1]=pair[1]
    out[2]=pair[2]
    out.multiline=M.merge(conf.multiline,pair.multiline)
    out.map_modes=pair.map_modes or conf.pair_map_modes
    return out
end
return M
