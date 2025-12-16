local success, gs = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/Aiko-Hub/refs/heads/main/loader/gamelist.lua"))()
end)

if not success then
    warn("Failed to load game list:", gs)
    return
end

if gs then
    for PlaceID, Execute in pairs(gs) do
        if PlaceID == game.PlaceId then
            print("Found game! Loading script...")
            
            local scriptSuccess, scriptError = pcall(function()
                local scriptContent = game:HttpGet(Execute)
                wait(0.1)
                loadstring(scriptContent)()
            end)
            
            if not scriptSuccess then
                warn("Failed to execute script:", scriptError)
            else
                print("Script loaded successfully!")
            end
            break
        end
    end
else
    warn("Game list is empty or invalid")
end
