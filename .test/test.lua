vim.opt.runtimepath:append('/home/user/.config/nvim/.other/ua_')
vim.cmd'syntax enable'
function vim.lg(...)
    local d=debug.getinfo(2)
    return vim.fn.writefile(vim.fn.split(
        ':'..d.short_src..':'..d.currentline..':\n'..
        vim.inspect(#{...}>1 and {...} or ...),'\n'
    ),'/tmp/nlog','a')
end
vim.o.buftype='nofile'
_G.UA_DEV=1
vim.opt.runtimepath:append('/home/user/.local/share/nvim/lazy/nvim-treesitter/')
require'nvim-treesitter'.setup()
require'ultimate-autopair'.setup()
vim.cmd'checkhealth ultimate-autopair'
