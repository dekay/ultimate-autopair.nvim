local open_pair=require'ultimate-autopair._lib.open_pair' --TODO:TEMP
local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    local info=(o.m --[[@as ua.prof.def.pair]]).info
    if info.start_pair~=info.end_pair then --TODO:TEMP
        local count=open_pair.count_end_pair(setmetatable({col=o.col},{__index=o}))
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
---@return ua.prof.def.pair
function M.init(start_pair,end_pair)
    local m={}
    m.run=M.run
    m.info={
        start_pair=start_pair,
        end_pair=end_pair,
        main_pair=start_pair,
        conf={}, --TODO:TEMP
        _filter={ --TODO:TEMP
            start_pair_filter=function() return true end,
            end_pair_filter=function() return true end
        },
    }
    m.hooks={'i;map;'..start_pair:sub(vim.str_utf_start(start_pair,#start_pair)+#start_pair)}
    m.doc=('autopairs start pair: %s,%s'):format(start_pair,end_pair)
    return m
end
return M
