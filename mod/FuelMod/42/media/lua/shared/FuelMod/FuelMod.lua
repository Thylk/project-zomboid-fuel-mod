-- FuelMod entry point. Lives in shared/ so it runs on client and server.
-- Files sit under a FuelMod/ subfolder because Lua files with the same
-- relative path as a vanilla or other-mod file replace that file.

print("[FuelMod] Lua loaded")

local function onGameStart()
    print("[FuelMod] OnGameStart, world age hours = " .. tostring(getGameTime():getWorldAgeHours()))
end

Events.OnGameStart.Add(onGameStart)
