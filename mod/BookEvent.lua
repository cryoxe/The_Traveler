---@diagnostic disable: param-type-mismatch

local event = {}
-- Pos = Isaac.GetFreeNearPosition(player.Position, 40)
--[[
Les types d'event :
-donner un trinket parmi une pool /ok
-spawn un item parmi une pool /ok
-spawn des récompense (coffres) /ok
-tuer tous les ennemis /ok
-mama méga ? 
-boost les stats pour tout l'étage
-Golden trouble /ok
-random item /ok
-lot of friendly thing /ok
-heart ?
-Golden shower : pluie de pièce limité dans le temps !
]]--

function RandomMirrorInteger(RNG, number)
  local randomNumber = RNG:RandomInt(number +1)
  local isNegative = RNG:RandomInt(10)
  if (isNegative > 4) then
    randomNumber = randomNumber * -1
  end
  return randomNumber
end

function Fork(number, fork)
  local min = tostring(number - fork)
  local max = tostring(number + fork)
  -- Isaac.ConsoleOutput("Minimum = "..tostring(min).." Maximum = "..tostring(max).." | ")
  local randomNumber = math.random(min, max)
  return randomNumber
end


-- Donne au joueur des "Blues Friends" (1 à 4)
function event.GiveBlueFly(player, rng)
  local Pos = Isaac.GetFreeNearPosition(player.Position, 10)
  local totalNumber = {6, 10, 16, 18}
  local numberInUse = totalNumber[player:GetData()["TravelerBookUse"]+1]
  local flyNumber = rng:RandomInt(numberInUse +1)
  local spiderNumber = numberInUse - flyNumber

  player:AddBlueFlies(flyNumber, Pos, player)
  local iteration = 0
  repeat
    player:AddBlueSpider(Pos)
    iteration = iteration + 1
  until iteration == spiderNumber

  if (player:GetData()["TravelerBookUse"] == 2) then
    Isaac.GetPlayer():AddRottenHearts(4)
  end
end

-- Donne au joueur des Trinket (1 à 3)
function event.GiveNewTrinket(player)
  local trinketPool = {TrinketType.TRINKET_CRYSTAL_KEY, TrinketType.TRINKET_BLUE_KEY}
  if (player:GetData()["TravelerBookUse"] > 0) then
    player:AddTrinket(trinketPool[1])
  else
    player:AddTrinket(trinketPool[1])
    player:UsePill(PillEffect.PILLEFFECT_GULP, PillColor.PILL_NULL, 2311)
    player:AddTrinket(trinketPool[2])
  end
  player:UsePill(PillEffect.PILLEFFECT_GULP, PillColor.PILL_NULL, 2311)
end

-- spawn un item (2 à 3)
function event.GiveNewItem()
  Game():SpawnParticles(Vector(320,279), EffectVariant.POOF02, 2, 1, Color.Default)
---@diagnostic disable-next-line: param-type-mismatch
  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Vector(320,280), Vector(0,0), nil)
end

-- spawn un cycling item (3 à 4)
function event.SpawnCycleItem(player, rng)
  local Pos = Isaac.GetFreeNearPosition(player.Position, 40)
  local roomTypeList = {0, 1, 2, 6, 8, 9, 10, 11, 12, 3, 4, 5}
  local roomInUse = {}
  local iteration = 0

  if (player:GetData()["TravelerBookUse"] == 2) then
    repeat
      table.insert(roomInUse, roomTypeList[rng:RandomInt(9)])
      iteration = iteration + 1
    until iteration == 4
    CyclingItemsAPI:createCyclingPedestal(Pos, 4, roomInUse, 8, true, true)
  else
    repeat
      table.insert(roomInUse, roomTypeList[rng:RandomInt(12)])
      iteration = iteration + 1
    until iteration == 4
    CyclingItemsAPI:createCyclingPedestal(Pos, 6, roomInUse, 8, true, true)      
  end

end

-- fait spawn des chest (1 à 4)
function event.GiveChest(player, rng)
  local chestType = {PickupVariant.PICKUP_CHEST, PickupVariant.PICKUP_REDCHEST, PickupVariant.PICKUP_BOMBCHEST, PickupVariant.PICKUP_SPIKEDCHEST, PickupVariant.PICKUP_MIMICCHEST, PickupVariant.PICKUP_HAUNTEDCHEST, PickupVariant.PICKUP_ETERNALCHEST, PickupVariant.PICKUP_WOODENCHEST, PickupVariant.PICKUP_OLDCHEST, PickupVariant.PICKUP_MEGACHEST, PickupVariant.PICKUP_MOMSCHEST}
  local totalNumber = {2, 3, 3, 4}
  local numberToSpawn = totalNumber[player:GetData()["TravelerBookUse"]+1]
  local chestToSelect = 5
  if (player:GetData()["TravelerBookUse"] == 2) then
    chestToSelect = 7
  elseif (player:GetData()["TravelerBookUse"] == 3) then
    chestToSelect = 10
  end

  local iteration = 0
  repeat
    local chestToSpawn = rng:RandomInt(chestToSelect) +1
    Isaac.Spawn(EntityType.ENTITY_PICKUP, chestType[chestToSpawn], 0, Isaac.GetFreeNearPosition(player.Position, 60), Vector(0,0), nil)
    iteration = iteration + 1
  until iteration == numberToSpawn
end

-- fait spawn des truc doré (1 à 4)
function event.GoldenTrouble(player, rng)
  local goldenPickupType = {CoinSubType.COIN_GOLDEN, KeySubType.KEY_GOLDEN, HeartSubType.HEART_GOLDEN, BombSubType.BOMB_GOLDENTROLL, BombSubType.BOMB_GOLDEN, BatterySubType.BATTERY_GOLDEN}
  local totalNumber = {2, 3, 3, 4}
  local numberToSpawn = totalNumber[player:GetData()["TravelerBookUse"]+1]
  local goldenToSelect = 3
  if (player:GetData()["TravelerBookUse"] == 2) then
    goldenToSelect = 4
  elseif (player:GetData()["TravelerBookUse"] == 3) then
    goldenToSelect = 5
  end

  local iteration = 0
  repeat
    local goldenToSpawn = rng:RandomInt(goldenToSelect) +1
    Isaac.Spawn(EntityType.ENTITY_PICKUP, CoinSubType.COIN_GOLDEN, 0, Isaac.GetFreeNearPosition(player.Position, 10), Vector(0,0), nil)
    print("spawned : " .. goldenPickupType[goldenToSpawn])
    iteration = iteration + 1
  until iteration == numberToSpawn
end

-- pluie de pièce limité (1 à 3)
function event.GoldenShower(player, rng)
  -- Vector(320,280)
  local coinToSpawn = Fork(15, 3)
  local lifetime = 60
  if (player:GetData()["TravelerBookUse"] == 1) then
    coinToSpawn = Fork(18, 4)
    lifetime = 75
  elseif (player:GetData()["TravelerBookUse"] == 2) then
    coinToSpawn = Fork(20, 5)
    lifetime = 100
  end
  local iteration = 0
  repeat
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, Isaac.GetFreeNearPosition(player.Position, 50), Vector(RandomMirrorInteger(rng, 7),RandomMirrorInteger(rng, 7)), nil)
    iteration = iteration + 1
  until iteration == coinToSpawn
  
  local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN)
  for _, pickup in pairs(pickups) do
    local pickupIguess = pickup:ToPickup()
    pickupIguess.Timeout = lifetime
  end
end

-- Ennemies go brrrrr (1 à 4)
function event.BaneOfEnemy(player, rng)
  local enemies = Isaac.FindInRadius(player.Position, 1000, EntityPartition.ENEMY)
  local lenghtOfEffect = {40, 50, 70, 120}
  local choosenLenght = lenghtOfEffect[player:GetData()["TravelerBookUse"]+1]
  -- print("DATA : "..tostring(player:GetData()["TravelerBookUse"]).." Effect duration : "..tostring(choosenLenght))
  local numberOfEffectToSpawn = {2, 3, 4, 4}
  local choosenNumberOfEffect = numberOfEffectToSpawn[player:GetData()["TravelerBookUse"]+1]
  local damage = choosenLenght/5
  -- print("Damage = "..tostring(damage))
  local iteration = 0
  repeat
    for _, enemy in pairs(enemies) do
      local typeOfEffect = rng:RandomInt(9) +1
      if (typeOfEffect == 1) then
        enemy:AddBurn(EntityRef(player), Fork(choosenLenght, 10), Fork(damage, 5))
      elseif (typeOfEffect == 2) then
        enemy:AddCharmed(EntityRef(player), Fork(choosenLenght, 10))
      elseif (typeOfEffect == 3) then
      enemy:AddConfusion(EntityRef(player), Fork(choosenLenght, 10), false)
      elseif (typeOfEffect == 4) then
        enemy:AddFear(EntityRef(player), Fork(choosenLenght, 10))
      elseif (typeOfEffect == 5) then
        enemy:AddFreeze(EntityRef(player), Fork(choosenLenght, 10))
      elseif (typeOfEffect == 6) then
        enemy:AddMidasFreeze(EntityRef(player), Fork(choosenLenght, 10))
      elseif (typeOfEffect == 7) then
        enemy:AddPoison(EntityRef(player), Fork(choosenLenght, 10), Fork(damage, 5))
      elseif (typeOfEffect == 8) then
        enemy:AddShrink(EntityRef(player), Fork(choosenLenght, 10))
      elseif (typeOfEffect == 9) then
        enemy:AddSlowing(EntityRef(player), Fork(choosenLenght, 10), 0.5, Color(1, 0, 0, 1, 0, 0, 0))
      end
    end
    iteration = iteration + 1
  until iteration == choosenNumberOfEffect
  local room = Game():GetRoom()
  room:EmitBloodFromWalls(Fork(choosenLenght, 10), 2)
end

-- Randomize hearts (1 à 4)
function event.RandomHeart(player, rng)
  local poolOfHeart = {5, 6, 7, 8}
  local choosenPool = poolOfHeart[player:GetData()["TravelerBookUse"]+1]
  local qualityBonus = {1, 2, 3, 4}
  local choosenQualityBonus = qualityBonus[player:GetData()["TravelerBookUse"]+1]

  local heartQuality = player:GetMaxHearts() + player:GetSoulHearts() + player:GetRottenHearts() + player:GetEternalHearts() + player:GetGoldenHearts() + player:GetBoneHearts()
  player:TakeDamage(player:GetHearts() + player:GetSoulHearts() + player:GetRottenHearts() + player:GetEternalHearts() + player:GetGoldenHearts() - 1, 301989889, EntityRef(player), 1)
  local numberOfBrokenHeart = player:GetBrokenHearts()
  player:AddBrokenHearts(numberOfBrokenHeart * -1)
  heartQuality = (heartQuality - (player:GetMaxHearts() + player:GetSoulHearts() + player:GetRottenHearts() + player:GetEternalHearts() + player:GetGoldenHearts())) - numberOfBrokenHeart

  -- player:AddMaxHearts(numberOfContainers, true)
  print("Heart To spawn = " .. heartQuality.." + "..choosenQualityBonus)

  local iteration = 0
  local numberOfRotten = 0
  local numberOfEternal = 0
  local numberOfGolden = 0
  local numberOfBroken = 0
  repeat
    local typeOfHeart = rng:RandomInt(choosenPool)
    if (typeOfHeart == 0) then
      player:AddBoneHearts(1) -- 1 BONE HEART
      iteration = iteration + 2
      print("1 BONE HEART")

    elseif (typeOfHeart == 1) then
      player:AddMaxHearts(2)  -- 1 container HEART
      iteration = iteration + 2
      print("1 CONTAINER HEART")

    elseif (typeOfHeart == 2) then
      if (numberOfBroken < 2) then
        player:AddBrokenHearts(1) -- 1 BROKEN HEART
        numberOfBroken = numberOfBroken + 1
        print("1 BROKEN HEART")
      end

    elseif (typeOfHeart == 3) then
      player:AddSoulHearts(1) -- 1/2 BLUE HEART
      iteration = iteration + 1
      print("1/2 BLUE HEART")

    elseif (typeOfHeart == 4) then
      if (player:GetMaxHearts() - numberOfRotten > 0) then
        player:AddRottenHearts(2) -- 1 ROTTEN HEART
        iteration = iteration + 1
        numberOfRotten = numberOfRotten + 1
        print("1 ROTTEN HEART")
      else
        print("Impossible de mettre coeur")
      end

    elseif (typeOfHeart == 5) then
      if (player:GetMaxHearts() - numberOfEternal > 0) then
        player:AddEternalHearts(1) -- 1 ETERNAL HEART
        iteration = iteration + 1
        numberOfEternal = numberOfEternal + 1
        print("1 ETERNAL HEART")
      else
        print("Impossible de mettre coeur")
      end

    elseif (typeOfHeart == 6) then
      player:AddBlackHearts(1) -- 1/2 BLACK HEART
      iteration = iteration + 1
      print("1/2 BLACK HEART")

    elseif (typeOfHeart == 7) then
      if (player:GetMaxHearts() - numberOfGolden > 0) then
        player:AddGoldenHearts(1) -- 1 GOLDEN HEART
        iteration = iteration + 1
        numberOfGolden = numberOfGolden + 1
        print("1 GOLDEN HEART")
      else
        print("Impossible de mettre coeur")
      end

    end
    print("Used quality = " .. tostring(iteration) .. " / ".. heartQuality + choosenQualityBonus)
  until iteration >= heartQuality + choosenQualityBonus
  player:AddHearts(24)
end

-- (1 à 3)
function event.Fwiend(player, rng)
  local numberOfFriends = {14, 22, 30}
  local choosenFriends = numberOfFriends[player:GetData()["TravelerBookUse"]+1]

  local iteration = 0
  repeat
    local familiar = rng:RandomInt(4)
    if (familiar == 0) then
      player:ThrowFriendlyDip(rng:RandomInt(21), player.Position, Vector.Zero)
      iteration = iteration + 1
      print("DIP !")

    elseif (familiar == 1) then
      player:AddItemWisp(rng:RandomInt(732)+1, player.Position)
      iteration = iteration + 4
      print("Item WISP")

    elseif (familiar == 2) then
      player:AddMinisaac(player.Position)
      iteration = iteration + 1
      print("MINISSAC")

    elseif (familiar == 3) then
      player:UseActiveItem(CollectibleType.COLLECTIBLE_LEMEGETON, 1)
      iteration = iteration + 2
      print("WISP !")

    end
    print("iteration = "..iteration.." / "..choosenFriends)

  until iteration >= choosenFriends
end

function event.TempStats(player, rng)
  local statsPower = {5, 6, 6, 8}
  local choosenStats = statsPower[player:GetData()["TravelerBookUse"]+1]
  player:AddCacheFlags(CacheFlag.CACHE_ALL)
  player:EvaluateItems()
  local iteration = 0
  repeat
    --r
    local stat = rng:RandomInt(6)
    if (stat == 0) then
      player.Damage = player.Damage + Fork(choosenStats, 4)/5
    elseif (stat == 1) then
      player.MoveSpeed = player.MoveSpeed + Fork(choosenStats, 4)/10
    elseif (stat == 2) then
      player.ShotSpeed = player.ShotSpeed + Fork(choosenStats, 4)/10
    elseif (stat == 3) then
      player.MaxFireDelay = player.MaxFireDelay - Fork(choosenStats, 4)
    elseif (stat == 4) then
      player.Luck = player.Luck + Fork(choosenStats, 4)/10
    elseif (stat == 5) then
      player.TearRange = player.TearRange + Fork(choosenStats, 4)*5
    end
    iteration = iteration + 1
  until iteration == player:GetData()["TravelerBookUse"]+1
end

return event
