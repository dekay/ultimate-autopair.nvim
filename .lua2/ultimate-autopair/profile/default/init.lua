local M={}
---@param conf ua.prof.conf
---@param objects ua.object[]
function M.init(conf,objects)
    for _,v in pairs(conf) do
        local obj=require('ultimate-autopair.profile.default.start_pair').init(v[1],v[2])
        table.insert(objects,obj)
    end
end
return M
