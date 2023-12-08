local M={}
---@param start_pair string
---@param end_pair string
---@param multiline boolean
---@param start_pair_filter fun(row:number,col:number)
---@param end_pair_filter fun(row:number,col:number)
---@param lines string[]
---@param row number
---@param col number
---@param gotostart boolean|"both"
---@param Icount number?
---@param ret_pos boolean?
---@return number?
---@return number?
function M.count_start_pair(start_pair,end_pair,multiline,start_pair_filter,end_pair_filter,lines,row,col,gotostart,Icount,ret_pos)
    --TODO(fix): if gotostart=='both' and cursor in pair then dont count pair
    start_pair=start_pair:reverse()
    end_pair=end_pair:reverse()
    local rlines={lines[row]}
    if multiline then
        rlines=vim.fn.reverse(vim.list_slice(lines,(not gotostart) and row or nil,gotostart==true and row or nil))
    end
    local count=Icount or 0
    if not gotostart then rlines[#rlines]=rlines[#rlines]:sub(col) end
    if gotostart==true then rlines[1]=rlines[1]:sub(1,col) end
    for rrow,line in ipairs(rlines)do
        rrow=(multiline and gotostart~=true and #rlines or row)+1-rrow
        assert(lines[rrow]==line)
        local real_col
        local rline=line:reverse()
        local next_start_pair=rline:find(start_pair,1,true)
        local next_end_pair=rline:find(end_pair,1,true)
        while true do
            if next_start_pair and ((not next_end_pair) or next_start_pair<next_end_pair) then
                real_col=((not gotostart) and rrow==row and #lines[rrow] or #line)-next_start_pair+1-#start_pair+1
                if start_pair_filter(rrow,real_col) then count=count-1 end
                next_start_pair=rline:find(start_pair,next_start_pair+#start_pair,true)
            elseif next_end_pair then
                real_col=((not gotostart) and rrow==row and #lines[rrow] or #line)-next_end_pair+1-#end_pair+1
                if end_pair_filter(rrow,real_col) then count=count+1 end
                next_end_pair=rline:find(end_pair,next_end_pair+#end_pair,true)
            else break end
            if ret_pos and count<=0 then
                return real_col,rrow
            elseif count<0 then
                count=0
            end
        end
    end
    return (not ret_pos) and count or nil
end
---@param start_pair string
---@param end_pair string
---@param multiline boolean
---@param start_pair_filter fun(row:number,col:number)
---@param end_pair_filter fun(row:number,col:number)
---@param lines string[]
---@param row number
---@param col number
---@param gotoend boolean|"both"
---@param Icount number?
---@param ret_pos boolean?
---@return number?
---@return number?
function M.count_end_pair(start_pair,end_pair,multiline,start_pair_filter,end_pair_filter,lines,row,col,gotoend,Icount,ret_pos)
    --TODO(fix): if gotostart=='both' and cursor in pair then dont count pair
    local rlines={lines[row]}
    if multiline then
        rlines=vim.list_slice(lines,gotoend==true and row or nil,(not gotoend) and row or nil)
    end
    local count=Icount or 0
    if not gotoend then lines[#lines]=lines[#lines]:sub(1,col) end
    if gotoend==true then lines[1]=lines[1]:sub(col) end
    for rrow,line in ipairs(rlines) do
        rrow=((gotoend==true or not multiline) and row-1 or 0)+rrow
        assert(lines[rrow]==line)
        local real_col
        local next_start_pair=line:find(start_pair,1,true)
        local next_end_pair=line:find(end_pair,1,true)
        while true do
            if next_start_pair and ((not next_end_pair) or next_start_pair<next_end_pair) then
                real_col=next_start_pair+(gotoend==true and rrow==row and col-1 or 0)
                if start_pair_filter(rrow,real_col) then count=count+1 end
                next_start_pair=line:find(start_pair,next_start_pair+#start_pair,true)
            elseif next_end_pair then
                real_col=next_end_pair+(gotoend==true and rrow==row and col-1 or 0)
                if end_pair_filter(rrow,real_col) then count=count-1 end
                next_end_pair=line:find(end_pair,next_end_pair+#end_pair,true)
            else break end
            if ret_pos and count==0 then
                return real_col,rrow
            elseif count<0 then
                count=0
            end
        end
    end
    return (not ret_pos) and count or nil
end
---@param pair string
---@param multiline boolean
---@param start_pair_filter fun(row:number,col:number)
---@param end_pair_filter fun(row:number,col:number)
---@param lines string[]
---@param row number
---@param col number
---@param gotoend boolean|"both"
---@param Icount number?
---@param ret_pos boolean?
---@return number?
---@return number?
function M.count_amiguous_pair(pair,multiline,start_pair_filter,end_pair_filter,lines,row,col,gotoend,Icount,ret_pos)
    local count=Icount or 0
    local index
    local rowindex
    local rlines={lines[row]}
    if multiline then
        rlines=vim.list_slice(lines,gotoend==true and row or nil,(not gotoend) and row or nil)
    end
    if not gotoend then lines[#lines]=lines[#lines]:sub(1,col) end
    if gotoend==true then lines[1]=lines[1]:sub(col) end
    for rrow,line in ipairs(rlines) do
        rrow=((gotoend==true or not multiline) and row-1 or 0)+rrow
        assert(lines[rrow]==line)
        local pos=line:find(pair,1,true)
        while pos do
            local real_col=pos+(gotoend==true and rrow==row and col-1 or 0)
            if ((count%2==1 and end_pair_filter(rrow,real_col)) or
                (count%2==0 and start_pair_filter(rrow,real_col))) and
                (real_col>=col+#pair-1 or real_col<=col-1 or row~=rrow) then
                --TODO: check above that it works correctly when cursor in between pair
                count=count+1
                if not gotoend or not index then
                    index=real_col
                    rowindex=rrow
                end
            end
            pos=line:find(pair,pos+#pair,true)
        end
    end
    if not ret_pos and count%2==0 then return end
    return index,rowindex
end
return M
