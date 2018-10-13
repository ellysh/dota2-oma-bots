
local M = {}

M.OBJECTIVES = {

  {
    objective = "glyph",
    module = require(GetScriptDirectory() .."/utility/glyph"),
    moves = {
      {
        move = "do_glyph",
        actions = {
          {action = "do_glyph"},

        },
      },
    },
  },

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
        move = "swap_lesser_crit_tp",
        actions = {
          {action = "swap_lesser_crit_tp"},

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
    objective = "attack_with_mom",
    module = require(GetScriptDirectory() .."/utility/attack_with_mom"),
    moves = {
      {
        move = "use_frost_arrow",
        actions = {
          {action = "use_frost_arrow"},

        },
      },
      {
        move = "use_mom",
        actions = {
          {action = "use_mom"},

        },
      },
      {
        move = "attack_enemy_hero",
        actions = {
          {action = "attack_enemy_hero"},

        },
      },
      {
        move = "kill_enemy_creep",
        actions = {
          {action = "kill_enemy_creep"},

        },
      },
    },
  },

  {
    objective = "defend_tower",
    module = require(GetScriptDirectory() .."/utility/defend_tower"),
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
        move = "move_enemy_creep",
        actions = {
          {action = "move_enemy_creep"},

        },
      },
      {
        move = "pull_enemy_creep",
        actions = {
          {action = "pull_enemy_creep"},

        },
      },
      {
        move = "move_safe",
        actions = {
          {action = "move_safe"},

        },
      },
      {
        move = "kill_enemy_creep",
        actions = {
          {action = "kill_enemy_creep"},
          {action = "stop_attack"},

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
    objective = "attack_with_better_position",
    module = require(GetScriptDirectory() .."/utility/attack_with_better_position"),
    moves = {
      {
        move = "attack_enemy_hero",
        actions = {
          {action = "attack_enemy_hero"},

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
        move = "kill_enemy_creep",
        actions = {
          {action = "kill_enemy_creep"},
          {action = "stop_attack"},

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
      {
        move = "aggro_hg",
        actions = {
          {action = "aggro_hg"},
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
        move = "decrease_creeps_distance_aggro",
        actions = {
          {action = "decrease_creeps_distance_aggro"},

        },
      },
      {
        move = "increase_creeps_distance",
        actions = {
          {action = "increase_creeps_distance"},

        },
      },
      {
        move = "decrease_creeps_distance_base",
        actions = {
          {action = "decrease_creeps_distance_base"},

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
    objective = "keep_equilibrium",
    module = require(GetScriptDirectory() .."/utility/keep_equilibrium"),
    moves = {
      {
        move = "attack_enemy_creep",
        actions = {
          {action = "attack_enemy_creep"},
          {action = "stop_attack"},

        },
      },
      {
        move = "attack_ally_creep",
        actions = {
          {action = "attack_ally_creep"},
          {action = "stop_attack"},

        },
      },
    },
  },

  {
    objective = "body_block",
    module = require(GetScriptDirectory() .."/utility/body_block"),
    moves = {
      {
        move = "move_and_block",
        actions = {
          {action = "move_and_block"},
          {action = "stop_attack_and_move"},

        },
      },
      {
        move = "move_start_position",
        actions = {
          {action = "move_start_position"},

        },
      },
      {
        move = "turn_enemy_fountain",
        actions = {
          {action = "turn_enemy_fountain"},
          {action = "stop_turn"},

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
