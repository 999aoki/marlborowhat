-- First, let's find out the UniverseId
print("Current PlaceId:", game.PlaceId)
print("Current GameId (UniverseId):", game.GameId)
print("Game Name:", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)

-- Updated gamelist using GameId instead of PlaceId
local gs = {
    -- Use GameId (UniverseId) instead of PlaceId
    -- You'll need to find the correct GameId for 99 Nights
    [YOUR_GAME_ID_HERE] = "https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/loader/scripts/aiko99NITF.lua", -- 99 Nights in The Forest
    [3101667897] = "https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/loader/scripts/aikoTheForge.lua", -- The Forge (example GameId)
}

for GameID, Execute in pairs(gs) do
    if GameID == game.GameId then
        print("Match found! Loading script...")
        loadstring(game:HttpGet(Execute))()
        break
    end
end
