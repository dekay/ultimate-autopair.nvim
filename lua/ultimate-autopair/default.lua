local in_lisp=function (fn)
    return not fn.in_lisp() or fn.in_string() or fn.in_comment()
end
local markdown={
    ts_not_after={'latex_block','code_span','fenced_code_block'}
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
        disable={
            ft='tex',
            {"'","'"},
            {'`','`'},
        },
        set_or_change={
            ft='tex',
            {'``',"''"},
            {'$','$'},
            {'\\[','\\]'},
            --{'$$','$$'},
        }
    },
    markdown={
        set_or_change={
            ft='markdown',
            {'`','`',tsnode={lang_detect='after insert',not_after={'latex_block','fenced_code_block'}}},
            {'*','*',tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
            {'_','_',tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
            {'__','__',tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
            {'**','**',tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
            {'$','$',tsnode={lang_detect='after insert',not_after={'code_span','fenced_code_block'}}},
            {'~~','~~',tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
            --{'***','***',tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
            --{'___','___',tsnode={lang_detect='after insert',not_after=markdown.ts_not_after}},
        }
    },
    rust_default_include={ --TODO
        set_or_change={
            ft='rust',
            {"'","'",tsnode={not_after={'lifetime','label'}}},
        },
    },
    rust={ --TODO
        set_or_change={
            ft='rust',
            {'<','>',
                tsnode={not_after={'arrow_function','binary_expression','augmented_assignment_expression'}},
                multiline=function (fn) return fn.treesitter_enabled() end,
            },
        }
    },
    lua_default_include={ --TODO
        set_or_change={
            ft='lua',
            {"'","'",alpha_before={tsnode={not_after={'string'}}}},
        },
    },
    lua={ --TODO
        set_or_change={
            ft='lua',
            {'%[=-%[','%]=-%]',type='patter'},
        },
    },
    comment={ --TODO
        {function (o)
            local utils=require'ultimate-autopair.utils'
            local comment=utils.ft_get_option(utils.get_filetype_after_insert(utils.to_filter(o),'´'),'commentstring') --[[@as string]]
            local pair={comment:match('(.+)%%s(.+)')}
            return #pair>0 and pair or nil
        end,type='callable'}
    },
}
