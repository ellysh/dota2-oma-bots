
local M = {}

M.OBJECTIVES = {
  [1] = {
    objective = "prepare_for_match",
    module = require(GetScriptDirectory() .."/utility/prepare_for_match"),
    moves = {
      {move = "buy_and_use_courier",
       actions = {
         {action = "buy_courier"},
         {action = "use_courier"},
       },
      },
      {move = "buy_starting_items",
       actions = {
         {action = "buy_starting_items"},
       }
      },
    },
  },

  [2] = {
    objective = "recovery",
    module = require(GetScriptDirectory() .."/utility/recovery"),
    moves = {
      {move = "move_base",
       actions = {
         {action = "move_base"},
         {action = "restore_hp_on_base"},
       }
      },
      {move = "heal_tango",
       actions = {
         {action = "heal_tango"},
       }
      },
      {move = "heal_flask",
       actions = {
         {action = "heal_flask"},
       }
      },
      {move = "heal_faerie_fire",
       actions = {
         {action = "heal_faerie_fire"},
       }
      },
      {move = "move_shrine",
       actions = {
         {action = "move_shrine"},
       }
      },
      {move = "tp_base",
       actions = {
         {action = "tp_base"},
         {action = "restore_hp_on_base"},
       }
      },
    },
  },

  [3] = {
    objective = "buy_items",
    module = require(GetScriptDirectory() .."/utility/buy_items"),
    moves = {
      {move = "buy_flask",
       actions = {
         {action = "buy_flask"},
         {action = "deliver_item"},
       }
      },
      {move = "buy_faerie_fire",
       actions = {
         {action = "buy_faerie_fire"},
         {action = "deliver_item"},
       },
      },
    },
  },

  [4] = {
    objective = "kill_enemy_hero",
    module = require(GetScriptDirectory() .."/utility/kill_enemy_hero"),
    moves = {
      {move = "attack_enemy_hero",
       actions = {
         {action = "attack_enemy_hero"},
       }
      },
    }
  },

  [5] = {
    objective = "laning",
    module = require(GetScriptDirectory() .."/utility/laning"),
    moves = {
      {move = "move_mid_tower",
       actions = {
         {action = "move_mid_tower"},
       }
      },
      {move = "increase_creeps_distance",
       actions = {
         {action = "increase_creeps_distance"},
       }
      },
      {move = "decrease_creeps_distance",
       actions = {
         {action = "decrease_creeps_distance"},
       }
      },
      {move = "lasthit_enemy_creep",
       actions = {
         {action = "lasthit_enemy_creep"},
       }
      },
      {move = "deny_ally_creep",
       actions = {
         {action = "deny_ally_creep"},
       }
      },
      {move = "harras_enemy_hero",
       actions = {
         {action = "harras_enemy_hero"},
       }
      },
      {move = "evasion",
       actions = {
         {action = "evasion"},
       }
      },
      {move = "turn",
       actions = {
         {action = "turn"},
       }
      },
      {move = "stop",
       actions = {
         {action = "stop"},
       }
      },
    },
  },

}

return M
