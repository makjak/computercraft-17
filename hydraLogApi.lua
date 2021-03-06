local urlbase = "http://localhost:8080/reactor"

local headers = {
    ["Content-Type"] = "application/json"
}

if(not os.loadAPI("hydraApi")) then
    error("Could not load hydraApi")
end

function getReactorInfo(reactor)
    local info = {}
    info['energy'] = reactor.getEnergyStored()
    info['energyProduction'] = reactor.getEnergyProducedLastTick()
    info['fuelTemperature'] = reactor.getFuelTemperature()
    info['energyFraction'] = reactor.getEnergyStored() / 10000000
    info['controlRods'] = reactor.getNumberOfControlRods()
    info['active'] =  reactor.getActive()
    info['fuelReactivity'] = reactor.getFuelReactivity()
    info['fuelConsumption'] = reactor.getFuelConsumedLastTick()
    local x, y, z = reactor.getMinimumCoordinate()
    info['minCoordinate'] = {x, y, z }
    x, y, z = reactor.getMaximumCoordinate()
    info['maxCoordinate'] = {x, y, z }

    local avg = 0
    for i = 0,info['controlRods'] - 1 do
        avg = avg + reactor.getControlRodLevel(i)
    end

    info['controlRodAverage'] = avg / info['controlRods']

    return info
end

function logReactor(base, reactorid, reactor)
    local json = textutils.serializeJSON(getReactorInfo(reactor))
    local handle = http.post(urlbase, json, headers)

    return handle ~= nil and handle.getResponseCode() == 200
end


