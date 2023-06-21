Discord - https://discord.gg/3WYz3zaqG5

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

## external craft bench event
```lua
-- from client side script (replace arg 1 'basic' with the name of a crafting table from your config)(replace arg2 'idle' with an emote you want to use on this bench)
    TriggerEvent('sayer-crafting:ExternalBench','basic','idle')
-- from server side
    TriggerClientEvent('sayer-crafting:ExternalBench','basic','idle')
```

## external recycle bench event
```lua
    --from client side
    TriggerEvent('sayer-crafting:ExternalRecycle')
    --from server side
    TriggerClientEvent('sayer-crafting:ExternalRecycle')
```
