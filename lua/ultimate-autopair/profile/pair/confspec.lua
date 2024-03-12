local M={}
--DEFAULT VALUES SHOULD ONLY BE USED ONCE (once implemented into the specification), OTHERWISE ASSERT AN ERROR
M.conf_spec={
    main={
        __inherit_keys={'maps'},
        __array_value='pair',
        map_modes='modes',
        pair_map_modes='modes',
        filter='filters',
        multiline='boolean',
        p='number',
    },
    pair={
        __inherit_keys={'basepair'},
        --TODO: specify that some values need to be set, while others are optional
        [1]='string',
        [2]='string',
        start_pair='basepair',
        end_pair='basepair',
    },
    basepair={ --OOP lets gooo
        __inherit_keys={'maps','filters'},
        --TODO: specify that some values need to be set, while others are optional
        modes='modes',
        ft='array_of_strings',
        nft='array_of_strings',
        multiline='boolean',
        p='number',
    },
    maps={
        backspace='backspace',
        newline='newline',
        space='space',
    },
    filters={
        alpha='alpha',
        cmdtype='cmdtype',
        filter='filter',
        escape='escape',
        filetype='filetype',
        tsnode='tsnode',
    },
    alpha={
        __inherit_keys={'basefilter'},
        before='boolean',
        after='boolean',
        py_fstr='boolean',
    },
    cmdtype={
        __inherit_keys={'basefilter'},
        skip='array_of_strings',
    },
    escape={
        __inherit_keys={'basefilter'},
        escapechar='string'
    },
    filetype={
        __inherit_keys={'basefilter'},
        ft='array_of_strings',
        nft='array_of_strings',
        detect_after='boolean',
    },
    filter={
        __inherit_keys={'basefilter'},
    },
    tsnode={
        __inherit_keys={'basefilter'},
        p='number',
        lang_detect_after='boolean',
        separate='array_of_strings',
    },
    basefilter={
        modes='modes',
        p='number',
    },
    backspace={
        __inherit_keys={'basemap'},
        overjump='boolean',
    },
    space={
        __inherit_keys={'basemap'},
    },
    newline={
        __inherit_keys={'basemap'},
    },
    basemap={
        modes='modes',
        p='number',
        enable='boolean',
        map='map',
    },
    map={
        __type='special',
    },
    mode={
        __type='enum',
        __data={'n','v','x','s','o','!','i','l','c','t',''},
    },
    modes={
        __array_value='mode',
    },
    boolean={ --Should be inlined
        __type='type',
        __data='boolean',
    },
    string={ --Should be inlined
        __type='type',
        __data='string',
    },
    number={ --Should be inlined
        __type='type',
        __data='number',
    },
    array_of_strings={ --Should be inlined
        __array_value='string',
    }
}
function M.validate(conf,spec_name)
    local spec=M.conf_spec[spec_name]
    if spec.__type=='type' then
        assert(type(conf)==spec.__data)
        return
    elseif spec.__type=='enum' then
        assert(vim.tbl_contains(spec.__data --[[@as table]],conf))
        return
    elseif spec.__type=='special' then
        return
    end
    local tspec=setmetatable({merge='boolean'},{__index=spec})
    local inherit=vim.deepcopy(tspec.__inherit_keys or {})
    while #inherit>0 do
        local i_spec_name=table.remove(inherit)
        local ispec=M.conf_spec[i_spec_name]
        if ispec.__inherit_keys then
            vim.list_extend(inherit,ispec.__inherit_keys)
        end
        for k,v in pairs(ispec) do
            tspec[k]=tspec[k] or v
        end
    end
    if tspec.__array_value then
        for k,_ in ipairs(conf) do
            tspec[k]=tspec.__array_value
        end
    end
    for k,v in pairs(conf) do
        assert(tspec[k])
        M.validate(v,tspec[k])
    end
end
return M
