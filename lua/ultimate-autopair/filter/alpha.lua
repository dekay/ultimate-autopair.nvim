local M={}
local utils=require'ua.ultils'
function M.call(o)
    if o.conf.after then
        if utils.is_alpha(o.line:sub(o.ecol,vim.str_utf_end(o.line,o.ecol)+o.ecol)) then
            return
        end
        if o.conf.alpha then
            if utils.is_alpha(o.line:sub(vim.str_utf_start(o.line,o.scol-1)+o.scol-1,o.scol-1)) then
                return
            end
        end
        return true
    end
end
M.conf={
    before='boolean',
    after='boolean',
}
return M
