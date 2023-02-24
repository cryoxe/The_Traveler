local registry = include("ItemRegistry")
local item = {}

-- luamod the_traveler

local function UseItem(_, collecitble, rng, player)
  player:AddCollectible(registry.BookOfTravel4, ActiveSlot.SLOT_PRIMARY)
end
function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseItem, registry.BookOfTravel3)
end

return item