if(not os.loadAPI("hydraApi")) then
    error("Could not load hydraApi")
end

local timers = {}
local config
local monitor = hydraApi.getMonitor()

function tick()
    local dirty = {}
    local sides = {}
    for k,v in pairs(config) do
        local side = config[k]["side"]
        timers[k]["count"] = timers[k]["count"] - 1
        if(timers[k]["count"] <= 0) then
            dirty[side] = true
            if(timers[k]["state"] == 0) then
                timers[k]["state"] = 1
                timers[k]["count"] = config[k]["high"]
            else
                timers[k]["state"] = 0
                timers[k]["count"] = config[k]["low"]
            end
        end
        if(sides[side] == nil) then
            sides[side] = 0
        end
        if(timers[k]["state"] == 1) then
            sides[side] = sides[side] + config[k]["color"]
        end
    end

    for k, v in pairs(dirty) do
        if(dirty[k]) then
            redstone.setBundledOutput(k, sides[k])
            print(k .. ": " .. tostring(sides[k))
        end
    end
end

function createTimers()
    for k,v in pairs(config) do
        timers[k] = {}
        timers[k]["state"] = 0
        timers[k]["count"] = config[k]["high"]
    end
end

function writeTimers()
    if(monitor == nil) then
        return
    end
    monitor.clear()
    local row = 1
    for k,v in pairs(config) do
        monitor.setCursorPos(1, row)
        monitor.write(formatForScreen(k))
        row = row + 1
    end
end

function formatForScreen(k)
    local value = tostring(k) .. ": " .. tostring(timers[k]["state"]) ..  " - " .. tostring(timers[k]["count"])

    return value
end

function loadConfig()
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
end

loadConfig()
createTimers()

while true do
    tick()
    writeTimers()
    sleep(1)
    print("Tick")
end



