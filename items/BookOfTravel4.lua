local registry = include("ItemRegistry")
local item = {}


local function UseItem(_, collecitble, rng, player)
  player:RemoveCollectible(registry.BookOfTravel4, ActiveSlot.SLOT_PRIMARY)
end

function item:Init(mod)
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseItem, registry.BookOfTravel4)
end

return item