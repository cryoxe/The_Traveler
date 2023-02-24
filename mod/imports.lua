local includes = {}

local items = {
  include("Items/Exodus"),
  include("Items/HermesBoots"),
  include("Items/Elysium"),
  include("Items/BookOfTravel"),
  include("Items/BookOfTravel2"),
  include("Items/BookOfTravel3"),
  include("Items/BookOfTravel4")
}

function includes:Init(mod)
  -- do your inits here
  for _, item in pairs(items) do
    item:Init(mod)
  end
end

return includes
