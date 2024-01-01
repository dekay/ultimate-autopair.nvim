local M={}
local utils=require'ultimate-autopair.ultils'
---@param o ua.filter
function M.call(o)
    if o.conf.after then
        if utils.is_alpha(o.line:sub(o.cole,vim.str_utf_end(o.line,o.cole)+o.cole)) then
            return
        end
        if o.conf.alpha then
            if utils.is_alpha(o.line:sub(vim.str_utf_start(o.line,o.cols-1)+o.cols-1,o.cols-1)) then
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
