local M={save={}}
local utils=require'ua.ultils'
function M.in_tsnode(o,nodetypes,half_pos)
    local save=utils.save(o.save,M.in_tsnode,nodetypes)
    local node,node2=utils.gettsnode(o,{half_pos=half_pos})

end
function M.get_node(o,conf)
    local node,node2=M.in_tsnode(o,conf.seperate,true)
    if not node then return {no_node=true} end
    local srow,scol,erow,ecol=utils.gettsnodepos(node,o)
    local t
    if node2 then
        local srow2,scol2,erow2,ecol2=utils.gettsnodepos(node2,o)
        t={srow=srow,scol=scol,erow=erow,ecol=ecol,srow2=srow2,scol2=scol2,erow2=erow2,ecol2=ecol2,in_node=node}
    end
    return {srow=srow,scol=scol,erow=erow,ecol=ecol,in_node=node},t
end
function M.call(m)
    utils.register_check(m,function (o,cb,conf)
        local save=o.save[M.save]
        if not save then
            local ssave,t=M.get_node(o,conf)
            if t then
                utils.split()
            end
            o.save[M.save]=ssave
            return cb()
        end
        if save.no_node then return cb() end
        return cb()
    end,{
            if_checks={
                utils.OPTION_TO_FILTER, --probably uneeded, the user can specifi themself
            },
            conf={seperate={'string[]',merge=true}}
        })
end
return M

