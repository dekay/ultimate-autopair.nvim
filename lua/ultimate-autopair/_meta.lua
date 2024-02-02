---@class ua.instance
---@field [number] ua.object
---@field disabled boolean?
---@field hooked 'half'|boolean?
---@class ua.info
---@field m ua.object
---@field line string --Special, is calculated from lines[row], do not set
---@field lines string[]
---@field row number
---@field col number
---@field source ua.source
---@class ua.act
---@field [1] 'left'|'right'|'ins'|'pos'|'delete'
---@field [number] any
---@alias ua.actions (string|ua.act)[]
---@class ua.object
---@field run? fun(o:ua.info):ua.actions?
---@field hooks ua.hook.hash[]
---@field __hook_subconf? ua.hook.subconf --TODO
---@field doc? string
---@field p? number
---@alias ua.id number
---@alias ua.prof.conf table
---@class ua.filter
---@field conf table
---@field cols number
---@field cole number
---@field line string --Special, is calculated from lines[row], do not set
---@field lines string[]
---@field rows number
---@field rowe number
---@field source ua.source
---@class ua.source
---@field o table<string,any>
---@field cmdtype string|nil
---@field get_parser fun():LanguageTree?
---@field source number|string
---@field _cache table<function|table,any>
---@field _lines string[]
