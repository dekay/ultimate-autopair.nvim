local M={}
local utils=require'ultimate-autopair.utils'
---@type table<string,true|table<string,boolean>>
M._cache_keywordy={}
M._regex=vim.regex[=[\c[[=a=][=b=][=c=][=d=][=e=][=f=][=g=][=h=][=i=][=j=][=k=][=l=][=m=][=n=][=o=][=p=][=q=][=r=][=s=][=t=][=u=][=v=][=w=][=x=][=y=][=z=]]]=]
M._regex_keyword=vim.regex[=[\c\k]=]
function M.is_keywordy(char,o)
    if M._cache_keywordy[char]==true then return true end
    local ft=utils.get_filetype(o)
    if M._cache_keywordy[char] and M._cache_keywordy[char][ft]~=nil then return M._cache_keywordy[char][ft] end
    local is_alpha=M._regex:match_str(char)
    if is_alpha then
        M._cache_keywordy[char]=true
        return true
    end
    if not M._cache_keywordy[char] then M._cache_keywordy[char]={} end
    local is_keyword
    if ft==vim.o.filetype then
        is_keyword=M._regex_keyword:match_str(char) and true or false
    else
        local opt_keyword=vim.o.iskeyword
        vim.o.iskeyword=vim.filetype.get_option(ft,'iskeyword')
        is_keyword=M._regex_keyword:match_str(char) and true or false
        vim.o.iskeyword=opt_keyword
    end
    M._cache_keywordy[char][ft]=is_keyword
    return is_keyword
end
---@param o ua.filter
---@return boolean?
function M.call(o)
    if o.conf.after then
        if M.is_keywordy(utils.get_char(o.line,o.cole),o) then
            return
        end
    end
    if o.conf.before then
        if o.conf.py_fstr and
            utils.get_filetype(o)=='python' and
            vim.regex[[\c\a\@1<!\v((r[fb])|([fb]r)|[frub])$]]:match_str(o.line:sub(1,o.cols-1)) then
            return true
        end
        if M.is_keywordy(utils.get_char(o.line,o.cols-1),o) then
            return
        end
    end
    return true
end
M.conf={
    before='boolean',
    after='boolean',
    py_fstr='boolean',
}
return M
