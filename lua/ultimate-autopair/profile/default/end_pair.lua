local utils=require'ultimate-autopair.utils'
local M={}
function M.run(o)
    local m=o.m.object
    vim.lg(o.line:sub(o.col,o.col+#m.end_pair-1))
    if o.line:sub(o.col,o.col+#m.end_pair-1)~=m.end_pair then return end
    return (vim.keycode'<Right>'):rep(utils.len(m.end_pair))
end
function M.init(start_pair,end_pair)
    return {
        run=M.run,
        object={start_pair=start_pair,end_pair=end_pair},
        hooks={'i;map;'..end_pair},
    }
end
return M
