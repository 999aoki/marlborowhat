-- Debug version to find the issue
print("=== LOADER DEBUG START ===")
print("Current PlaceId:", game.PlaceId)
print("PlaceId type:", type(game.PlaceId))

local success, gs = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/Aiko-Hub/refs/heads/main/loader/gamelist.lua"))()
end)

if not success then
    warn("Failed to load gamelist:", gs)
    return
end

print("Gamelist loaded successfully!")
print("Gamelist type:", type(gs))

if gs then
    print("\n=== Checking all PlaceIDs in gamelist ===")
    for PlaceID, Execute in pairs(gs) do
        print("PlaceID in list:", PlaceID, "| Type:", type(PlaceID))
        print("Comparing:", tostring(PlaceID), "vs", tostring(game.PlaceId))
        print("Match?", tostring(PlaceID) == tostring(game.PlaceId))
        
        if tostring(PlaceID) == tostring(game.PlaceId) then
            print("\n=== MATCH FOUND! ===")
            print("Loading script from:", Execute)
            
            local scriptSuccess, scriptError = pcall(function()
                loadstring(game:HttpGet(Execute))()
            end)
            
            if scriptSuccess then
                print("Script executed successfully!")
            else
                warn("Script execution failed:", scriptError)
            end
            break
        end
    end
    print("\n=== LOADER DEBUG END ===")
else
    warn("Gamelist is nil or invalid")
end
