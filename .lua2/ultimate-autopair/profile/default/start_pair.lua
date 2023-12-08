local utils=require'ultimate-autopair.utils'
local M={}
function M.run(o)
    local m=o.m.object
    return m.start_pair..m.end_pair..(vim.keycode'<Left>'):rep(utils.len(m.end_pair))
end
function M.init(start_pair,end_pair)
    return {
        run=M.run,
        object={start_pair=start_pair,end_pair=end_pair},
        get_hook=function ()
            return {{mode='i',type='map',input=start_pair}}
        end
    }
end
return M
