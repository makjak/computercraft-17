if(not os.loadAPI("hydraApi")) then
    error("Could not load hydraApi")
end

local timers = {}
local config
local monitor = hydraApi.getMonitor()

function tick()
    -- redstone.setBundledOutput("left", 1)
end

function createTimers(config)
    for k,v in pairs(config) do
        timers[k] = {}
        timers[k]["state"] = 0
        timers[k]["count"] = 0
    end
end

function writeTimers()
    if(monitor == nil) then
        return
    end
    monitor.clear()
    local row = 1
    for k,v in pairs(reactorIds) do
        monitor.setCursorPos(1, row)
        monitor.write()
        row = row + 1
    end
end

function formatForScreen(k)
    local value = tostring(k) .. ": " .. tostring(config[k]["high"])

    return value
end

config = hydraApi.loadConfig("timers.cfg")

if(config == nil) then
    config = {}
    config[1] = {}
    config[1]["high"] = 3
    config[1]["low"] = 2
    config[1]["side"] = "left"
    config[1]["color"] = 1

    hydraApi.saveConfig(config, "timers.cfg")
end

while true do
    tick()
    writeTimers()
    sleep(1)
end



