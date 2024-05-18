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
vim.opt.runtimepath:append('/home/user/.local/share/nvim/lazy/nvim-treesitter-endwise/')
vim.opt.runtimepath:append('/home/user/.local/share/nvim/lazy/nvim-ts-autotag//')
require'nvim-treesitter'.setup()
vim.cmd'checkhealth ultimate-autopair'
