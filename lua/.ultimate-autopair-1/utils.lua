local M={}
---@param hash ua.hook.hash
---@return fun(m:ua.module):ua.o
function M.get_o_creator(hash)
    local go=M.create_go(hash)
    return function (m)
        local o=setmetatable({m=m},{__index=go})
        return setmetatable({},{__index=o})
    end
end
---@param hash ua.hook.hash
---@return table
function M.create_go(hash)
    return {hash=hash}
end
---@generic T:string|string?
---@param str T
---@return T
function M.keycode(str)
  return str and vim.api.nvim_replace_termcodes(str,true,true,true)
end
M.key_bs=M.keycode'<bs>'
M.key_del=M.keycode'<del>'
M.key_left=M.keycode'<left>'
M.key_right=M.keycode'<right>'
M.key_end=M.keycode'<end>'
M.key_home=M.keycode'<home>'
M.key_up=M.keycode'<up>'
M.key_down=M.keycode'<down>'
return M
