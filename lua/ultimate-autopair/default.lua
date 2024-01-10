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
        {'[',']'},
        {'{','}'},
        {'"','"'},
        --{"'","'",start_pair={alpha_before=true},cond=in_lisp},
        {"'","'",start_pair={filter={alpha={before=true,py_fstr=true}}}}, --TODO: temp
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
            filetype={nft={'TelescopePrompt'}},
            tsnode={p=-2},
        },
        extension={
            surround={},
            fly={},
        },
        integration={
            autotag={},
            endwise={},
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
    },
    --TODO>>
    lua={
        change={
            {"'","'",alpha_before={_filter=true,tsnode={not_after={lua={'string'}}}}},
        },
        {'%[=-%[','%]=-%]',type='patter',ft={'lua'}},
    },
    comment={
        {function (o)
            local utils=require'ultimate-autopair.utils'
            local comment=utils.ft_get_option(utils.get_filetype_after_insert(utils.to_filter(o),'´'),'commentstring') --[[@as string]]
            local pair={comment:match('(.+)%%s(.+)')}
            return #pair>0 and pair or nil
        end,type='callable'}
    },
}
