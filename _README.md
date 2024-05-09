# Ultimate-autopair.nvim 0.7.0
[Ultimate-autopair](https://github.com/altermo/ultimate-autopair.nvim) plugin aims to have any most features you want and be ultra customizable, while making it easy to configure.
## Major features
+ Treesitter node filtering and treesitter injected language(filetype) detection
+ Multiline support (and caching)
+ The configuration system to rule them all:
    + Smart merge with default configuration
    + Smart inherit from parent config
    + Validate that the configuration is correct
    + Every option which is not a function or static_table option may be a function which get's calculated when it's used
    + Generate a random config (cause why not)
+ Mappings
    + backspace
        + `(|)` > `|`
    + newline
        + `(|)` > `(\n|\n)`
    + space
        + `(|foo)` > `( |foo )`
        +  Previous versions had a space2 which was refactored into space, please read `:h todo`
    + fastwarp and reverse fastwarp
        + `(|)foo` > `(|foo)`
        + works multiline: `(|){foo\nbar}` > `({foo\nbar})`
    + close
        + `(|` > `(|)`
    + tabout
        + `(f|oo)` > `(foo|)`
+ Extensions
    + surround
        + `|"foo"` > `(` > `(|"foo")`
    + fly
        + `({[|]})` > `)` > `({[]})|`
+ UTF-8 compatible (or at leasts tries to be)
+ Extensiv testing
+ Terminal and normal mode support
+ And much much more...
## develop
+ if your planing to use this with `rust`: `:h ultimate-autopair-use-with-rust`
+ If your planing to use this with `latex`: `:h ultimate-autopair-use-with-latex`
+ If your planing to use this with `lisp`: `:h ultimate-autopair-use-with-lisp`
+ If your planing to use this with `html`: `:h ultimate-autopair-use-with-html`
## Install (lazy)
Minimum Neovim version: 0.9.2; Recommended: 0.10 or 0.11-dev\
(Neovim versions 0.9.1<= and 0.10-dev had bugs which could crache Neovim (see: [neovim/neovim#24796](https://github.com/neovim/neovim/pull/24796)))
```lua
{
    'altermo/ultimate-autopair.nvim',
    event={'InsertEnter','CmdlineEnter'},
    branch='v0.7', --recommended as each new version will have breaking changes
    opts={
        --Config goes here
    },
    dependencies={
        -- -- Optional dependencies
        -- 'nvim-treesitter/nvim-treesitter',
        -- -- For installing parsers which will be used to get nodes and injected filetypes
        -- 'windwp/nvim-ts-autotag',
        -- -- html tag integration (IMPORTANT: read `:h ultimate-autopair-use-with-html`)
        -- 'gpanders/nvim-parinfer'
        -- -- the parinfer algorithm for LISP

        -- -- Other recommended but not exactly related to ultimate-autopair
        -- 'RRethy/nvim-treesitter-endwise',
        -- -- Auto add `end` keyword for some languages
        -- 'abecodes/tabout.nvim',
        -- -- Treesitter based more complex tabout (if ultimate-autopair's tabout is not good enough)
        -- 'kylechui/nvim-surround',
        -- -- Surround selected with pairs, delete/change surrounding pairs (in normal/visual mode)
    },
}
```

### Donate
If you want to donate then you need to find the correct link (hint: 50₁₀):
* [0a]() [0b]() [0c]() [0d]() [0e]() [0f]() [0g]() [0h]()
* [1a]() [1b]() [1c]() [1d]() [1e]() [1f]() [1g]() [1h]()
* [2a]() [2b]() [2c]() [2d]() [2e]() [2f]() [2g]() [2h]()
* [3a]() [3b]() [3c]() [3d]() [3e]() [3f]() [3g]() [3h]()
* [4a]() [4b]() [4c]() [4d]() [4e]() [4f]() [4g]() [4h]()
* [5a]() [5b]() [5c]() [5d]() [5e]() [5f]() [5g]() [5h]()
* [6a]() [6b](https://www.buymeacoffee.com/altermo) [6c]() [6d]() [6e]() [6f]() [6g]() [6h]()
* [7a]() [7b]() [7c]() [7d]() [7e]() [7f]() [7g]() [7h]()
### Chat
+ [github discussions](https://github.com/altermo/ultimate-autopair.nvim/discussions)
<!-- + [matrix](https://matrix.to/#/#ultimate-autopair.nvim:matrix.org)-->
