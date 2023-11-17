local M={}
--TODO
local utils=require'ua.ultils'
function M.call(m)
    utils.register_check(m,function (o,cb,conf)

        return cb()
    end,{
            if_checks={utils.ONLY_END_PAIR,utils.ONLY_INSERT,
                utils.OPTIOM_PAIR_CONF_CAN_ENABLE, --probably uneeded, the user can specifi themself
            },
            no_filter=true,
            config={nofilter='boolean',only_jump_end_pair='boolean',other_char='string'},
            globa_config={undomap='string',undocmap='string',undomapconf='table'},
        },{
        })
end
return M

