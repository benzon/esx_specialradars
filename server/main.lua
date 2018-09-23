ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_radars:sendBill')
AddEventHandler('esx_radars:sendBill', function(speed, sharedAccountName, label, amount)
	local _source = source
	local xTarget = ESX.GetPlayerFromId(_source)

	if xTarget.job ~= nil and xTarget.job.name ~= 'police' and xTarget.job.name ~= 'ambulance' and xTarget.job.name ~= 'fib' then

		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)

			if amount < 0 then
				print('esx_radars: ' .. GetPlayerName(_source) .. ' tried sending a negative bill!')
			elseif account == nil then

				if xTarget ~= nil then
					MySQL.Async.execute(
						'INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
						{
							['@identifier']  = xTarget.identifier,
							['@sender']      = 'steam:RADARS_AUT',
							['@target_type'] = 'player',
							['@target']      = 'steam:RADARS_AUT',
							['@label']       = label,
							['@amount']      = amount
						},
						function(rowsChanged)
							TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_invoice', amount))
						end
					)
				end

			else

				if xTarget ~= nil then
					MySQL.Async.execute(
						'INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
						{
							['@identifier']  = xTarget.identifier,
							['@sender']      = 'steam:RADARS_AUTO',
							['@target_type'] = 'society',
							['@target']      = sharedAccountName,
							['@label']       = label,
							['@amount']      = amount
						},
						function(rowsChanged)
							TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_invoice', amount))
						end
					)
				end

			end
		end)
		if speed > 50 then
			RemoveDriveLicense(xTarget.identifier)
			TriggerClientEvent('esx:showNotification', xTarget.source, _U('remove_dmv'))
		end
	else
		TriggerClientEvent('esx:showNotification', xTarget.source, _U('employer_notified'))
	end
end)

function RemoveDriveLicense(identifier)
	MySQL.Async.execute(
		'DELETE FROM user_licenses WHERE owner = @owner',
		{
			['@owner'] = identifier
		}, function(rowsChanged)
			return rowsChanged
		end
	)
end