local gs = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/loader/gamelist.lua"))()

for PlaceID, Execute in pairs(gs) do
    if tostring(PlaceID) == tostring(game.PlaceId) then
        print("Match found! Loading script...")
        loadstring(game:HttpGet(Execute))()
        break
    end
end
