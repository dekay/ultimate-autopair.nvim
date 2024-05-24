local utils=require'ultimate-autopair.utils'
local M={}
---@param o ua.filter
function M.in_lisp(o)
    local ft=utils.get_filetype(o)
    return utils.ft_get_option(ft,'lisp')
end
---@param o ua.filter
function M.in_string(o)
    local query=require'ultimate-autopair._lib.query'
    local parser=o.source.get_parser()
    if not parser then
        --TODO: some simple regex matching
        return false
    end
    local nodes=query.find_all_node_types(parser,{'string' --[[TODO: add other string node types]]})
    local range={o.rows-1,o.cols-1,o.rowe-1,o.cole-1}
    for _,node in ipairs(nodes) do
        local trange={node:range()}
        --NOTE: whether it is inclusive or not depends on the string, but as most strings are not inclusive
        if utils.range_in_range(trange,range,false) then
            return true
        end
    end
    return false
end
---@param o ua.filter
function M.in_comment(o)
    local query=require'ultimate-autopair._lib.query'
    local parser=o.source.get_parser()
    if not parser then
        --TODO: some simple regex matching (using commentstring)
        return false
    end
    local nodes=query.find_all_node_types(parser,{'comment' --[[TODO: add other comment node types]]})
    local range={o.rows-1,o.cols-1,o.rowe-1,o.cole-1}
    for _,node in ipairs(nodes) do
        local trange={node:range()}
        --NOTE: whether it is inclusive or not depends on the comment, but as most comments are inclusive
        if utils.range_in_range(trange,range,true) then
            return true
        end
    end
    return false
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
