-- Toggle Visibility of all Layers Script for Aseprite
-- Author: Snepsid
-- Version: 1.0.0
-- Description: Toggles visibility of all layers in the active sprite
-- License: CC0 1.0 Universal

local sprite = app.activeSprite
if not sprite then
  return app.alert("No active sprite")
end

local function toggleVisibility(layer, visibility)
  layer.isVisible = visibility
  if layer.isGroup then
    for _, child in ipairs(layer.layers) do
      toggleVisibility(child, visibility)
    end
  end
end

local visibility = false
for _, layer in ipairs(sprite.layers) do
  if layer.isVisible then
    visibility = true
    break
  end
end

for _, layer in ipairs(sprite.layers) do
  toggleVisibility(layer, not visibility)
end
