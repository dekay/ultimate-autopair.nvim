local M={}
function M.init(_,mem,id)
    table.insert(mem,{
        id=id,
        get=function ()
            return {{type='key',mode='i',key='('}}
        end,
        check=function () return 'a' end
    })
end
return M
