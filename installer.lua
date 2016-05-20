local baseUrl = "http://pastebin.com/raw.php?i="
local dataId = "MXUN1pmS"
local appTable = {}

function download(id)
    local handle = http.get(baseUrl..id)
    if(handle == nil) then
        error("Could not download: "..baseUrl..id)
    end
    local data = handle.readAll()
    handle.close()
    
    return data
end

function saveFile(data, filename)
    local handle = fs.open(filename, "w")
    handle.write(data)
    handle.close()
end

function loadInstalled()
    local installed = nil
    local handle = fs.open("installed.txt", "r")
    if(handle ~= nil) then
        installed = textutils.unserialize(handle.readAll())
        handle.close()
    end
    return installed
end

function findDepTree(depTable, app)
    if(app["deps"] ~= nil and #app["deps"] > 0) then
        print("App '" .. app["app"] .. "' has " .. tostring(#app["deps"]) .. " dependencies.")
        for k,dep in pairs(app["deps"]) do
            depApp = find(dep)
            if(depApp ~= nil) then
                findDepTree(depTable, depApp)
            else
                error("Could not find dependancy: " .. dep)
            end
        end
    end
    depTable[app["app"]] = app
end

function install(app)
    installed = installed or {}
    print("Installing app: " .. app["app"])
    local depTable = {}
    findDepTree(depTable, app)
    installApps(depTable)
    saveFile(textutils.serialize(depTable), "installed.txt")
    return installed
end

function installApps(depTable)
    for key, app in pairs(depTable) do
        local data = download(app["id"])
        local saveas = app["saveas"]
        
        if(saveas == nil) then
            saveas = app["app"]
        end
        saveFile(data, saveas)
        print("Saved " .. app["app"] .. " as " .. saveas)           
    end
end

function find(name)
    for k, app in pairs(appTable) do
        if(app["app"] == name) then
            return app
        end
    end
    return nil
end

function writeList()
    for k, app in pairs(appTable) do
        print(tostring(k) .. ": " .. app["app"])           
    end
    
end

function refresh()
    local installed = loadInstalled()
   
    if(installed == nil) then
        print("No installed apps")
        return
    else
        print("Redownloading files.")
        installApps(installed)
    end  
end

function makeSpace(level)
    local s = ""
    for i = 0,level,1 do
        s = s .. "  "
    end
    return s
end

function info(app, level)
    level = level or 0
    local saveas = app["app"]
    if(app["saveas"] ~= nil) then
        saveas = app["saveas"]
    end
    local space = makeSpace(level)
    print(space .. "App: " .. app["app"].. ", save as: " ..saveas)
    local numDeps = 0
    
    if(app["deps"] ~= nil) then numDeps = #app["deps"] end
    
    print(space .. "Dependencies(" .. tostring(numDeps) .."):")
    
    if(numDeps > 0) then
        for k,v in pairs(app["deps"]) do
            local dep = find(v)
            info(dep, level + 1)
        end
    end
end

function doCommand(args)
    local command
    if(#args == 0) then
        command = "help"
    else
        command = args[1]
    end
    
    if(command == "list") then
        term.clear()
        writeList()
    elseif(command == "i") then
        local appName = args[2]
        local app = find(appName)
        if(app == nil) then
            print("Could not find app: " .. tostring(appName))
        else
            install(app)
            
        end
    elseif(command == "re") then
        refresh()
    elseif(command == "info") then
        local appName = args[2]
        local app = find(appName)
        if(app == nil) then
            print("Could not find app: " .. tostring(appName))
        else
            info(app)
        end
    elseif(command == "help") then
        term.clear()
        print("inst <command> [arguments]")
        print("Commands:")
        print("  help            - this screen")
        print("  list            - list apps")
        print("  i <appname>     - install <appname>")
        print("  info <appname>  - info on <appname>")
        print("  re              - redownload installed apps")
        
    else
        print("Unknown command: " .. command)
    end
end

appTable = textutils.unserialize(download(dataId))

args = {...}

doCommand(args)