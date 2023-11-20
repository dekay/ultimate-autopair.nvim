local M={}
local utils=require'ua.ultils'
function M.call(m)
    utils.register_check(m,function (o,cb,conf)
        if conf.after then
            if utils.is_alpha(o.line:sub(o.ecol,vim.str_utf_end(o.line,o.ecol)+o.ecol)) then
                return
            end
        end
        if conf.alpha then
            if utils.is_alpha(o.line:sub(vim.str_utf_start(o.line,o.scol-1)+o.scol-1,o.scol-1)) then
                return
            end
        end
        return cb()
    end,{
            if_checks={utils.ONLY_NORMAL_TEXT,
                utils.OPTION_TO_FILTER, --probably uneeded, the user can specifi themself
            },
            special_pair_configs={
                alpha='alpha', --instead of alpha_alpha=alpha
            },
            config={alpha='boolean',after='boolean'}, --wil be trasformd to alpha and alpha_after for pair configs
        })
end
return M

