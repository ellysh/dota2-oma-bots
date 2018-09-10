local env = require(
  GetScriptDirectory() .."/utility/environment")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local M = {}

---------------------------------

-- We do not have environment variables in this objective

function M.pre_buyback()
  return M.pre_do_buyback()
end

---------------------------------

function M.pre_do_buyback()
  return not algorithms.IsBotAlive()
         and env.BOT:HasBuyback()
         and 10 < env.BOT:GetRespawnTime()
end

function M.do_buyback()
  env.BOT:ActionImmediate_Buyback()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
