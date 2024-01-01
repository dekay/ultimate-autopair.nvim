local open_pair=require'ultimate-autopair._lib.open_pair' --TODO:TEMP
local hookutils=require'ultimate-autopair.hook.utils'
local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    local info=(o.m --[[@as ua.prof.def.pair]]).info
    if info.start_pair~=info.end_pair then --TODO:TEMP
        local count2=open_pair.count_start_pair(o)
        --Same as: count_open_end_pair_after
        local count1=open_pair.count_end_pair(setmetatable({col=o.col-1},{__index=o}))
        --Same as: count_open_start_pair_before
        if count1==0 or count1>count2 then return end
    else
        local count=open_pair.count_ambiguous_pair(setmetatable({col=o.col-1},{__index=o})) and 1 or 0
        local end_count=open_pair.count_ambiguous_pair(o,true,count)
        if not (count==1 and not end_count) then return end
    end
    if o.line:sub(o.col,o.col+#info.end_pair-1)~=info.end_pair then return end
    return {
        {'right',info.end_pair},
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
            main_pair=end_pair,
            multiline=pair.multiline,
            _filter={ --TODO:TEMP
                start_pair_filter=function() return true end,
                end_pair_filter=function() return true end
            },
        },
        hooks={
            hookutils.to_hash('map',end_pair:sub(1,vim.str_utf_end(end_pair,1)+1),{mode='i'}),
            hookutils.to_hash('map',end_pair:sub(1,vim.str_utf_end(end_pair,1)+1),{mode='c'}),
        },
        doc=('autopairs end pair: %s,%s'):format(start_pair,end_pair),
    }
end
return M
