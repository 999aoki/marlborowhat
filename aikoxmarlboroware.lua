local gs = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/loader/gamelist.lua"))()
local URL = gs[game.PlaceId] or gs[game.GameId]

if URL then
    print("Loading Script For: " .. game.Name)
    loadstring(game:HttpGet(URL))()
else
    game:GetService"Players".LocalPlayer:Kick"Unsupported Game."
end
