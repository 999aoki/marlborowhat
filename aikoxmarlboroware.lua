local gs = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/loader/gamelist.lua"))()

local URL = gs[game.GameId]

if URL then
  loadstring(game:HttpGet(URL))()
end
