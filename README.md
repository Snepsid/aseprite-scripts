# Aseprite Scripts Collection

A collection of utility scripts for Aseprite to enhance your pixel art workflow.

## Scripts

### Toggle Visibility of All Layers

Toggles visibility of all layers in the active sprite. If any layer is visible, all layers will be hidden. If all layers are hidden, all layers will be shown.

### Import Sprite Sheet to Layers

Imports a sprite sheet and splits it into individual layers based on provided sprite dimensions. Each sprite from the sheet will be placed on its own layer.

### Export All Layers Individually

Exports layers and grouped layers from the active sprite to separate PNG files, organizing them in directories based on their group names. Each layer within a group is exported as an individual PNG file.

## Installation

1. Open Aseprite
2. Go to File > Scripts > Open Scripts Folder
3. Copy the desired script(s) into this folder
4. Restart Aseprite or reload scripts (File > Scripts > Rescan Scripts Folder)

## Usage

### Toggle Visibility
1. Open your sprite in Aseprite
2. Go to File > Scripts > Toggle Visibility
3. All layers will toggle their visibility state

### Import Sprite Sheet to Layers
1. Open a new sprite in Aseprite with the dimensions you want for the final sprites
2. Go to File > Scripts > Import Sprite Sheet to Layers
3. Select your sprite sheet file when prompted
4. Enter the width and height of individual sprites in the sheet
5. The script will create new layers, each containing one sprite from the sheet

### Export All Layers Individually
1. Open your sprite with layers in Aseprite
2. Edit the script to set your desired export directory
3. Go to File > Scripts > Layer Export
4. The script will create directories for each group and export individual layers as PNGs

## Contributing

Feel free to open issues or submit pull requests with improvements!

## License

This work is dedicated to the public domain under CC0 1.0 Universal. See the LICENSE file for details.
