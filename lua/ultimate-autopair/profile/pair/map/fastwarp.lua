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
function M.run(o)
    local m=o.m --[[@as ua.prof.pair.fastwarp]]
    local info=m.info
    local epairs=putils.forward_get_end_pairs(o,info.pairs)
    for _,epair in ipairs(epairs) do
        local count=0 --TODO: better input for if first
        for col=o.col+#epair.info.end_pair,#o.line do
            count=count+1
            for _,v in ipairs(M.act) do
                local ret=v(setmetatable({col=col},{__index=o}),col,epair.info.end_pair,count==1)
                if ret then return ret end
            end
        end
        if o.col~=#o.line then
            return {
                {'delete',0,epair.info.end_pair},
                {'pos',#o.line},
                epair.info.end_pair,
                {'pos',o.col},
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
