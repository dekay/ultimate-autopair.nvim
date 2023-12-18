local M={}
---@param conf ua.prof.conf
---@param objects ua.object[]
function M.init(conf,objects)
    for _,v in pairs(conf) do
        local objs=require('ultimate-autopair.profile.default.start_pair').init(v[1],v[2])
        table.insert(objects,objs)
        local obje=require('ultimate-autopair.profile.default.end_pair').init(v[1],v[2])
        table.insert(objects,obje)
    end
end
return M
