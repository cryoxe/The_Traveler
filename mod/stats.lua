local mt = {
    __index = {
        items = {},
        costume = {},
        trinket = {},
        card = {},
        pill = {},
        charge = {},
        name = ""
    }
}
function mt.__index:AddItem(id, costume)
    costume = costume or false
    table.insert(self.items, {id, costume})
end

local stats = {default = {}, tainted = {}}
setmetatable(stats.default, mt)
setmetatable(stats.tainted, mt)
local character = stats.default
local tainted = stats.tainted

character.items = {}
tainted.items = {}

character.name = "The Traveler"
character.stats = {
    damage = 0.10,
    firedelay = -0.30,
    shotspeed = 0.10,
    range = 0.10,
    speed = 0.10,
    tearflags = TearFlags.TEAR_NORMAL,
    tearcolor = Color(0.9, 0.020, 0, 1.0, 0, 0, 0),
    flying = false,
    luck = -1.50
}
character.costume = ""
--character.costume = {"costume 1","costume 2"}
--character:AddItem(CollectibleType.COLLECTIBLE_CRACKED_ORB, true)
character:AddItem(Isaac.GetItemIdByName("Book Of Travel"), true)
--https://wofsauge.github.io/IsaacDocs/rep/enums/CollectibleType.html
character.trinket = TrinketType.TRINKET_NULL
--=https://wofsauge.github.io/IsaacDocs/rep/enums/TrinketType.html
character.card = Card.CARD_CRACKED_KEY
--https://wofsauge.github.io/IsaacDocs/rep/enums/Card.html
character.pill = false
--https://wofsauge.github.io/IsaacDocs/rep/enums/PillEffect.html
character.charge = 4
--true for full charge


tainted.enabled = false

tainted.name = "Omega"
tainted.stats = {
    damage = 2.00,
    firedelay = 1.00,
    shotspeed = 1.00,
    range = 1.00,
    speed = 1.00,
    tearflags = TearFlags.TEAR_POISON | TearFlags.TEAR_FREEZE,
    tearcolor = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0),
    flying = false,
    luck = 1.00
}
tainted.costume = ""
tainted.trinket = TrinketType.TRINKET_SWALLOWED_PENNY
tainted.card = Card.CARD_FOOL
tainted.pill = false
tainted.charge = -1
tainted:AddItem(CollectibleType.COLLECTIBLE_SAD_ONION)

--[[
	modded items :
	Isaac.GetItemIdByName("CUSTOMITEM")
	Isaac.GetPillEffectByName("CUSTOMPILL")
	Isaac.GetCardIdByName("cardHudName")
	Isaac.GetTrinketIdByName("trinketName")
	Make sure to use the same name as in the items.xml file.
]]

return stats
