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
        {'*|*','*','**|**',{c={{'*','*'},{'**','**'}},skip=true}},
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
    DEV_run={
        {'foo\nbar|baz\nfizzbuzz','vim','foo\nbarvim|baz\nfizzbuzz'},
        {'foo\n|bar\n','<bs>','foo|bar\n'},
        {'|','f\r','foo\n|',{cmd='abbr <buffer>f foo'}},
        {'|','<C-r>=&ft\r','lua|',{ft='lua'}},
        {'„|','“','„“|'},
        {'a%','b','ab%',{cursor='%'}},
    },
}
