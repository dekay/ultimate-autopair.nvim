# Design
## Setup
1. Configurations will be parsed by a configuration parser.
    + If such parser/parsers exist.
    + `init.setup` will use `init.extend_default`.
2. All previously defined hooks(mappings,autocmds,other) are cleared for the instance.
    + If the instance has not previously defined hooks, don't do anything.
3. All configurations are passed to their respective profiles (`profile=*`)
    + `init.setup` will use `default` profile.
4. The profiles will generate modules from the configurations and add them to `mem`.
    + `mem` is a list of modules, each instance has one.
5. The specified hook system creates hooks for the modules.
## Run
1. The hook system catches an action
2. The hook system looks up which modules wanted to hook into the action.
3. The hook system recalls the action to the modules until one of them returns an action.
    + If no module returns an action, a fallback is used.
4. The action is sent to the editor


