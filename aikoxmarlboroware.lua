local gs = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/loader/gamelist.lua"))()

local URL = gs[game.PlaceId] or gs[game.GameId]

if URL then
    print("Loading script for:", game.PlaceId, "or", game.GameId)
    loadstring(game:HttpGet(URL))()
else
    warn("No script found for this game.")
    warn("PlaceId: " .. tostring(game.PlaceId))
    warn("GameId: " .. tostring(game.GameId))
end
