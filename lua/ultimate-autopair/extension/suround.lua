local M={}
local utils=require'ua.ultils'
function M.call(m)
    utils.register_check(m,function(o,cb,conf)
        if utils.is_open(m) then return cb() end
        if not conf.p.dosuround then return cb() end
        local spair=utils.get_pair_as_start(o,o.cole+1,{filter=function (p)
            return p.conf.fly
        end})
        if not spair then return cb() end
        local epair=utils.end_pair(spair)
        return utils.create_act{{epair.rowe+1,epair.cole+1},m.other_pair,{o.col,o.row},m.pair}
    end,{
            if_checks={utils.ONLY_START_PAIR,utils.ONLY_INSERT},
            pair_config={suround='boolean',dosuround='boolean'},
        })
end
return M
