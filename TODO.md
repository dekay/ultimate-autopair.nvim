+ add debugging to everything
+ sorting, for both mem and callbacks in hook.callbacks
+ other types of mappings
    + make it possible to activate mappings without an expr mapping using `nvim_feedkeys`
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
+ use `typos` to spell check everything and add to breaking change that wrongly spelled arguments are corrected
+ create a test for each bug report on github
+ make the boolean|nil option acept `"default"` as a replacement for nil
+ FILTER:
    + have a filter option to whether do use the filter as a filter
    + have a run option to whether do use the filter when run is called
        + both options for pair specific conf
+ Instead: in tsnode filter, have a way to check the node before and after a character is fake inserted
+ When filtering, filter the whole pair, instead of just the cursor:
    + Example `pair=\(,\)` `\|` > `(` > `\(|\)`
