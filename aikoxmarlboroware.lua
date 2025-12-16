local gs = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/loader/gamelist.lua"))()

for GameID, Execute in pairs(gs) do
    if GameID == game.GameId then
        print("Match found! Loading script for", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
        loadstring(game:HttpGet(Execute))()
        break
    end
end
