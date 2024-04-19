local putils=require'ultimate-autopair.profile.pair.utils'
---@class ua.prof.pair.fastwarp.info
---@field pairs ua.prof.pair.pair[]
---@class ua.prof.pair.fastwarp:ua.object
---@field info ua.prof.pair.fastwarp.info
---@class ua.prof.pair.fastwarp.conf:ua.prof.pair.map.conf

local M={}
---@type (fun(o:ua.info,ind:number,p:string,first:boolean):ua.actions|nil)[]
M.act={
    function (o,ind,p)
        if not o.line:sub(ind,ind):match('%w') then return end
        while o.line:sub(ind,ind):match('%w') do
            ind=ind+1
        end
        return {
            {'delete',0,p},
            {'pos',ind-1},
            p,{'left',p},
        }
    end,
    function (o,ind,p,first)
        if first then return end
        local next_spair=putils.forward_get_start_pairs(o,o.m.info.pairs)
        if #next_spair==0 then return end
        return {
            {'delete',0,p},
            {'pos',ind-1},
            p,{'left',p},
        }
    end
}
---@param o ua.info
---@return ua.actions|nil
function M.run(o,_rec)
    local m=o.m --[[@as ua.prof.pair.fastwarp]]
    local info=m.info
    local spairs=putils.backwards_get_start_pairs(o,info.pairs)
    for _,spair in ipairs(_rec and {} or spairs) do
        local opair=setmetatable({m=spair},{__index=o})
        local col,row=putils.next_open_end_pair(opair)
        if col and row
            and putils.pair_balansed_start(opair)
        then
            local act=M.run(setmetatable({col=col,row=row},{__index=o}),true)
            if act then
                table.insert(act,1,{'pos',col,row})
                table.insert(act,{'pos',o.col,o.row})
                return act
            end
        end
    end
    local epairs=putils.forward_get_end_pairs(o,info.pairs)
    for _,epair in ipairs(epairs) do
        for col=o.col+#epair.info.end_pair,#o.line do
            for _,v in ipairs(M.act) do
                local ret=v(setmetatable({col=col},{__index=o}),col,epair.info.end_pair,col==o.col+#epair.info.end_pair)
                if ret then return ret end
            end
        end
        if o.col~=#o.line then
            return {
                {'delete',0,epair.info.end_pair},
                {'pos',#o.line},
                epair.info.end_pair,
                {'left',epair.info.end_pair},
            }
        else
            return {
                {''},
            }
        end
    end
end

---@param somepairs ua.prof.pair.pair
---@param conf ua.prof.pair.fastwarp.conf
---@return ua.prof.pair.fastwarp
function M.init(somepairs,conf)
    ---@type ua.prof.pair.fastwarp
    return putils.create_obj(conf,{
        run=M.run,
        info={pairs=somepairs},
        doc='autopairs fastwarp',
    })
end
return M
