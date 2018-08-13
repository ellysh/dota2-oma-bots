
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
      {
        move = "move_start_position",
        is_interruptible = false,
        actions = {
          {action = "move_start_position"},
        },
      },
    },
  },

  {
    objective = "body_block",
    module = require(GetScriptDirectory() .."/utility/body_block"),
    is_interruptible = false,
    moves = {
      {
        move = "move_and_block",
        is_interruptible = false,
        actions = {
          {action = "move_and_block"},
          {action = "stop_attack_and_move"},
        },
      },
    },
  },

  {
    objective = "item_recovery",
    module = require(GetScriptDirectory() .."/utility/item_recovery"),
    is_interruptible = false,
    moves = {
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
        move = "tp_base",
        is_interruptible = false,
        actions = {
          {action = "tp_base"},
        }
      },
    },
  },

  {
    objective = "base_recovery",
    module = require(GetScriptDirectory() .."/utility/base_recovery"),
    is_interruptible = true,
    moves = {
      {
        move = "deliver_items",
        is_interruptible = false,
        actions = {
          {action = "deliver_items"},
        }
      },
      {
        move = "move_base",
        is_interruptible = true,
        actions = {
          {action = "move_base"},
          {action = "restore_hp_on_base"},
        }
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
        }
      },
      {
        move = "move_safe_recovery",
        is_interruptible = false,
        actions = {
          {action = "move_safe_recovery"},
        }
      },
      {
        move = "move_safe_evasion",
        is_interruptible = false,
        actions = {
          {action = "move_safe_evasion"},
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
        is_interruptible = false,
        actions = {
          {action = "attack_enemy_hero"},
          {action = "stop_attack"},
        }
      },
      {
        move = "move_enemy_hero",
        is_interruptible = true,
        actions = {
          {action = "move_enemy_hero"},
        }
      },
      {
        move = "attack_enemy_hero",
        is_interruptible = false,
        actions = {
          {action = "attack_enemy_hero"},
          {action = "stop_attack"},
        }
      },
    }
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
        }
      },
      {
        move = "lasthit_enemy_creep",
        is_interruptible = false,
        actions = {
          {action = "lasthit_enemy_creep"},
          {action = "stop_attack"},
        }
      },
      {
        move = "deny_ally_creep",
        is_interruptible = false,
        actions = {
          {action = "deny_ally_creep"},
          {action = "stop_attack"},
        }
      },
      {
        move = "attack_enemy_creep",
        is_interruptible = false,
        actions = {
          {action = "attack_enemy_creep"},
          {action = "stop_attack"},
        }
      },
      {
        move = "attack_enemy_tower",
        is_interruptible = true,
        actions = {
          {action = "attack_enemy_tower"},
        }
      },
    }
  },

  {
    objective = "attack_unit",
    module = require(GetScriptDirectory() .."/utility/attack_unit"),
    is_interruptible = true,
    moves = {
      {
        move = "lasthit_enemy_creep",
        is_interruptible = false,
        actions = {
          {action = "lasthit_enemy_creep"},
          {action = "stop_attack"},
        }
      },
      {
        move = "deny_ally_creep",
        is_interruptible = false,
        actions = {
          {action = "deny_ally_creep"},
          {action = "stop_attack"},
        }
      },
      {
        move = "harras_enemy_hero",
        is_interruptible = false,
        actions = {
          {action = "harras_enemy_hero"},
          {action = "stop_attack"},
        }
      },
      {
        move = "attack_enemy_creep",
        is_interruptible = false,
        actions = {
          {action = "attack_enemy_creep"},
          {action = "stop_attack"},
        }
      },
      {
        move = "attack_ally_creep",
        is_interruptible = false,
        actions = {
          {action = "attack_ally_creep"},
          {action = "stop_attack"},
        }
      },
      {
        move = "attack_enemy_tower",
        is_interruptible = true,
        actions = {
          {action = "attack_enemy_tower"},
        }
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
        }
      },
      {
        move = "move_mid_tower",
        is_interruptible = true,
        actions = {
          {action = "move_mid_tower"},
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
        move = "decrease_creeps_distance",
        is_interruptible = true,
        actions = {
          {action = "decrease_creeps_distance"},
        }
      },
      {
        move = "turn",
        is_interruptible = false,
        actions = {
          {action = "turn"},
          {action = "stop_attack_and_move"},
        }
      },
    }
  },

}

return M
