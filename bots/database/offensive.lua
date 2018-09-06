
local M = {}

M.OBJECTIVES = {

  {
    objective = "swap_items",
    module = require(GetScriptDirectory() .."/utility/swap_items"),
    is_interruptible = false,
    moves = {
      {
        move = "swap_flask_tp",
        is_interruptible = false,
        actions = {
          {action = "swap_flask_tp"},

        },
      },
      {
        move = "put_item_in_inventory",
        is_interruptible = false,
        actions = {
          {action = "put_item_in_inventory"},

        },
      },
    },
  },

  {
    objective = "buy_items",
    module = require(GetScriptDirectory() .."/utility/buy_items"),
    is_interruptible = false,
    moves = {
      {
        move = "buy_flask",
        is_interruptible = false,
        actions = {
          {action = "buy_flask"},

        },
      },
      {
        move = "buy_tpscroll",
        is_interruptible = false,
        actions = {
          {action = "buy_tpscroll"},

        },
      },
      {
        move = "buy_ring_of_protection",
        is_interruptible = false,
        actions = {
          {action = "buy_ring_of_protection"},

        },
      },
      {
        move = "buy_sobi_mask",
        is_interruptible = false,
        actions = {
          {action = "buy_sobi_mask"},

        },
      },
      {
        move = "buy_boots",
        is_interruptible = false,
        actions = {
          {action = "buy_boots"},

        },
      },
      {
        move = "buy_gloves",
        is_interruptible = false,
        actions = {
          {action = "buy_gloves"},

        },
      },
      {
        move = "buy_boots_of_elves",
        is_interruptible = false,
        actions = {
          {action = "buy_boots_of_elves"},

        },
      },
      {
        move = "buy_two_boots_of_elves",
        is_interruptible = false,
        actions = {
          {action = "buy_two_boots_of_elves"},

        },
      },
      {
        move = "buy_ogre_axe",
        is_interruptible = false,
        actions = {
          {action = "buy_ogre_axe"},

        },
      },
      {
        move = "buy_blades_of_attack",
        is_interruptible = false,
        actions = {
          {action = "buy_blades_of_attack"},

        },
      },
      {
        move = "buy_broadsword",
        is_interruptible = false,
        actions = {
          {action = "buy_broadsword"},

        },
      },
      {
        move = "buy_recipe_lesser_crit",
        is_interruptible = false,
        actions = {
          {action = "buy_recipe_lesser_crit"},

        },
      },
      {
        move = "deliver_items",
        is_interruptible = false,
        actions = {
          {action = "deliver_items"},

        },
      },
    },
  },

  {
    objective = "evasion",
    module = require(GetScriptDirectory() .."/utility/evasion"),
    is_interruptible = true,
    moves = {
      {
        move = "use_silence",
        is_interruptible = false,
        actions = {
          {action = "use_silence"},

        },
      },
      {
        move = "move_safe_recovery",
        is_interruptible = true,
        actions = {
          {action = "move_safe_recovery"},

        },
      },
      {
        move = "move_safe_evasion",
        is_interruptible = true,
        actions = {
          {action = "move_safe_evasion"},

        },
      },
    },
  },

  {
    objective = "upgrade_skills",
    module = require(GetScriptDirectory() .."/utility/upgrade_skills"),
    is_interruptible = false,
    moves = {
      {
        move = "upgrade",
        is_interruptible = false,
        actions = {
          {action = "upgrade"},

        },
      },
    },
  },

  {
    objective = "kill_enemy_hero",
    module = require(GetScriptDirectory() .."/utility/kill_enemy_hero"),
    is_interruptible = true,
    moves = {
      {
        move = "use_silence",
        is_interruptible = false,
        actions = {
          {action = "use_silence"},

        },
      },
      {
        move = "attack_enemy_hero",
        is_interruptible = false,
        actions = {
          {action = "attack_enemy_hero"},
          {action = "stop_attack"},

        },
      },
      {
        move = "move_enemy_hero",
        is_interruptible = true,
        actions = {
          {action = "move_enemy_hero"},

        },
      },
    },
  },

  {
    objective = "farm",
    module = require(GetScriptDirectory() .."/utility/farm"),
    is_interruptible = false,
    moves = {
      {
        move = "lasthit_enemy_creep",
        is_interruptible = false,
        actions = {
          {action = "lasthit_enemy_creep"},
          {action = "stop_attack"},

        },
      },
      {
        move = "deny_ally_creep",
        is_interruptible = false,
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
    is_interruptible = false,
    moves = {
      {
        move = "attack_enemy_hero",
        is_interruptible = false,
        actions = {
          {action = "attack_enemy_hero"},
          {action = "stop_attack"},

        },
      },
      {
        move = "attack_enemy_tower",
        is_interruptible = false,
        actions = {
          {action = "attack_enemy_tower"},
          {action = "stop_attack"},

        },
      },
      {
        move = "move_safe",
        is_interruptible = false,
        actions = {
          {action = "move_safe"},

        },
      },
    },
  },

  {
    objective = "push_lane",
    module = require(GetScriptDirectory() .."/utility/push_lane"),
    is_interruptible = true,
    moves = {
      {
        move = "use_trueshot",
        is_interruptible = false,
        actions = {
          {action = "use_trueshot"},

        },
      },
      {
        move = "attack_enemy_creep",
        is_interruptible = false,
        actions = {
          {action = "attack_enemy_creep"},
          {action = "stop_attack"},

        },
      },
      {
        move = "attack_enemy_tower",
        is_interruptible = true,
        actions = {
          {action = "attack_enemy_tower"},

        },
      },
    },
  },

  {
    objective = "aggro_control",
    module = require(GetScriptDirectory() .."/utility/aggro_control"),
    is_interruptible = false,
    moves = {
      {
        move = "aggro_last_hit",
        is_interruptible = false,
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
    is_interruptible = true,
    moves = {
      {
        move = "tp_mid_tower",
        is_interruptible = false,
        actions = {
          {action = "tp_mid_tower"},

        },
      },
      {
        move = "increase_creeps_distance",
        is_interruptible = true,
        actions = {
          {action = "increase_creeps_distance"},

        },
      },
      {
        move = "decrease_creeps_distance",
        is_interruptible = true,
        actions = {
          {action = "decrease_creeps_distance"},

        },
      },
      {
        move = "turn",
        is_interruptible = false,
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
    is_interruptible = true,
    moves = {
      {
        move = "stop",
        is_interruptible = true,
        actions = {
          {action = "stop_attack_and_move"},

        },
      },
    },
  },

}

return M
