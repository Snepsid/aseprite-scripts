-- Aseprite script: Collect unique layer colors in current frame
-- and replace the sprite palette with them (no duplicates, ignoring transparency)

local spr = app.activeSprite
if not spr then
  return app.alert("No active sprite found.")
end

local frame = app.activeFrame
local uniqueColors = {}

-- Helper: convert RGBA to a 32-bit integer key
local function colorKey(c)
  return (c.red << 24) | (c.green << 16) | (c.blue << 8) | c.alpha
end

for _, layer in ipairs(spr.layers) do
  if layer.isImage then
    local cel = layer:cel(frame)
    if cel and cel.image then
      local img = cel.image
      for pixel in img:pixels() do
        local c = pixel()
        if c.alpha > 0 then -- ignore transparent pixels
          uniqueColors[colorKey(c)] = c
        end
      end
    end
  end
end

-- Build the new palette from unique colors
local newPalette = Palette(#uniqueColors)
local i = 0
for _, c in pairs(uniqueColors) do
  if i < 256 then -- palette size limit
    newPalette:setColor(i, Color(c))
    i = i + 1
  else
    break
  end
end

-- Apply new palette
spr:setPalette(newPalette)
app.refresh()
app.alert("Palette replaced with " .. i .. " unique colors from layers.")
