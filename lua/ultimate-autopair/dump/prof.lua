local M={}
---@param id ua.id
---@param conf ua.prof.config[]
---@return ua.modulo[]
function M.init(id,conf)
    _=conf
    return {
        {
            get=function ()
                return {{type='key',key='(',mode='i'}}
            end,
            check=function ()
                return '()'..vim.keycode'<Left>'
            end,
            doc='autopair ()',
            id=id,
            p=10,
        }
    }
end
return M
