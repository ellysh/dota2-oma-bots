local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local M = {}

---------------------------------

-- We do not have environment variables in this objective

function M.pre_buyback()
  local bot = GetBot()

  return not algorithms.IsBotAlive()
         and bot:HasBuyback()
         and 10 < bot:GetRespawnTime()
end

function M.post_buyback()
  return not M.pre_buyback()
end

---------------------------------

function M.pre_do_buyback()
  return true
end

function M.post_do_buyback()
  return not M.pre_do_buyback()
end

function M.do_buyback()
  GetBot():ActionImmediate_Buyback()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
