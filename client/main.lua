local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX								= nil
local GUI						= {}
GUI.Time						= 0
local vitesse_flash				= 0
local vitesse_flash				= nil
local is_flashed 				= false
local speedlimit				= 0
local PlayerPed 				= nil
local PedCoords					= nil
local PedSpeed					= 0
local i 						= 0
local timeout					= 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Citizen.Wait(1000)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
	RequestModel("prop_cctv_pole_01a")
	while not HasModelLoaded("prop_cctv_pole_01a") do
		Wait(1)
	end
	for k, v in pairs(Config.Radars) do
		CreateObject(GetHashKey('prop_cctv_pole_01a'), Config.Radars[k].props.x, Config.Radars[k].props.y, Config.Radars[k].props.z, true, true, true)
		Citizen.Wait(150)
	end
end)

Citizen.CreateThread(function()
	while true do
		PlayerPed = GetPlayerPed(-1)
		if IsPedInAnyVehicle(PlayerPed, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPed, false), -1) == PlayerPed then
			PedCoords = GetEntityCoords(PlayerPed, true)
			for k, w in pairs(Config.Radars) do
				if GetDistanceBetweenCoords(PedCoords, Config.Radars[k].flash.x, Config.Radars[k].flash.y, Config.Radars[k].flash.z, true) < Config.Radars[k].r then
					if is_flashed == false and timeout == 0 then
						for i=1, #Config.Radars, 1 do
							speedlimit 	= Config.Radars[i].speedlimit + 6
							PedSpeed	= GetEntitySpeed(PlayerPed)
							PedSpeed 	= PedSpeed * 3.6
							if PedSpeed > speedlimit then
								vitesse_flash = (GetEntitySpeed(PlayerPed) * 3.6)

								local price = 0
								local speeding = PedSpeed - speedlimit

								speeding = round(speeding)

								if speeding < 20 then 
									price = 375
								end

								if speeding < 30 then 
									price = 425
								end

								if speeding < 50 then 
									price = 485
								end
								
								if speeding >= 50 then 
									price = 750
								end

								if is_flashed == false then
									StartScreenEffect('SwitchShortMichaelIn',  400,  false)
									ESX.ShowNotification(_U('auto_fine_notif', (speeding + speedlimit), (speedlimit-6)))
									TriggerServerEvent('esx_radars:sendBill', (speeding + speedlimit), 'society_police',_U('auto_fine', (speeding + speedlimit), (speedlimit-6)), price)
									is_flashed = true
									timeout = 85
								end

							end
						end
					end
				else
					price 			= 0
					vitesse_flash 	= 0
					is_flashed 		= false
				end
			end		
		end
		if timeout > 0 then
			timeout = timeout - 1
		end
		Citizen.Wait(55)
	end
end)

function round(num, dec)
	local mult = 10^(dec or 0)
	return math.floor(num * mult + 0.5) / mult
end