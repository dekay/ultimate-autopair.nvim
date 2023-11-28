---@diagnostic disable: duplicate-set-field
function vim.pprint(...)
  local s,args=pcall(vim.deepcopy,{...})
  if not s then args={...} end
  vim.schedule_wrap(vim.notify)(vim.inspect(#args>1 and args or unpack(args)))
end
local M={path='/tmp/nlog'}
function vim.lg(...)
    if M.log_started==false then return end
    local d=debug.getinfo(2)
    return vim.fn.writefile(vim.fn.split(
        ':'..d.short_src..':'..d.currentline..':\n'..
        vim.inspect(#{...}>1 and {...} or ...),'\n'
    ),M.path,'a')
end
function Test()
    UA_DEV='ok'
    require'ultimate-autopair.test.init'.start()
    vim.cmd.q()
end
--vim.schedule(Test)
