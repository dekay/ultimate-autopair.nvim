local M={}
function M.run(o)
    local info=o.m.info
    if o.line:sub(o.col,o.col+#info.end_pair-1)~=info.end_pair then return end
    return {
        {'right',info.end_pair},
    }
end
function M.init(start_pair,end_pair)
    return {
        run=M.run,
        info={start_pair=start_pair,end_pair=end_pair},
        hooks={'i;map;'..end_pair:sub(1,vim.str_utf_end(end_pair,1)+1)},
        doc=('autopairs end pair: %s,%s'):format(start_pair,end_pair),
    }
end
return M
