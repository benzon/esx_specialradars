resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

--[[

	Author: 	SimonOriginal (https://github.com/SimonOriginal)
	Licece: 	MIT Licence
	Date  :		23/08/2018

]]--

description 'ESX Special Radars'

version '2.4.1'


server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/main.lua',
	'client/coyote.lua'
}
