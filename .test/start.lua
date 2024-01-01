local timer
vim.cmd.vsplit()
local lbuf=vim.api.nvim_create_buf(false,true)
vim.api.nvim_set_current_buf(lbuf)
local function restart()
    local buf=vim.api.nvim_create_buf(false,true)
    for _,win in ipairs(vim.fn.win_findbuf(lbuf)) do
        vim.api.nvim_win_set_buf(win,buf)
    end
    vim.api.nvim_buf_delete(lbuf,{force=true})
    vim.api.nvim_buf_call(buf,function ()
        vim.fn.termopen('/home/user/.config/nvim/.other/ua_/.test/nvim')
    end)
    lbuf=buf
end
vim.schedule(restart)
vim.api.nvim_create_autocmd('BufWritePost',{callback=function ()
    if timer then vim.fn.timer_stop(timer) end
    timer=vim.fn.timer_start(100,function ()
        restart()
    end)
end,group=vim.api.nvim_create_augroup('ua.test',{})})
