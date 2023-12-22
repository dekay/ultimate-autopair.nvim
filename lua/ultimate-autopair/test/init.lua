local utils=require'ultimate-autopair.test.utils'
local  M={}
M.jobs={}
function M.check_not_allowed_string(path)
    if vim.fn.executable('grep')==0 then
        utils.warning('Some of the required executables are missing for dev testing')
        utils.info('INFO Pleas make sure that grep is installed')
        return
    end
    local blacklist={'vim.lg','print','vim.dev'}
    local search=table.concat(blacklist,'\\|')
    local job=vim.fn.jobstart({'grep','-r','--exclude-dir=test',search,path},{on_stdout=function (_,data,_)
        for _,v in ipairs(data) do
            if v~='' then
                utils.warning('Found something not allowed: '..v:sub(v:sub(2):find(' ') or 1))
            end
        end
    end})
    debug.setmetatable(job,{name='grep',expected=1})
    table.insert(M.jobs,job)
end
function M.check_other(_)
    if vim.fn.has('nvim-0.9.0')==0 then
        utils.warning('You have an older version of neovim than recommended')
    end
    if not pcall(require,'nvim-treesitter') then
        utils.warning('nvim-treesitter not installed: most of treesitter specific behavior will not work')
    end
end
function M.start()
    local path=vim.api.nvim_get_runtime_file('lua/ultimate-autopair',false)[1]
    local root=vim.fn.fnamemodify(path,':h:h')
    ---@diagnostic disable-next-line: undefined-field
    if _G.UA_DEV then
        M.check_not_allowed_string(path)
    end
    M.check_other()
    local exitcodes=vim.fn.jobwait(M.jobs,5000)
    for k,exitcode in ipairs(exitcodes) do
        local mt=getmetatable(M.jobs[k])
        local name=mt.name
        local expected=mt.expected or 0
        if exitcode==-1 then
            utils.warning(('timeout `%s`'):format(name))
        elseif exitcode~=expected then
            utils.warning(('job `%s` exited with code %s'):format(name,exitcode))
        else
            utils.info(('`%s` ran successfully'):format(name))
        end
    end
    require'ultimate-autopair.test.run'.run(root)
end
return M
