local M={}
local utils=require'ua.ultils'
function M.call(m)
    utils.regeister_check(m,function(_,cb,conf)
        local cmdtype=utils.get_cmdtype()
        if not vim.tbl_contains(cmdtype,conf.skip) then
            return cb() --TODO: maybe don't use cb but instead return a value? false|nil: stop, true: continue, string|table: stop and do return action
        end
    end,{
            config={
                skip={'string[]',merge=true}, --merg: whether to merge conf and pair conf options
            }
        })
end
return M
