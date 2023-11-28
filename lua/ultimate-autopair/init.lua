local M={_id=0}
local _
---@param id ua.id?
function M.list(id)
    local objects=_.memory_manager.get_from_id(id)
    local buf=vim.api.nvim_create_buf(false,true)
    vim.bo[buf].bufhidden='wipe'
    vim.bo[buf].modifiable=false
    vim.api.nvim_buf_set_lines(buf,0,-1,false,vim.tbl_flatten(vim.tbl_map(function(obj)
        return {vim.inspect(obj.gethook())..' '..obj.doc}
    end,objects)))
    vim.keymap.set('n','<cr>',function ()
        local infobuf=vim.api.nvim_create_buf(false,true)
        vim.bo[infobuf].bufhidden='wipe'
        vim.api.nvim_buf_set_lines(buf,0,-1,false,vim.split(vim.inspect(objects[vim.o.lines'.']),'\n'))
        vim.api.nvim_set_current_buf(infobuf)
    end,{buf=buf})
    vim.cmd.vsplit()
    vim.api.nvim_set_current_buf(buf)
end
---@param conf ua.prof.conf
---@param id ua.id?
function M.setup(conf,id)
    if vim.fn.has('nvim-0.9.0')~=1 then error('Requires at least version nvim-0.9.0') end
    M.init({M.extend_default(conf or {})},id)
end
---@param configs ua.prof.conf[]
---@param id ua.id?
function M.init(configs,id)
    id=id or M._id
    configs=_.config_manager.init(configs)
    M._configs=configs
    local objects=_.profile.create_objects_from_config(configs,id)
    _.memory_manager.replace_with_id(objects,id)
    _.hook.reinit(id)
end
return M
