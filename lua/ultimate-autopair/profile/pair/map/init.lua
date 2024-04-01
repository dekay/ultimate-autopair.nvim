local M={}
M.maps={
    bs='backspace',
    cr='newline',
    space='space',
    fastwarp='fastwarp',
}
---@param objects ua.instance
---@param somepairs ua.prof.pair.pair[]
---@param conf ua.prof.pair.conf
function  M.init(objects,somepairs,conf)
    for mapname,confname in pairs(M.maps) do
        local mapobj=require('ultimate-autopair.profile.pair.map.'..mapname).init(somepairs,conf[confname])
        if mapobj then
            table.insert(objects,mapobj)
        end
    end
end

return M
