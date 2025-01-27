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
    return "YOUR_EXPORT_PATH_HERE" -- Change this path
end

-- Function to create a directory, handling spaces and special characters
local function createDirectory(path)
    -- Ensure the path is enclosed in quotes to handle spaces and special characters
    local mkdirCommand = 'mkdir "' .. path:gsub('"', '\\"') .. '"'
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

-- Main process
local outputDir = selectDirectory()

for i, layer in ipairs(sprite.layers) do
    if layer.isGroup then
        -- Replace any non-alphanumeric character with an underscore for the directory name
        local safeGroupName = layer.name:gsub("%W", "_")
        local groupPath = outputDir .. "/" .. safeGroupName
        createDirectory(groupPath)
        for j, innerLayer in ipairs(layer.layers) do
            if not innerLayer.isGroup then
                local success, err = pcall(exportLayer, innerLayer, groupPath)
                if not success then
                    app.alert("Failed to export layer " .. innerLayer.name .. ": " .. tostring(err))
                end
            end
        end
    end
end

app.alert("Export complete!")
