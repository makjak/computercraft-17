local urlbase = "http://api.niels.nu/cclogger/"

if(not os.loadAPI("hydraApi")) then
    error("Could not load hydraApi")
end

function xyzTupleToList(tuple)
    local x, y, z = tuple
    return {x, y, z}
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
    info['minCoordinate'] = xyzTupleToList(reactor.getMinimumCoordinate())
    info['maxCoordinate'] = xyzTupleToList(reactor.getMaximumCoordinate())

    local avg = 0
    for i = 0,info['controlRods'] - 1 do
        avg = avg + reactor.getControlRodLevel(i)
    end

    info['controlRodAvrage'] = avg / info['controlRods']

    return info
end

function logReactor(base, reactorid, reactor)
    local url = urlbase .. base .. "/reactor/" .. reactorid
    print(url)
    print(textutils.serializeJSON(getReactorInfo(reactor)))
end


