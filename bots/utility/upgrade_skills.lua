local skill_build = require(
  GetScriptDirectory() .."/database/skill_build")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local map = require(
  GetScriptDirectory() .."/utility/map")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_upgrade_skills()
  return algorithms.IsBotAlive()
end

---------------------------------

function M.pre_upgrade()
  return 0 < env.BOT_DATA.ability_points
end

function M.upgrade()
  env.BOT:ActionImmediate_LevelAbility(
    skill_build.SKILL_BUILD[env.BOT_DATA.level])
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
