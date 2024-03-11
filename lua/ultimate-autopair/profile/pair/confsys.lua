local M={}
--DEFAULT VALUES SHOULD ONLY BE USED ONCE (once implemented into the specification), OTHERWISE ASSERT AN ERROR
M.config_specification={
    main={
        is_arrayish=true,
        inherit_keys={'maps'},
        key_value={
            map_modes='modes',
            pair_map_modes='modes',
            multiline='boolean',
            p='number',
            filter='filters',
        },
        array_value='pair',
    },
    pair={
        inherit_keys={'basepair'},
        key_value={
            --TODO: specify that some values need to be set, while others are optional
            [1]='string',
            [2]='string',
            start_pair='basepair',
            end_pair='basepair',
        },
    },
    basepair={ --OOP lets gooo
        inherit_keys={'maps','filters'},
        key_value={
            --TODO: specify that some values need to be set, while others are optional
            modes='modes',
            ft='array_of_strings',
            nft='array_of_strings',
            multiline='boolean',
            p='number',
        }
    },
    maps={
        key_value={
            backspace='backspace',
            newline='newline',
            space='space',
        }
    },
    filters={
        key_value={
            alpha='alpha',
            cmdtype='cmdtype',
            filter='filter',
            escape='escape',
            filetype='filetype',
            tsnode='tsnode',
        },
    },
    alpha={
        inherit_keys={'basefilter'},
        key_value={
            before='boolean',
            after='boolean',
            py_fstr='boolean',
        }
    },
    cmdtype={
        inherit_keys={'basefilter'},
        key_value={
            skip='array_of_strings',
        }
    },
    escape={
        inherit_keys={'basefilter'},
        key_value={
            escapechar='string'
        }
    },
    filetype={
        inherit_keys={'basefilter'},
        key_value={
            ft='array_of_strings',
            nft='array_of_strings',
            detect_after='boolean',
        }
    },
    filter={
        inherit_keys={'basefilter'},
    },
    tsnode={
        inherit_keys={'basefilter'},
        key_value={
            p='number',
            lang_detect_after='boolean',
            separate='array_of_strings',
        }
    },
    basefilter={
        key_value={
            modes='modes',
            p='number',
        }
    },
    backspace={
        inherit_keys={'basemap'},
        key_value={
            overjump='boolean',
        }
    },
    space={
        inherit_keys={'basemap'},
    },
    newline={
        inherit_keys={'basemap'},
    },
    basemap={
        key_value={
            modes='modes',
            p='number',
            enable='boolean',
            map='map',
        }
    },
    map={
        is_special=true,
    },
    mode={
        is_enum=true,
        enum_values={'n','v','x','s','o','!','i','l','c','t',''},
    },
    modes={
        is_arrayish=true,
        array_value='mode',
    },
    boolean={ --Should be inlined
        is_enum=true,
        enum_values={true,false},
    },
    string={ --Should be inlined
        is_type=true,
        validator=function (x) return type(x)=='string' end
    },
    number={ --Should be inlined
        is_type=true,
        validator=function (x) return type(x)=='number' end
    },
    array_of_strings={
        is_arrayish=true,
        array_value='string',
    }
}
function M.validate(conf,_t)
    local spec=M.config_specification[_t]
    if spec.is_type then
        assert(spec.validator(conf))
        return
    elseif spec.is_special then
        return
    elseif spec.is_enum then
        assert(vim.tbl_contains(spec.enum_values,conf))
        return
    end
    local keys=vim.tbl_keys(conf)
    local tokeys=vim.deepcopy(spec.key_value) or {}
    local toinherit=vim.deepcopy(spec.inherit_keys or {})
    tokeys.merge='boolean'
    while #toinherit>0 do
        local i_t=table.remove(toinherit)
        local ispec=M.config_specification[i_t]
        if ispec.inherit_keys then
            vim.list_extend(toinherit,ispec.inherit_keys)
        end
        for k,v in pairs(ispec.key_value) do
            tokeys[k]=v
        end
    end
    if spec.is_arrayish then
        for idx,k in pairs(keys) do
            if type(k)=='number' then
                M.validate(conf[k],spec.array_value)
                keys[idx]=nil
            end
        end
    end
    for _,k in pairs(keys) do
        assert(tokeys[k])
        M.validate(conf[k],tokeys[k])
    end
end
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
    if new.merge==false or origin==nil or (new.merge~=true and origin.merge==false) then
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
    if new.merge~=true and origin.merge==false then
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
    local function last(c)
        for k,v in ipairs(c) do
            c[k]=M.pair_init(c,v)
        end
        return c
    end
    if conf==nil then
        local out=setmetatable({},{__index=def})
        if out.pair_map_modes==nil then
            out.pair_map_modes=def.map_modes
        end
        for k,v in ipairs(def) do
            out[k]=M.pair_init(out,v)
        end
        for _,v in pairs(require'ultimate-autopair.profile.pair.map'.maps) do
            out[v]=setmetatable({modes=def.map_modes},{__index=def[v]})
        end
        return out
    end
    if conf.merge==false then return last(setmetatable({},{__index=conf})) end
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
    for _,v in pairs(require'ultimate-autopair.profile.pair.map'.maps) do
        merge_idx(v)
        out[v]=setmetatable({modes=M.merge_list(out.map_modes,out[v].modes)},{__index=out[v]})
    end
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
    return last(out)
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
