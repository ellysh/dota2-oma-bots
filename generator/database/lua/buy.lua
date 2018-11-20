
local M = {}

M.OBJECTIVES = {

  {
    objective = "buy_items",
    module = require(GetScriptDirectory() .."/utility/buy_items"),
    moves = {
      {
        move = "buy_tango",
        actions = {
          {action = "buy_tango"},

        },
      },
      {
        move = "buy_flask",
        actions = {
          {action = "buy_flask"},

        },
      },
      {
        move = "buy_tpscroll",
        actions = {
          {action = "buy_tpscroll"},

        },
      },
      {
        move = "buy_boots",
        actions = {
          {action = "buy_boots"},

        },
      },
      {
        move = "buy_blades_of_attack_for_pt",
        actions = {
          {action = "buy_blades_of_attack_for_pt"},

        },
      },
      {
        move = "buy_boots_of_elves",
        actions = {
          {action = "buy_boots_of_elves"},

        },
      },
      {
        move = "buy_lifesteal",
        actions = {
          {action = "buy_lifesteal"},

        },
      },
      {
        move = "buy_quarterstaff",
        actions = {
          {action = "buy_quarterstaff"},

        },
      },
      {
        move = "buy_two_boots_of_elves",
        actions = {
          {action = "buy_two_boots_of_elves"},

        },
      },
      {
        move = "buy_ogre_axe",
        actions = {
          {action = "buy_ogre_axe"},

        },
      },
      {
        move = "buy_blades_of_attack_for_crit",
        actions = {
          {action = "buy_blades_of_attack_for_crit"},

        },
      },
      {
        move = "buy_broadsword",
        actions = {
          {action = "buy_broadsword"},

        },
      },
      {
        move = "buy_recipe_lesser_crit",
        actions = {
          {action = "buy_recipe_lesser_crit"},

        },
      },
      {
        move = "deliver_items",
        actions = {
          {action = "deliver_items"},

        },
      },
    },
  },

}

return M
