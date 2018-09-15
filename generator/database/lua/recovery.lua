
local M = {}

M.OBJECTIVES = {

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
        move = "tp_base",
        actions = {
          {action = "tp_base"},

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
        move = "deliver_items",
        actions = {
          {action = "deliver_items"},

        },
      },
    },
  },

  {
    objective = "base_recovery",
    module = require(GetScriptDirectory() .."/utility/base_recovery"),
    moves = {
      {
        move = "deliver_items",
        actions = {
          {action = "deliver_items"},

        },
      },
      {
        move = "move_base",
        actions = {
          {action = "move_base"},
          {action = "restore_hp_on_base"},

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
