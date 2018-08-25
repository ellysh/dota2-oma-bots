local env = require(
  GetScriptDirectory() .."/utility/environment")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local M = {}

---------------------------------

-- We do not have environment variables in this objective

function M.pre_glyph()
  return M.pre_do_glyph()
end

function M.post_glyph()
  return not M.pre_glyph()
end

---------------------------------

function M.pre_do_glyph()
  local tower_data = algorithms.GetAllyBuildings(
                       env.BOT_DATA,
                       constants.MAX_UNIT_SEARCH_RADIUS)[1]

  local tower_incoming_damage = algorithms.GetTotalDamageToUnit(
                                  tower_data)

  return GetGlyphCooldown() == 0
         and (constants.MAX_INCOMING_TOWER_DAMAGE < tower_incoming_damage
              or (algorithms.IsUnitLowHp(tower_data)
                  and constants.MIN_INCOMING_TOWER_DAMAGE
                      < tower_incoming_damage))
end

function M.post_do_glyph()
  return not M.pre_do_glyph()
end

function M.do_glyph()
  env.BOT:ActionImmediate_Glyph()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
