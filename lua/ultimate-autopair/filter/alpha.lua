local M={}
local utils=require'ultimate-autopair.utils'
---@param o ua.filter
---@return boolean?
function M.call(o)
    if o.conf.after then
        if utils.is_keywordy(utils.get_char(o.line,o.cole),o) then
            return
        end
    end
    if o.conf.before then
        if o.conf.py_fstr and
            utils.get_filetype(o)=='python' and
            vim.regex[[\c\a\@1<!\v((r[fb])|([fb]r)|[frub])$]]:match_str(o.line:sub(1,o.cols-1)) then
            return true
        end
        if utils.is_keywordy(utils.get_char(o.line,o.cols-1),o) then
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
