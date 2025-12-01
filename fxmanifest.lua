fx_version 'cerulean'
game 'gta5'

name 'peakhousemenu'
author 'ARP'
description 'Admin coin manager for Peak HouseRobbery'
version '1.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client.lua'

server_script 'server.lua'
