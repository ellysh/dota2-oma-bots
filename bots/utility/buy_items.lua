local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local map = require(
  GetScriptDirectory() .."/utility/map")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_buy_items()
  return IsCourierAvailable()
         and algorithms.IsBotAlive()
end

---------------------------------

local function IsEnoughGoldToBuy(item_name)
  local reserved_gold = functions.ternary(
                          env.BOT_DATA.level < 5,
                          0,
                          constants.RESERVED_GOLD)

  return (GetItemCost(item_name) + reserved_gold)
          <= env.BOT_DATA.gold
end

local function pre_buy_item(item_name)
  return not algorithms.DoesBotOrCourierHaveItem(item_name)
         and IsEnoughGoldToBuy(item_name)
end

function M.pre_buy_flask()
  return not algorithms.DoesBotOrCourierHaveItem("item_flask")
         and GetItemCost("item_flask") <= env.BOT_DATA.gold
end

function M.buy_flask()
  algorithms.BuyItem("item_flask")
end

---------------------------------

function M.pre_buy_tango()
  return not algorithms.DoesBotOrCourierHaveItem("item_tango")
         and env.BOT_DATA.level == 1
         and GetItemCost("item_tango") <= env.BOT_DATA.gold
end

function M.buy_tango()
  algorithms.BuyItem("item_tango")
end

---------------------------------

function M.pre_buy_tpscroll()
  return not algorithms.DoesBotOrCourierHaveItem("item_tpscroll")
         and GetItemCost("item_tpscroll") <= env.BOT_DATA.gold
end

function M.buy_tpscroll()
  algorithms.BuyItem("item_tpscroll")
end

---------------------------------

function M.pre_buy_ring_of_protection()
  return pre_buy_item("item_ring_of_protection")

         and algorithms.DoesBotOrCourierHaveItem("item_power_treads")

         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_basilius")

         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_aquila")
end

function M.buy_ring_of_protection()
  algorithms.BuyItem("item_ring_of_protection")
end

---------------------------------

function M.pre_buy_sobi_mask()
  return pre_buy_item("item_sobi_mask")

         and algorithms.DoesBotOrCourierHaveItem(
               "item_ring_of_protection")

         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_basilius")

         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_aquila")
end

function M.buy_sobi_mask()
  algorithms.BuyItem("item_sobi_mask")
end

---------------------------------

function M.pre_buy_boots()
  return pre_buy_item("item_boots")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_power_treads")
end

function M.buy_boots()
  algorithms.BuyItem("item_boots")
end

---------------------------------

function M.pre_buy_gloves()
  return pre_buy_item("item_gloves")

         and algorithms.DoesBotOrCourierHaveItem("item_boots")

         and not algorithms.DoesBotOrCourierHaveItem("item_power_treads")
end

function M.buy_gloves()
  algorithms.BuyItem("item_gloves")
end

---------------------------------

function M.pre_buy_boots_of_elves()
  return pre_buy_item("item_boots_of_elves")
         and algorithms.DoesBotOrCourierHaveItem("item_mask_of_madness")
         and not algorithms.DoesBotOrCourierHaveItem("item_power_treads")
end

function M.buy_boots_of_elves()
  algorithms.BuyItem("item_boots_of_elves")
end

---------------------------------

function M.pre_buy_lifesteal()
  return pre_buy_item("item_lifesteal")
         and algorithms.DoesBotOrCourierHaveItem("item_gloves")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_mask_of_madness")
end

function M.buy_lifesteal()
  algorithms.BuyItem("item_lifesteal")
end

---------------------------------

function M.pre_buy_quarterstaff()
  return pre_buy_item("item_quarterstaff")
         and algorithms.DoesBotOrCourierHaveItem("item_lifesteal")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_mask_of_madness")
end

function M.buy_quarterstaff()
  algorithms.BuyItem("item_quarterstaff")
end

---------------------------------

function M.pre_buy_two_boots_of_elves()
  return algorithms.DoesBotOrCourierHaveItem("item_ring_of_aquila")
         and (2 * GetItemCost("item_boots_of_elves")) <= env.BOT_DATA.gold
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_boots_of_elves")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_dragon_lance")
end

function M.buy_two_boots_of_elves()
  algorithms.BuyItem("item_boots_of_elves")
  algorithms.BuyItem("item_boots_of_elves")
end

---------------------------------

function M.pre_buy_ogre_axe()
  return pre_buy_item("item_ogre_axe")
         and algorithms.DoesBotOrCourierHaveItem("item_boots_of_elves")
         and algorithms.DoesBotOrCourierHaveItem("item_power_treads")
         and not algorithms.DoesBotOrCourierHaveItem("item_dragon_lance")
end

function M.buy_ogre_axe()
  algorithms.BuyItem("item_ogre_axe")
end

---------------------------------

function M.pre_buy_blades_of_attack()
  return pre_buy_item("item_blades_of_attack")
         and algorithms.DoesBotOrCourierHaveItem("item_dragon_lance")
         and not algorithms.DoesBotOrCourierHaveItem("item_lesser_crit")
end

function M.buy_blades_of_attack()
  algorithms.BuyItem("item_blades_of_attack")
end

---------------------------------

function M.pre_buy_broadsword()
  return pre_buy_item("item_broadsword")
         and algorithms.DoesBotOrCourierHaveItem("item_blades_of_attack")
         and not algorithms.DoesBotOrCourierHaveItem("item_lesser_crit")
end

function M.buy_broadsword()
  algorithms.BuyItem("item_broadsword")
end

---------------------------------

function M.pre_buy_recipe_lesser_crit()
  return pre_buy_item("item_recipe_lesser_crit")
         and algorithms.DoesBotOrCourierHaveItem("item_broadsword")
         and not algorithms.DoesBotOrCourierHaveItem("item_lesser_crit")
end

function M.buy_recipe_lesser_crit()
  algorithms.BuyItem("item_recipe_lesser_crit")
end

---------------------------------

function M.pre_deliver_items()
  return moves.pre_deliver_items()
end

function M.deliver_items()
  moves.deliver_items()
end

-- Provide an access to local functions for unit tests only

return M
