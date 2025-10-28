-- import_folder_structure_toggle_fixed.lua
-- Import images from a folder into Aseprite and recreate folder hierarchy as layer groups.
-- Includes checkbox to control whether first (01) ends up on top.

local dlg = Dialog("Import Folder Structure")
dlg:file{ id="folder", label="Root Folder", open=true }
dlg:check{ id="topFirst", text="Top = first (01 at top)", selected=true }
dlg:button{ id="ok", text="Import" }
dlg:button{ id="cancel", text="Cancel" }
dlg:show()

local data = dlg.data
if not data.folder or data.cancel then return end

-- Utility: remove extension
local function nameNoExt(filename)
  return filename:match("(.+)%..+$") or filename
end

-- Recursively scan directory
local function scanDir(path)
  local entries = app.fs.listFiles(path)
  table.sort(entries, function(a, b) return a:lower() < b:lower() end)
  local items = {}
  for _, e in ipairs(entries) do
    local full = app.fs.joinPath(path, e)
    if app.fs.isDirectory(full) then
      items[#items+1] = { type = "folder", name = e, path = full, children = scanDir(full) }
    else
      local ext = app.fs.fileExtension(full):lower()
      if ext == "png" or ext == "jpg" or ext == "jpeg" or ext == "ase" or ext == "aseprite" then
        items[#items+1] = { type = "file", name = e, path = full }
      end
    end
  end
  return items
end

local rootItems = scanDir(data.folder)
if #rootItems == 0 then
  app.alert("No valid image files found in the selected folder.")
  return
end

-- Iterator for order control
local function iterItems(items, topFirst)
  if topFirst then
    local i = #items + 1
    return function()
      i = i - 1
      if i >= 1 then return items[i] end
      return nil
    end
  else
    local i = 0
    return function()
      i = i + 1
      if i <= #items then return items[i] end
      return nil
    end
  end
end

app.transaction(function()
  local sprite = Sprite(512, 512)

  local function importGroup(parent, items)
    for item in iterItems(items, data.topFirst) do
      if item.type == "folder" then
        local group = sprite:newGroup()
        group.name = item.name
        if parent then group.parent = parent end  -- ✅ only set parent if not nil
        importGroup(group, item.children)
      elseif item.type == "file" then
        local img = Image{ fromFile = item.path }
        if sprite.width ~= img.width or sprite.height ~= img.height then
          sprite:resize(img.width, img.height)
        end
        local layer = sprite:newLayer()
        layer.name = nameNoExt(item.name)
        if parent then layer.parent = parent end  -- ✅ root layers stay at sprite root
        local cel = sprite:newCel(layer, 1)
        cel.image = img
      end
    end
  end

  importGroup(nil, rootItems)
end)

app.refresh()
app.alert("Import complete!\n'01 at top' = " .. tostring(data.topFirst))
