local in_lisp=function (fn)
    return not fn.in_lisp() or fn.in_string() or fn.in_comment()
end
local markdown={
    ts_not_after={markdown={'latex_block','code_span','fenced_code_block'}}
}
return {
    conf={
        merge={
            filter=true,
            extension=true,
        },
        {'(',')'},
        {'"','"'},
        --{"'","'",end_pair={alpha_before=true},cond=in_lisp},
        {"'","'",filter={alpha={before=true}}}, --TODO: temp
        {'`','`',cond=in_lisp},
        {'```','```',ft={'markdown'}},
        {'<!--','-->',ft={'markdown','html'}},
        {'"""','"""',ft={'python'}},
        {"'''","'''",ft={'python'}},
        filter={
            alpha={},
            cmdtype={},
            cond={p=-1},
            escape={},
            filetype={},
            tsnode={p=-2},
        },
        extension={
            surround={},
            fly={},
        },
    },
    tex={
        change={
            {"'","'",nft={'tex'}},
            {'`','`',nft={'text'}},
        },
        {'``',"''",ft={'tex'}},
    },
    markdown={
        change={
            {'`','`',tsnode={lang_detect='after insert',not_after={markdown={'latex_block','fenced_code_block'}}}},
        },
        {'*','*',ft={'markdown'},tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
        {'_','_',ft={'markdown'},tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
        {'__','__',ft={'markdown'},tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
        {'**','**',ft={'markdown'},tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
        {'$','$',ft={'markdown'},tsnode={lang_detect='after insert',not_after={markdown={'code_span','fenced_code_block'}}}},
    },
    rust={
        change={
            {"'","'",tsnode={not_after={rust={'lifetime'}}}},
        },
    }
}
