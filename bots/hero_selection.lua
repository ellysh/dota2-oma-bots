local functions = require(
  GetScriptDirectory() .."/utility/functions")

local BotHeroes = {
  "npc_dota_hero_drow_ranger",
  "npc_dota_hero_shadow_shaman",
  "npc_dota_hero_shadow_shaman",
  "npc_dota_hero_shadow_shaman",
  "npc_dota_hero_shadow_shaman"
};

function GetBotNames()
  return {"OMA"}
end

local function IsHumanPlayersPicked()
  local players = functions.TableConcat(
                    GetTeamPlayers(GetTeam()),
                    GetTeamPlayers(GetOpposingTeam()))
  local no_pick_player = functions.GetElementWith(
    players,
    nil,
    function(player)
      return not IsPlayerBot(player)
             and GetSelectedHeroName(player) == ""
    end)

    return no_pick_player == nil
end

function Think()
  if not IsHumanPlayersPicked() then return end

  local players = GetTeamPlayers(GetTeam());
  for i, player in pairs(players) do
    if IsPlayerBot(player) then
      SelectHero(player, BotHeroes[i]);
    end
  end
end

function UpdateLaneAssignments()
  -- Radiant:  easy lane = bot / hard lane = top
  -- Dire:     easy lane = top / hard lane = bot

  if ( GetTeam() == TEAM_RADIANT ) then
    return {
      [1] = LANE_MID,
      [2] = LANE_BOT,
      [3] = LANE_TOP,
      [4] = LANE_BOT,
      [5] = LANE_TOP,
    }
  elseif ( GetTeam() == TEAM_DIRE ) then
    return {
      [1] = LANE_MID,
      [2] = LANE_TOP,
      [3] = LANE_BOT,
      [4] = LANE_TOP,
      [5] = LANE_BOT,
    }
  end
end
