-- Layer Export Script for Aseprite
-- Author: Snepsid
-- Version: 1.0.0
-- Description: Exports grouped layers to separate PNG files
-- License: CC0 1.0 Universal

local sprite = app.activeSprite
if not sprite then
    app.alert("No active sprite")
    return
end

-- Function to select the output directory (manually change the path below)
local function selectDirectory()
    return (os.getenv("HOME") or "") .. "/aseprite_export"
end

-- Function to create a directory, handling spaces and special characters
local function createDirectory(path)
    -- Ensure the path is enclosed in quotes to handle spaces and special characters
    local mkdirCommand = 'mkdir -p "' .. path:gsub('"', '\\"') .. '"'
    os.execute(mkdirCommand)
end

-- Function to export a layer as a PNG
local function exportLayer(layer, path)
    local image = Image(sprite.spec)
    image:clear()
    for i, cel in ipairs(layer.cels) do
        image:drawImage(cel.image, cel.position)
    end
    local fullPath = path .. "/" .. layer.name .. ".png"
    image:saveAs(fullPath)
end

local function processLayer(layer, path)
    if layer.isGroup then
        -- Replace any non-alphanumeric character with an underscore for the directory name
        local safeGroupName = layer.name:gsub("%W", "_")
        local groupPath = path .. "/" .. safeGroupName
        createDirectory(groupPath)

        for i, innerLayer in ipairs(layer.layers) do
            processLayer(innerLayer, groupPath)
        end

        return
    end

    local success, err = pcall(exportLayer, layer, path)
    if not success then
        app.alert("Failed to export layer " .. layer.name .. ": " .. tostring(err))
    end
end

-- Main process
local outputDir = selectDirectory()
createDirectory(outputDir)

for i, layer in ipairs(sprite.layers) do
    processLayer(layer, outputDir)
end

app.alert("Export complete!")
