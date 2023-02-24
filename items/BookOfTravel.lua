local registry = include("ItemRegistry")
local event = include("mod/BookEvent")
local item = {}

-- luamod the_traveler
NullItemID.ID_VEIN = Isaac.GetCostumeIdByPath("gfx/characters/vein.anm2")

local function getPlayers()
  local game = Game()
  local numPlayers = game:GetNumPlayers()

  local players = {}
  for i = 0, numPlayers do
    local player = Isaac.GetPlayer(i)
    table.insert(players, player)
  end

  return players
end

  -- Game():ShowHallucination(15, BackdropType.ERROR_ROOM)
  -- player:AddNullCostume(NullItemID.ID_VEIN)

local function UseItem(_, collecitble, rng, player)
  Game():SpawnParticles(Isaac.GetPlayer(0).Position, EffectVariant.POOF02, 2, 1, Color.Default)
  Game():ShakeScreen(25)
  local iteration = 0
  repeat
    local choosenEvent =  rng:RandomInt(8)
    if (choosenEvent == 0) then
      event.GiveBlueFly(player, rng)
      print("GiveBlueFly")
    elseif (choosenEvent == 1) then
      event.TempStats(player, rng)
      print("TempStats")
    elseif (choosenEvent == 2) then
      event.GiveChest(player, rng)
      print("CHEST")
    elseif (choosenEvent == 3) then
      event.GoldenTrouble(player, rng)
      print("GOLDEN")
    elseif (choosenEvent == 4) then
      event.GoldenShower(player, rng)
      print("GoldenShower")
    elseif (choosenEvent == 5) then
      event.BaneOfEnemy(player, rng)
      print("BaneOfEnemy")
    elseif (choosenEvent == 6) then
      event.RandomHeart(player, rng)
      print("RandomHeart")
    elseif (choosenEvent == 7) then
      event.Fwiend(player, rng)
      print("FWIEND")
    end
    iteration = iteration + 1
  until iteration == 2
  --player:AddCollectible(registry.BookOfTravel2, ActiveSlot.SLOT_PRIMARY)
  player:GetData()["TravelerBookUse"] = player:GetData()["TravelerBookUse"] + 1
  print("Book use = "..player:GetData()["TravelerBookUse"])
end

local function Post_Player_Update(_, player)
  if (player == nil or not player:HasCollectible(registry.BookOfTravel)) then return end

  -- first pickup
  if (not player:GetData()["TravelerBookUse"]) then
    player:GetData()["TravelerBookUse"] = 0
  end

    

end

local function Post_New_Level()
  for _, player in pairs(getPlayers()) do
    if (player:GetData()["TempHiveMind"] == true) then
      player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HIVE_MIND, 1)
    end
  end
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseItem, registry.BookOfTravel)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Post_Player_Update)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Post_New_Level)
end

return item
-- luamod the_traveler