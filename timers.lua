if(not os.loadAPI("hydraApi")) then
    error("Could not load hydraApi")
end

local config = hydraApi.loadConfig("timers.cfg")

if(config == nil) then
    config = {}
    config[1] = {}
    config[1]["high"] = 3
    config[1]["low"] = 2
    config[1]["side"] = "left"
    config[1]["color"] = 1

    hydraApi.saveConfig(config, "timers.cfg")
end


