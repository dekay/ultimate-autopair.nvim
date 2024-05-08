local utils=require'ultimate-autopair.utils'
local open_pair=require'ultimate-autopair._lib.open_pair' --TODO:make user be able to chose the open_pair detector (separately for open_pair/find_pair/...)
local putils=require'ultimate-autopair.profile.pair.utils'

---@class ua.prof.pair.pair:ua.object
---@field start_pair string
---@field _filter table --TODO: the problem: extension.tsnode can be initialized for specific positions, which means that filter may change, MAYBE?: have a filter initialize function which initializes the filters for a position
---@field end_pair string
---@field main_pair? string
---@field multiline? boolean
---@field start_pair_filter table
---@field end_pair_filter table
---@field extension table
---@field type "start"|"end"
---@field ispair true
---@alias ua.prof.pair.conf table
---@alias ua.prof.pair.conf.pair table
local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run_start(o)
    o.lsave={}
    local m=o.m --[[@as ua.prof.pair.pair]]
    local last_char=m.start_pair:sub(-1+vim.str_utf_start(m.start_pair,#m.start_pair))
    local ret=putils.run_extension(m.extension,o)
    if ret then return ret end
    if o.line:sub(o.col-#m.start_pair+#last_char,o.col-1)~=m.start_pair:sub(0,-1-#last_char) then return end
    if not utils.run_filters(m.start_pair_filter,o,#m.start_pair-1) then
        return
    end
    if m.start_pair~=m.end_pair then
        local count=open_pair.count_end_pair(o)
        if open_pair.count_end_pair(o,true,count,true) then return end
    else
        if open_pair.count_ambiguous_pair(o,'both') then return end
    end
    return {
        last_char,
        m.end_pair,
        {'left',m.end_pair},
    }
end

---@param o ua.info
---@return ua.actions|nil
function M.run_end(o)
    o.lsave={}
    local m=o.m --[[@as ua.prof.pair.pair]]
    local ret=putils.run_extension(m.extension,o)
    if ret then return ret end
    if o.line:sub(o.col,o.col+#m.end_pair-1)~=m.end_pair then return end
    if not utils.run_filters(m.end_pair_filter,o,0,-#m.end_pair) then
        return
    end
    if m.start_pair~=m.end_pair then
        local count2=open_pair.count_start_pair(o)
        --Same as: count_open_end_pair_after
        local count1=open_pair.count_end_pair(o)
        --Same as: count_open_start_pair_before
        if count1==0 or count1>count2 then return end
    else
        if open_pair.count_ambiguous_pair(o,'both') then return end
    end
    return {
        {'right',m.end_pair},
    }
end
---@param pair ua.prof.pair.conf.pair
---@return ua.prof.pair.pair[]
function M.init(pair)
    ---TODO: pair may include hook options, so follow that
    local start_pair=pair[1]
    local end_pair=pair[2]

    local obj_mt={
        extension=pair.extension,
        start_pair=start_pair,
        end_pair=end_pair,
        multiline=pair.multiline,
        _filter={ --TODO:TEMP
            start_pair_filter=function (o)
                return utils.run_filters(pair.start_pair_filter,o,#start_pair-1,-1)
            end,
            end_pair_filter=function (o)
                return utils.run_filters(pair.end_pair_filter,o,#end_pair-1,-1)
            end
        },
        end_pair_filter=pair.end_pair_filter,
        start_pair_filter=pair.start_pair_filter,
        ispair=true,
    }
    return {
        setmetatable({
            main_pair=end_pair,
            type='end',
            run=M.run_end,
            hooks=putils.create_hooks(end_pair:sub(1,vim.str_utf_end(end_pair,1)+1),pair.map_modes),
            doc=('autopairs end pair: %s,%s'):format(start_pair,end_pair),
        },{__index=obj_mt}),
        setmetatable({
            run=M.run_start,
            main_pair=start_pair,
            type='start',
            hooks=putils.create_hooks(start_pair:sub(vim.str_utf_start(start_pair,#start_pair)+#start_pair),pair.map_modes),
            doc=('autopairs start pair: %s,%s'):format(start_pair,end_pair)
        },{__index=obj_mt}),
    }
end
return M
