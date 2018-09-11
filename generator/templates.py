HEADER = """
local M = {}

M.OBJECTIVES = {
"""

FOOTER = """
}

return M
"""

#---------------------------------------------

STRATEGY_HEADER = """
  {
    strategy = "<0>",
    objectives = {
"""

STRATEGY_FOOTER = """
    },
  },
"""

#---------------------------------------------

OBJECTIVE_HEADER = """
  {
    objective = "<0>",
    module = require(GetScriptDirectory() .."/utility/<0>"),
    moves = {"""

OBJECTIVE_FOOTER = """
    },
  },
"""

#---------------------------------------------

MOVE_HEADER = """
      {
        move = "<1>",
        actions = {
"""

MOVE_FOOTER = """
        },
      },"""

#---------------------------------------------

ACTION = """          {action = "<2>"},
"""
