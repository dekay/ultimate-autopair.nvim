local M={}
M.maps={
    bs=true,
}
---@param objects ua.instance
---@param somepairs ua.prof.def.pair
function  M.init(objects,somepairs)
    for mapname,_ in pairs(M.maps) do
        table.insert(objects,require('ultimate-autopair.profile.pair.map.'..mapname).init(somepairs))
    end
end

return M
