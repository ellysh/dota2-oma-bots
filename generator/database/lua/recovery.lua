
local M = {}

M.OBJECTIVES = {

  {
    objective = "buyback",
    module = require(GetScriptDirectory() .."/utility/buyback"),
    is_interruptible = false,
    moves = {
      {
        move = "do_buyback",
        is_interruptible = false,
        actions = {
          {action = "do_buyback"},

        },
      },
    },
  },

  {
    objective = "glyph",
    module = require(GetScriptDirectory() .."/utility/glyph"),
    is_interruptible = false,
    moves = {
      {
        move = "do_glyph",
        is_interruptible = false,
        actions = {
          {action = "do_glyph"},

        },
      },
    },
  },

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
    objective = "item_recovery",
    module = require(GetScriptDirectory() .."/utility/item_recovery"),
    is_interruptible = false,
    moves = {
      {
        move = "heal_tango",
        is_interruptible = false,
        actions = {
          {action = "heal_tango"},

        },
      },
      {
        move = "heal_flask",
        is_interruptible = false,
        actions = {
          {action = "heal_flask"},

        },
      },
      {
        move = "tp_base",
        is_interruptible = false,
        actions = {
          {action = "tp_base"},

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
    objective = "base_recovery",
    module = require(GetScriptDirectory() .."/utility/base_recovery"),
    is_interruptible = true,
    moves = {
      {
        move = "deliver_items",
        is_interruptible = false,
        actions = {
          {action = "deliver_items"},

        },
      },
      {
        move = "move_base",
        is_interruptible = true,
        actions = {
          {action = "move_base"},
          {action = "restore_hp_on_base"},

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
