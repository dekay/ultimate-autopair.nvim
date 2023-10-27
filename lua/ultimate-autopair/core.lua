local M={I={}}
M.INSERT_NOOP='a\b'
---@param str string
---@return string
function M.I.keycode(str)
  return vim.api.nvim_replace_termcodes(str,true,true,true)
end
---@param keys string
function M.I.feedkeys(keys)
    vim.api.nvim_feedkeys(keys,'n',false)
end
---@param pos number[]
function M.I.gotopos(pos)
    if pos[2] then M.I.feedkeys(M.I.keycode'<cmd>'..pos[2]..'\r') end
    M.I.feedkeys(M.I.keycode'<C-o>'..pos[1]..'|')
end
---@param modules ua.module[]
---@param o fun(m:ua.module):ua.o
---@param fallback string|table
---@return string|table
function M._eval(modules,o,fallback)
    for _,mod in ipairs(modules) do
        local ret=mod.check(o(mod))
        if ret then return ret end
    end
    return fallback
end
---@param code string|table
function M._run(code)
    if type(code)=='string' then M.I.feedkeys(code) return end
    for _,v in pairs(code) do
        if type(v)=='string' then
            M.I.feedkeys(v)
        else
            M.I.gotopos(v)
        end
    end
    if vim.fn.mode()=='i' then
        M.I.feedkeys(M.INSERT_NOOP)
    end
end
return M
