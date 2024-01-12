local M={}
---@param o ua.filter
---@param node_types string[]
---@return string[]
---@return string[]
function M.get_nodes_and_trees(o,node_types)
    local qsource=o.source.__buf or table.concat(o.lines,'\n')
    local nodes={}
    local langs={}
    local function _get(parser)
        ---@cast parser LanguageTree
        local lang=parser:lang()
        local trees=parser:trees()
        for _,i in ipairs(node_types) do
            local s,query=pcall(vim.treesitter.query.parse,lang,('((%s) @%s)'):format(i,i))
            if not s then goto continue end
            for _,tree in ipairs(trees) do
                table.insert(langs,{lang,tree:root()})
                for _,node in query:iter_captures(tree:root(),qsource,0,-1) do
                    --TODO: if there is no ask for filter at a row, don't do query there
                    table.insert(nodes,node)
                end
            end
            ::continue::
        end
        for _,child in pairs(parser:children()) do
            _get(child)
        end
    end
    local parser=o.source.get_parser()
    if not parser then return {},{} end
    parser:parse()
    _get(parser)
    return nodes,langs
end
---@param o ua.filter
---@return boolean?
function M.call(o)
    local nodes,langs=M.get_nodes_and_trees(o,{'string'})
    return true
end
return M
