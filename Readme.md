Discord - https://discord.gg/3WYz3zaqG5

## Sayer Crafting v1.0.0
```
Designed to give you a wide variety of ways to enable crafting within your server using multiple props,locations,peds and items
```

## Please note
- any item you use within the script must be in your shared/items.lua for the script to work correctly
- you must not have any duplicate itemcodes in your Shared/Items.lua
- Please make sure u use the latest dependencies aswell as core for this in order to work.

## Dependencies :
- QBCore Framework - https://github.com/qbcore-framework/qb-core
- PolyZone - https://github.com/mkafrin/PolyZone
- qb-target - https://github.com/BerkieBb/qb-target
- qb-menu - https://github.com/qbcore-framework/qb-menu

## Install : 
- Place This into your qb-core/server/player.lua metadata chunk
```lua
    PlayerData.metadata['sayercraftxp'] = PlayerData.metadata['sayercraftxp'] or 0
    PlayerData.metadata['sayercraftlevel'] = PlayerData.metadata['sayercraftlevel'] or 1
```

## Configure your tables/props/locations
## and configure your items :)
