local hookutils=require'ultimate-autopair.hook.utils'
local putils=require'ultimate-autopair.profile.pair.utils'
---@class ua.prof.pair.space.info
---@field get_pairs fun():ua.prof.pair.pair[]
---@class ua.prof.pair.space:ua.object
---@field info ua.prof.pair.space.info
---@class ua.prof.pair.space.conf:ua.prof.pair.map.conf

local M={}
---@param o ua.info
---@return ua.actions|nil
function M.run(o)
    local m=o.m --[[@as ua.prof.pair.space]]
    local info=m.info
    local first_col=o.line:sub(1,o.col-1):find(' *$')
    local total=o.col-first_col
    local spairs=putils.backwards_get_start_pairs(setmetatable({col=first_col},{__index=o}),info.get_pairs())
    for _,spair in ipairs(spairs) do
        local opair=setmetatable({m=spair},{__index=o})
        local col,row=putils.next_open_end_pair(opair)
        if not row or not col then goto continue end
        local ototal=#o.line:sub(o.col,col-1):reverse():match('^ *')
        if ototal>total then goto continue end
        if putils.pair_balansed_end(opair) then
            return {
                ' ',
                {'pos',col+1,row},
                (' '):rep(total-ototal+1),
                {'pos',o.col+1,o.row},
            }
        end
        ::continue::
    end
end
---@param objects ua.object[]
---@param conf ua.prof.pair.space.conf
---@return ua.prof.pair.space
function M.init(objects,conf)
    --TODO: each pair may have it's own space config defined (!which may include disabling space!)
    --TODO: how to do the autocmd stuff... (should only need to change the hook, no other config neceserry (will carry over to make autopair after alpha insert possible))
    ---@type ua.prof.pair.space
    return putils.create_obj(conf,{
        run=M.run,
        info={get_pairs=function () return putils.get_pairs(objects) end},
        doc='autopairs space',
    })
end
return M
