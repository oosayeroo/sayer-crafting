fx_version 'cerulean'
game 'gta5'
author 'oosayeroo'
description 'sayer-crafting'
version '2.0.0'
lua54 'yes'

client_scripts{
    'client/functions.lua',
    'client/main.lua'
}

shared_scripts{
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}