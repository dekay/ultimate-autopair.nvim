return {
    simple={
        {'|','(','(|)'},
        {'(|)',')','()|'},
        {'(|)','(','((|))'},
        {'|','"','"|"'},
        {'"|"','"','""|'},
        {'|"','"','"|"'},
        {'"|','"','""|'},
        {'() |','(','() (|)'},
        {"'' |","'","'' '|'"},
        {'(|))','(','((|))'},
        {'"a|b"','"','"a"|"b"'},
        {'|)',')',')|)'},
        {'(|))',')','()|)'},
        {'()|)',')','())|)'},
        {'|','f(','foo(|)',{cmd='abbr <buffer>f foo'}},
        {'|','*','*|*',{c={{'*','*'},{'**','**'}}}},
        {'*|*','*','**|**',{c={{'*','*'},{'**','**'}},skip=true}},
        {'**|**','*','***|***',{c={{'**','**'},{'***','***'}},skip=true}},
        {'((|))','<lt>','((<|>))',{c={{'(',')'},{'((<','>))'}},skip=true}},
        {'**|**','*','****|',{c={{'*','*'},{'**','**'}}}},
        {'*|**','*','**|**',{c={{'*','*'},{'**','**'}}}},
        {'**|*','*','***|*',{c={{'*','*'},{'**','**'}}}},
        {'****|','*','*****|*',{c={{'*','*'},{'**','**'}},skip=true}},
        {'***|*','*','****|*',{c={{'**','**'}},skip=true}},
        {'|','<esc>a(<esc>..a','(((|)))'},
        {'|','<esc>3a(<esc>a','(((|)))'},
        {'|foo','<esc>R(','(|)o'},
        {'<!-|','-','<!--|'},
        {'<!-|','-','<!--|-->',{ft='markdown'}},
        {'<!-|-->','-','<!--|-->',{ft='markdown'}},
        {'<!--|-->','-','<!---->|',{ft='markdown'}},
        {'""|','"','"""|"""',{ft='python'}},
        {'"""|"""','"','""""""|',{ft='python'}},
        {'<cr|','>','<cr>|<cr>',{c={{'<cr>','<cr>'}}}},
        {'|','&','&|',{c={{'&','?',map_modes={'c'}}}}},
        {'\0|\0',"'","\0'|'\0"},
        {'|','{','{|},',{c={{'{','},'}},skip=true}}, --TODO: important
    },
    multiline={
        {'|\n)','(','(|\n)'},
        {'(\n|)',')','(\n)|'},
        {'\n|)',')','\n)|)'},
        {'(|\n)','(','((|)\n)'},
        {'(\n|\n)','(','(\n(|)\n)'},
        {'()\n|)',')','()\n)|)'},
        {'(\n(|)',')','(\n()|)'},
        {'(|\n))','(','((|\n))'},
        {'"""\n|"""','"','"""\n"""|',{ft='python'}},
        {'"\n|"','"','"\n"|"'},
        {'|\n>','<lt>','<|>\n>',{c={{'<','>',multiline=false}}}},
        {'<\n|>','>','<\n>|>',{c={{'<','>',multiline=false}}}},
        {'<|>\n','>','<>|\n',{c={{'<','>',multiline=false}}}},
        {'(|)\n',')','()|\n'},
        {'\n(|)\n',')','\n()|\n'},
        {'\n |\n()','(','\n (|)\n()'},
        {'\n "|"\n""','"','\n ""|\n""',{ft='lua',c={change={{'"','"',multiline=true}}}}},
        {'\n "\n|"\n""','"','\n "\n"|\n""',{ft='lua',c={change={{'"','"',multiline=true}}}}},
        {'(\n  (|)\n)','<bs>','(\n  |\n)'},
        {'\n"|"','"','\n""|'},
        {"\n'|'","'","\n''|",{ft='lua'}},
        {'(\n\n|\n)','(','(\n\n(|)\n)'},
        {"'|",'\r',"'\n|",{c={cr={autoclose=true}},skip=true}},
        {'*\n|*','*','*\n*|',{c={{'*','*',multiline=true}}}},
        {'*\n|*','*','*\n*|*',{c={{'*','*',multiline=false}}}},
    },
    cmdline={
        {'|','<C-r>="(\r','()|'},
    },
    utf8={
        {'|','«','«|»',{c={{'«','»'}}}},
        {'«|»','»','«»|',{c={{'«','»'}}}},
        {'a|b','«','a«|b',{c={{'««','»»'}}}},
        {'a«|b','«','a««|»»b',{c={{'««','»»'}}}},
        {'a««|»»b','«','a««|»»b',{c={{'««','»»'},{'«««','»»»'}},skip=true}},
        {'a««b»|»c','»','a««b»»|»c',{c={{'««','»»'}}}},
        {'a««b|»»c','»','a««b»»|c',{c={{'««','»»'}}}},
        {'a«|b»»c','«','a««|b»»c',{c={{'««','»»'}}}},
        {'|','´','´|´',{c={{'´','´'}}}},
        {'a´b|´c','´','a´b´|c',{c={{'´','´'}}}},
        {'a|´b','´','a´|´b',{c={{'´','´'}}}},
        {'a´b|c','´','a´b´|c',{c={{'´','´'}}}},
        {'a´b´c|d','´','a´b´c´|´d',{c={{"´","´"}}}},
        {'a´b|c´d','´','a´b´|´c´d',{c={{'´','´'}}}},
        {'a|b','´','a´|b',{c={{'´´','´´'}}}},
        {'a´|b','´','a´´|´´b',{c={{'´´','´´'}}}},
        {'a´´b|´´c','´','a´´b´´|c',{c={{'´´','´´'}}}},
        {'a´|b´´c','´','a´´|b´´c',{c={{'´´','´´'}}}},
        {'a´´b´|´c','´','a´´b´´|´c',{c={{'´´','´´'}},skip=true}},
        {'print("§",|)','"','print("§","|")',{ft='lua'}},
        {"'á|',","'","'á'|,"},
        {',(|)aøe,','<C-e>',',(|aøe),',{skip=true}}, --fastwarp
        {',««|»»aøe,','<C-e>',',««|aøe»»,',{c={{'««','»»'}},skip=true}}, --fastwarp
        {',´´|´´aøe,','<C-e>',',´´|aøe´´,',{c={{'´´','´´'}},skip=true}}, --fastwarp
        --{'(|aáa),','','|aáa,',{interactive=true}}, --backspace
        --{'|"¿qué?",','(','(|"¿qué?"),',{interactive=true}}, --ext.surround
        {"ä|,","'","ä'|,"}, --ext.alpha
        {'"ě""|",','<bs>','"ě"|,',{ft='lua'}}, --backspace
        {"'ø',|","'","'ø','|'",{ft='lua'}}, --treesitter
        {"{'ø',{}|}",'{',"{'ø',{}{|}}",{ft='lua'}}
    },
    filter_alpha={
        {'don|t',"'","don'|t"},
        {'Ã|',"'","Ã'|"},
        {'Ã|',"'","Ã'|'",{cmd='set iskeyword='}},
        {'_|',"'","_'|"},
        {'-|',"'","-'|",{ft='lisp'}},
        {'```query\n.|\n```',"'","```query\n.'|\n```",{ft='markdown'}},
        {"'a|'","'","'a'|"},
        {'f|',"'","f'|"},
        {'f|',"'","f'|'",{ft='python'}},
        {'```python\nf|\n```',"'","```python\nf'|'\n```",{ft='markdown'}},
        {'Rb|',"'","Rb'|'",{ft='python'}},
        {'bar|',"'","bar'|",{ft='python'}},
        {"a' |","'","a' '|'",{c={filter={alpha={filter=true}}}}},
        {"a' |","'","a' '|",{c={filter={alpha={filter=false}}}}},
        {'|a','<lt>','<|a',{c={{'<','>',alpha={after=true}}}}},
        {'a|','<lt>','a<|',{c={{'<','>',alpha={before=true}}}}},
        {'<|a','<lt>','<<|a',{c={{'<<','>>',alpha={after=true}}}}},
        {'a<|','<lt>','a<<|',{c={{'<<','>>',alpha={before=true}}}}},
        {'b""|','"','b"""|"',{ft='python',c={change={{'"""','"""',alpha={before=true}}}}}},
    },
    filter_escape={
        {'\\|','(','\\(|'},
        {'\\\\|','(','\\\\(|)'},
        {'|\\)','(','(|)\\)'},
        {'\\(|)',')','\\()|)'},
        {'\\<!-|','-','\\<!--|',{ft='markdown'}},
        {'<!-| \\-->','-','<!--|--> \\-->',{ft='markdown'}},
        {'<!--\\-->|-->','-','<!--\\-->-->|',{ft='markdown'}},
        {'\\|','(','\\(|\\)',{c={{'\\(','\\)'}}}},
        {'\\\\|','(','\\\\(|)',{c={{'\\(','\\)'}}}},
        {'\\(|\\)','\\','\\(\\)|',{c={{'\\(','\\)'}}}},
        {'\\(|)','<bs>','\\|)'},
        {'«|','(','«(|',{c={filter={escape={escapechar='«'}}}}},
        {'««|','(','««(|)',{c={filter={escape={escapechar='«'}}}}},
    },
    filter_filetype={
        {'<!-|','-','<!--|'},
        {'""|','"','"""|"'},
        {'<!-|','-','<!--|-->',{ft='markdown'}},
        {'|','(','(|',{ft='TelescopePrompt'}},
        {'```lua\n|\n```','<lt>',"```lua\n<|>\n```",{ft='markdown',c={{'<','>',ft={'lua'}}}}},
        {'$|$','<lt>','$<|>$',{ft='markdown',c={{'<','>',ft={'tex',detect_after='\a'}}},skip=true}},
        {'$|$','<lt>','$<|$',{ft='markdown',c={{'<','>',ft={'tex',detect_after='\a'},filetype={detect_after=false}}},skip=true}},
        {'|','<lt>','<|',{ft='lua',c={{'<','>',nft={'lua'}}}}},
    },
    filter_cmdtype={
        {'|','<C-r>="(\r','()|',{c={filter={cmdtype={skip={}}}}}},
        {'|','<C-r>="("\r','(|',{c={filter={cmdtype={skip={'='}}}}}},
        {'|','<C-r>=input("")\r(\r','(|'},
        {'|','<C-r>=input("")\r(\r','()|',{c={filter={cmdtype={skip={merge=false}}}}}},
    },
    filter_tsnode={ --TODO: don't run tests if parser not found
        {'$|$)','(','$(|)$)',{ft='markdown',skip=true}},
        {'$1+1|$','$','$1+1$|',{c={{'$','$'}},ft='markdown',skip=true}},
        {'| ")"','(','(|) ")"',{ft='lua'}},
        {'"|")','(','"(|)")',{ft='lua'}},
        {[[|"'"]],"'",[['|'"'"]],{ft='lua'}},
        {[['""(|)']],')',[['""()|']],{ft='lua'}},
        {'("|")',')','(")|")',{ft='lua'}},
        {[[| '\')']],'(',[[(|) '\')']],{ft='lua'}},
        {'| [[)]]','(','(|) [[)]]',{ft='lua'}},
        {'|\n")"','(','(|)\n")"',{ft='lua'}},
        {'"|"\n)','(','"(|)"\n)',{ft='lua'}},
        {"'''|'","'","''''|",{ft='lua'}},
        {'local a=| }','{','local a={|} }',{ft='lua',c={filter={tsnode={separate={'table_constructor'},detect_after="{"}}},skip=true}}, --TODO: make detect_after only run on insert
        {"let a: Vec<|a>;","'","let a: Vec<'|a>;",{ft='rust',c={filter={tsnode={dont={'lifetime'},detect_after="'"}}},skip=true}}, --TODO: only do on insertion, not on general filtering
        {"|","'","'|'",{ft='rust',c={filter={tsnode={dont={'lifetime'},detect_after="'"}}},skip=true}},
        --{[["'"|"'"]],'"',[["'""|""'"]],{ft='lua'}},
        --{[['"' '"' |]],"'",[['"' '"' '|']],{ts=true}},
        --{"f'|","'","f''|",{ts=true,ft='lua'}},
        ----TODO: test multiline string (python)
        ----TODO: test more injected filter
    },
    map_backspace={
        {'a[|]b','<bs>','a|b'},
        {'a"|"b','<bs>','a|b'},
        {'a[]|b','<bs>','a|b'},
        {'a""|b','<bs>','a|b'},
        {'a<!--|-->b','<bs>','a|b',{ft='markdown'}},
        {'a<!--|b-->c','<bs>','a|bc',{ft='markdown'}},
        {'a<!---->|b','<bs>','a|b',{ft='markdown'}},
        {'" "|" "','<bs>','" | "'},
        {'[[|]]','<bs>','[|]'},
        {'[[|]','<bs>','[|]'},
        {'[|]]','<bs>','|]'},
        {'[]|]','<bs>','[|]'},
        {'[[]|','<bs>','[|'},
        {'[]|]','<bs>','[|]'},
        {'][|][','<bs>',']|['},
        {'][]|[','<bs>',']|['},
        {'"|""','<bs>','|""'},
        {'" "|"','<bs>','" |"'},
        {'""| "','<bs>','"| "'},
        {'\\[|]','<bs>','\\|]'},
        {'[\\[|]','<bs>','[\\|]'},
        {'[|\\]','<bs>','|\\]'},
        {'\\[]|','<bs>','\\[|'},
        {"a''|",'<bs>',"a'|"},
        {"a'|'",'<bs>',"a|'"},
        {"a'|' '",'<bs>',"a|' '"},
        {"a''| '",'<bs>',"a'| '",{skip=true}}, --TODO: dont alpha filter
        {'<!--|-->','<bs>','<!-|-->'},
        {'[|foo]','<bs>','|foo'},
        {'"|foo"','<bs>','|foo"'},
        {'[|\n]','<bs>','|\n'},
        {'[ ]|','<bs>','|',{skip=true}},
        {'|','<C-r>="(a<left><bs>\r','a|',{skip=true}}, --TODO
        {'(|)','H','|',{c={backspace={map='H'}}}},
        {'(|)','<bs>','|)',{c={backspace={modes={'c'}}}}},
        --{'(|)','H','|',{c={backspace={map={'<bs>','H'}}}}},
        --{'[ |foo ]','','[|foo]',},
        --{[["'"'|']],'',[["'"|]],{ts=true}},
        --{'{\n|\n}','','{|}'},
        --{'{\n\t|\n}','','{|}',{interactive=true}},
        --{'{\n\t|\n}','','{|}',{c={backspace={indent_ignore=true}}}},
        --{'[ | ]','','[|]'},
        --{'( |foo )','','(|foo)'},
        --{'(  |foo  )','','( |foo )'},
        --{'(  | )','','( | )'},
        --{'(|foo)','','|foo)',{c={backspace={overjumps=false}}}},
        --{'( | )','','(| )',{c={backspace={space=false}}}},
        --{'"|foo"','','|foo',{c={config_internal_pairs={{'"','"',bs_overjumps=true}}}}},
        --{'"|\n"','','|\n',{c={config_internal_pairs={{'"','"',bs_overjumps=true,multiline=true}}}}},
        --{'<>\n|\n<>','','<>|<>',{c={{'<>','<>',newline=true}}}},
        --{'<>\n\t|\n<>','','<>|<>',{c={{'<>','<>',newline=true},backspace={indent_ignore=true}}}},
        --{'<< | >>','','<<|>>',{c={{'<<','>>',space=true}}}},
        --{'<< |foo >>','','<<|foo>>',{c={{'<<','>>',space=true}}}},
        --{'$ | $','','$|$',{c={{'$','$',space=true}}}},
        --{'( |  )','','( | )',{c={backspace={space='balance'}}}},
        --{'(  |)','','(|)',{c={backspace={space='balance'}}}},
        --{'( |foo  )','','( |foo )',{c={backspace={space='balance'}}}},
        --{'(  |foo )','','( |foo )',{c={backspace={space='balance'}}}},
        --{'f|','','|',{abrv={f='foo'}}},
        --{'<!--|-->','','<!-|',{c={backspace={single_delete=true}},ft='markdown'}},
        --{'```|```','','``|',{c={backspace={single_delete=true}},ft='markdown'}},
        --{'**|**','<bs>','*|*',{c={{'*','*'},{'**','**'}}}},
        --{'**|**','<bs>','|**',{c={{'*','*'}}}},
        --{'(((|)))','<bs>','(|)',{c={{'(',')'},{'(((',')))'}}}},
    },
    map_newline={
        {'{|}','<cr>','{\n|\n}'},
        --{'{|}','<cr>','{\n|}',{ft='fennel'}},
        --{'{foo|}','\r','{foo\n|\n}'},
        --{'{|foo}','\r','{\n|foo\n}',},
        --{'local x=[[|]]','\r','local x=[[\n|\n]]',{ft='lua'}},
        --{'"""|"""','\r','"""\n|\n"""',{ft='python'}},
        --{'```lua|```','\r','```lua\n|\n```',{ft='markdown',skip=true}},
        --{'{|','\r','{\n|\n}',{c={cr={autoclose=true}}}},
        --{'{[(|','\r','{[(\n|\n)]}',{c={cr={autoclose=true}}}},
        --{'({|\n)','\r','({\n|\n}\n)',{c={cr={autoclose=true}}}},
        --{'{foo|','\r','{foo\n|\n}',{c={cr={autoclose=true}}}},
        --{'{|foo','\r','{\n|foo\n}',{c={cr={autoclose=true}}}},
        --{'```|','\r','```\n|\n```',{c={cr={autoclose=true}},ft='markdown'}},
        --{'{(|}','\r','{(\n|\n)}',{c={cr={autoclose=true}},skip=true}},
        --{'do|','\r','do\n\nend',{skip=true,ft='lua',c={cr={autoclose=true},{'do','end',imap=false}}}},
        --{'{|}','\r','{\n|\n};',{skip=true,ft='c',c={autosemi={'c'}}}},
        --{'{|','\r','{\n|\n};',{skip=true,ft='c',c={autosemi={'c'},autoclose=true}}},
        --{'{|};','\r','{\n|\n};',{skip=true,ft='c',c={autosemi={'c'},autoclose=true}}},
        --{'(function()|)','<cr>','(function()\n|\nend)',{req='endwise'}},
    },
    map_space={
        {'[|]',' ','[ |]'},
        {'[|]',' ','[ | ]',{c={space={enable=true}}}},
        {'[|foo]',' ','[ |foo ]',{c={space={enable=true}}}},
        {'[|foo ]',' ','[ |foo ]',{c={space={enable=true}}}},
        {'[ |foo]',' ','[  |foo  ]',{c={space={enable=true}}}},
        {'[|foo  ]',' ','[ |foo  ]',{c={space={enable=true}}}},
        --{'+ [|]',' ','+ [ |]',{ft='markdown'}},
        --{'+ (|)',' ','+ ( |)',{ft='norg'}},
        --{'+ ( )(|)',' ','+ ( )( | )',{ft='norg'}},
        --{'<<|>>',' ','<< | >>',{c={{'<<','>>',space=true}}}},
        --{'<< | >>',' ','<<  |  >>',{c={{'<<','>>',space=true}}}},
        --{'<<|foo>>',' ','<< |foo >>',{c={{'<<','>>',space=true}}}},
        --{'<< |foo >>',' ','<<  |foo  >>',{c={{'<<','>>',space=true}}}},
        --{'$|$',' ','$ | $',{c={{'$','$',space=true}}}},
        --{'$|foo$',' ','$ |foo $',{c={{'$','$',space=true}}}},
        --{'|','I="( \r','( | )',{interactive=true}},
        --{'<!--|-->',' ','<!-- | -->',{c={{'<!--','-->',space=true}}}},
        --{'[|]',' ','[ |]'},
        --{'[|]',' ','[ |]',{change={{'[',']',space=false}}}},
    },
    --map_space_beforealpha={
        --{'[ |]','foo','[ foo| ]',{interactive=true,c={space2={enable=true}}}},
        --{'[  |','foo','[  foo|  ]',{interactive=true,c={space2={enable=true}}}},
        --{'[ |oo]','f','[ f|oo ]',{interactive=true,c={space2={enable=true}}}},
        --{'[ |oo ]','f','[ f|oo ]',{interactive=true,c={space2={enable=true}}}},
        --{'[  |oo ]','f','[  f|oo  ]',{interactive=true,c={space2={enable=true}}}},
        --{'$ |$','foo','$ foo| $',{interactive=true,c={{'$','$',space=true},space2={enable=true}}}},
        --{'<< |>>','foo','<< foo| >>',{interactive=true,c={{'<<','>>',space=true},space2={enable=true}}}},
        --{'<!-- |-->','f','<!-- f| -->',{interactive=true,c={{'<!--','-->',space2=true}}}},
    --},
    map_fastwarp={
        {'{|}[]','<C-e>','{|[]}'},
        {'{,|},','<C-e>','{,,|}'},
        {'{|}foo','<C-e>','{|foo}'},
        {'{|}foo,','<C-e>','{|foo},'},
        {'{foo|},bar','<C-e>','{foo,bar|}'},
        {'{foo|},()','<C-e>','{foo,|}()'},
        --{'{foo,|}(),','<C-e>','{foo,()|},'},
        --{'(|)"bar"','<C-e>','(|"bar")'},
        --{'{foo|},','','{foo,|}'},
        --{'{foo|},(bar)','','{foo,|}(bar)'},
        --{'{(|),}','','{(|,)}'},
        --{'{(|,)}','','{(|,)}'},
        --{'(|)\n','','(\n|)',{c={fastwarp={nocursormove=false}}}},
        --{'(|),""','','(|,)""',{ts=true}},
        --{'"|"[],','','"|[]",',{ts=true}},
        --{'("|")','','("|")',{ts=true}},
        --{'"|"foo','','"|foo"',{ts=true}},
        --{'"|"foo,','','"|foo",',{ts=true}},
        --{'"|foo",bar','','"|foo,bar"',{ts=true}},
        --{'"foo|",bar','','"foo,bar|"',{ts=true}},
        --{'"|" ""','','"| """',{ts=true}},
        --{'"foo|"\n','','"foo|"\n',{ts=true}},
        --{'<<|>>foo','','<<|foo>>',{c={{'<<','>>',fastwarp=true}}}},
        --{'<<|>>()','','<<|()>>',{c={{'<<','>>',fastwarp=true}}}},
        --{'<<|>><<>>','','<<|<<>>>>',{c={{'<<','>>',fastwarp=true}}}},
        --{'(<<|>>)','','(<<|>>)',{c={{'<<','>>',fastwarp=true}}}},
        --{'<<|>>foo,,','','<<|foo>>,,',{c={{'<<','>>',fastwarp=true}}}},
        --{'(|)<<>>','','(|<<>>)',{c={{'<<','>>'}}}},
        --{'<>|<>foo','','<>|foo<>',{c={{'<>','<>',fastwarp=true}}}},
        --{'<>|<>()','','<>|()<>',{c={{'<>','<>',fastwarp=true}}}},
        --{'<>|<><><>','','<>|<><><>',{c={{'<>','<>',fastwarp=true}}}},
        --{'(<>|<>)','','(<>|<>)',{c={{'<>','<>',fastwarp=true}}}},
        --{'<>|<>foo,,','','<>|foo<>,,',{c={{'<>','<>',fastwarp=true}}}},
        --{'(|)<><>','','(|<><>)',{c={{'<>','<>'}}}},
        --{'```|```lua','','```|lua```',{ft='markdown'}},
        --{'(|)a_e','','(|a_e)'},
        --{'(|")")foo','','(|")"foo)',{c={fastwarp={no_filter_nodes={}}},ts=true}},
        --{'(|)foo','e','(|foo)',{c={fastwarp={multi=true,{map='e'},{map='E',nocursormove=false}}}}},
        --{'(|)foo','E','(foo|)',{c={fastwarp={multi=true,{map='e'},{map='E',nocursormove=false}}}}},
        --{'(|),','','(|,)',{c={fastwarp={faster=true}}}},
        --{'(|),{},','','(|,{}),',{c={fastwarp={faster=true}}}},
        --{'{|},foo(""),','','{|,foo("")},',{c={fastwarp={faster=true}}}},
    },
    map_rfaswarp={
        --{'(foo|)','','(|)foo'},
        --{'(|foo)','','(|)foo'},
        --{'(|)','','(|)'},
        --{'(foo,bar|)','','(foo|),bar'},
        --{'({bar}|)','','(|){bar}'},
        --{'("bar"|)','','(|)"bar"',{ts=true}},
        --{'(foo{bar}baz|)','','(foo{bar}|)baz'},
        --{'(\n|)','','(|)\n'},
        --{'(\n,|)','','(\n|),'},
        --{'(|"",)','','(|""),',{ts=true}},
        --{'"foo|"','','"|"foo',{ts=true}},
        --{'"|foo"','','"|"foo',{ts=true}},
        --{'"|"','','"|"',{ts=true}},
        --{'"foo,bar|"','','"foo|",bar'},
        --{'<<foo|>>','','<<|>>foo',{c={{'<<','>>',fastwarp=true}}}},
        --{'<<()|>>','','<<|>>()',{c={{'<<','>>',fastwarp=true}}}},
        --{'<<|<<>>>>','','<<|>><<>>',{c={{'<<','>>',fastwarp=true}}}},
        --{'(<<|>>)','','(<<|>>)',{c={{'<<','>>',fastwarp=true}}}},
        --{'(|"")','','(|)""'},
        --{'(|")")','','(|)")"',{ts=true,c={fastwarp={filter_string=true}},skip=true}}, --TODO: errors once in a while
        --{'(|{)}','','(|){}',{c={fastwarp={hopout=true}}}},
    },
    --ext_fly={
        --{'[{( | )}]',']','[{(  )}]|'},
        --{'(|a)',')','()|a)'},
        --{'("|")',')','("")|',{ts=true,c={{'"','"',p=11,fly=true},extensions={fly={nofilter=true}}}}},
        --{'"(|)"','"','"()"|',{ts=true,c={{'"','"',p=11,fly=true},extensions={fly={nofilter=true}}}}},
        --{[['"' "(|)"]],'"',[['"' "()"|]],{c={{'"','"',p=11,fly=true}}}},
        --{'({|})',')','({)|})',{interactive=true,c={extensions={fly={undomap='<C-u>'}}}}},
        --{'|(  )',')','(  )|'},
        --{'|(  )',')',')|(  )',{c={extensions={fly={only_jump_end_pair=true}}}}},
        --{'<<(|)>>','>','<<()>>|',{c={{'<<','>>',fly=true}}}},
        --{'(<<|>>)',')','(<<>>)|',{c={{'<<','>>',fly=true}}}},
    --},
    profile_map={
        {'|','a','bb|',{c={profile='map',{'i','a','bb'}}}},
        {'ab|c','a','a|c',{c={profile='map',{'i','a','<bs>'}}}},
        {'ab|c','a','ab<bs>|c',{c={profile='map',{'i','a','<bs>',keycode=false}}}},
    },
    profile_raw={
        {'|','a','bb|',{c={profile='raw',{{'map','a','i'},function () return {'bb'} end}}}},
        {'|','a','bb|',{c={profile='raw',{hooks={{'map','a','i'}},run=function () return {'bb'} end}}}},
        {'|a','<esc>!','bb|a',{c={profile='raw',{hooks={{'map','!','n'}},run=function () return {{'ins','bb'}} end}}}},
        --{'|','<esc>Y','|',{c={profile='raw',{hooks={{'map','Y','n'}},run=function () end}}}}, --TODO: important
    },
    profile_cond={
        {'|','a','bb|',{c={profile='cond',filter={filetype={nft={'lua'}}},{profile='map',{'i','a','bb'}}}}},
        {'|','a','a|',{ft='lua',c={profile='cond',filter={filetype={nft={'lua'}}},{profile='map',{'i','a','bb'}}}}},
    },
    hook_user={
        --TODO
    },
    hook_map={
        --TODO
    },
    DEV_run={
        {'foo\nbar|baz\nfizzbuzz','vim','foo\nbarvim|baz\nfizzbuzz'},
        {'foo\n|bar\n','<bs>','foo|bar\n'},
        {'|','f\r','foo\n|',{cmd='abbr <buffer>f foo'}},
        {'|','<C-r>=&ft\r','lua|',{ft='lua'}},
        {'„|','“','„“|'},
        {'a%','b','ab%',{cursor='%'}},
    },
}
