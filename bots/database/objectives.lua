
local M = {}

M.OBJECTIVES = {
  {
    objective = "prepare_for_match",
    module = require(GetScriptDirectory() .."/utility/prepare_for_match"),
    moves = {
      {
        move = "buy_and_use_courier",
        actions = {
          {action = "buy_courier"},
          {action = "use_courier"},
        },
      },
      {
        move = "buy_starting_items",
        actions = {
          {action = "buy_starting_items"},
       }
      },
    },
  },

  {
    objective = "recovery",
    module = require(GetScriptDirectory() .."/utility/recovery"),
    moves = {
      {
        move = "move_base",
        actions = {
          {action = "move_base"},
          {action = "restore_hp_on_base"},
        }
      },
      {
        move = "heal_tango",
        actions = {
          {action = "heal_tango"},
        }
      },
      {
        move = "heal_flask",
        actions = {
          {action = "heal_flask"},
        }
      },
      {
        move = "heal_faerie_fire",
        actions = {
          {action = "heal_faerie_fire"},
        }
      },
      {
        move = "move_shrine",
        actions = {
          {action = "move_shrine"},
        }
      },
      {
        move = "tp_base",
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
    moves = {
      {
        move = "upgrade",
        actions = {
          {action = "upgrade"},
        }
      },
    }
  },

  {
    objective = "buy_items",
    module = require(GetScriptDirectory() .."/utility/buy_items"),
    moves = {
      {
        move = "buy_flask",
        actions = {
          {action = "buy_flask"},
        }
      },
      {
        move = "buy_faerie_fire",
        actions = {
          {action = "buy_faerie_fire"},
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
        move = "deliver_items",
        actions = {
          {action = "deliver_items"},
        }
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
        }
      },
      {
        move = "attack_enemy_hero",
        actions = {
          {action = "attack_enemy_hero"},
        }
      },
    }
  },

  {
    objective = "laning",
    module = require(GetScriptDirectory() .."/utility/laning"),
    moves = {
      {
        move = "move_mid_tower",
        actions = {
          {action = "move_mid_tower"},
        }
      },
      {
        move = "lasthit_enemy_creep",
        actions = {
          {action = "lasthit_enemy_creep"},
        }
      },
      {
        move = "deny_ally_creep",
        actions = {
          {action = "deny_ally_creep"},
        }
      },
      {
        move = "harras_enemy_hero",
        actions = {
          {action = "harras_enemy_hero"},
        }
      },
      {
        move = "attack_enemy_tower",
        actions = {
          {action = "attack_enemy_tower"},
        }
      },
      {
        move = "evasion",
        actions = {
          {action = "evasion"},
        }
      },
      {
        move = "increase_creeps_distance",
        actions = {
          {action = "increase_creeps_distance"},
        }
      },
      {
        move = "decrease_creeps_distance",
        actions = {
          {action = "decrease_creeps_distance"},
        }
      },
      {
        move = "turn",
        actions = {
          {action = "turn"},
        }
      },
      {
        move = "stop",
        actions = {
          {action = "stop"},
        }
      },
    },
  },

}

return M
