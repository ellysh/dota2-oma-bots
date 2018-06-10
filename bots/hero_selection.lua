local BotHeroes = {
  "npc_dota_hero_drow_ranger",
  "npc_dota_hero_crystal_maiden",
  "npc_dota_hero_crystal_maiden",
  "npc_dota_hero_crystal_maiden",
  "npc_dota_hero_crystal_maiden"
};

function Think()
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
