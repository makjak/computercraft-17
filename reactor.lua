local confModemSide = "left"

if(not os.loadAPI("hydraApi")) then
        error("Could not load hydraApi")
end

local modem = peripheral.wrap(confModemSide)
local monitor = hydraApi.getMonitor()
monitor.clear()

local reactorIds = modem.getNamesRemote()

local reactor = {}

function getReactorInfo(reactor) 
    local info = {}
    if(reactor.getActive()) then
        info['status'] = 'Active'
    else
        info['status'] = 'Inactive'
    end
    info['energyfraction'] = reactor.getEnergyStored() / 10000000
    info['energypercent'] = hydraApi.formatPercent(info['energyfraction'])
    info['energyproduction'] = reactor.getEnergyProducedLastTick()
    info['rods'] = reactor.getNumberOfControlRods()
    info['fuelconsumption'] = reactor.getFuelConsumedLastTick()
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

function displayList()
    local row = 1
    for key, r in pairs(reactor) do
        local info = getReactorInfo(r)
        monitor.setCursorPos(1,row)
        monitor.write(padLeft(info['energypercent'], 6) .. ' ')
        monitor.write(padLeft(round(r.getFuelTemperature()),6) .. ' ')
        monitor.write(padLeft(round(info['rodaverage']),4) .. ' ')
        row = row + 1
    end
end

function displaySingle(reactor)
    local info = getReactorInfo(reactor)
    monitor.setCursorPos(1, 1)
    monitor.write("Reactor status:   " .. info['status'] .. '    ')
    monitor.setCursorPos(1, 2)
    monitor.write("Energy:           " .. info['energypercent'] .. '%    ')
    monitor.setCursorPos(1, 3)
    monitor.write("Production:       " .. hydraApi.formatEnergy(info['energyproduction']) .. '      ')
    monitor.setCursorPos(1, 4)
    monitor.write("Fuel temp:        " .. tostring(round(reactor.getFuelTemperature())) .. 'C    ')
    monitor.setCursorPos(1, 5)
    monitor.write("Fuel consumption: " .. tostring(info['fuelconsumption']) .. " mB/t    ")
    monitor.setCursorPos(1, 6)
    monitor.write("Rods insertion:   " .. tostring(round(info['rodaverage'])) .. '%    ')
end

while true do
    displaySingle(reactor[1])
    os.sleep(2)
end