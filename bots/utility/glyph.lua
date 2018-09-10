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

local function GetAllyTower()
  local buildings = all_units.GetAllyBuildingsData(env.BOT_DATA)

  return functions.GetElementWith(
           buildings,
           nil,
           function(unit_data)
             return unit_data.name == "npc_dota_badguys_tower1_mid"
                    or unit_data.name == "npc_dota_goodguys_tower1_mid"
           end)
end

function M.pre_do_glyph()
  local tower_data = GetAllyTower()

  local tower_incoming_damage = algorithms.GetTotalIncomingDamage(
                                  tower_data)
                                * functions.GetDamageMultiplier(
                                    tower_data.armor)

  return GetGlyphCooldown() == 0
         and (constants.MAX_INCOMING_TOWER_DAMAGE < tower_incoming_damage
              or (algorithms.IsUnitLowHp(tower_data)
                  and constants.MIN_INCOMING_TOWER_DAMAGE
                      < tower_incoming_damage))
end

function M.do_glyph()
  env.BOT:ActionImmediate_Glyph()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
