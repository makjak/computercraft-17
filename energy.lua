if(not os.loadAPI("hydraApi")) then
    error("Could not load hydraApi")
end

local monitor = hydraApi.getMonitor()
if(monitor == nil) then
    error('No monitor attached')
end

monitor.clear()

local capacitors = hydraApi.getAllPeripherals('tile_blockcapacitorbank_name')

local config

function displayList()
    local row = 2
    monitor.setCursorPos(1,1)
    monitor.write("RF         %")
    for key, c in pairs(capacitors) do
        local stored = c.getEnergyStored() * config[key]['size']
        monitor.setCursorPos(1,row)
        monitor.write(hydraApi.padLeft(hydraApi.formatEnergy(stored), 10) .. ' ')
        row = row + 1
    end
end

function loadConfig(capacitors)
    config = hydraApi.loadConfig("energy.cfg")

    if(config == nil) then
        config = {}

        for key, c in pairs(capacitors) do
            config[key] = {}
            config[key]['size'] = 1
        end

        hydraApi.saveConfig(config, "energy.cfg")
    end
end

loadConfig(capacitors)

while true do
    displayList()
    os.sleep(2)
end