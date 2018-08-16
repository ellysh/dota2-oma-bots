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
         and (M.pre_buy_flask()
              or M.pre_buy_ring_of_protection()
              or M.pre_buy_sobi_mask()
              or M.pre_buy_boots()
              or M.pre_buy_gloves()
              or M.pre_buy_boots_of_elves()
              or M.pre_buy_tpscroll()
              or M.pre_deliver_items()
              or M.pre_buy_two_boots_of_elves()
              or M.pre_buy_ogre_axe()
              or M.pre_buy_blades_of_attack()
              or M.pre_buy_broadsword()
              or M.pre_buy_recipe_lesser_crit())
end

function M.post_buy_items()
  return not M.pre_buy_items()
end

---------------------------------

local function IsEnoughGoldToBuy(item_name)
  return GetItemCost(item_name) <= env.BOT_DATA.gold
end

local function pre_buy_item(item_name)
  return not algorithms.DoesBotOrCourierHaveItem(item_name)
         and IsEnoughGoldToBuy(item_name)
end

function M.pre_buy_flask()
  return pre_buy_item("item_flask")
end

function M.post_buy_flask()
  return not M.pre_buy_flask()
end

function M.buy_flask()
  algorithms.BuyItem("item_flask")
end

---------------------------------

function M.pre_buy_tpscroll()
  return pre_buy_item("item_tpscroll")
end

function M.post_buy_tpscroll()
  return not M.pre_buy_tpscroll()
end

function M.buy_tpscroll()
  algorithms.BuyItem("item_tpscroll")
end

---------------------------------

function M.pre_buy_ring_of_protection()
  return pre_buy_item("item_ring_of_protection")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_basilius")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_aquila")
end

function M.post_buy_ring_of_protection()
  return not M.pre_buy_ring_of_protection()
end

function M.buy_ring_of_protection()
  algorithms.BuyItem("item_ring_of_protection")
end

---------------------------------

function M.pre_buy_sobi_mask()
  return pre_buy_item("item_sobi_mask")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_basilius")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_aquila")
end

function M.post_buy_sobi_mask()
  return not M.pre_buy_sobi_mask()
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

function M.post_buy_boots()
  return not M.pre_buy_boots()
end

function M.buy_boots()
  algorithms.BuyItem("item_boots")
end

---------------------------------

function M.pre_buy_gloves()
  return pre_buy_item("item_gloves")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_power_treads")
end

function M.post_buy_gloves()
  return not M.pre_buy_gloves()
end

function M.buy_gloves()
  algorithms.BuyItem("item_gloves")
end

---------------------------------

function M.pre_buy_boots_of_elves()
  return pre_buy_item("item_boots_of_elves")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_power_treads")
end

function M.post_buy_boots_of_elves()
  return not M.pre_buy_boots_of_elves()
end

function M.buy_boots_of_elves()
  algorithms.BuyItem("item_boots_of_elves")
end

---------------------------------

function M.pre_buy_two_boots_of_elves()
  return algorithms.DoesBotOrCourierHaveItem("item_power_treads")
         and (2 * GetItemCost("item_boots_of_elves")) <= env.BOT_DATA.gold
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_boots_of_elves")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_dragon_lance")
end

function M.post_buy_two_boots_of_elves()
  return not M.pre_buy_two_boots_of_elves()
end

function M.buy_two_boots_of_elves()
  algorithms.BuyItem("item_boots_of_elves")
  algorithms.BuyItem("item_boots_of_elves")
end

---------------------------------

function M.pre_buy_ogre_axe()
  return pre_buy_item("item_ogre_axe")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_dragon_lance")
end

function M.post_buy_ogre_axe()
  return not M.pre_buy_ogre_axe()
end

function M.buy_ogre_axe()
  algorithms.BuyItem("item_ogre_axe")
end

---------------------------------

function M.pre_buy_blades_of_attack()
  return pre_buy_item("item_blades_of_attack")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_lesser_crit")
         and algorithms.DoesBotOrCourierHaveItem(
               "item_dragon_lance")
end

function M.post_buy_blades_of_attack()
  return not M.pre_buy_blades_of_attack()
end

function M.buy_blades_of_attack()
  algorithms.BuyItem("item_blades_of_attack")
end

---------------------------------

function M.pre_buy_broadsword()
  return pre_buy_item("item_broadsword")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_lesser_crit")
         and algorithms.DoesBotOrCourierHaveItem(
               "item_dragon_lance")
end

function M.post_buy_broadsword()
  return not M.pre_buy_broadsword()
end

function M.buy_broadsword()
  algorithms.BuyItem("item_broadsword")
end

---------------------------------

function M.pre_buy_recipe_lesser_crit()
  return pre_buy_item("item_recipe_lesser_crit")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_lesser_crit")
         and algorithms.DoesBotOrCourierHaveItem(
               "item_dragon_lance")
end

function M.post_buy_recipe_lesser_crit()
  return not M.pre_buy_recipe_lesser_crit()
end

function M.buy_recipe_lesser_crit()
  algorithms.BuyItem("item_recipe_lesser_crit")
end

---------------------------------

function M.pre_deliver_items()
  return moves.pre_deliver_items()
end

function M.post_deliver_items()
  return moves.post_deliver_items()
end

function M.deliver_items()
  moves.deliver_items()
end

-- Provide an access to local functions for unit tests only

return M
