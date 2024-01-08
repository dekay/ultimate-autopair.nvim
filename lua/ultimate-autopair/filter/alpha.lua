local M={}
local utils=require'ultimate-autopair.utils'
---@param o ua.filter
---@return boolean?
function M.call(o)
    if o.conf.after then
        if utils.is_alpha(utils.get_char(o.line,o.cole)) then
            return
        end
    end
    if o.conf.before then
        if utils.is_alpha(utils.get_char(o.line,o.cols-1)) then
            return
        end
    end
    return true
end
M.conf={
    before='boolean',
    after='boolean',
}
return M
