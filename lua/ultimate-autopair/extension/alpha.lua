---FI
local M={}
local utils=require'ultimate-autopair.utils'
local default=require'ultimate-autopair.profile.default.utils'
M.alpha_re=[=[[[=a=][=b=][=c=][=d=][=e=][=f=][=g=][=h=][=i=][=j=][=k=][=l=][=m=][=n=][=o=][=p=][=q=][=r=][=s=][=t=][=u=][=v=][=w=][=x=][=y=][=z=]]\a]=]
---@param o core.o
---@param m prof.def.module
---@param ext prof.def.ext
---@return boolean?
function M.check(o,m,ext)
    --TODO: check if incheck relative to not incheck
    --TODO: work for non pairs
    if ext.conf.alpha or m.conf.alpha then
        if not o.incmd and o.key=='"' or o.key=="'" and utils.getsmartft(o)=='python' and not ext.conf.no_python then
            if vim.regex([[\v\c<((r[fb])|([fb]r)|[frub])$]]):match_str(o.line:sub(o.col-1-#m.pair,o.col-#m.pair)) then
                return
            end
        end
        if vim.regex(M.alpha_re):match_str(o.line:sub(o.col-#m.pair)) then
            return true
        end
    end
    if ext.conf.after or m.conf.alpha_after then
        if vim.regex(M.alpha_re):match_str(o.line:sub(1,o.col)) then
            return true
        end
    end
end
---@param m prof.def.module
---@param ext prof.def.ext
function M.call(m,ext)
    if not default.get_type_opt(m,'charins') then return end
    local filter=m.filter
    m.filter=function(o)
        return filter(o)
    end
end
--TODO: continue
return M
