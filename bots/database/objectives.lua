
local M = {}

M.OBJECTIVES = {

  {
    strategy = "buy",
    objectives = {
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


    },
  },

  {
    strategy = "recovery",
    objectives = {
  {
    objective = "buyback",
    module = require(GetScriptDirectory() .."/utility/buyback"),
    moves = {
      {
        move = "do_buyback",
        actions = {
          {action = "do_buyback"},

        },
      },
    },
  },

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
      {
        move = "heal_flask",
        actions = {
          {action = "heal_flask"},

        },
      },
      {
        move = "heal_faerie_fire",
        actions = {
          {action = "heal_faerie_fire"},

        },
      },
      {
        move = "tp_base",
        actions = {
          {action = "tp_base"},

        },
      },
    },
  },

  {
    objective = "base_recovery",
    module = require(GetScriptDirectory() .."/utility/base_recovery"),
    moves = {
      {
        move = "use_silence",
        actions = {
          {action = "use_silence"},

        },
      },
      {
        move = "deliver_items",
        actions = {
          {action = "deliver_items"},

        },
      },
      {
        move = "restore_hp_on_base",
        actions = {
          {action = "restore_hp_on_base"},

        },
      },
      {
        move = "move_base",
        actions = {
          {action = "move_base"},

        },
      },
    },
  },

  {
    objective = "evasion",
    module = require(GetScriptDirectory() .."/utility/evasion"),
    moves = {
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


    },
  },

  {
    strategy = "defensive",
    objectives = {
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


    },
  },

  {
    strategy = "offensive",
    objectives = {
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
        move = "attack_enemy_tower",
        actions = {
          {action = "attack_enemy_tower"},

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
    objective = "pursuit_enemy_hero",
    module = require(GetScriptDirectory() .."/utility/pursuit_enemy_hero"),
    moves = {
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


    },
  },

  {
    strategy = "farm",
    objectives = {
  {
    objective = "prepare_for_match",
    module = require(GetScriptDirectory() .."/utility/prepare_for_match"),
    moves = {
      {
        move = "buy_starting_items",
        actions = {
          {action = "buy_starting_items"},

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


    },
  },

}

return M
