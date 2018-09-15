local constants = require(
  GetScriptDirectory() .."/utility/constants")

local M = {}

-- This function iterates over the table in a sorted order.
-- It was taken from here:
-- https://stackoverflow.com/questions/15706270/sort-a-table-in-lua

function M.spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table
    -- and keys a, b, otherwise just sort the keys
    if order ~= nil then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-- You should use this function for any table without numeric indexes

function M.GetTableSize(table)
  local count = 0

  for _ in pairs(table) do count = count + 1 end
  return count
end

-- This function compares two Lua table objects. It was taken from here:
-- https://web.archive.org/web/20131225070434/http://snippets.luacode.org/snippets/Deep_Comparison_of_Two_Values_3

local function deepcompare(t1, t2, ignore_mt)
  local ty1 = type(t1)
  local ty2 = type(t2)
  if ty1 ~= ty2 then return false end
  -- non-table types can be directly compared
  if ty1 ~= "table" and ty2 ~= "table" then return t1 == t2 end
  -- as well as tables which have the metamethod __eq
  local mt = getmetatable(t1)
  if not ignore_mt and mt and mt.__eq then return t1 == t2 end
  for k1,v1 in pairs(t1) do
    local v2 = t2[k1]
    if v2 == nil or not deepcompare(v1,v2) then return false end
  end
  for k2,v2 in pairs(t2) do
    local v1 = t1[k2]
    if v1 == nil or not deepcompare(v1,v2) then return false end
  end
  return true
end

function M.GetElementIndexInList(list, element, is_deep)
  if list == nil then
    return -1 end

  -- We should sort by keys. Otherwise, elements have a random order.

  for i, e in M.spairs(list) do
    if (not is_deep and e == element)
       or (is_deep and deepcompare(e, element, true)) then
      return i end
  end
  return -1
end

function M.IsElementInList(list, element, is_deep)
  return M.GetElementIndexInList(list, element, is_deep) ~= -1
end

function M.IsIntersectionOfLists(list1, list2, is_deep)
  for _, e in pairs(list1) do
    if e ~= "nil" and M.IsElementInList(list2, e, is_deep) then
      return true end
  end
  return false
end

function M.ComplementOfLists(list1, list2, is_deep)
  local result = {}

  for key, element in pairs(list1) do
    if not M.IsElementInList(list2, element, is_deep) then
      table.insert(result, element)
    end
  end
  return result
end

-- This function was taken from the Ranked Matchmaking AI project:
-- https://github.com/adamqqqplay/dota2ai

local function IsFlagSet(mask, flag)
  if flag == 0 or mask == 0 then
    return false end

  return ((mask / flag)) % 2 >= 1
end

function M.ternary(condition, a, b)
  if condition then
    return a
  else
    return b
  end
end

function M.GetElementWith(list, compare_function, validate_function)

  for _, element in M.spairs(list, compare_function) do
    if validate_function == nil or validate_function(element) then
      return element
    end
  end

  return nil
end

function M.GetListWith(list, compare_function, validate_function)
  local result = {}

  for _, element in M.spairs(list, compare_function) do
    if validate_function == nil or validate_function(element) then
      table.insert(result, element)
    end
  end

  return result
end

function M.GetKeyAndElementWith(list, compare_function, validate_function)

  for key, element in M.spairs(list, compare_function) do
    if validate_function == nil or validate_function(key, element) then
      return key, element
    end
  end

  return nil, nil
end

function M.GetNumberOfElementsWith(list, check_function)
  local result = 0

  for _, element in pairs(list) do
    if check_function(element) then
      result = result + 1
    end
  end

  return result
end

function M.GetKeyWith(list, compare_function, validate_function)

  for key, element in M.spairs(list, compare_function) do
    if validate_function == nil or validate_function(key, element) then
      return key
    end
  end

  return nil
end

function M.DoWithKeysAndElements(list, do_function)
  for key, element in pairs(list) do
    do_function(key, element)
  end
end

function M.GetRate(a, b)
  return a / b
end

-- This function is taken from here:
-- https://stackoverflow.com/a/15278426
-- Result will be stored in the t1 table. The return value is
-- requried for tests.
--
-- The function should be used for tables indexed by numbers only!

function M.TableConcat(t1, t2)
  for i = 1, #t2 do
    t1[#t1+1] = t2[i]
  end
  return t1
end

function M.IsTableEmpty(table)
  return table == nil or #table == 0
end

function M.ClearTable(table)
  for i = 1, #table do
    table.remove(table, i)
  end
end

function M.GetDistance(location1, location2)
  return math.sqrt(math.pow(location1.x - location2.x, 2) +
           math.pow(location1.y - location2.y, 2))
end

function M.GetUnitDistance(unit1_data, unit2_data)
  return M.GetDistance(unit1_data.location, unit2_data.location)
end

function M.GetDamageMultiplier(armor)
  local result = 1 - (0.05 * armor / (1 + 0.05 * math.abs(armor)))

  if result < 0 then
    return 0 end

  if 2 < result then
    return 2 end

  return result
end

function M.IsLocationBetweenLocations(
  target_location,
  location1,
  location2)

  local locations_distance = M.GetDistance(location1, location2)

  return M.GetDistance(target_location, location1)
           < locations_distance
         and M.GetDistance(target_location, location2)
               < locations_distance
end

function M.IsLocationBetweenUnits(
  target_location,
  unit1_data,
  unit2_data)

  return M.IsLocationBetweenLocations(
           target_location,
           unit1_data.location,
           unit2_data.location)
end

function M.IsUnitBetweenLocations(unit_data, location1, location2)
  return M.IsLocationBetweenLocations(
           unit_data.location,
           location1,
           location2)
end

function M.IsUnitBetweenUnits(target_data, unit1_data, unit2_data)
  return M.IsUnitBetweenLocations(
           target_data,
           unit1_data.location,
           unit2_data.location)
end

local function DegToRad(deg)
  return deg * math.pi / 180
end

local function RadToDeg(rad)
  return rad * 180 / math.pi
end

local CIRCLE_QUARTER = {
  [1] = {},
  [2] = {},
  [3] = {},
  [4] = {},
  UNDEFINED = {},
}

local function GetCircleQuarter(sin, cos)
  if 0 <= sin and 0 < cos then
    return CIRCLE_QUARTER[1]
  elseif 0 <= sin and cos <= 0 then
    return CIRCLE_QUARTER[2]
  elseif sin < 0 and cos <= 0 then
    return CIRCLE_QUARTER[3]
  elseif sin < 0 and 0 < cos then
    return CIRCLE_QUARTER[4]
  end

  return CIRCLE_QUARTER["UNDEFINED"]
end

local function GetSin(location1, location2)
  return (location2.y - location1.y)
         / M.GetDistance(location1, location2)
end

local function GetCos(location1, location2)
  return (location2.x - location1.x)
         / M.GetDistance(location1, location2)
end

local function GetAngle(sin, cos, circle_quarter)
  local angle = 0

  if circle_quarter == CIRCLE_QUARTER[1] then
    angle = RadToDeg(math.asin(sin))
  elseif circle_quarter == CIRCLE_QUARTER[2] then
    angle = RadToDeg(math.acos(cos))
  elseif circle_quarter == CIRCLE_QUARTER[3] then
    angle = 180 - RadToDeg(math.asin(sin))
  elseif circle_quarter == CIRCLE_QUARTER[4] then
    angle = 270 + RadToDeg(math.acos(cos))
  end

  return angle
end

function M.GetDelta(a, b)
  return math.abs(a - b)
end

function M.IsFacingLocation(unit_data, location, degrees)
  local sin = GetSin(unit_data.location, location)
  local cos = GetCos(unit_data.location, location)
  local circle_quarter = GetCircleQuarter(sin, cos)
  local angle = GetAngle(sin, cos, circle_quarter)

  return M.GetDelta(unit_data.facing, angle) <= degrees
end

function M.GetOpposingTeam(team)
  local OPPOSING_TEAM = {
    [TEAM_RADIANT] = TEAM_DIRE,
    [TEAM_DIRE] = TEAM_RADIANT,
  }

  return OPPOSING_TEAM[team]
end

-- Provide an access to local functions for unit tests only
M.test_IsFlagSet = IsFlagSet

return M
