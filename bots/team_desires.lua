local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local IS_TEAM_WITH_HUMAN = false
local IS_TEAM_WITH_HUMAN_CALCULATED = false

local function CheckTeamWithHuman()
  local players = GetTeamPlayers(GetTeam());

  for _, player in pairs(players) do
    if not IsPlayerBot(player) then
      IS_TEAM_WITH_HUMAN = true
      return
    end
  end
end

function TeamThink()
  if not IS_TEAM_WITH_HUMAN_CALCULATED then
    CheckTeamWithHuman()
    IS_TEAM_WITH_HUMAN_CALCULATED = true
  end

  if not IS_TEAM_WITH_HUMAN then
    all_units.UpdateUnitList()
  end
end
