HEADER = """
local M = {}

M.OBJECTIVES = {
"""

FOOTER = """
}

return M
"""

#---------------------------------------------

OBJECTIVE_HEADER = """
  {
    objective = "<0>",
    module = require(GetScriptDirectory() .."/utility/<0>"),
    is_interruptible = <1>,
    moves = {"""

OBJECTIVE_FOOTER = """
    },
  },
"""

#---------------------------------------------

MOVE_HEADER = """
      {
        move = "<2>",
        is_interruptible = <3>,
        actions = {
"""

MOVE_FOOTER = """
        },
      },"""

#---------------------------------------------

ACTION = """          {action = "<4>"},
"""
