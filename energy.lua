if(not os.loadAPI("hydraApi")) then
    error("Could not load hydraApi")
end

local monitor = hydraApi.getMonitor()
if(monitor == nil) then
    error('No monitor attached')
end

monitor.clear()

local capacitors = hydraApi.getAllPeripherals('tile_blockcapacitorbank_name')

function displayList()
    local row = 2
    monitor.setCursorPos(1,1)
    monitor.write("RF     %")
    for key, c in pairs(capacitors) do
        monitor.setCursorPos(1,row)
        monitor.write(hydraApi.padLeft(hydraApi.formatEnergy(c.getEnergyStored()), 8) .. ' ')
        row = row + 1
    end
end

while true do
    displayList()
    os.sleep(2)
end