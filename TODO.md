+ add debugging to everything
+ sorting, for both mem and callbacks in hook.callbacks
+ other types of mappings
    + make it possibe to activate mappings without an expr mapping using `nvim_feedkeys`
        + maybe make it default behaviour?
    + make mappings use `InsertCharPre` (and `CmdlineCharPre`)
+ Easy documented hook api
    + Like `hook.send_key('(')` > `hook._run('(',mode=utils.mode())`
+ doc
    + Add doc about unique mapping
    + ctrl-w support: just use `{bs={map={'<C-w>','<bs>'}}}`
+ What is the difference between hook request and hook (NOTHING)
+ How to create a treesitter query for tree injections
+ Function based extension enable `{enable=fun()}`
+ use `typos` to spell check everything and add to breaking chagne that wrongly spelled arguments are corrected
+ create a test for each bug report on github
+ make the boolean|nil option acept `"default"` as a replacement for nil
