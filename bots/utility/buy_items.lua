local M = {}

---------------------------------

function M.pre_buy_items()
  return M.pre_buy_flask()
         or M.pre_buy_faerie_fire()
end

function M.post_buy_items()
  return not M.pre_buy_items()
end

---------------------------------

function M.pre_buy_flask()
  return false
end

function M.pre_buy_faerie_fire()
  return false
end

-- Provide an access to local functions for unit tests only

return M
