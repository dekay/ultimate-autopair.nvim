local M={}
function M.run(o)
    local m=o.m.object
    return {
        m.start_pair,
        m.end_pair,
        {'left',m.end_pair},
    }
end
function M.init(start_pair,end_pair)
    return {
        run=M.run,
        object={start_pair=start_pair,end_pair=end_pair},
        hooks={'i;map;'..start_pair},
    }
end
return M
