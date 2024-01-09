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
    },
    filter_alpha={
        {'don|t',"'","don'|t"},
        {'Ã|',"'","Ã'|",{cmd='set iskeyword='}},
        {'_|',"'","_'|"},
        {'-|',"'","-'|",{ft='lisp'}},
        {'```query\n.|\n```',"'","```query\n.'|\n```",{ft='markdown',skip=true}},
        {"'a|'","'","'a'|"},
        {'f|',"'","f'|"},
        {'f|',"'","f'|'",{ft='python'}},
        {'Rb|',"'","Rb'|'",{ft='python'}},
        {'bar|',"'","bar'|",{ft='python'}},
        {"a' |","'","a' '|'",{c={filter={alpha={filter=true}}},skip=true}},
        {'|a','<','<|a',{c={{'<','>',alpha_after=true}},skip=true}},
        {'a|','<','a<|',{c={{'<','>',alpha_before=true}},skip=true}},
        {'<|a','<','<<|a',{c={{'<<','>>',alpha_after=true}},skip=true}},
        {'a<|','<','a<<|',{c={{'<<','>>',alpha_before=true}},skip=true}},
        {'b""|','"','b"""|"',{ft='python',c={_conf_internal_pair={{'"""','"""',alpha_before=true}}},skip=true}},
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
