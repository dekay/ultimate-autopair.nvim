local M={}
local utils=require'ua.ultils'
M.fns={
    in_macro=function ()
        return vim.fn.reg_recording()~='' or vim.fn.reg_executing()~=''
    end,
    in_string=function (opt,col,row)
        local new_o=utils._get_o_pos(opt.o,col,row)
        local tsnode=require'ultimate-autopair.extension.tsnode'
        local node=tsnode._in_tsnode(new_o,{'string','raw_string'},opt.incheck)
        return node and node~=node:tree():root()
    end,
    in_check=function (opt)
        return opt.incheck
    end,
    in_cmdline=function (opt)
        return opt.o.incmd
    end,
    in_lisp=function (opt,col,row,notree)
        if notree then return vim.o.lisp end
        local new_o=utils._get_o_pos(opt.o,col,row)
        local ft=utils.getsmartft(new_o)
        return vim.filetype.get_option(ft,'lisp')
    end,
    in_node=function (opt,nodes,col,row)
        local new_o=utils._get_o_pos(opt.o,col,row)
        local tsnode=require'ultimate-autopair.extension.tsnode'
        local node=tsnode._in_tsnode(new_o,type(nodes)=='string' and {nodes} or nodes,opt.incheck)
        return node and node~=node:tree():root() and node or nil
    end,
    is_pair=function (opt)
        return opt.m.type=='pair'
    end,
    is_start_pair=function (opt)
        return opt.m.type=='start'
    end,
    is_end_pair=function (opt)
        return opt.m.type=='end'
    end,
    is_ambiguous_pair=function (opt)
        return opt.m.type=='ambiguous'
    end,
    get_ft=function (opt,col,row,notree)
        return utils.getsmartft(opt.o:new_pos(col,row),notree)
    end,
    get_mode=function (_,complex)
        return utils.getmode(complex)
    end,
    get_cmdtype=function ()
        return utils.getcmdtype()
    end,
}
function M.init_fns(opt)
    return setmetatable({},{__index=function(tbl,k)
        tbl[k]=function (...) M.fns[k](opt,...) end
        return rawget(tbl,k)
    end})
end
function M.call(m)
    utils.register_check(m,function(o,cb,conf)
        if not conf.cond then return cb() end
        local fns=M.init_fns({o=o,m=m,incheck=o.incheck})
        for _,v in ipairs(conf.cond) do
            if not v(fns,o,m) then return end
        end
        return cb()
    end,{
            if_checks={
                utils.OPTION_TO_FILTER, --probably uneeded, the user can specifi themself
            },
            special_pair_configs={cond='cond'},
            config={cond={'function[]',single_to_table=true,merge=true}},
        })
end
return M
