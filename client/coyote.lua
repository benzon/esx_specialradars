local notif = false
local i     = 0

Citizen.CreateThread(function()
	while true do
        local PlayerPed = GetPlayerPed(-1)
        local coords_ped = GetEntityCoords(PlayerPed, true)
        if IsPedInAnyVehicle(PlayerPed, false) then
            for key, valeur in pairs(Config.Coyote) do
                if (notif == false and GetDistanceBetweenCoords(coords_ped, Config.Coyote[key].position.x, Config.Coyote[key].position.y, Config.Coyote[key].position.z, true) < 110) then
                    DrawNotif('Vous entrez dans une ~y~zone de danger~w~. ~g~Pour votre sécurité contrôles routier fréquent~g~ !')
                    notif = true
                end
                if notif == true then
                    i = i+1
                    if i > 1550 then
                        i = 0
                        notif = false
                    end
                end
            end
        end
        Citizen.Wait(15)
    end
end)

function DrawNotif(message)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(message);
	SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, "~r~ATTENTION~w~", "Coyote Info Trafic");
	DrawNotification(false, true);
end