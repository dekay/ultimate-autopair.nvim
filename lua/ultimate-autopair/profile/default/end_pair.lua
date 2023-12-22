local M={}
function M.run(o)
    local m=o.m.object
    vim.lg(o.line:sub(o.col,o.col+#m.end_pair-1))
    if o.line:sub(o.col,o.col+#m.end_pair-1)~=m.end_pair then return end
    return {
        {'right',m.end_pair},
    }
end
function M.init(start_pair,end_pair)
    return {
        run=M.run,
        object={start_pair=start_pair,end_pair=end_pair},
        hooks={'i;map;'..end_pair},
        doc=('autopairs end pair: %s,%s'):format(start_pair,end_pair),
    }
end
return M
