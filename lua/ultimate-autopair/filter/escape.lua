local M={}
---@param o ua.filter
---@return boolean?
function M.call(o)
    local col=o.cols-1
    local escape=false
    while o.line:sub(col,col)=='\\' do
        col=col-1
        escape=not escape
    end
    return not escape
end
return M
