function download(url)
    local handle = http.get(url)
    if(handle == nil) then
        error("Could not download: "..url)
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

function run(args)
    local url, name
    if(#args < 2) then
        print("Usage: dlurl <url> <filename>")
        return
    end

    url = args[1]
    local data = download(args[1])
    saveFile(data, args[2])
    name = args[2]

    print("Downloaded " .. url .. " as " .. name)
end

args = {...}

run(args)
