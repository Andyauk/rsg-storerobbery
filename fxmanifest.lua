fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'rsg-storerobbery'
version '1.0.8'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

client_script 'client/*.lua'
server_script 'server/*.lua'

files {
    'html/*'
}

dependencies {
    'rsg-core',
    --'rsg-policejob',
    'rsg-lawman',
    'ox_lib'
}

lua54 'yes'
