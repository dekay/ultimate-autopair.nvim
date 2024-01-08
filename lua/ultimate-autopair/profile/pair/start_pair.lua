local hookutils=require'ultimate-autopair.hook.utils'
local open_pair=require'ultimate-autopair._lib.open_pair' --TODO:TEMP
local utils=require'ultimate-autopair.utils'
local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    local info=(o.m --[[@as ua.prof.def.pair]]).info
    if not utils.run_filters(info.filter_conf,o) then
        return
    end
    if info.start_pair~=info.end_pair then --TODO:TEMP
        local count=open_pair.count_end_pair(setmetatable({col=o.col-1},{__index=o}))
        if open_pair.count_end_pair(o,true,count+1,true) then return end
    else
        if open_pair.count_ambiguous_pair(o,'both') then return end
    end
    local last_char=info.start_pair:sub(-1+vim.str_utf_start(info.start_pair,#info.start_pair))
    if o.line:sub(o.col-#info.start_pair+#last_char,o.col-1)~=info.start_pair:sub(0,-1-#last_char) then return end
    return {
        last_char,
        info.end_pair,
        {'left',info.end_pair},
    }
end
---@param pair any
---@return ua.prof.def.pair
function M.init(pair)
    local start_pair=pair[1]
    local end_pair=pair[2]

    return {
        run=M.run,
        info={
            start_pair=start_pair,
            end_pair=end_pair,
            main_pair=start_pair,
            multiline=pair.multiline,
            _filter={ --TODO:TEMP
                start_pair_filter=function() return true end,
                end_pair_filter=function() return true end
            },
            filter_conf=pair.filter_conf, --TODO:TEMP
        },
        hooks={
            hookutils.to_hash('map',start_pair:sub(vim.str_utf_start(start_pair,#start_pair)+#start_pair),{mode='i'}),
            hookutils.to_hash('map',start_pair:sub(vim.str_utf_start(start_pair,#start_pair)+#start_pair),{mode='c'}),
        },
        doc=('autopairs start pair: %s,%s'):format(start_pair,end_pair)
    }
end
return M
