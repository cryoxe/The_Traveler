local registry = include("ItemRegistry")
local item = {}

-- luamod the_traveler

local function UseItem(_, collecitble, rng, player)
  player:AddCollectible(registry.BookOfTravel3, ActiveSlot.SLOT_PRIMARY)
end
function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseItem, registry.BookOfTravel2)
end

return item