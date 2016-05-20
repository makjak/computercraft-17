-- Returns a table with the sides and peripheral types
function getPeripheralList()
	local sides = peripheral.getNames()
	local pTable = {}
	
	for k,side in pairs(sides) do
		pTable[side] = peripheral.getType(side)
	end
	
	return pTable
end

-- finds the first peripheral of type 'peripheralType' and wraps it
function getPeripheral(peripheralType)
	local pTable = getPeripheralList()
	for side, pType in pairs(pTable) do
		if(peripheralType == pType) then
			return peripheral.wrap(side)
		end
	end
	return nil
end

-- finds all peripherals of type 'peripheralType' and wraps them
function getAllPeripherals(peripheralType)
	local pTable = getPeripheralList()
	local wrappedTable = {}
	for side, pType in pairs(pTable) do
		if(peripheralType == pType) then
			wrappedTable[side] = peripheral.wrap(side)
		end
	end
	return wrappedTable
end

-- finds the first modem and wraps it
function getModem(wireless)
    local modem = getAllPeripherals("modem")
    for k, m in pairs(modem) do
        if(m.isWireless() == wireless) then
            return m
        end
    end
end

-- finds the first monitor and wraps it
function getMonitor()
	return getPeripheral("monitor")
end

-- finds the first crafting terminal and wraps it
function getCraftingTerminal()
	return getPeripheral("me_crafting_terminal")
end

-- finds the first ME bridge and wraps it
function getMeBridge()
	return getPeripheral("meBridge")
end

-- finds all redstone energy cells and wraps them
function getAllEnergyCells()
	return getAllPeripherals("redstone_energy_cell")
end

-- finds all alvearies and wraps them
function getAllAlvearies()
	return getAllPeripherals("alveary")
end

-- String split function, splits pString on pPattern
function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

-- Debug function: prints a table
function printTable(t)
	if(t == nil) then
		print("**nil**")
		return
	end
	for k,v in pairs(t) do
		print(tostring(k) .. "=" .. tostring(v))
	end
end

function round(number)
	return math.floor(number * 10) / 10
end

function formatLargeNumber(amount)
        local postfix
 
        if(amount >= 1000000000) then
                amount = math.floor(amount / 100000000) / 10
                postFix = "G" 
        elseif(amount >= 1000000) then
                amount = math.floor(amount / 100000) / 10
                postFix = "M"
        elseif(amount >= 1000) then
                amount = math.floor(amount / 100) / 10
                postFix = "k"
        else
                postFix = ""         
        end
       
        return tostring(round(amount)) .. postFix
end

function formatEnergy(amount)
	return formatLargeNumber(amount) .. "RF"
end

function formatPercent(fraction)
	percent = math.floor(fraction * 1000) / 10
	return string.format("%3.1f", percent) .. "%"
end

function saveConfig(config, filename)
	local handle = fs.open(filename, "w")
	handle.write(textutils.serialize(config))
	handle.close()
end

function loadConfig(filename)
	local config
	local handle = fs.open(filename, "r")
	if(handle ~= nil) then
		config = textutils.unserialize(handle.readAll())
		handle.close()
	end
	return config
end

-- Debug function: prints all connected peripherals
function printPeripherals()
	printTable(getPeripheralList())
end