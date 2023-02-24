local malus = {}
local item = {}


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

function BuggyGame()
    print("ENterNewRoom")
    local rng = RNG()
    local check = rng:RandomInt(100)
    print(check)
    --if (check >= 50) then

    --  getPlayers()[1]:UseActiveItem(CollectibleType.COLLECTIBLE_DATAMINER, false, false, false, false)
    --end

end
function item:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
        print("ENterNewRoom")
        local rng = RNG()
        local check = rng:RandomInt(100)
        local players = getPlayers()
        print(check)
        if (check >= 50) then
            players[1]:UseActiveItem(CollectibleType.COLLECTIBLE_DATAMINER, 1)
        end
    end)
end

return item