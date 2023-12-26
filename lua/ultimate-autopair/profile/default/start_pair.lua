local M={}
function M.run(o)
    local info=o.m.info
    return {
        info.start_pair,
        info.end_pair,
        {'left',info.end_pair},
    }
end
function M.init(start_pair,end_pair)
    local m={}
    m.run=M.run
    m.info={start_pair=start_pair,end_pair=end_pair}
    m.hooks={'i;map;'..start_pair:sub(vim.str_utf_start(start_pair,#start_pair)+#start_pair)}
    m.doc=('autopairs start pair: %s,%s'):format(start_pair,end_pair)
    return m
end
return M
