local M={}
---@param o ua.info
---@param conf table
---@return ua.actions?
function M.run(o,conf)
    local no=setmetatable({},{__index=o})
    while true do
        if vim.tbl_contains(conf.jump_other_char or {},no.line:sub(no.col,no.col)) then
        elseif false then
            break
        else
            return
        end
        no.col=no.col+1
        if no.col>#o.line then
            if not conf.multiline then return end
            no.col=1
            o.row=o.row+1
        end
    end
    return {{'pos',o.row,o.col}}
end
M.ext_type={
    'after',
    'alternative', --If the normal action is done, don't ever do this one (especially hook.last_act_cycle)
}
M.conf={
    fly='boolean',
    multiline='boolean',
    jump_non_end_pair='boolean',
    jump_other_char='string[]',
}
return M
