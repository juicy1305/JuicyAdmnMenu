ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end

reportlistesql = {}

RMenu.Add('menu', 'main', RageUI.CreateMenu("Base V1 - Juicy", " "))
RMenu.Add('menu', 'options', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Base V1 - Juicy", " "))
RMenu.Add('menu', 'joueurs', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Liste Joueurs", " "))
RMenu.Add('menu', 'warn', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Menu Warn", " "))
RMenu.Add('menu', 'sanction', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Menu Sanction", " "))
RMenu.Add('menu', 'actionstaff', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Menu Staff", " "))
RMenu.Add('menu', 'perso', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Menu Personnel", " "))
RMenu.Add('menu', 'world', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Menu HRP", " "))
RMenu.Add('menu', 'options', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Menu Options", " "))
RMenu.Add('menu', 'veh', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Menu Véhicules", " "))
RMenu.Add('menu', 'customcolor', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Couleur du véhicule", " "))
RMenu.Add('menu', 'ped', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Menu PEDS", " "))
RMenu.Add('menu', 'lister', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Liste Reports", " "))
RMenu.Add('menu', 'gestr', RageUI.CreateSubMenu(RMenu:Get('menu', 'lister'), "Test2", " "))
RMenu.Add('menu', 'time', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Menu Temps", " "))
RMenu:Get('menu', 'main'):SetSubtitle(" ")
RMenu:Get('menu', 'main').EnableMouse = false
RMenu:Get('menu', 'main').Closed = function()

VM.Staff = false
    end
end)

VM = {
    Staff = false,
}

superadmin = nil
local invincible = false
local crossthemap = false
local affichername = false
local afficherblips = false
local Freeze = false
local superJump = false
local fastSprint = false
local infStamina = false
local Frigo = false
local Frigo2 = false
local godmode = true
local fastSwim = false
local blipsStatus = 0
local StaffMod = false
local NoClip = false
local NoClipSpeed = 2.0
local invisible = false
local PlayerInZone = 0
local ShowName = false
local gamerTags = {}
local GetBlips = false
local pBlips = {}
local armor = 0
local InStaff = false
local Spectating = false
local WarnType = {
    "~o~→~s~ Freekill",
    "~o~→~s~ ForceRP",
    "~o~→~s~ HRP-Vocal",
    "~o~→~s~ Conduite-HRP",
    "~o~→~s~ No Fear RP",
    "~o~→~s~ No Pain RP",
    "~o~→~s~ Troll",
    "~o~→~s~ Power Gaming",
    "~o~→~s~ Insultes",
    "~o~→~s~ Non respect du staff",
    "~o~→~s~ Meta Gaming",
    "~o~→~s~ Force RP",
    "~o~→~s~ Free Shoot",
    "~o~→~s~ Free Punch",
    "~o~→~s~ Tire en zone safe",
    "~o~→~s~ Non respect du mass RP",
    "~o~→~s~ Autre... ~o~(Entrer la raison)~s~",
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, true)
end


function GetTargetedVehicle(pCoords, ply)
    for i = 1, 200 do
        coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, (6.281)/i, 0.0)
        targetedVehicle = GetVehicleInDirection(pCoords, coordB)
        if(targetedVehicle ~= nil and targetedVehicle ~= 0)then
            return targetedVehicle
        end
    end
    return
end

function GetVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function ShowMarker()
	local ply = GetPlayerPed(-1)
	local pCoords = GetEntityCoords(ply, true)
    local veh = GetTargetedVehicle(pCoords, ply)
    if veh ~= 0 and GetEntityType(veh) == 2 then
        local coords = GetEntityCoords(veh)
        local x,y,z = table.unpack(coords)
        DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
    end
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

Citizen.CreateThread(function()
    while true do
    	if Admin.showcoords then
            x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
            roundx=tonumber(string.format("%.2f",x))
            roundy=tonumber(string.format("%.2f",y))
            roundz=tonumber(string.format("%.2f",z))
            DrawTxt("~r~X:~s~ "..roundx,0.05,0.00)
            DrawTxt("     ~r~Y:~s~ "..roundy,0.11,0.00)
            DrawTxt("        ~r~Z:~s~ "..roundz,0.17,0.00)
            DrawTxt("             ~r~Angle:~s~ "..GetEntityHeading(PlayerPedId()),0.21,0.00)
        end
        if Admin.showcrosshair then
            DrawTxt('+', 0.495, 0.484, 1.0, 0.3, MainColor)
        end
    	Citizen.Wait(0)
    end
end)

Admin = {
	showcoords = false,
}
MainColor = {
	r = 255, 
	g = 255, 
	b = 255,
	a = 0.68
}

------------------------------------ Color Menu ------------------------------------------

local menuColor = {255, 87, 51 }
Citizen.CreateThread(function()
    Wait(1000)
    menuColor[1] = GetResourceKvpInt("menuR")
    menuColor[2] = GetResourceKvpInt("menuG")
    menuColor[3] = GetResourceKvpInt("menuB")
    ReloadColor()
end)

local AllMenuToChange = nil
function ReloadColor()
    Citizen.CreateThread(function()
        if AllMenuToChange == nil then
            AllMenuToChange = {}
            for Name, Menu in pairs(RMenu['menu']) do
                if Menu.Menu.Sprite.Dictionary == "commonmenu" then
                    table.insert(AllMenuToChange, Name)
                end
            end
        end
        for k,v in pairs(AllMenuToChange) do
            RMenu:Get('menu', v):SetRectangleBanner(255, 87, 51 )
            for name, menu in pairs(RMenu['menu']) do
              RMenu:Get('menu', name).TitleFont = 4
          end
        end
    end)
end

----------------------------------------------------------------------------------

function DrawTxt(text,r,z)
    SetTextColour(MainColor.r, MainColor.g, MainColor.b, 255)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0,0.4)
    SetTextDropshadow(1,0,0,0,255)
    SetTextEdge(1,0,0,0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(r,z)
 end

RegisterNetEvent("admin:Freeze")
AddEventHandler("admin:Freeze",function()

    FreezeEntityPosition(GetPlayerPed(-1), not Freeze)
    Freeze = not Freeze
end)

RegisterNetEvent("admin:tp")
AddEventHandler("admin:tp",function(coords)
    SetEntityCoords(GetPlayerPed(-1),coords)
end)


Citizen.CreateThread(function()

    while true do
      Citizen.Wait(1)

     
      if infStamina then
        RestorePlayerStamina(source, 1.0)
      end

      if superJump then
        SetSuperJumpThisFrame(PlayerId())
	  end
    end
  
  end)

function DrawPlayerInfo(target)
    drawTarget = target
    drawInfo = true
end

function StopDrawPlayerInfo()
    drawInfo = false
    drawTarget = 0
end

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(0)
        if drawInfo then
            local text = {}
            -- cheat checks
            local targetPed = GetPlayerPed(drawTarget)
            
            table.insert(text,"Appuez sur E pour arrêter de spectate")
            
            for i,theText in pairs(text) do
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.30)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString(theText)
                EndTextCommandDisplayText(0.3, 0.7+(i/30))
            end
            
            if IsControlJustPressed(0,103) then
                local targetPed = PlayerPedId()
                local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
    
                RequestCollisionAtCoord(targetx,targety,targetz)
                NetworkSetInSpectatorMode(false, targetPed)
    
                StopDrawPlayerInfo()
                
            end
            
        end
    end
end)

function SpectatePlayer(targetPed,target,name)
    local playerPed = PlayerPedId() -- yourself
    enable = true
    if targetPed == playerPed then enable = false end

    if(enable)then

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(true, targetPed)
        DrawPlayerInfo(target)
        ESX.ShowNotification('~g~Mode spectateur activé')
    else

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(false, targetPed)
        StopDrawPlayerInfo()
        ESX.ShowNotification('~b~Mode spectateur arrêté')
    end
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterNetEvent("CA")
AddEventHandler("CA", function()
  local pos = GetEntityCoords(GetPlayerPed(-1), true)
  ClearAreaOfObjects(pos.x, pos.y, pos.z, 50.0, 0)
end)

function soufle()
    infStamina = not infStamina
      if infStamina then
        Notify("Endurance infinie ~g~activée")
      else
        Notify("Endurance infinie ~r~desactivée")
      end
   end

   function Keyboardput(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function superman()
	superJump = not superJump	  
end

RegisterNetEvent("hAdmin:envoyer")
AddEventHandler("hAdmin:envoyer", function(msg)
	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	local head = RegisterPedheadshot(PlayerPedId())
	while not IsPedheadshotReady(head) or not IsPedheadshotValid(head) do
		Wait(1)
	end
	headshot = GetPedheadshotTxdString(head)
	ESX.ShowAdvancedNotification('Message du Staff', '~r~Informations', '~b~Raison ~w~' ..msg, headshot, 3)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if StaffMod then

            if invisible then
                SetEntityVisible(GetPlayerPed(-1), 0, 0)
                NetworkSetEntityInvisibleToNetwork(pPed, 1)
            else
                SetEntityVisible(GetPlayerPed(-1), 1, 0)
                NetworkSetEntityInvisibleToNetwork(pPed, 0)
			end

            if ShowName then
                local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
                for _, v in pairs(GetActivePlayers()) do
                    local otherPed = GetPlayerPed(v)
                
                    if otherPed ~= pPed then
                        if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
                            gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
                            SetMpGamerTagVisibility(gamerTags[v], 4, 1)
                        else
                            RemoveMpGamerTag(gamerTags[v])
                            gamerTags[v] = nil
                        end
                    end
                end
            else
                for _, v in pairs(GetActivePlayers()) do
                    RemoveMpGamerTag(gamerTags[v])
                end
            end

            for k,v in pairs(GetActivePlayers()) do
                if NetworkIsPlayerTalking(v) then
                    local pPed = GetPlayerPed(v)
                    local pCoords = GetEntityCoords(pPed)
                    DrawMarker(32, pCoords.x, pCoords.y, pCoords.z+1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                end
			end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if GetBlips then
            local players = GetActivePlayers()
            for k,v in pairs(players) do
                local ped = GetPlayerPed(v)
                local blip = AddBlipForEntity(ped)
                table.insert(pBlips, blip)
                SetBlipScale(blip, 0.85)
                if IsPedOnAnyBike(ped) then
                    SetBlipSprite(blip, 226)
                elseif IsPedInAnyHeli(ped) then
                    SetBlipSprite(blip, 422)
                elseif IsPedInAnyPlane(ped) then
                    SetBlipSprite(blip, 307)
                elseif IsPedInAnyVehicle(ped, false) then
                    SetBlipSprite(blip, 523)
                else
                    SetBlipSprite(blip, 1)
                end

                if IsPedInAnyPoliceVehicle(ped) then
                    SetBlipSprite(blip, 56)
                    SetBlipColour(blip, 3)
                end
                SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
			end
		else
			for k,v in pairs(pBlips) do
                RemoveBlip(v)
            end
        end
    end
end)

local ServersIdSession = {}

Citizen.CreateThread(function()
    while true do
        Wait(500)
        for k,v in pairs(GetActivePlayers()) do
            local found = false
            for _,j in pairs(ServersIdSession) do
                if GetPlayerServerId(v) == j then
                    found = true
                end
            end
            if not found then
                table.insert(ServersIdSession, GetPlayerServerId(v))
            end
        end
    end
end)

function openStaffMenu()
    if VM.Staff then
        VM.Staff = false
    else
		VM.Staff = true
        RageUI.Visible(RMenu:Get('menu', 'main'), true)

        Citizen.CreateThread(function()
			while VM.Staff do
				RageUI.IsVisible(RMenu:Get('menu', 'main'), true, true, true, function()
					RageUI.Checkbox("Activer le mode modération", "", InStaff, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
						InStaff = Checked;
						if Selected then
							if Checked then
								notifdezub()					
								InStaff = true
								StaffMod = true
							else
							if nombrecheck == 1 then 
								nombrecheck = nombrecheck - 1
								end
								InStaff = false
								StaffMod = false
								FreezeEntityPosition(GetPlayerPed(-1), false)
								NoClip = false
				
								SetEntityVisible(GetPlayerPed(-1), 1, 0)
								NetworkSetEntityInvisibleToNetwork(GetPlayerPed(-1), 0)
								SetEntityCollision(GetPlayerPed(-1), 1, 1)
				
								for _, v in pairs(GetActivePlayers()) do
									RemoveMpGamerTag(gamerTags[v])
								end
								-- Go Webhook Inactive
							end
						end
					end)

----------------------------------------------------------------- TENUE STAFF ----------------------------------------------------------------------------

					if model == GetHashKey("mp_m_freemode_01") then
					tenuesuperadmin() end     

					function tenuesuperadmin() 
						TriggerEvent('skinchanger:getSkin', function()
							local couleur = math.random(0,9)
							if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
								TriggerEvent('skinchanger:loadSkin', {
									['sex'] = 0, 
									['bags_1'] = 0, ['bags_2'] = 0,  
									['tshirt_1'] = 15, ['tshirt_2'] = 2, 
									['torso_1'] = 178, ['torso_2'] = couleur,
									['arms'] = 31,
									['pants_1'] = 77, ['pants_2'] = couleur,
									['shoes_1'] = 55, ['shoes_2'] = couleur,
									['mask_1'] = 0, ['mask_2'] = 0,
									['bproof_1'] = 0,
									['chain_1'] = 0,
									['helmet_1'] = 91, ['helmet_2'] = couleur,
								})
						
							end
						end) 
					end 
									   
--------------------------------------------------------------------------------------------------------------------------------------------------------
						
					if InStaff then
						RageUI.Button("~o~→~s~ Actions ~o~personnelles", "", { RightLabel = "~o~→→" },true, function()
						end, RMenu:Get('menu', 'perso'))
						RageUI.Button("~o~→~s~ Actions ~o~staff", "", { RightLabel = "~o~→→" },true, function()
						end, RMenu:Get('menu', 'actionstaff'))
						RageUI.Button("~o~→~s~ Gestions ~o~véhicules", "", { RightLabel = "~o~→→" },true, function()
						end, RMenu:Get('menu', 'veh'))
						RageUI.Button("~o~→~s~ Liste des ~o~joueurs", "", { RightLabel = "~o~→→" },true, function()
						end, RMenu:Get('menu', 'joueurs'))
						RageUI.Button("~o~→~s~ Options ~o~Hors-Roleplay", "", { RightLabel = "~o~→→" },true, function()
						end, RMenu:Get('menu', 'world'))
						RageUI.Button("~o~→~s~ Gestion ~o~temps", "", { RightLabel = "~o~→→" },true, function()
						end, RMenu:Get('menu', 'time'))
						RageUI.Button("~o~→~s~ Menu ~o~Peds", "", { RightLabel = "~o~→→" },true, function()
						end, RMenu:Get('menu', 'ped'))
						RageUI.Button("~o~→~s~ Menu ~o~Warns", "", { RightLabel = "~o~→→" },true, function()
						end, RMenu:Get('menu', 'warn')) 
						RageUI.Button("~r~→~s~ Gestions ~r~Reports", "", { RightLabel = "~r~→→" },true, function()
						end, RMenu:Get('menu', 'lister')) 
					end
				end, function()
				end, 1)
		
				
				RageUI.IsVisible(RMenu:Get('menu', 'perso'), true, true, true, function()

					RageUI.Separator(" ↓ ~o~ Gestion Gives ~s~↓ ", nil, {}, true, function(Hovered, Active, Selected)
					end)

					RageUI.Button("~o~→~s~ S'octroyer du Heal",description, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetEntityHealth(GetPlayerPed(-1), 200)
							Notify("~o~→~s~ ~g~Heal effectué~w~")
						end
					end)

					RageUI.Button("~o~→~s~ S'octroyer du Blindage",description, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetPedArmour(GetPlayerPed(-1), 200)
							Notify("~o~→~s~ ~b~Blindage effectué~w~")
						end
					end)

					RageUI.Button("~o~→~s~ S'octroyer de l'argent liquide",description, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							GiveCash()
							Notify("~b~Give cash effectué~w~")
						end
					end)

					RageUI.Button("~o~→~s~ S'octroyer de l'argent en banque",description, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							GiveBanque()
							Notify("~b~Give banque effectué~w~")
						end
					end)

					RageUI.Button("~o~→~s~ S'octroyer de l'argent sale",description, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							GiveND()
							Notify("~b~Give argent sale effectué~w~")
						end
					end)

					RageUI.Separator(" ↓ ~o~Gestions Mouvements~s~ ↓ ", nil, {}, true, function(Hovered, Active, Selected)
					end)

					RageUI.Button("~o~→~s~ Afficher/Cacher ses coordonnées",description, {}, true, function(Hovered, Active, Selected)
						if (Selected) then   
							Admin.showcoords = not Admin.showcoords    
							end   
						end)

					RageUI.Button("~o~→~s~ Se téléporter sur son marqueur", nil, {
					}, true, function(_, _, Selected)
					if Selected then
						local playerPed = GetPlayerPed(-1)
						local WaypointHandle = GetFirstBlipInfoId(8)
						if DoesBlipExist(WaypointHandle) then
							local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
							--SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, coord.z, false, false, false, true)
							SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.9, false, false, false, true)
		
						end
					end
					end)

					RageUI.Checkbox("~o~→~s~ Noclip", nil, crossthemap,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							crossthemap = Checked
							if Checked then
								news_no_clip()
							else
								news_no_clip()
							end
						end
					end)

					RageUI.Checkbox("~o~→~s~ Nage rapide", description, fastSwim,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							fastSwim = Checked
							if Checked then
								SetSwimMultiplierForPlayer(PlayerId(), 1.49)
							else
								SetSwimMultiplierForPlayer(PlayerId(), 1.0)
							end
						end
					end)

					RageUI.Checkbox("~o~→~s~ Super Sprint", description, fastSprint,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							fastSprint = Checked
							if Checked then
								SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
							else
								SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
							end
						end
					end)
					
				end, function()
				end)
		
				RageUI.IsVisible(RMenu:Get('menu', 'joueurs'), true, true, true, function()
					for k,v in ipairs(ServersIdSession) do
						if GetPlayerName(GetPlayerFromServerId(v)) == "**Invalid**" then table.remove(ServersIdSession, k) end
						RageUI.Button(v.." : " ..GetPlayerName(GetPlayerFromServerId(v)), nil, {}, true, function(Hovered, Active, Selected)
							if (Selected) then
								IdSelected = v
							end
						end, RMenu:Get('menu', 'options'))
					end
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'actionstaff'), true, true, true, function()

					RageUI.Separator("↓ ~o~Gestion Modération ~s~↓", nil, {}, true, function(_, _, _)
					end)

				RageUI.Button("~o~→~s~ Kick une personne", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local quelid = Keyboardput("ID du joueur", "", 3)
						local reason = Keyboardput("Raison du kick", "", 100)
						ExecuteCommand("kick "..quelid.. "" ..reason)
						if quelid and reason then
							ExecuteCommand("kick "..quelid.. " " ..reason)
							ESX.ShowNotification("Vous venez de kick l\'ID :"..quelid.. " pour la raison suivante : " ..reason)
						else
							RageUI.CloseAll()	
						end	
					end
				end)

				RageUI.Button("~o~→~s~ Bannir une personne", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local quelid = Keyboardput("ID du joueur", "", 3)
						local day = Keyboardput("Jours", "", 100)
						local raison = Keyboardput("Raison du kick", "", 100)
						if quelid and day and raison then
							ExecuteCommand("sqlban "..quelid.. " " ..day.. " " ..raison)
							ESX.ShowNotification("Vous venez de ban l\'ID :"..quelid.. " " ..day.. " pour la raison suivante : " ..raison)
						else
							RageUI.CloseAll()	
						end
					end
				end)

				RageUI.Button("~o~→~s~ Débannir une personne", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local name = Keyboardput("Nom Steam", "", 100)
						if name then
							ExecuteCommand("sqlunban "..name)
							ESX.ShowNotification("Vous venez de déban : "..name)
						else
							RageUI.CloseAll()	
						end
					end
				end)

					RageUI.Separator("↓ ~o~Intéraction sur un joueur  ~s~↓", nil, {}, true, function(_, _, _)
					end)
					
					RageUI.Button("~o~→~s~ Envoyer~s~ un message à un joueur", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local quelid = Keyboardput("ID", "", 100)
							local msg = Keyboardput("Raison", "", 100)

							if msg ~= nil then
								msg = tostring(msg)
						
								if type(msg) == 'string' then
									TriggerServerEvent("hAdmin:Message", quelid, msg)
									RageUI.CloseAll()
								end
							end
							ESX.ShowNotification("Vous venez d'envoyer le message à  l'ID : ~b~ " ..quelid)
						end
					end)
					RageUI.Button("~o~→~s~ Se téléporter sur un joueur", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local quelid = Keyboardput("ID", "", 100)
							ExecuteCommand("goto "..quelid)
							ESX.ShowNotification("~b~Vous venez de vous téléporter à l\'ID : ~b~ " ..quelid)
						end
					end)
					RageUI.Button("~o~→~s~ Téléporter un joueur à vous", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected, target)
						if (Selected) then
							local quelid = Keyboardput("ID", "", 100)
							ExecuteCommand("bring "..quelid)
							ESX.ShowNotification("~o~Vous venez de téléporter l\'ID :~s~ " ..quelid.. " ~b~à vous~s~ !")
						end
					end)
					if superadmin then
						RageUI.Button("~o~→~s~ Attribuer un job~s~ à une personne", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local quelid = Keyboardput("ID", "", 10)
								local job = Keyboardput("Job", "", 10)
								local grade = Keyboardput("Grade", "", 10)
								if job and grade and quelid then
									ExecuteCommand("setjob "..quelid.. " " ..job.. " " ..grade)
									ESX.ShowNotification("Vous venez de setjob ~g~"..job.. " " .. grade .. " l\'ID : " ..quelid)
								else
									RageUI.CloseAll()	
								end	
							end
						end)
					end

					RageUI.Separator("↓ ~o~Intéraction give sur un joueur  ~s~↓", nil, {}, true, function(_, _, _)
					end)

					RageUI.Button("~o~→~s~ Octroyer du heal~s~ une personne", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local quelid = Keyboardput("ID", "", 3)
							if quelid then
								ExecuteCommand("heal "..quelid)
								Notify("~g~Heal de l'ID "..quelid.." effectué~w~")
							else
								RageUI.CloseAll()	
							end
						end
					end)

					RageUI.Button("~o~→~s~ Revive~s~ une personne",description, {}, true, function(Hovered, Active, Selected)
						if (Selected) then   
							local previve = Keyboardput('ID du Joueur', '', 3)
							ExecuteCommand('revive', previve)
							end      
						end)

					RageUI.Button("~o~→~s~ Give un item à un joueur", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local quelid = Keyboardput("ID", "", 3)
							local item = Keyboardput("Item", "", 10)
							local amount = Keyboardput("Nombre", "", 10)
							if item and quelid and amount then
								ExecuteCommand("giveitem "..quelid.. " " ..item.. " " ..amount)
								ESX.ShowNotification("Vous venez de donner ~g~"..amount.. " " .. item .. " ~w~à l'ID :" ..quelid)	
							else
								RageUI.CloseAll()	
							end			
						end
					end)

					if superadmin then
						RageUI.Button("~o~→~s~ Give une arme à un joueur", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local quelid = Keyboardput("ID du joueur", "", 3)
								local weapon = Keyboardput("WEAPON_...", "", 50)
								local ammo = Keyboardput("Munitions", "", 100)
								if weapon and ammo and quelid then
									ExecuteCommand("giveweapon "..quelid.. " " ..weapon.. " " ..ammo)
									ESX.ShowNotification("Vous venez de donner ~g~"..weapon.. " avec " .. ammo .. " munitions ~w~à l'ID :" ..quelid)
								else
									RageUI.CloseAll()	
								end
							end
						end)

						RageUI.Separator("↓ ~o~Intéraction Chat  ~s~↓", nil, {}, true, function(_, _, _)
						end)
	
						RageUI.Button("~o~→~s~ Vider le Chat", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
							ExecuteCommand("clear")
							end
						end)
						
						RageUI.Button("~o~→~s~ Faire une Annonce", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local msg = Keyboardput("Message d'annonce", "", 600)
								ExecuteCommand("alert "..msg)
	
								if msg ~= nil then
									msg = tostring(msg)
	
									if type(msg) == 'string' then
										TriggerServerEvent("hAdmin:Message", msg)
										RageUI.CloseAll()
									end
								end
							end
						end)
						
				    end
				end, function()
				end)
		
				RageUI.IsVisible(RMenu:Get('menu', 'options'), true, true, true, function()

					RageUI.Separator(GetPlayerName(GetPlayerFromServerId(IdSelected)))

					RageUI.Separator("↓ ~o~Actions possibles sur le joueurs ~s~↓", nil, {}, true, function(_, _, _)
					end)

					RageUI.Button("~o~→~s~ Envoyer un message au joueur", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local msg = Keyboardput("Raison", "", 100)

							if msg ~= nil then
								msg = tostring(msg)
						
								if type(msg) == 'string' then
									TriggerServerEvent("hAdmin:Message", IdSelected, msg)
									RageUI.CloseAll()
								end
							end
							ESX.ShowNotification("Vous venez d'envoyer le message à ~b~" .. GetPlayerName(GetPlayerFromServerId(IdSelected)))
						end
					end)

					if superadmin then
						RageUI.Button("~o~→~s~ Setjob le joueur", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local job = Keyboardput("Job", "", 10)
								local grade = Keyboardput("Grade", "", 10)
								if job and grade then
									ExecuteCommand("setjob "..IdSelected.. " " ..job.. " " ..grade)
									ESX.ShowNotification("Vous venez de setjob ~b~"..job.. " " .. grade .. " " .. GetPlayerName(GetPlayerFromServerId(IdSelected)))
								else
									RageUI.CloseAll()	
								end	
							end
						end)
					end

					RageUI.Button("~o~→~s~ Se téléporter sur le joueur", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected))))
							ESX.ShowNotification('~b~Vous venez de vous Téléporter à~s~ '.. GetPlayerName(GetPlayerFromServerId(IdSelected)) ..'')
						end
					end)

					RageUI.Button("~o~→~s~ Le téléporter à vous", nil, {}, true, function(Hovered, Active, Selected, target)
						if (Selected) then
							ExecuteCommand("bring "..IdSelected)
							ESX.ShowNotification('~b~Vous venez de Téléporter ~s~ '.. GetPlayerName(GetPlayerFromServerId(IdSelected)) ..' ~b~à vous~s~ !')
						end
					end)

					RageUI.Button("~o~→~s~ Regarder le joueur", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
						local playerId = GetPlayerFromServerId(IdSelected)
                            SpectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
						end
					end)

					RageUI.Checkbox("~o~→~s~ Freeze/Un-freeze le joueur", description, Frigo,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							Frigo = Checked
							if Checked then
								ESX.ShowNotification("~r~Joueur Freeze ("..GetPlayerName(GetPlayerFromServerId(IdSelected))..")")
								TriggerEvent("admin:Freeze", IdSelected)
							else
								ESX.ShowNotification("~o~Joueur Unfreeze ("..GetPlayerName(GetPlayerFromServerId(IdSelected))..")")
								TriggerEvent("admin:Freeze", IdSelected)
							end
						end
					end)

					RageUI.Separator("↓ ~o~Gestion Gives sur le joueur ~s~↓", nil, {}, true, function(_, _, _)
					end)

					RageUI.Button("~o~→~s~ Heal le joueur", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("heal "..IdSelected)
							Notify("~g~Heal de ".. GetPlayerName(GetPlayerFromServerId(IdSelected)) .." effectué~w~")
						end
					end)

					if superadmin then
						RageUI.Button("~o~→~s~ Wipe l'inventaire~s~ du joueur", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								ExecuteCommand("clearinventory "..IdSelected)
								ESX.ShowNotification("Vous venez d'enlever tout les items de ~b~".. GetPlayerName(GetPlayerFromServerId(IdSelected)) .."~s~ !")
							end
						end)
					end

					if superadmin then
						RageUI.Button("~o~→~s~ Wipe les armes~s~ du joueur", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								ExecuteCommand("clearloadout "..IdSelected)
								ESX.ShowNotification("Vous venez de enlever toutes les armes de ~b~".. GetPlayerName(GetPlayerFromServerId(IdSelected)) .."~s~ !")
							end
						end)
					end

					RageUI.Button("~o~→~s~ Give un item~s~ au joueur", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local item = Keyboardput("Item", "", 10)
							local amount = Keyboardput("Nombre", "", 10)
							if item and amount then
								ExecuteCommand("giveitem "..IdSelected.. " " ..item.. " " ..amount)
								ESX.ShowNotification("Vous venez de donner ~b~"..amount.. " " .. item .. " ~w~à " .. GetPlayerName(GetPlayerFromServerId(IdSelected)))	
							else
								RageUI.CloseAll()	
							end			
						end
					end)

					if superadmin then
						RageUI.Button("~o~→~s~ Give une arme~s~ au joueur", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local weapon = Keyboardput("WEAPON_...", "", 100)
								local ammo = Keyboardput("Munitions", "", 100)
								if weapon and ammo then
									ExecuteCommand("giveweapon "..IdSelected.. " " ..weapon.. " " ..ammo)
									ESX.ShowNotification("Vous venez de donner ~b~"..weapon.. " avec " .. ammo .. " munitions ~w~à " .. GetPlayerName(GetPlayerFromServerId(IdSelected)))
								else
									RageUI.CloseAll()	
								end
							end
						end)

				    end
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'warn'), true, true, true, function()
					for k,v in ipairs(ServersIdSession) do
						if GetPlayerName(GetPlayerFromServerId(v)) == "**Invalid**" then table.remove(ServersIdSession, k) end
						RageUI.Button("["..v.."] - "..GetPlayerName(GetPlayerFromServerId(v)), nil, {}, true, function(Hovered, Active, Selected)
							if (Selected) then
								IdSelected = v
							end
						end, RMenu:Get('menu', 'sanction'))
					end
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'sanction'), true, true, true, function()
					RageUI.Separator("~o~ID~s~ ~o~[~s~ ~b~"..IdSelected.."~s~ ~o~]~s~", nil, {}, true, function(Hovered, Active, Selected)
					end)

					RageUI.Separator("~o~Joueur~s~ "..GetPlayerName(GetPlayerFromServerId(IdSelected)), nil, {}, true, function(Hovered, Active, Selected)
					end)

					RageUI.Separator(" ~r~(3 Warn = Ban)~s~ ", nil, {}, true, function(Hovered, Active, Selected)
					end)

					RageUI.Separator(" ↓ ~o~Raison du warn ~s~↓ ", nil, {}, true, function(Hovered, Active, Selected)
					end)
		
					for k,v in pairs(WarnType) do
						RageUI.Button(""..v, nil, {}, true, function(Hovered, Active, Selected)
							if Selected then
								if v == "Autre...(Entrer la raison)" then
									AddTextEntry("Entrer la raison", "")
									DisplayOnscreenKeyboard(1, "Entrer la raison", '', "", '', '', '', 128)
								
									while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
										Citizen.Wait(0)
									end
								
									if UpdateOnscreenKeyboard() ~= 2 then
										raison = GetOnscreenKeyboardResult()
										Citizen.Wait(1)
									else
										Citizen.Wait(1)
									end
									TriggerServerEvent("STAFFMOD:RegisterWarn", IdSelected, raison)
								else
									TriggerServerEvent("STAFFMOD:RegisterWarn", IdSelected, v)
								end
							end
						end)
					end
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'veh'), true, true, true, function()

					RageUI.Button("~o~→~s~ Give un véhicule~s~ ~o~(avec clé)", nil, {}, true, function(_, _, Selected)
					if Selected then
		
						local ped = GetPlayerPed(tgt)
						local ModelName = Keyboardput("Véhicule", "", 100)
		
						if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
							RequestModel(ModelName)
							while not HasModelLoaded(ModelName) do
								Citizen.Wait(0)
							end
								--local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)), true, true)
								TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
								give_vehi(ModelName)
								Wait(50)
						else
							ShowNotification("Erreur !")
						end
					end
					end)

					RageUI.Button("~o~→~s~ Faire apparaître un véhicule", nil, {}
					, true, function(_, _, Selected)
					if Selected then
		
						local ped = GetPlayerPed(tgt)
						local ModelName = Keyboardput("Véhicule", "", 100)
		
						if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
							RequestModel(ModelName)
							while not HasModelLoaded(ModelName) do
								Citizen.Wait(0)
							end
								local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)), true, true)
								TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
								Wait(50)
						else
							ShowNotification("Erreur !")
						end
					end
					end)

					RageUI.Button("~o~→~s~ Réparer le véhicule", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
					SetVehicleFixed(plyVeh)
					SetVehicleDirtLevel(plyVeh, 0.0) 
						end   
					end)   
					
					RageUI.Button("~o~→~s~ Custom~s~ au maximum", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						FullVehicleBoost()
						end   
					end) 

					RageUI.Button("~o~→~s~ Changer la plaque~s~ du véhicule", nil, {}, true, function(_, Active, Selected)
					if Selected then
						if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
							local plaqueVehicule = Keyboardput("Plaque", "", 8)
							SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , plaqueVehicule)
							ESX.ShowNotification("La plaque du véhicule est désormais : ~g~"..plaqueVehicule)
						else
							ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
						end
					end
					end)

					RageUI.Button("~o~→~s~ Mettre en fourrière~s~ le véhicule", nil, {}, true, function(_, Active, Selected)
					if Active then
						ShowMarker()
					end
					if Selected then
						TriggerEvent("esx:deleteVehicle")
					end
					end)

					RageUI.Button("~o~→~s~ Changer la couleur~s~ du véhicule", nil, {RightLabel = ""},true, function()
					end, RMenu:Get('menu', 'customcolor'))

				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'customcolor'), true, true, true, function()
					RageUI.Button("~o~→~s~ Bleu", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
						SetVehicleCustomPrimaryColour(vehicle, 0, 0, 255)
						SetVehicleCustomSecondaryColour(vehicle, 0, 0, 255)
						end      
					end)
					RageUI.Button("~o~→~s~ Rouge", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
						SetVehicleCustomPrimaryColour(vehicle, 255, 0, 0)
						SetVehicleCustomSecondaryColour(vehicle, 255, 0, 0)
						end      
					end)
					RageUI.Button("~o~→~s~ Vert", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
						SetVehicleCustomPrimaryColour(vehicle, 0, 255, 0)
						SetVehicleCustomSecondaryColour(vehicle, 0, 255, 0)
						end      
					end)
					RageUI.Button("~o~→~s~ Noir", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
						SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
						SetVehicleCustomSecondaryColour(vehicle, 0, 0, 0)
						end      
					end)
					RageUI.Button("~o~→~s~ Rose", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
						SetVehicleCustomPrimaryColour(vehicle, 100, 0, 60)
						SetVehicleCustomSecondaryColour(vehicle, 100, 0, 60)
						end      
					end)
					RageUI.Button("~o~→~s~ Blanc", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
						SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)
						SetVehicleCustomSecondaryColour(vehicle, 255, 255, 255)
						end      
					end)
				 
			   end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'ped'), true, true, true, function()

					RageUI.Separator("↓ ~o~Sélections Manuelles ~s~ ↓")

					RageUI.Button("~o~→~s~ Reprendre~s~ son personnage", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
							local isMale = skin.sex == 0
		
		
							TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
								ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
									TriggerEvent('skinchanger:loadSkin', skin)
									TriggerEvent('esx:restoreLoadout')
							end)
							end)
							end)
					end
					end)

					RageUI.Button("~o~→~s~ Entrer un ped custom", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local j1 = PlayerId()
						local newped = Keyboardput('Entrer le nom de votre Ped', '', 45)
						local p1 = GetHashKey(newped)
						RequestModel(p1)
						while not HasModelLoaded(p1) do
						  Wait(100)
						 end
						 SetPlayerModel(j1, p1)
						 SetModelAsNoLongerNeeded(p1)
						end      
					end)

					RageUI.Separator("↓ ~o~Sélections rapides ~s~ ↓")
				
					RageUI.Button("~o~→~s~ Devenir un Gangster Mexicain", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local j1 = PlayerId()
						local p1 = GetHashKey('csb_ramp_mex')
						RequestModel(p1)
						while not HasModelLoaded(p1) do
							Wait(100)
							end
							SetPlayerModel(j1, p1)
							SetModelAsNoLongerNeeded(p1)
						end      
					end)

					RageUI.Button("~o~→~s~ Devenir un OG des Ballas", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local j1 = PlayerId()
						local p1 = GetHashKey('g_m_y_ballaorig_01')
						RequestModel(p1)
						while not HasModelLoaded(p1) do
							Wait(100)
							end
							SetPlayerModel(j1, p1)
							SetModelAsNoLongerNeeded(p1)
						end      
					end)

					RageUI.Button("~o~→~s~ Devenir un Prisonnier", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local j1 = PlayerId()
						local p1 = GetHashKey('s_m_y_prismuscl_01')
						RequestModel(p1)
						while not HasModelLoaded(p1) do
							Wait(100)
							end
							SetPlayerModel(j1, p1)
							SetModelAsNoLongerNeeded(p1)
						end      
					end)

					 RageUI.Button("~o~→~s~ Devenir un Simple Civil", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local j1 = PlayerId()
						local p1 = GetHashKey('a_m_y_stwhi_02')
						RequestModel(p1)
						while not HasModelLoaded(p1) do
							Wait(100)
							end
							SetPlayerModel(j1, p1)
							SetModelAsNoLongerNeeded(p1)
						end      
					end)

					 RageUI.Button("~o~→~s~ Devenir un Shériff", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local j1 = PlayerId()
						local p1 = GetHashKey('s_m_y_ranger_01')
						RequestModel(p1)
						while not HasModelLoaded(p1) do
						  Wait(100)
						 end
						 SetPlayerModel(j1, p1)
						 SetModelAsNoLongerNeeded(p1)
						end      
					end)

					 RageUI.Button("~o~→~s~ Devenir un agent du FBI", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local j1 = PlayerId()
						local p1 = GetHashKey('s_m_m_ciasec_01')
						RequestModel(p1)
						while not HasModelLoaded(p1) do
						  Wait(100)
						 end
						 SetPlayerModel(j1, p1)
						 SetModelAsNoLongerNeeded(p1)
						end      
					end)

					 RageUI.Button("~o~→~s~ Devenir un O'Neil", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then   
						local j1 = PlayerId()
						local p1 = GetHashKey('ig_old_man2')
						RequestModel(p1)
						while not HasModelLoaded(p1) do
						  Wait(100)
						 end
						 SetPlayerModel(j1, p1)
						 SetModelAsNoLongerNeeded(p1)
						end      
					end)

				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'time'), true, true, true, function()

					RageUI.Separator("↓ ~o~Sélections de Temps Personalisées ~s~ ↓")

					RageUI.Button("~o~→~s~ Choisir une heure", "Format → heures (espace) minutes", {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
						local heure = Keyboardput('Entrer l\'heure que vous souhaiter', '', 45)
							ExecuteCommand("time "..heure)
						end
					end)

					RageUI.Button("~o~→~s~ Bloquer le temps", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("freezetime")
						end
					end)

					RageUI.Separator("↓ ~o~Sélection de Temps Pré-sets  ~s~ ↓")
			
					RageUI.Button("~o~→~s~ Soleil plein", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("weather EXTRASUNNY")
						end
					end)

					RageUI.Button("~o~→~s~ Temps dégagé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("weather CLEAR")
						end
					end)

					RageUI.Button("~o~→~s~ Temps neutre", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						  if (Selected) then
							ExecuteCommand("weather NEUTRAL")
						  end
					  end)

					RageUI.Button("~o~→~s~ Temps halloween", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("weather HALLOWEEN")
						end
					end)

					RageUI.Button("~o~→~s~ Temps de neige", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("weather XMAS")
						end
					end)


					RageUI.Button("~o~→~s~ Temps de pluit", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("weather RAIN")
						end
					end)

					RageUI.Button("~o~→~s~ Temps nuageux", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("weather CLOUDS")
						end
					end)
			  
			 end, function()
			  end)

				RageUI.IsVisible(RMenu:Get('menu', 'lister'), true, true, true, function()
			
					for numreport = 1, #reportlistesql, 1 do
					  RageUI.Button("[Joueur : "..reportlistesql[numreport].reporteur.."~s~] - "..reportlistesql[numreport].type, "Numéro : "..reportlistesql[numreport].id, { RightLabel = label or couscous }, true, function(Hovered, Active, Selected)
						  if (Selected) then
							  typereport = reportlistesql[numreport].type
							  sonid = reportlistesql[numreport].sonid
							  reportjoueur = reportlistesql[numreport].reporteur
							  raisonreport = reportlistesql[numreport].raison
							  joueurreporter = reportlistesql[numreport].nomreporter
							  supprimer = reportlistesql[numreport].id
						  end
					  end, RMenu:Get('menu', 'gestr'))
				  end
			  
			 end, function()
			  end)
			  
		  RageUI.IsVisible(RMenu:Get('menu', 'gestr'), true, true, true, function()

			RageUI.Separator("~o~ Report effectué par~s~ : ".. reportjoueur)

			RageUI.Separator("~o~ ID du joueur ~s~: " ..sonid)

			RageUI.Separator("~r~ Type de report~s~ : ".. typereport)
  
			RageUI.Separator("~r~ Joueur qui est reporté~s~ : ".. joueurreporter)

			RageUI.Separator("~r~ Raison du report~s~ : ".. raisonreport)

			RageUI.Button("~o~→~s~ Se téléporter~s~ au joueur", nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					ExecuteCommand("goto "..sonid)
				end
			end)

			RageUI.Button("~o~→~s~ Le téléporter~s~ vers soi", nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					ExecuteCommand("bring "..sonid)
				end
			end)

			RageUI.Button("~o~→~s~ Spectate~s~ le joueur", nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					ExecuteCommand("spect "..sonid)
				end
			end)

			RageUI.Checkbox("~o~→~s~ Freeze/Unfreeze~s~ le joueur", description, Frigo,{},function(Hovered,Ative,Selected,Checked)
				if Selected then
					Frigo = Checked
					if Checked then
						ExecuteCommand("freeze "..sonid)
						ESX.ShowNotification("~r~Joueur Freeze")
					else
						ExecuteCommand("freeze "..sonid)
						ESX.ShowNotification("~o~Joueur Defreeze")
					end
				end
			end)

			RageUI.Button("~r~→~s~ Supprimer le report", nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					TriggerServerEvent('h4ci_report:supprimereport', supprimer)
					ESX.ShowNotification("~o~Le report de ~s~".. reportjoueur .. " ~o~a bien été supprimé, pensez à relancer le menu")
				end
			end)
			  
	  
			 end, function()
			  end)

				RageUI.IsVisible(RMenu:Get('menu', 'world'), true, true, true, function()
					
					RageUI.Checkbox("~o~→~s~ Afficher~s~ les Noms", description, affichername,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							affichername = Checked
							if Checked then
								ShowName = true
							else
								ShowName = false
							end
						end
					end)

					RageUI.Checkbox("~o~→~s~ Afficher les Blips", description, afficherblips,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							afficherblips = Checked
							if Checked then
								GetBlips = true
							else
								GetBlips = false
							end
						end
					end)

					RageUI.Button("~o~→~s~ Devenir~s~ Invincible", nil, {RightLabel = "~o~On~s~ | ~r~Off~s~"}, true, function(Hovered, Active, Selected)
						if (Selected) then       
					   -- SetEntityVisible(PlayerPedId(), false, false)
					   Admin.godmode = not Admin.godmode
		
						if Admin.godmode then
						SetEntityInvincible(PlayerPedId(), true)
						ESX.ShowNotification('Invicible ~g~ON')
						else
						SetEntityInvincible(PlayerPedId(), false)
						ESX.ShowNotification('Invicible ~r~OFF')
						end
						
						end
					end)


				end, function()
				end)
				Wait(0)
			end
		end)
	end
end

TriggerEvent('chat:addSuggestion', '/report', 'Faire un appel staff', {
    { name="Raison", help="Merci de détailler votre demande" },
})

RegisterCommand("spect", function(source, args, rawCommand) 
  ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
  playergroup = group
  if playergroup == 'superadmin' or playergroup == 'owner' then
  idnum = tonumber(args[1])
  local playerId = GetPlayerFromServerId(idnum)
  SpectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
  else
    ESX.ShowNotification("Vous n'avez pas accès à cette commande")
  end
end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
				if IsControlJustPressed(0, 82) then
					ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
						playergroup = group
						if playergroup == 'superadmin' or playergroup == 'owner' then
							superadmin = true
							openStaffMenu()
							ESX.TriggerServerCallback('h4ci_report:affichereport', function(keys)
								reportlistesql = keys
								end)
						elseif playergroup == 'dev' or playergroup == 'mod' or playergroup == 'admin' then
							superadmin = false
							openStaffMenu()
						end
					end)
			end
		end
	end)

function GetPlayers()
	local players = {}

	for _, i in ipairs(GetActivePlayers()) do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end

function GiveCash()
	local amount = Keyboardput("Combien?", "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('vAdmin:GiveCash', amount)
		end
	end
end


function GiveBanque()
	local amount = Keyboardput("Combien?", "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('vAdmin:GiveBanque', amount)
		end
	end
end


function GiveND()
	local amount = Keyboardput("Combien?", "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('vAdmin:GiveND', amount)
		end
	end
end

function admin_heal_player()
	local plyId = Keyboardput1("N_BOX_ID", "", "", 8)
	if plyId ~= nil then
		plyId = tonumber(plyId)
		if type(plyId) == 'number' then
			TriggerServerEvent('esx_ambulancejob:revive', plyId)
		end
	end
end

function FullVehicleBoost()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
		SetVehicleModKit(vehicle, 0)
		SetVehicleMod(vehicle, 14, 0, true)
		SetVehicleNumberPlateTextIndex(vehicle, 5)
		ToggleVehicleMod(vehicle, 18, true)
		SetVehicleColours(vehicle, 0, 0)
		SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
		SetVehicleModColor_2(vehicle, 5, 0)
		SetVehicleExtraColours(vehicle, 111, 111)
		SetVehicleWindowTint(vehicle, 2)
		ToggleVehicleMod(vehicle, 22, true)
		SetVehicleMod(vehicle, 23, 11, false)
		SetVehicleMod(vehicle, 24, 11, false)
		SetVehicleWheelType(vehicle, 12) 
		SetVehicleWindowTint(vehicle, 3)
		ToggleVehicleMod(vehicle, 20, true)
		SetVehicleTyreSmokeColor(vehicle, 0, 0, 0)
		LowerConvertibleRoof(vehicle, true)
		SetVehicleIsStolen(vehicle, false)
		SetVehicleIsWanted(vehicle, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetCanResprayVehicle(vehicle, true)
		SetPlayersLastVehicle(vehicle)
		SetVehicleFixed(vehicle)
		SetVehicleDeformationFixed(vehicle)
		SetVehicleTyresCanBurst(vehicle, false)
		SetVehicleWheelsCanBreak(vehicle, false)
		SetVehicleCanBeTargetted(vehicle, false)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
		SetVehicleHasStrongAxles(vehicle, true)
		SetVehicleDirtLevel(vehicle, 0)
		SetVehicleCanBeVisiblyDamaged(vehicle, false)
		IsVehicleDriveable(vehicle, true)
		SetVehicleEngineOn(vehicle, true, true)
		SetVehicleStrong(vehicle, true)
		RollDownWindow(vehicle, 0)
		RollDownWindow(vehicle, 1)
		SetVehicleNeonLightEnabled(vehicle, 0, true)
		SetVehicleNeonLightEnabled(vehicle, 1, true)
		SetVehicleNeonLightEnabled(vehicle, 2, true)
		SetVehicleNeonLightEnabled(vehicle, 3, true)
		SetVehicleNeonLightsColour(vehicle, 0, 0, 255)
		SetPedCanBeDraggedOut(PlayerPedId(), false)
		SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
		SetPedRagdollOnCollision(PlayerPedId(), false)
		ResetPedVisibleDamage(PlayerPedId())
		ClearPedDecorations(PlayerPedId())
		SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
		for i = 0,14 do
			SetVehicleExtra(veh, i, 0)
		end
		SetVehicleModKit(veh, 0)
		for i = 0,49 do
			local custom = GetNumVehicleMods(veh, i)
			for j = 1,custom do
				SetVehicleMod(veh, i, math.random(1,j), 1)
			end
		end
	end
end

RegisterNetEvent("STAFFMOD:RegisterWarn")
AddEventHandler("STAFFMOD:RegisterWarn", function(reason)
	SetAudioFlag("LoadMPData", 1)
	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	ShowFreemodeMessage("WARNED", "Tu à été warn pour: "..reason, 5)
end)

function ShowFreemodeMessage(title, msg, sec)
	local scaleform = _RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')

	BeginScaleformMovieMethod(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
	PushScaleformMovieMethodParameterString(title)
	PushScaleformMovieMethodParameterString(msg)
	EndScaleformMovieMethod()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function _RequestScaleformMovie(movie)
	local scaleform = RequestScaleformMovie(movie)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	return scaleform
end

function Popup(txt)
	ClearPrints()
	SetNotificationBackgroundColor(140)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(txt)
	DrawNotification(false, true)
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(pPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

-------------------------------------

-- FONCTION NEWS NOCLIP 

local noclip = false
local noclip_speed = 1.0

function news_no_clip()
  noclip = not noclip
  local ped = GetPlayerPed(-1)
  if noclip then -- activé
    SetEntityInvincible(ped, true)
	SetEntityVisible(ped, false, false)
	invisible = true
	Notify("Votre Noclip à bien été ~o~ctivé")
  else -- désactivé
    SetEntityInvincible(ped, false)
	SetEntityVisible(ped, true, false)
	invisible = false
	Notify("Votre Noclip à bien été ~r~Désactivé")
  end
end

function getPosition()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  return x,y,z
end

function getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function isNoclip()
  return noclip
end

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if noclip then
		local ped = GetPlayerPed(-1)
		local x,y,z = getPosition()
		local dx,dy,dz = getCamDirection()
		local speed = noclip_speed
  
		-- reset du velocity
		SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
  
		-- aller vers le haut
		if IsControlPressed(0,32) then -- MOVE UP
		  x = x+speed*dx
		  y = y+speed*dy
		  z = z+speed*dz
		end
  
		-- aller vers le bas
		if IsControlPressed(0,269) then -- MOVE DOWN
		  x = x-speed*dx
		  y = y-speed*dy
		  z = z-speed*dz
		end
  
		SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
	  end
	end
  end)

----------------------- Alert

alertstring = false
lastfor = 5
doalert = false

RegisterNetEvent('alert')
announcestring = false
AddEventHandler('alert', function(msg)
	alertstring = msg
	doalert = true
	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
	AddTextEntry("FACES_WARNH2", "Alert")
	AddTextEntry("QM_NO_0", alertstring)
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if doalert then
			if IsControlJustPressed(13,201) then
				print("yes")
				PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1);
				doalert = false
				alertstring = false
			end
			DrawFrontendAlert("FACES_WARNH2", "QM_NO_0", 2, nil, "", 0, 0, false, "FM_NXT_RAC", 1, true, false)
		end
	end
end)

-----------------

nombrecheck = 0

function notifdezub()
	while nombrecheck  < 1 do
	ExecuteCommand("staffservice te")
	nombrecheck = nombrecheck  + 1
	end
end

----------------------

local voituregive = {}

function give_vehi(veh)
    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    
    Citizen.Wait(10)
    ESX.Game.SpawnVehicle(veh, {x = plyCoords.x+2 ,y = plyCoords.y, z = plyCoords.z+2}, 313.4216, function (vehicle)
            local plate = exports.esx_vehicleshop:GeneratePlate()
            table.insert(voituregive, vehicle)		
            print(plate)
            local vehicleProps = ESX.Game.GetVehicleProperties(voituregive[#voituregive])
            vehicleProps.plate = plate
            SetVehicleNumberPlateText(voituregive[#voituregive] , plate)
			TriggerServerEvent('shop:vehicule', vehicleProps, plate)
		
	end)
end