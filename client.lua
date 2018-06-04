local ESX = nil
local inMarker = false
local registerOpen = false
local PlayerData = {}

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

-- Notification
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Display marker and Enter/Exit events
Citizen.CreateThread(function ()
  while true do
    Wait(0)
		--if PlayerData.job ~= nil and PlayerData.job.name ~= 'unemployed' and PlayerData.job.name == "police" then
			v = Config.Marker.Records
	    if( v.Type ~= -1 and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.Pos.x, v.Pos.y, v.Pos.z, true) < 50 ) then
	      DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
	    end
			if( v.Type ~= -1 and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x ) then
	      inMarker = true
				hintToDisplay(v.Hint)
			else
				inMarker = false
	    end
		end
  --end
end)

-- Key events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlPressed(0, 38) and inMarker then
			SetNuiFocus(true, true)
			registerOpen = true
			SendNUIMessage({
			  action = "open"
			})
		end
	end
end)

-- Disable movements when the register is open
Citizen.CreateThread(function()
  while true do
    if registerOpen then
      DisableControlAction(0, 1, true) -- LookLeftRight
      DisableControlAction(0, 2, true) -- LookUpDown
      DisableControlAction(0, 24, true) -- Attack
      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)

-- Close the register
RegisterNUICallback('escape', function(data, cb)
	SetNuiFocus(false, false)
	registerOpen = false
	cb('ok')
end)

-- # Search for a player
-- # Callback from javascript
RegisterNUICallback('search', function(data, cb)
	TriggerServerEvent('jsfour-brottsregister:getPlayerData', data.personnummer, data.lastdigits)
	cb('ok')
end)

-- # Callback from server
RegisterNetEvent('jsfour_brottsregister:searchCallback')
AddEventHandler('jsfour_brottsregister:searchCallback', function(error, playerData)
	if not error then
		SendNUIMessage({
			action = "playerFound",
			array = playerData
		})
	else
		SendNUIMessage({
			action = "playerNull"
		})
	end
end)
