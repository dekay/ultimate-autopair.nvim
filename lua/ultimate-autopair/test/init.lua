local list_of_tests=require'ultimate-autopair.test.tests'
local M={}
function M.ok(msg)
    vim.notify('Ok:'..msg,vim.log.levels.INFO)
end
function M.info(msg)
    vim.notify('Info:'..msg,vim.log.levels.INFO)
end
function M.error(msg)
    vim.notify('Err:'..msg,vim.log.levels.ERROR)
end
function M.warning(msg)
    vim.notify('Warn:'..msg,vim.log.levels.WARN)
end
function M.request(...)
    return vim.rpcrequest(M.chan,...) --[[@as any]]
end
function M.chan_exec(cmd)
    return M.request('nvim_exec2',cmd,{output=true}).output
end
function M.chan_exec_lua(cmd)
    return M.chan_exec('lua << EOF\n'..cmd..'\nEOF')
end
function M.get_lines()
    return M.request('nvim_buf_get_lines',0,0,-1,true)
end
function M.set_lines(lines)
    return M.request('nvim_buf_set_lines',0,0,-1,true,lines)
end
function M.set_pos(row,col)
    return M.request('nvim_win_set_cursor',0,{row,col})
end
function M.get_pos()
    return M.request('nvim_win_get_cursor',0)
end
function M.set_lines_and_pos(lines,cursor)
    lines=vim.split(lines,'\n')
    local row,col
    for k,v in ipairs(lines) do
        col=v:find(cursor or '|',1,true)
        if col then row=k break end
    end
    assert(row)
    lines[row]=lines[row]:sub(0,col-1)..lines[row]:sub(col+1)
    M.set_lines(lines)
    M.set_pos(row,col-1)
end
function M.get_lines_and_pos(cursor)
    local lines=M.get_lines()
    local row,col=unpack(M.get_pos())
    lines[row]=lines[row]:sub(1,col)..(cursor or '|')..lines[row]:sub(col+1)
    return table.concat(lines,'\n')
end
function M.assert_no_autoconvert(s,t)
    if not _G.UA_DEV then return end
    if t and t.ascii then return end
    local pos=vim.str_utf_pos(s)
    for k,v in ipairs(pos) do
        local n=vim.fn.char2nr(s:sub(v,(pos[k+1] or 0)-1))
        if not (n<128 or n>255) then
            error(('DEV ERROR: The `%s` in string `%s` may autoconvert\n%s'):format(s:sub(v,(pos[k+1] or 0)-1),s,M._create_mess(t)))
        end
    end
end
function M.feed(input)
    if M.request('nvim_input',input)~=#input then return false end
    local errmsg=M.request('nvim_eval','v:errmsg')
    if errmsg~='' then M.chan_exec('let v:errmsg=""') end
    return errmsg
end
function M.sort_test_by_conf(list_tests)
    local ret={}
    local skip={}
    for category,tests in pairs(list_tests) do
        if category:sub(1,3)=='DEV' and not _G.UA_DEV then
            goto skip
        end
        for k,testopt in pairs(tests) do
            testopt._category=category
            if testopt[4] and testopt[4].skip then
                table.insert(skip,testopt)
                goto continue
            end
            if testopt.I then
                return {[(testopt[4] or {})]={testopt,_path={category,k}}},{}
            end
            local testconf=testopt[4] and testopt[4].c or {}
            for config,_ in pairs(ret) do
                if vim.deep_equal(config,testconf) then
                    table.insert(ret[config],testopt)
                    goto continue
                end
            end
            ret[testconf]={testopt,_path={category,k}}
            ::continue::
        end
        ::skip::
    end
    return ret,skip
end
function M.test(plugin_path)
    if not plugin_path then
        local lua_path=vim.api.nvim_get_runtime_file('lua/ultimate-autopair',false)[1]
        if not lua_path then
            M.error('Could not find ultimate-autopair plugin path')
            return
        end
        plugin_path=vim.fn.fnamemodify(lua_path,':h:h')
    end
    if (vim.fn.systemlist({vim.v.progpath,'--version'})[1]~=vim.api.nvim_exec2('version',{output=true}).output:gsub('^\n(.-)\n.*','%1')) then
        M.warning(("The version number in `:version` didn't match `:!%s --version`"):format(vim.v.progpath))
    end
    M.chan=vim.fn.jobstart({vim.v.progpath,'--embed','--headless','--clean'},{rpc=true})
    M.chan_exec(('set rtp+=%s'):format(plugin_path))
    M.chan_exec_lua[[
    function vim.lg(...)
        local d=debug.getinfo(2)
        return vim.fn.writefile(vim.fn.split(
            ':'..d.short_src..':'..d.currentline..':\n'..
            vim.inspect(#{...}==1 and ... or {...}),'\n'
        ),'/tmp/nlog','a')
    end]]
    M.chan_exec_lua[[_G.UA_DEV=true]]
    local conf_tests,skip=M.sort_test_by_conf(list_of_tests)
    for _,tests in pairs(conf_tests) do
        if M.run_tests(tests) then
            M.warning('Unrecoverable error happened: Prematurely stopping test execution')
            if vim.fn.jobstop(M.chan)==0 then
                M.error('neovim exited abnormally')
            end
            return
        end
    end
    if _G.UA_DEV then
        for _,testopt in ipairs(skip) do
            local category=testopt._category
            testopt._category=nil
            M.info(('test(%s) %s skipped'):format(category,vim.inspect(testopt,{newline='',indent=''})))
        end
    end
    if vim.fn.jobstop(M.chan)==0 then
        M.error('neovim exited abnormally')
    end
end
function M._create_mess(v,actual)
    local ret=('{Initial}:\n%s\n{Input}: `%s`\n{Expected-result}:\n%s'):format(v[1],v[2],v[3])
    if actual then ret=ret..('\n{Actual-result}:\n%s'):format(actual) end
    if v[4] then ret=('{Config}:\n%s\n'):format(vim.inspect(v[4]))..ret end
    return ret
end
function M.run_tests(tests)
    local pcategory,ptest=unpack(tests._path)
    M.chan_exec(('lua ua_conf=(require"ultimate-autopair.test.tests".%s[%s][4] or {}).c'):format(pcategory,ptest))
    M.chan_exec('lua require"ultimate-autopair".setup(ua_conf)')
    for _,v in ipairs(tests) do
        M.assert_no_autoconvert(v[1],v)
        M.assert_no_autoconvert(v[2],v)
        M.assert_no_autoconvert(v[3],v)
        local category=v._category
        v._category=nil
        local conf=v[4] or {}
        M.chan_exec('stopinsert')
        M.chan_exec('bwipeout!')
        M.chan_exec('edit '..vim.fn.tempname())
        M.chan_exec('set all&')
        M.chan_exec('startinsert')
        M.set_lines_and_pos(v[1],conf.cursor)
        if conf.cmd then
            M.chan_exec(conf.cmd)
        end
        if conf.ft then
            M.chan_exec('setf '..conf.ft)
            M.chan_exec_lua('pcall(vim.treesitter.start)')
        end
        local errmsg=M.feed(v[2])
        if errmsg==false then
            M.error(('test(%s) went wrong:\nThe input could not be processed\nPossible reason: An unmatched `<` may be in the input, replace all unmatched `<` with `<lt>`\n%s'):format(category,M._create_mess(v)))
        elseif errmsg~='' then
            M.error(('test(%s) errord:\n%s\n%s'):format(category,errmsg,M._create_mess(v)))
            -- When a test errors, it is slow, and one errord test typically means multiple errord tests
            -- So we don't stop test execution here so that the test execution doesn't take so long
            return true
        elseif M.get_lines_and_pos(conf.cursor)~=v[3] then
            M.error(('test(%s) failed\n%s'):format(category,M._create_mess(v,M.get_lines_and_pos(conf.cursor))))
        end
    end
end
return M
