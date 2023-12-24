return {
    simple={
        {'|','(','(|)'},
        {'(|)',')','()|'},
        {'|','"','"|"'}, --TODO: slow; cause of multipair """ creating imap `"""` instead of `"`, making neovim test instance waiting for timeout
        {'"|"','"','""|'},
        {'|"','"','"|"'},
        {'"|','"','""|'},
        {'() |','(','() (|)'},
        {"'' |","'","'' '|'"},
        {'(|))','(','((|))'},
        {'"a|b"','"','"a"|"b"'},
        {'|)',')',')|)'},
        {'(|))',')','()|)'},
    },
    DEV_run={
        {'foo\nbar|baz\nfizzbuzz','vim','foo\nbarvim|baz\nfizzbuzz'},
        {'foo\n|bar\n','<bs>','foo|bar\n'},
        {'|','f\r','foo\n|',{cmd='abbr <buffer>f foo'}},
        {'|','<C-r>=&ft\r','lua|',{ft='lua'}},
    },
}
