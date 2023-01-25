fx_version 'adamant'

game 'gta5'
lua54 'yes'
author "Ranjit"
description "CluckingBell "

client_scripts {
    '@PolyZone/CircleZone.lua',
    '@PolyZone/client.lua',
    'client/client.lua',
    'config.lua',
}

server_scripts {
    'server/server.lua',
    'config.lua',
}

dependencies {
    'PolyZone',
    'qb-target',
}