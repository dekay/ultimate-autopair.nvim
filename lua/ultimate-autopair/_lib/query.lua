---@alias ua.query.langs {[1]:string,[2]:TSNode}
local M={}
---@param root_parser LanguageTree
---@return ua.query.langs
function M.get_lang_root_nodes(root_parser)
    local children={root_parser}
    local ret={}
    while true do
        ---@type LanguageTree
        local parser=table.remove(children,1)
        if not parser then return ret end
        local lang=parser:lang()
        local trees=parser:trees()
        for _,tree in ipairs(trees) do
            table.insert(ret,{lang,tree:root()})
        end
        vim.list_extend(children,parser:children())
    end
end
---@type table<string,table<string,Query|false>>
M._cache_queries=vim.defaulttable(function() return {} end)
---@param node_type string
---@param lang string
---@return Query?
function M.query_from_node_type(node_type,lang)
    if M._cache_queries[lang][node_type]~=nil then
        return M._cache_queries[lang][node_type] or nil
    end
    local query_str=('((%s) @%s)'):format(node_type,node_type)
    local s,query=pcall(vim.treesitter.query.parse,lang,query_str)
    M._cache_queries[lang][node_type]=s and query
    return s and query or nil
end
---@param langs ua.query.langs
---@param source string|number
---@param node_type string
---@return TSNode[]
function M.find_all_node_type(langs,source,node_type)
    local ret={}
    for _,v in ipairs(langs) do
        local lang,root=v[1],v[2]
        local query=M.query_from_node_type(node_type,lang)
        if not query then goto continue end
        for _,node in query:iter_captures(root,source,0,-1) do
            table.insert(ret,node)
        end
        ::continue::
    end
    return ret
end
return M
