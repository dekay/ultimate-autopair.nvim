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
---@field lsave table
---@field buf? number --TODO: temp
---@class ua.act
---@field [1] 'left'|'right'|'ins'
---@field [number] any
---@alias ua.actions (string|ua.act)[]
---@class ua.object
---@field run? fun(o:ua.info):ua.actions?
---@field hooks ua.hook.hash[]
---@field __hook_subconf ua.hook.subconf --TODO
---@field doc? string
---@field p? number
---@alias ua.id number
---@alias ua.prof.conf table
---@class ua.filter
---@field conf table --TODO: temp
---@field cols number
---@field cole number
---@field line string --Special, is calculated from lines[row], do not set
---@field lines string[]
---@field rows number
---@field rowe number
---@field source string[]|string|number --TODO: temp
