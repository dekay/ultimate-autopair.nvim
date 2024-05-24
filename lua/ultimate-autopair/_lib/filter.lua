local utils=require'ultimate-autopair.utils'
local M={}
---@param o ua.filter
function M.in_lisp(o)
    local ft=utils.get_filetype(o)
    return utils.ft_get_option(ft,'lisp')
end
---@param o ua.filter
function M.in_string(o)
    return false --TODO
end
---@param o ua.filter
function M.in_comment(o)
    return false --TODO
end
---@param o ua.filter
---@param procnames string[]?
---@return boolean|2
function M.term_in_shell_or_vim(o,procnames)
    if o.source.o.channel==0 then
        return 2
    end
    procnames=procnames or {
        'sh',
        'bash',
        'zsh',
        'fish',
        'nvim',
        'vim',
    }
    local function in_not_allowed_proc(pid)
        if not vim.tbl_contains(procnames,vim.api.nvim_get_proc(pid).name) then return true end
        ---NOTE: nvim_get_proc_children sometimes doesn't return all children
        for _,v in ipairs(vim.api.nvim_get_proc_children(pid)) do
            if in_not_allowed_proc(v) then return true end
        end
    end
    return not in_not_allowed_proc(vim.fn.jobpid(vim.o.channel))
end
return M
