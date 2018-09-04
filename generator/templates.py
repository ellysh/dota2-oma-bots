HEADER = """
local M = {}

M.OBJECTIVES = {
"""

FOOTER = """
}

return M
"""

#---------------------------------------------

OBJECTIVE = """
  {
    objective = "<0>",
    module = require(GetScriptDirectory() .."/utility/<0>"),
    is_interruptible = <1>,
    moves = {
<MOVES>
    },
  },
"""

#---------------------------------------------

MOVE = """      {
        move = "<2>",
        is_interruptible = <3>,
        actions = {
<ACTIONS>
        },
      },"""

#---------------------------------------------

ACTION = """          {action = "<4>"},"""
