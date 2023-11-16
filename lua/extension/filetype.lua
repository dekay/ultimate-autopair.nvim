local M={}
local utils=require'ua.ultils'
function M.call(m)
    utils.regeister_check(m,function(o,cb,conf)
        local ft=utils.getsmartft(o,not conf.tree)
        if conf.ft and not vim.tbl_contains(conf.ft,ft) then
        elseif conf.nft and vim.tbl_contains(conf.nft,ft) then
        else return cb() end
    end,{
            config={tree='boolean',ft={'string[]',merge=true},nft={'string[]',merge=true}}, --TODO, an option to disable merging, per option
            special_pair_configs={
                ft='ft',
                nft='nft',
            },
        })
end
return M
