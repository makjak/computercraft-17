local confModemSide = "back"

if(not os.loadAPI("hydraApi")) then
    error("Could not load hydraApi")
end

if(not peripheral.isPresent(confModemSide)) then
    error("No modem on side " .. confModemSide)
end

local modem = peripheral.wrap(confModemSide)
-- local monitor = hydraApi.getMonitor()
-- monitor.clear()

local reactorIds = modem.getNamesRemote()

local reactor = {}

function getReactorInfo(reactor)
    local info = {}
    info['energyfraction'] = reactor.getEnergyStored() / 10000000
    info['energypercent'] = hydraApi.formatPercent(info['energyfraction'])
    info['rods'] = reactor.getNumberOfControlRods()
    local avg = 0
    for i = 0,info['rods'] - 1 do
        avg = avg + reactor.getControlRodLevel(i)
    end

    info['rodaverage'] = avg / info['rods']

    return info
end

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
        local info = getReactorInfo(r)
        -- monitor.setCursorPos(1,row)
        -- monitor.write(padLeft(info['energypercent'], 6) .. ' ')
        -- monitor.write(padLeft(round(r.getFuelTemperature()),6) .. ' ')
        -- monitor.write(padLeft(round(info['rodaverage']),4) .. ' ')
        -- row = row + 1
        print("Active:            " .. r.getActive())
        print("Energy storage:    " .. info['energypercent'])
        print("Energy production: " .. r.getEnergyProducedLastTick)
        print("Fuel temperature:  " .. r.getFuelTemperature())

        print("Rod insertion:     " .. info['rodaverage'])
    end

    os.sleep(2)
end
