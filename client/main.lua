function az_gopostal_notify(msg)
  BeginTextCommandThefeedPost("STRING")
  AddTextComponentSubstringPlayerName(tostring(msg))
  EndTextCommandThefeedPostTicker(false, false)
end

function az_gopostal_help(msg)
  BeginTextCommandDisplayHelp("STRING")
  AddTextComponentSubstringPlayerName(tostring(msg))
  EndTextCommandDisplayHelp(0, false, true, -1)
end

function az_gopostal_doAction(label, ms)
  local ped = PlayerPedId()
  FreezeEntityPosition(ped, true)
  local start = GetGameTimer()
  while GetGameTimer() - start < ms do
    Wait(0)
    DisableAllControlActions(0)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandPrint(1, true)
  end
  FreezeEntityPosition(ped, false)
end

RegisterNetEvent('az_gopostal:notify', function(msg) az_gopostal_notify(msg) end)



local active = false
local idx = 1
local blip = nil

local function setBlip(pos)
  if blip then RemoveBlip(blip) end
  blip = AddBlipForCoord(pos.x, pos.y, pos.z)
  SetBlipSprite(blip, 280)
  SetBlipScale(blip, 0.85)
  SetBlipColour(blip, 1)
  SetBlipRoute(blip, true)
  BeginTextCommandSetBlipName("STRING"); AddTextComponentString("GoPostal Drop"); EndTextCommandSetBlipName(blip)
end

RegisterCommand('gopostal', function()
  if active then az_gopostal_notify("Already on a route.") return end
  TriggerServerEvent('az_gopostal:requestStart')
end)

RegisterNetEvent('az_gopostal:startDenied', function() active = false end)

RegisterNetEvent('az_gopostal:startOk', function()
  active = true
  idx = 1
  az_gopostal_notify("GoPostal route started.")
  setBlip(Config.Mailboxes[idx])
end)

CreateThread(function()
  while true do
    Wait(0)
    if not active then goto cont end

    local pos = Config.Mailboxes[idx]
    local p = GetEntityCoords(PlayerPedId())
    local dist = #(p - pos)

    if dist < 25.0 then
      DrawMarker(2, pos.x,pos.y,pos.z+0.2, 0,0,0, 0,180,0, 0.45,0.45,0.45, 230,57,70,170, false,true,2,false,nil,nil,false)
    end

    if dist < 2.0 then
      az_gopostal_help("Press ~INPUT_DETONATE~ to drop mail")
      if IsControlJustPressed(0, Config.ActionKey) then
        az_gopostal_doAction("Dropping mail...", Config.ActionTimeMs or 3000)
        TriggerServerEvent('az_gopostal:stopComplete')
        idx = idx + 1
        if idx > #Config.Mailboxes then
          active = false
          if blip then RemoveBlip(blip) blip=nil end
          az_gopostal_notify("Route complete.")
        else
          setBlip(Config.Mailboxes[idx])
          az_gopostal_notify("Next mailbox...")
        end
      end
    end
    ::cont::
  end
end)
