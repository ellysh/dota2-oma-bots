local env = require(
  GetScriptDirectory() .."/utility/environment")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local M = {}

---------------------------------

-- We do not have environment variables in this objective

function M.pre_glyph()
  return M.pre_do_glyph()
end

---------------------------------

function M.pre_do_glyph()
  local tower_incoming_damage = algorithms.GetTotalIncomingDamage(
                                  env.ALLY_TOWER_DATA)
                                * functions.GetDamageMultiplier(
                                    env.ALLY_TOWER_DATA.armor)

  return GetGlyphCooldown() == 0
         and (constants.MAX_INCOMING_TOWER_DAMAGE < tower_incoming_damage
              or (algorithms.IsUnitLowHp(env.ALLY_TOWER_DATA)
                  and constants.MIN_INCOMING_TOWER_DAMAGE
                      < tower_incoming_damage))
end

function M.do_glyph()
  env.BOT:ActionImmediate_Glyph()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
