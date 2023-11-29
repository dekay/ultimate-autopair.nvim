local M={}
local utils=require'ua.ultils'
function M.call(m)
    utils.register_check(m,function (o,cb)
        local col=o.cols-1
        for _,v in ipairs({'\\'}) do
            local escape=false
            while o.line:sub(col,col)==v do
                col=col-1
                escape=not escape
            end
            if escape then return end
        end
        return cb()
    end,{
            if_checks={utils.ONLY_STRING_TEXT,
                utils.OPTION_TO_FILTER, --probably uneeded, the user can specifi themself
                utils.OPTIOM_PAIR_CONF_CAN_DISABLE, --probably uneeded, the user can specifi themself
            },
        })
end
return M

