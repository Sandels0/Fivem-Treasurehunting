server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Sandels'
description 'Aarteenkaivuu'
version '1.0.0'

dependency 'ox_lib'

shared_script '@es_extended/imports.lua'

client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}

server_script 'server.lua'
