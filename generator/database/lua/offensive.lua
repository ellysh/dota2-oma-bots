
local M = {}

M.OBJECTIVES = {

  {
    objective = "swap_items",
    module = require(GetScriptDirectory() .."/utility/swap_items"),
    moves = {
      {
        move = "swap_flask_tp",
        actions = {
          {action = "swap_flask_tp"},

        },
      },
      {
        move = "put_item_in_inventory",
        actions = {
          {action = "put_item_in_inventory"},

        },
      },
    },
  },

  {
    objective = "item_recovery",
    module = require(GetScriptDirectory() .."/utility/item_recovery"),
    moves = {
      {
        move = "heal_tango",
        actions = {
          {action = "heal_tango"},

        },
      },
    },
  },

  {
    objective = "buy_items",
    module = require(GetScriptDirectory() .."/utility/buy_items"),
    moves = {
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
        move = "buy_ring_of_protection",
        actions = {
          {action = "buy_ring_of_protection"},

        },
      },
      {
        move = "buy_sobi_mask",
        actions = {
          {action = "buy_sobi_mask"},

        },
      },
      {
        move = "buy_boots",
        actions = {
          {action = "buy_boots"},

        },
      },
      {
        move = "buy_gloves",
        actions = {
          {action = "buy_gloves"},

        },
      },
      {
        move = "buy_boots_of_elves",
        actions = {
          {action = "buy_boots_of_elves"},

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
        move = "buy_blades_of_attack",
        actions = {
          {action = "buy_blades_of_attack"},

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

  {
    objective = "evasion",
    module = require(GetScriptDirectory() .."/utility/evasion"),
    moves = {
      {
        move = "use_silence",
        actions = {
          {action = "use_silence"},

        },
      },
      {
        move = "move_safe_recovery",
        actions = {
          {action = "move_safe_recovery"},

        },
      },
      {
        move = "move_safe_evasion",
        actions = {
          {action = "move_safe_evasion"},

        },
      },
    },
  },

  {
    objective = "upgrade_skills",
    module = require(GetScriptDirectory() .."/utility/upgrade_skills"),
    moves = {
      {
        move = "upgrade",
        actions = {
          {action = "upgrade"},

        },
      },
    },
  },

  {
    objective = "kill_enemy_hero",
    module = require(GetScriptDirectory() .."/utility/kill_enemy_hero"),
    moves = {
      {
        move = "use_silence",
        actions = {
          {action = "use_silence"},

        },
      },
      {
        move = "attack_enemy_hero",
        actions = {
          {action = "attack_enemy_hero"},
          {action = "stop_attack"},

        },
      },
      {
        move = "move_enemy_hero",
        actions = {
          {action = "move_enemy_hero"},

        },
      },
    },
  },

  {
    objective = "farm",
    module = require(GetScriptDirectory() .."/utility/farm"),
    moves = {
      {
        move = "lasthit_enemy_creep",
        actions = {
          {action = "lasthit_enemy_creep"},
          {action = "stop_attack"},

        },
      },
      {
        move = "deny_ally_creep",
        actions = {
          {action = "deny_ally_creep"},
          {action = "stop_attack"},

        },
      },
    },
  },

  {
    objective = "kite",
    module = require(GetScriptDirectory() .."/utility/kite"),
    moves = {
      {
        move = "attack_enemy_hero",
        actions = {
          {action = "attack_enemy_hero"},
          {action = "stop_attack"},

        },
      },
      {
        move = "attack_enemy_tower",
        actions = {
          {action = "attack_enemy_tower"},
          {action = "stop_attack"},

        },
      },
      {
        move = "move_safe",
        actions = {
          {action = "move_safe"},

        },
      },
    },
  },

  {
    objective = "push_lane",
    module = require(GetScriptDirectory() .."/utility/push_lane"),
    moves = {
      {
        move = "use_trueshot",
        actions = {
          {action = "use_trueshot"},

        },
      },
      {
        move = "attack_enemy_creep",
        actions = {
          {action = "attack_enemy_creep"},
          {action = "stop_attack"},

        },
      },
      {
        move = "attack_enemy_tower",
        actions = {
          {action = "attack_enemy_tower"},

        },
      },
    },
  },

  {
    objective = "aggro_control",
    module = require(GetScriptDirectory() .."/utility/aggro_control"),
    moves = {
      {
        move = "aggro_last_hit",
        actions = {
          {action = "aggro_last_hit"},
          {action = "stop_attack"},

        },
      },
    },
  },

  {
    objective = "positioning",
    module = require(GetScriptDirectory() .."/utility/positioning"),
    moves = {
      {
        move = "tp_mid_tower",
        actions = {
          {action = "tp_mid_tower"},

        },
      },
      {
        move = "increase_creeps_distance",
        actions = {
          {action = "increase_creeps_distance"},

        },
      },
      {
        move = "decrease_creeps_distance",
        actions = {
          {action = "decrease_creeps_distance"},

        },
      },
      {
        move = "turn",
        actions = {
          {action = "turn"},
          {action = "stop_attack_and_move"},

        },
      },
    },
  },

  {
    objective = "force_stop",
    module = require(GetScriptDirectory() .."/utility/force_stop"),
    moves = {
      {
        move = "stop",
        actions = {
          {action = "stop_attack_and_move"},

        },
      },
    },
  },

}

return M
