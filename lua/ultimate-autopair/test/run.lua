---@diagnostic disable-next-line: undefined-field
if _G.UA_IN_TEST then
    function vim.lg(...)
        local d=debug.getinfo(2)
        return vim.fn.writefile(vim.fn.split(
            ':'..d.short_src..':'..d.currentline..':\n'..
            vim.inspect(#{...}==1 and ... or {...}),'\n'
        ),'/tmp/nlog','a')
    end
end
local M={}
return M
