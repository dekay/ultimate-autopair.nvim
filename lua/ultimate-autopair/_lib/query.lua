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

---@type table<string,table<string,boolean>>
M._cache_lang_node_types=vim.defaulttable(function() return {} end)
---@param node_types string[]
---@param lang string
---@return string[]
function M.remove_invalid_node_types(node_types,lang)
    local cache=M._cache_lang_node_types[lang]
    local ret={}
    for _,node_type in ipairs(node_types) do
        if cache[node_type]==nil then
            cache[node_type]=pcall(vim.treesitter.query.parse,lang,('(%s)'):format(node_type))
        end
        if cache[node_type] then
            table.insert(ret,node_type)
        end
    end
    return ret
end
---@param node_types string[]
---@return string
function M.node_types_to_query_str(node_types)
    return table.concat(vim.tbl_map(function(v) return ('((%s) @%s)'):format(v,v) end,node_types))
end
---@param parser LanguageTree
---@param node_types string[]
function M.find_all_node_types(parser,node_types)
    local cache_node_types={}
    local cache_query={}
    local ret={}
    parser:for_each_tree(function(tree,ltree)
        local lang=ltree:lang()
        local query_str
        if cache_node_types[lang] then
            query_str=cache_node_types[lang]
        else
            query_str=M.node_types_to_query_str(M.remove_invalid_node_types(node_types,lang))
            cache_node_types[lang]=query_str
        end
        local query
        if cache_query[lang] then
            query=cache_query[lang]
        else
            query=vim.treesitter.query.parse(lang,query_str)
            cache_query[lang]=query
        end
        for _,node in query:iter_captures(tree:root(),ltree:source(),0,-1) do
            table.insert(ret,node)
        end

    end)
    return ret
end
return M
