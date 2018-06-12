HEADER = """
local M = {}
"""

FOOTER = """
}

return M
"""
#---------------------------------------------

OBJECTIVES_HEADER = """
M.OBJECTIVES = {
"""

OBJECTIVES = """
  <0> = {
    move = "<1>",
    dependency = "<2>",
    timeout = <3>,
  },
"""

#---------------------------------------------

MOVES_HEADER = """
M.MOVES = {
"""

MOVES = """
  <0> = "<1>",
"""

#---------------------------------------------

CODE_SNIPPETS_HEADER = """
M.CODE_SNIPPETS = {
"""

CODE_SNIPPETS = """
  <0> = "<1>",
"""
