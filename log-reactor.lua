local confModemSide = "back"

if(not os.loadAPI("hydraApi")) then
    error("Could not load hydraApi")
end

if(not os.loadAPI("hydraLogApi")) then
    error("Could not load hydraLogApi")
end

if(not peripheral.isPresent(confModemSide)) then
    error("No modem on side " .. confModemSide)
end

local modem = peripheral.wrap(confModemSide)
-- local monitor = hydraApi.getMonitor()
-- monitor.clear()

local reactorIds = modem.getNamesRemote()

local reactor = {}

function round(number)
    return math.floor(number * 10) / 10
end

function padLeft(str, len)
    str = '' .. str
    return  string.rep(' ', len - #str) .. str
end

for k,v in pairs(reactorIds) do
    reactor[k] = peripheral.wrap(v)
    print("Connected to: " .. v)
end

while true do
    local row = 1
    for key, r in pairs(reactor) do
        hydraLogApi.logReactor("test", key, r)
    end

    os.sleep(2)
end
