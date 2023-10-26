local M={}
function M.check(pair_start,pair_end)
    pair_start,pair_end=M.eval_pairs(pair_start,pair_end)
    if pair_start==pair_end then
        M.isambiguous=true
    end
end
return M
