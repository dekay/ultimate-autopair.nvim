local utils=require'ultimate-autopair.utils'
local query=require'ultimate-autopair._lib.query'
local M={}
M.id={}
---@param o ua.filter
---@param trange number[]
---@return boolean?
function M.filter(o,trange)
    local range={o.rows-1,o.cols-1,o.rowe-1,o.cole-1}
    if utils.range_in_range(trange,range,true) then
        return true
    end
end
---@param o ua.filter
---@return boolean?
function M.call(o)
    local range={o.rows-1,o.cols-1,o.rowe-1,o.cole-1}
    local parser
    if o.conf.detect_after then
        local lines={}
        for k,v in ipairs(o.source._lines) do
            lines[k]=v
        end
        lines[o.rows]=o.line:sub(1,o.cols-1)..o.conf.detect_after..o.line:sub(o.cols)
        o.cole=o.cole+1
        parser=vim.treesitter.get_string_parser(table.concat(lines,'\n'),vim.treesitter.language.get_lang(o.source.o.filetype) or o.source.o.filetype)
        parser:parse(true)
    else
        parser=o.source.get_parser()
    end
    if not parser then return true end
    if o.conf.separate and o.lsave then
        if o.lsave[M.id]==false then
            local nodes=query.find_all_node_types(parser,o.conf.separate)
            for _,node in ipairs(nodes) do
                local trange={node:range()}
                if utils.range_in_range(trange,range,true) then
                    return false
                end
            end
        elseif o.lsave[M.id] then
            if not M.filter(o,o.lsave[M.id]) then return end
        else
            local nodes=query.find_all_node_types(parser,o.conf.separate)
            o.lsave[M.id]=false
            for _,node in ipairs(nodes) do
                local trange={node:range()}
                if utils.range_in_range(trange,range,false) then
                    o.lsave[M.id]=trange
                    break
                end
            end
        end
    end
    if o.conf.dont then
        if #query.find_all_node_types(parser,o.conf.dont)>0 then
            return false
        end
    end
    return true
end
return M
