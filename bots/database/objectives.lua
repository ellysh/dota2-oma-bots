
local M = {}

M.OBJECTIVES = {
  {
    objective = "prepare_for_match",
    module = require(GetScriptDirectory() .."/utility/prepare_for_match"),
    is_interruptible = false,
    moves = {
      {
        move = "buy_and_use_courier",
        is_interruptible = false,
        actions = {
          {action = "buy_courier"},
          {action = "use_courier"},
        },
      },
      {
        move = "buy_starting_items",
        is_interruptible = false,
        actions = {
          {action = "buy_starting_items"},
       }
      },
    },
  },

  {
    objective = "recovery",
    module = require(GetScriptDirectory() .."/utility/recovery"),
    is_interruptible = false,
    moves = {
      {
        move = "move_base",
        is_interruptible = false,
        actions = {
          {action = "move_base"},
          {action = "restore_hp_on_base"},
        }
      },
      {
        move = "heal_tango",
        is_interruptible = false,
        actions = {
          {action = "heal_tango"},
        }
      },
      {
        move = "heal_flask",
        is_interruptible = false,
        actions = {
          {action = "heal_flask"},
        }
      },
      {
        move = "heal_faerie_fire",
        is_interruptible = false,
        actions = {
          {action = "heal_faerie_fire"},
        }
      },
      {
        move = "move_shrine",
        is_interruptible = false,
        actions = {
          {action = "move_shrine"},
        }
      },
      {
        move = "tp_base",
        is_interruptible = false,
        actions = {
          {action = "tp_base"},
          {action = "restore_hp_on_base"},
        }
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
        }
      },
    }
  },

  {
    objective = "buy_items",
    module = require(GetScriptDirectory() .."/utility/buy_items"),
    is_interruptible = false,
    moves = {
      {
        move = "put_item_in_inventory",
        is_interruptible = false,
        actions = {
          {action = "put_item_in_inventory"},
        }
      },
      {
        move = "swap_items",
        is_interruptible = false,
        actions = {
          {action = "swap_items"},
        }
      },
      {
        move = "buy_flask",
        is_interruptible = false,
        actions = {
          {action = "buy_flask"},
        }
      },
      {
        move = "buy_faerie_fire",
        is_interruptible = false,
        actions = {
          {action = "buy_faerie_fire"},
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
        move = "deliver_items",
        is_interruptible = false,
        actions = {
          {action = "deliver_items"},
        }
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
        }
      },
      {
        move = "attack_enemy_hero",
        is_interruptible = true,
        actions = {
          {action = "attack_enemy_hero"},
        }
      },
    }
  },

  {
    objective = "laning",
    module = require(GetScriptDirectory() .."/utility/laning"),
    is_interruptible = true,
    moves = {
      {
        move = "move_mid_tower",
        is_interruptible = true,
        actions = {
          {action = "move_mid_tower"},
        }
      },
      {
        move = "lasthit_enemy_creep",
        is_interruptible = false,
        actions = {
          {action = "lasthit_enemy_creep"},
          {action = "stop"},
        }
      },
      {
        move = "deny_ally_creep",
        is_interruptible = false,
        actions = {
          {action = "deny_ally_creep"},
          {action = "stop"},
        }
      },
      {
        move = "harras_enemy_hero",
        is_interruptible = true,
        actions = {
          {action = "harras_enemy_hero"},
          {action = "stop"},
        }
      },
      {
        move = "evasion",
        is_interruptible = false,
        actions = {
          {action = "evasion"},
        }
      },
      {
        move = "increase_creeps_distance",
        is_interruptible = true,
        actions = {
          {action = "increase_creeps_distance"},
        }
      },
      {
        move = "attack_enemy_creep",
        is_interruptible = true,
        actions = {
          {action = "attack_enemy_creep"},
          {action = "stop"},
        }
      },
      {
        move = "attack_ally_creep",
        is_interruptible = true,
        actions = {
          {action = "attack_ally_creep"},
          {action = "stop"},
        }
      },
      {
        move = "attack_enemy_tower",
        is_interruptible = true,
        actions = {
          {action = "attack_enemy_tower"},
          {action = "stop"},
        }
      },
      {
        move = "decrease_creeps_distance",
        is_interruptible = true,
        actions = {
          {action = "decrease_creeps_distance"},
        }
      },
      {
        move = "turn",
        is_interruptible = true,
        actions = {
          {action = "turn"},
        }
      },
      {
        move = "stop",
        is_interruptible = true,
        actions = {
          {action = "stop"},
        }
      },
    },
  },

}

return M
