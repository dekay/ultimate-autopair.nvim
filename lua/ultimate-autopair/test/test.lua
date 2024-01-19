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
        {'|','f(','foo(|)',{cmd='abbr <buffer>f foo'}},
        {'|','*','*|*',{c={{'*','*'},{'**','**'}}}},
        {'*|*','*','**|**',{c={{'*','*'},{'**','**'}},skip=true}}, --TODO: important
        {'**|**','*','***|***',{c={{'**','**'},{'***','***'}},skip=true}}, --TODO: important
        {'**|**','*','****|',{c={{'*','*'},{'**','**'}}}},
        {'*|**','*','**|**',{c={{'*','*'},{'**','**'}}}},
        {'**|*','*','***|*',{c={{'*','*'},{'**','**'}}}},
        {'****|','*','*****|*',{c={{'*','*'},{'**','**'}},skip=true}},
        {'***|*','*','****|*',{c={{'**','**'}},skip=true}},
        {'|','<esc>a(<esc>..a','(((|)))'},
        {'|','<esc>3a(<esc>a','(((|)))'},
        {'|foo','<esc>R(','(|)o'},
        {'<!-|','-','<!--|'},
        {'<!-|','-','<!--|-->',{ft='html'}},
        {'<!-|-->','-','<!--|-->',{ft='html'}},
        {'<!--|-->','-','<!---->|',{ft='html'}},
        {'""|','"','"""|"""',{ft='python'}},
        {'"""|"""','"','""""""|',{ft='python'}},
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
        {'\n "|"\n""','"','\n ""|\n""',{c={config_internal_pairs={{'"','"',multiline=true}}},skip=true}},
        {'(\n  (|)\n)','','(\n  |\n)',{skip=true}},
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
        --{'(|)aøe,','','(|aøe),',{interactive=true}}, --faswarp
        --{'(|aáa),','','|aáa,',{interactive=true}}, --backspace
        --{'|"¿qué?",','(','(|"¿qué?"),',{interactive=true}}, --ext.surround
        --{"ä|,","'","ä'|,",{interactive=true}}, --ext.alpha
        --{'"ě""|",','','"ě"|,',{ts=true,interactive=true}}, --backspace
        --{"'ø',|","'","'ø','|'",{ts=true,interactive=true}}, --treesitter
        --{"{'ø',{}|}",'{',"{'ø',{}{|}}",{ts=true,interactive=true}}
    },
    filter_alpha={
        {'don|t',"'","don'|t"},
        {'Ã|',"'","Ã'|",{cmd='set iskeyword='}},
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
        {'|a','<','<|a',{c={{'<','>',alpha_after=true}},skip=true}},
        {'a|','<','a<|',{c={{'<','>',alpha_before=true}},skip=true}},
        {'<|a','<','<<|a',{c={{'<<','>>',alpha_after=true}},skip=true}},
        {'a<|','<','a<<|',{c={{'<<','>>',alpha_before=true}},skip=true}},
        {'b""|','"','b"""|"',{ft='python',c={_conf_internal_pair={{'"""','"""',alpha_before=true}}},skip=true}},
    },
    filter_escape={
        {'\\|','(','\\(|'},
        {'\\\\|','(','\\\\(|)'},
        {'|\\)','(','(|)\\)'},
        {'\\(|)',')','\\()|)'},
        {'\\<!-|','-','\\<!--|',{ft='html'}},
        {'<!-| \\-->','-','<!--|--> \\-->',{ft='html'}},
        {'<!--\\-->|-->','-','<!--\\-->-->|',{ft='html'}},
        {'\\|','(','\\(|\\)',{c={{'\\(','\\)'}}}},
        {'\\\\|','(','\\\\(|)',{c={{'\\(','\\)'}}}},
        {'\\(|\\)','\\','\\(\\)|',{c={{'\\(','\\)'}}}},
        {'\\(|)','<bs>','\\|)',{skip=true}},
    },
    filter_filetype={
        {'<!-|','-','<!--|'},
        {'""|','"','"""|"'},
        {'<!-|','-','<!--|-->',{ft='html'}},
        {'|','(','(|',{ft='TelescopePrompt'}},
    },
    filter_cmdtype={
        {'|','<C-r>="(\r','()|',{c={filter={cmdtype={skip={}}}}}},
        {'|','<C-r>="("\r','(|',{c={filter={cmdtype={skip={'='}}}}}},
    },
    filter_tsnode={
        {'$1+1|$','$','$1+1$|',{c={{'$','$'}},ft='markdown',skip=true}},
        {'$|$)','(','$(|)$)',{ft='markdown',skip=true}},
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
