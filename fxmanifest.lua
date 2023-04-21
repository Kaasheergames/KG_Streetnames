fx_version 'adamant'
game "gta5"
lua54 'yes'

name "KG_streetnames"
description "Toggable Streetnames HUD"
author "Kaasheergames - https://github.com/Kaasheergames"

version '1.0.0'

client_scripts {  
	'@es_extended/locale.lua',
	'client/*.lua',
	'locales/*.lua'
}

shared_script 'config.lua'

ui_page 'nui/nui.html'

files { 
	'nui/nui.html',
	'nui/style.css',
	'nui/script.js',
	'nui/images/*',
}