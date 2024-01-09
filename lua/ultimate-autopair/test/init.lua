local utils=require'ultimate-autopair.test.utils'
local  M={}
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
            if v=='' then return end
            utils.warning('Found something not allowed: '..v:sub(v:sub(2):find(' ') or 1))
        end
    end})
    debug.setmetatable(job,{name='grep',expected=1})
    local jobs={job}
    for k,exitcode in ipairs(vim.fn.jobwait(jobs,5000)) do
        local mt=getmetatable(jobs[k])
        if exitcode==-1 then
            utils.warning(('timeout `%s`'):format(mt.name))
        elseif exitcode~=(mt.expected or 0) then
            utils.warning(('job `%s` exited with code %s'):format(mt.name,exitcode))
        end
    end
end
function M.check_unique_lang_to_ft()
    local tree_langs=vim.tbl_map(function (x)
        return vim.fn.fnamemodify(x,':t:r')
    end,vim.api.nvim_get_runtime_file('parser/*',true))
    local done=require'ultimate-autopair.utils'.tslang2lang
    for _,tree_lang in ipairs(tree_langs) do
        if done[tree_lang] then goto continue end
        local filetypes=vim.treesitter.language.get_filetypes(tree_lang)
        if #filetypes>1 then
            utils.warning('Found multiple languages for '..tree_lang..': '..vim.inspect(filetypes))
        end
        done[tree_lang]=''
        ::continue::
    end
end
function M.start()
    local lua_path=vim.api.nvim_get_runtime_file('lua/ultimate-autopair',false)[1]
    local plugin_path=vim.fn.fnamemodify(lua_path,':h:h')
    if _G.UA_DEV then
        M.check_not_allowed_string(lua_path)
        M.check_unique_lang_to_ft()
    end
    if vim.fn.has('nvim-0.9.0')==0 then
        utils.warning('You have an older version of neovim than recommended')
    end
    if not pcall(require,'nvim-treesitter') then
        utils.warning('nvim-treesitter not installed: most of treesitter specific behavior will not work')
    end
    if not pcall(require,'nvim-treesitter-endwise') then
        utils.info('nvim-treesitter-endwise not installed: endwise integration will not work')
    end
    if not pcall(require,'nvim-ts-autotag') then
        utils.info('nvim-ts-autotag not installed: autotag integration will not work')
    end
    require'ultimate-autopair.test.run'.run(plugin_path)
end
return M
