# Problems
## How to do the hook system
The hook system handles both input and output.
Each object requests a hook creation. These requests have a `mode`, a `type` and an `input` key, which denote the what request is created. `mode` can be any major-mode in Neovim. `type` can be `autocmd-function`, `autocmd-feedkeys`, `map-function`, `map-expr` and `map-feedkeys`. If a `map-expr` and a `map-*` have the same `input` then error. The `map-expr` has an option called `dot_all` which will force the output to be dot repeatable. The `input` key contains the input to hook into. It may be `string` for mappings and `string|enum(charset)` for autocmds, where enum(charset) is a set of characters to hook into instead of just one, like all alpha characters (including UTF-8 ones).
Every hook request gets passed to hook creators, if non of them can make sense of the request then error.
### How to remember which object requested which hook
#### Idea 1
Have each object have a `hooks` table (Maybe even don't have a `hooks_get()` function and use the `hooks` instead for hook requests). Problem: needing to cycle through all ids.
#### Idea 2
Have a global `hooks` table where each hook is pointed towards a list of objects. Problem: need to cycle through all hooks when deleting an id.
#### Idea 3 *
Idea 1 and 2 combined. When deleting an id, just do `each i obj.hooks {remove_item(hooks[i],obj)}`. When adding `obj.hooks:append(hook) hooks[hook]:append(obj)`. When a hook is activated `each i hooks[hook] {do(i)}`.
### How to do documentation for hooks
#### Idea 1
Collect all the objects for a particular hook and then create the hook. Problem: what if a new object is to be added?
#### Idea 2 *
Every time a new object is added, recreate the hook and use the documentation from the global `hooks`.
Per instance instead of per object, as typically multiple objects are hooked into the same hook at once.
### How to create user created hooks
#### Idea 1 *
Have a hook creator which does exactly that. Problem: a little bit complicated.
### How to send hooks as user
#### Idea 1 *
`hook.send(input,type?,mode?)` where mode is infer if not given and type is all if not given. And for the output, don't use the underlying hook-creator, and instead have a separate `hook.act`, which can take options such as `function`, `feedkey` or `expr` (and `dot-all`).
## How to do the filter system
## How to do the extension system
