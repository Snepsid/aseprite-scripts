-- Import Sprite Sheet to Layers Script for Aseprite
-- Author: Snepsid
-- Version: 1.0.0
-- Description: Splits a sprite sheet into individual layers
-- License: CC0 1.0 Universal

local function showDialogForFileSelection()
    local dlg = Dialog("Select Sprite Sheet")
    dlg:file{ id="spriteSheet", label="Sprite Sheet:", open=true }
    dlg:button{ id="ok", text="OK" }
    dlg:button{ id="cancel", text="Cancel" }
    dlg:show()

    if dlg.data.ok then
        return dlg.data.spriteSheet
    else
        return nil
    end
end

local function showDialogForSpriteDimensions()
    local dlg = Dialog("Sprite Dimensions")
    dlg:number{ id="width", label="Width:", text="32" }
    dlg:number{ id="height", label="Height:", text="32" }
    dlg:button{ id="ok", text="OK" }
    dlg:button{ id="cancel", text="Cancel" }
    dlg:show()

    if dlg.data.ok then
        return dlg.data.width, dlg.data.height
    else
        return nil, nil
    end
end

local function processSpriteSheet(sheet, spriteWidth, spriteHeight)
    local cols = math.floor(sheet.width / spriteWidth)
    local rows = math.floor(sheet.height / spriteHeight)
    local spriteNumber = 1

    app.transaction(function()
        for row = 0, rows - 1 do
            for col = 0, cols - 1 do
                local layer = app.activeSprite:newLayer()
                layer.name = string.format("Layer %03d", spriteNumber)

                local x = col * spriteWidth
                local y = row * spriteHeight

                local cel = app.activeSprite:newCel(layer, 1)
                local sheetCel = sheet.layers[1].cel
                if sheetCel then
                    local sheetImage = sheetCel.image:clone()

                    -- Cropping the image to the size of a single sprite
                    sheetImage:crop(Rectangle(x, y, spriteWidth, spriteHeight))

                    cel.image = sheetImage
                end

                spriteNumber = spriteNumber + 1
            end
        end
    end)
end

function main()
    local spriteSheetPath = showDialogForFileSelection()
    if not spriteSheetPath then return end

    local spriteWidth, spriteHeight = showDialogForSpriteDimensions()
    if not spriteWidth or not spriteHeight then return end

    local sheet = app.open(spriteSheetPath)
    processSpriteSheet(sheet, spriteWidth, spriteHeight)
end

main()
