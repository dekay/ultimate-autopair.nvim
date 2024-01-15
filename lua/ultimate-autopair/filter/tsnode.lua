local query=require'ultimate-autopair._lib.query'
local M={}
---@param source ua.source
---@param node_types string[]
---@return string[]
---@return {[1]:string,[2]:TSNode}[]
function M.get_nodes_and_trees(source,node_types)
    local parser=source.get_parser()
    if not parser then return {},{} end
    local langs=query.get_lang_root_nodes(parser)
    local qsource=source.__buf or table.concat(source._lines,'\n')
    local nodes={}
    for _,v in ipairs(node_types) do
        vim.list_extend(nodes,query.find_all_node_type(langs,qsource,v))
    end
    return nodes,langs
end
---@param o ua.filter
---@return boolean?
function M.call(o)
    local nodes,langs=M.get_nodes_and_trees(o.source,{'string'})
    return true
end
return M
