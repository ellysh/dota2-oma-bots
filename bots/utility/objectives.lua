local M = {}

local objectives = require(
  GetScriptDirectory() .."/database/objectives")

local moves = require(
  GetScriptDirectory() .."/database/moves")

local code_snippets = require(
  GetScriptDirectory() .."/database/code_snippets")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local OBJECTIVES = {
  [1] = {
    objective = "prepare_for_match",
    moves = {
      {move = "buy_and_use_courier", desire = 80},
      {move = "buy_starting_items", desire = 70},
    },
    dependencies = {},
    desire = 100,
    single = true,
    done = false,
  },
  [2] = {
    objective = "laning",
    moves = {
      {move = "tp_out", desire = 100},
      {move = "evasion", desire = 90},
      {move = "move_mid_front_lane", desire = 80},
      {move = "lasthit_enemy_creep", desire = 75},
      {move = "deny_ally_creep", desire = 60},
      {move = "harras_enemy_hero", desire = 50},
      {move = "positioning", desire = 45},
      {move = "attack_enemy_building", desire = 40},
      {move = "turn", desire = 10},
      {move = "stop", desire = 1},
    },
    dependencies = {
      {objective = "prepare_for_match"},
    },
    desire = 90,
    single = false,
    done = false,
  },
}

local OBJECTIVE_INDEX = 1
local MOVE_INDEX = 1

---------------------------------

function M.pre_prepare_for_match()
  return DotaTime() < 0
end

function M.post_prepare_for_match()
  return M.post_buy_and_use_courier() and M.post_buy_starting_items()
end

---------------------------------

function M.post_buy_and_use_courier()
  -- TODO: Should we remove the single objectives here?

  return IsCourierAvailable()
end

function M.pre_buy_and_use_courier()
  return not M.post_buy_and_use_courier()
end

function M.buy_and_use_courier()
  logger.Print("M.buy_and_use_courier()")

  local bot = GetBot()

  bot:ActionImmediate_PurchaseItem('item_courier')

  bot:Action_UseAbility(functions.GetItem(bot, 'item_courier', nil))
end

---------------------------------

function M.post_buy_starting_items()
  local bot = GetBot()

  return functions.IsItemPresent(bot, 'item_flask')
         and functions.IsItemPresent(bot, 'item_tango')
         and functions.IsItemPresent(bot, 'item_slippers')
         and functions.IsItemPresent(bot, 'item_circlet')
         and functions.IsItemPresent(bot, 'item_branches')
end

function M.pre_buy_starting_items()
  return DotaTime() < 0 and not M.post_buy_starting_items()
end

function M.buy_starting_items()
  logger.Print("M.buy_starting_items()")

  local bot = GetBot()

  bot:ActionImmediate_PurchaseItem('item_flask')
  bot:ActionImmediate_PurchaseItem('item_tango')
  bot:ActionImmediate_PurchaseItem('item_slippers')
  bot:ActionImmediate_PurchaseItem('item_circlet')
  bot:ActionImmediate_PurchaseItem('item_branches')
end

---------------------------------

function M.post_laning()
  return false
end

function M.pre_laning()
  -- This is a objectives Dependency example

  return M.post_prepare_for_match()
end

---------------------------------

local function IsEnemyUnitsInAttackRange()
  local bot = GetBot()
  local creeps = common_algorithms.GetEnemyCreeps(
    bot,
    bot:GetAttackRange())

  local heroes = common_algorithms.GetEnemyHeroes(
    bot,
    bot:GetAttackRange())

  return not functions.IsArrayEmpty(creeps)
         or not functions.IsArrayEmpty(heroes)
end

function M.post_move_mid_front_lane()
  local target_location = GetLaneFrontLocation(
    GetTeam(),
    LANE_MID,
    0)

  local target_distance = GetUnitToLocationDistance(
    GetBot(),
    target_location)

  return (target_distance <= constants.MAP_LOCATION_RADIUS)
         or IsEnemyUnitsInAttackRange()
end

function M.pre_move_mid_front_lane()
  return not M.post_move_mid_front_lane()
end

function M.move_mid_front_lane()
  logger.Print("M.move_mid_front_lane()")

  local target_location = GetLaneFrontLocation(
    GetTeam(),
    LANE_MID,
    0)

  GetBot():Action_MoveToLocation(target_location)
end

local function IsLastHit(bot, unit)
  -- TODO: Consider incoming projectiles here
  return unit:GetHealth() <= 1.6 * bot:GetAttackDamage()
end

local CREEP_TYPE = {
  ENEMY = {},
  ALLY = {},
}

local function GetLastHitCreep(bot, creep_type)
  local creeps = functions.ternary(
    creep_type == CREEP_TYPE["ENEMY"],
    common_algorithms.GetEnemyCreeps(bot, 1600),
    common_algorithms.GetAllyCreeps(bot, 1600))

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMinHealth,
    function(unit)
      return common_algorithms.IsAttackTargetable(unit)
             and IsLastHit(bot, unit)
    end)
end

local function IsUnitAttack(unit)
  local anim = unit:GetAnimActivity()
  return anim == ACTIVITY_ATTACK or anim == ACTIVITY_ATTACK2
end

function M.pre_lasthit_enemy_creep()
  local bot = GetBot()

  return not IsUnitAttack(bot)
         and GetLastHitCreep(bot, CREEP_TYPE["ENEMY"]) ~= nil
end

function M.post_lasthit_enemy_creep()
  return not M.pre_lasthit_enemy_creep()
end

function M.lasthit_enemy_creep()
  local bot = GetBot()
  local creep = GetLastHitCreep(bot, CREEP_TYPE["ENEMY"])

  bot:SetTarget(creep)

  bot:Action_AttackUnit(creep, false)
end

function M.pre_deny_ally_creep()
  local bot = GetBot()

  return not IsUnitAttack(bot)
         and GetLastHitCreep(bot, CREEP_TYPE["ALLY"]) ~= nil
end

function M.post_deny_ally_creep()
  return not M.pre_deny_ally_creep()
end

function M.deny_ally_creep()
  local bot = GetBot()
  local creep = GetLastHitCreep(bot, CREEP_TYPE["ALLY"])

  bot:SetTarget(creep)

  bot:Action_AttackUnit(creep, false)
end

--------------------------------

local function AreEnemyCreepsInRadius(radius)
  local bot = GetBot()

  local creeps = common_algorithms.GetEnemyCreeps(bot, radius)

  return not functions.IsArrayEmpty(creeps)
end

function M.pre_positioning()
  return AreEnemyCreepsInRadius(constants.MIN_CREEP_DISTANCE)
end

function M.post_positioning()
  return not M.pre_positioning()
end

function M.positioning()
  local bot = GetBot()
  bot:Action_MoveToLocation(GetShopLocation(GetTeam(), SHOP_HOME))
end

--------------------------------

local function IsFocusedByEnemies()
  local bot = GetBot()
  local enemy_towers = bot:GetNearbyTowers(
    constants.MAX_TOWER_ATTACK_RANGE,
    true)

  local enemy_creeps = common_algorithms.GetEnemyCreeps(
    bot,
    constants.MAX_CREEP_ATTACK_RANGE)

  local enemy_heroes = common_algorithms.GetEnemyHeroes(
    bot,
    constants.MAX_HERO_ATTACK_RANGE)

  local total_damage =
    common_algorithms.GetTotalDamage(enemy_towers, bot) +
    common_algorithms.GetTotalDamage(enemy_creeps, bot) +
    common_algorithms.GetTotalDamage(enemy_heroes, bot)

  return 0.2 < functions.GetRate(total_damage, bot:GetHealth())
end

function M.pre_evasion()
  return IsFocusedByEnemies()
end

function M.post_evasion()
  return not M.pre_evasion()
end

function M.evasion()
  local bot = GetBot()
  bot:Action_MoveToLocation(GetShopLocation(GetTeam(), SHOP_HOME))
end

--------------------------------

local function IsEnemyTowerInRadius(radius)
  local bot = GetBot()
  local units = bot:GetNearbyTowers(radius, true)

  return not functions.IsArrayEmpty(units)
end

local function GetEnemyHero(bot)
  local heroes = common_algorithms.GetEnemyHeroes(bot, 1600)

  return functions.GetElementWith(
    heroes,
    common_algorithms.CompareMinHealth,
    function(unit)
      return common_algorithms.IsAttackTargetable(unit)
    end)
end

function M.pre_harras_enemy_hero()
  local bot = GetBot()

  return not AreEnemyCreepsInRadius(constants.CREEP_AGRO_RADIUS)
         and not IsEnemyTowerInRadius(constants.MAX_TOWER_ATTACK_RANGE)
         and not IsUnitAttack(bot)
         and GetEnemyHero(bot) ~= nil
end

function M.post_harras_enemy_hero()
  return not M.pre_harras_enemy_hero()
end

function M.harras_enemy_hero()
  local bot = GetBot()
  local hero = GetEnemyHero(bot)

  bot:SetTarget(hero)

  bot:Action_AttackUnit(hero, false)
end

--------------------------------

local function GetEnemyBuilding(bot)
  local units = common_algorithms.GetEnemyBuildings(bot, 1600)

  return functions.GetElementWith(
    units,
    common_algorithms.CompareMinHealth,
    function(unit)
      return common_algorithms.IsAttackTargetable(unit)
    end)
end

function M.pre_attack_enemy_building()
  -- TODO: Check if it is safe to attack building
  local bot = GetBot()

  return not IsUnitAttack(bot)
         and GetEnemyBuilding(bot) ~= nil
end

function M.post_attack_enemy_building()
  return not M.pre_attack_enemy_building()
end

function M.attack_enemy_building()
  local bot = GetBot()
  local unit = GetEnemyBuilding(bot)

  bot:SetTarget(unit)

  bot:Action_AttackUnit(unit, false)
end

---------------------------------

local function IsAttackDone(unit)
  if not IsUnitAttack(unit) then
    return true
  end

  return unit:GetAttackPoint() <= unit:GetAnimCycle()
end

local function IsUnitMoving(unit)
  return unit:GetAnimActivity() == ACTIVITY_RUN
end

function M.pre_stop()
  local bot = GetBot()
  local action = bot:GetCurrentActionType()

  return (IsUnitAttack(bot) and IsAttackDone(bot)) or IsUnitMoving(bot)
end

function M.post_stop()
  return not M.pre_stop()
end

function M.stop()
  local bot = GetBot()
  bot:Action_ClearActions(true)
end

---------------------------------

local function GetEnemyCreep()
  return common_algorithms.GetEnemyCreeps(GetBot(), 1600)[1]
end

function M.pre_turn()
  local bot = GetBot()
  return IsEnemyUnitsInAttackRange()
         and not IsUnitAttack(bot)
         and not IsUnitMoving(bot)
         and not bot:IsFacingLocation(GetEnemyCreep():GetLocation(), 30)
end

function M.post_turn()
  return not M.pre_turn()
end

function M.turn()
  local bot = GetBot()

  if not IsUnitMoving(bot) then
    bot:Action_MoveToLocation(GetEnemyCreep():GetLocation())
  else
    bot:Action_ClearActions(true)
  end
end

---------------------------------

function M.pre_attack_enemy_building()
  -- TODO: Implement this
  return false
end

function M.pre_tp_out()
  -- TODO: Implement this
  return false
end

---------------------------------

local function GetCurrentObjective()
  return OBJECTIVES[OBJECTIVE_INDEX]
end

local function GetCurrentMove()
  return GetCurrentObjective().moves[MOVE_INDEX]
end

local function FindNextObjective()
  -- TODO: Consider desire values here

  OBJECTIVE_INDEX = OBJECTIVE_INDEX + 1
  if #OBJECTIVES < OBJECTIVE_INDEX then
    OBJECTIVE_INDEX = 1
  end
end

local function FindNextMove()
  -- TODO: Consider desire values here

  MOVE_INDEX = MOVE_INDEX + 1
  if #GetCurrentObjective().moves < MOVE_INDEX then
    MOVE_INDEX = 1
  end
end

local function executeMove()
  local current_move = GetCurrentMove()

  logger.Print("current_move = " .. current_move.move ..
    " MOVE_INDEX = " .. MOVE_INDEX)

  if not M["pre_" .. current_move.move]()
    or M["post_" .. current_move.move]() then

    FindNextMove()
    return
  end

  M[current_move.move]()
end

function M.Process()
  local current_objective = GetCurrentObjective()

  logger.Print("current_objective = " .. current_objective.objective ..
    " OBJECTIVE_INDEX = " .. OBJECTIVE_INDEX)

  if not current_objective.done
     and M["pre_" .. current_objective.objective]() then

     executeMove(current_objective)
  else
    -- We should find another objective here
    FindNextObjective()
    return
  end

  if M["post_" .. current_objective.objective]() then
    current_objective.done = true
    FindNextObjective()
  end
end

-- Provide an access to local functions for unit tests only

return M
