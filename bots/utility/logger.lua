local M = {}

function M.Print(string)
  print(GameTime() .. ": " ..string .. "\n")
end

M.Print("OMA Bots version 0.3")

return M
