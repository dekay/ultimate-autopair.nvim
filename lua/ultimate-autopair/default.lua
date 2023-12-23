local in_lisp=function (fn)
    return not fn.in_lisp() or fn.in_string() or fn.in_comment()
end
return {
    conf={
        {'(',')'},
        {'"','"'},
        {"'","'",alpha_before=true,cond=in_lisp},
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
    },
    tex={
        change={
            {"'","'",nft={'tex'}},
            {'`','`',nft={'text'}},
        },
        {'``',"''",ft={'tex'}},
    },
}
