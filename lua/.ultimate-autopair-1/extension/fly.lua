local M={save={}}
local utils=require'ua.ultils'
function M.undo(o)
    if M.save[1]~=o.rowe or M.sace[2]~=o.cole then return end
    return utils.create_act{{M.save[1],M.save[3]},M.save[4]}
end
function M.init_module(conf,mconf)
    --This function audo defaults specific values to mconf if conf not set
    --And also lazy loads extensions
    return utils.create_map({
        p=conf.p, --maybe uneeded, can be infered
        doc='autopairs undo fly keymap',
        map=conf.undomap,
        cmap=conf.udocmap,
        conf=conf, --maybe uneeded, can be infered
        ext_conf=conf.undomapconf,
        check=M.undo,
    },mconf)
end
function M.call(m)
    utils.register_check(m,function (o,cb,conf)
        if not conf.p.fly then return cb() end
        local i=o.cole+1
        while true do
            local pair=utils.get_pair_as_start(o,i,{nofilter=conf.nofilter})
            if conf.other_char and conf.other_char:match(o.text:sub(i,i)) then
            elseif pair and m._pair==pair.pair then break
            elseif pair and pair.type=='end' and pair.conf.fly then
            elseif pair and pair.type~='end' and pair.conf.fly and conf.only_jump_end_pair then
            else return cb() end
            i=i+(pair and #pair.pair or 1)
        end
        M.save={o.rowe,o.col,i,m.pair}
        return utils.create_act{{o.rowe,i}}
    end,{
            if_checks={utils.ONLY_END_PAIR,utils.ONLY_INSERT,
                utils.OPTIOM_PAIR_CONF_CAN_ENABLE, --probably uneeded, the user can specifi themself
            },
            pair_config={fly='boolean'},
            no_filter=true,
            config={nofilter='boolean',only_jump_end_pair='boolean',other_char='string'},
            globa_config={undomap='string',undocmap='string',undomapconf='table'},
        })
end
return M

