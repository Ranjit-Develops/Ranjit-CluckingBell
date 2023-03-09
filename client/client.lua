local QBCore = exports['qb-core']:GetCoreObject()

local PlayerJob = {}

local WarningBrainFreeze = false

local drinked = 0

----------------
----Handlers
----------------
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	PlayerJob = QBCore.Functions.GetPlayerData().job
	PlayerLoaded = true
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
		PlayerJob = QBCore.Functions.GetPlayerData().job
		QBCore.Functions.GetPlayerData(function(Data)
			PlayerJob = Data.job
			if Data.job.onduty then
				if Data.job.name == Config.Job then
					TriggerServerEvent("QBCore:ToggleDuty")
				end
			end
		end)
    end
end)


----------------
----Blips
----------------
Citizen.CreateThread(function()
	for _, info in pairs(Config.BlipInfo) do
		if Config.UseBlips then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipSprite(info.blip, info.id)
			SetBlipDisplay(info.blip, 4)
			SetBlipScale(info.blip, 0.6)	
			SetBlipColour(info.blip, info.colour)
			SetBlipAsShortRange(info.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(info.title)
			EndTextCommandSetBlipName(info.blip)
		end
	end	
end)

----------------
----Events
----------------

RegisterNetEvent("Ranjit-CluckingBell:OpenTray", function(data)
	TriggerServerEvent("inventory:server:OpenInventory", "stash", "CluckingBell "..data.number.." Tray", {maxweight = 30000, slots = 10})
	TriggerEvent("inventory:client:SetCurrentStash", "CluckingBell "..data.number.." Tray") 
end)

RegisterNetEvent('Ranjit-CluckingBell:OpenShop', function()
	QBCore.Functions.TriggerCallback('Ranjit-CluckingBell:CheckDuty', function(result)
		if result then
			TriggerServerEvent("inventory:server:OpenInventory", "shop", "Main Shop", Config.ShopItems)
		else
			QBCore.Functions.Notify(Config.Locals["Notifications"]["MustBeOnDuty"], "error")
		end
	end)
end)

RegisterNetEvent('Ranjit-CluckingBell:SyncTable', function(CurrentVehicles)
	Config.ActiveVehicles = CurrentVehicles
end)

RegisterNetEvent("Ranjit-CluckingBell:Sit", function(data)
	QBCore.Functions.TriggerCallback('Ranjit-CluckingBell:GetPlace', function(Occupied)
		if Occupied then
			QBCore.Functions.Notify(Config.Locals["Notifications"]["ChairIsUsed"], "error")
		else
			local playerPos = GetEntityCoords(PlayerPedId())
			local playerPed = PlayerPedId()
			CanSit = true
		
			SetEntityHeading(data.heading)
		
			TriggerServerEvent('Ranjit-CluckingBell:TakePlace', data.pos.x, data.pos.y, data.pos.z)
				
			TaskStartScenarioAtPosition(playerPed, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", data.pos.x-0.10, data.pos.y-0.20, data.pos.z-0.20, data.heading, 0, true, true)
		
			Citizen.CreateThread(function()
				while true do
					if CanSit then
						ShowHelpNotification("Press ~INPUT_FRONTEND_RRIGHT~ To Get Up")
					elseif not CanSit then
						break
					end
					if IsControlJustReleased(0, 177) then
						CanSit = false
						ClearPedTasks(playerPed)
						SetEntityCoords(playerPed, data.pos.x, data.pos.y, data.pos.z)
						TriggerServerEvent('Ranjit-CluckingBell:LeavePlace', data.pos.x, data.pos.y, data.pos.z)
						TriggerServerEvent("Ranjit-CluckingBell:CheckSit:Server:SetSitActive", false)
						PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						break
					end
					Citizen.Wait(1)
				end
			end)
		end
	end, data.pos.x, data.pos.y, data.pos.z)
end)

RegisterNetEvent("Ranjit-CluckingBell:MakeDrink", function(data)
    QBCore.Functions.TriggerCallback('Ranjit-CluckingBell:HasItem', function(result)
        if result then
			if Config.UseSounds and not data.coffee then
				TriggerEvent('InteractSound_CL:PlayOnOne', 'soda_making', 8.0)
			else
				TriggerEvent('InteractSound_CL:PlayOnOne', 'coffee_pouring', 8.0)
			end
            QBCore.Functions.Progressbar("make_"..data.drink, Config.Locals["Progressbar"]["MakeDrinks"]["Text"] .. data.drinkname .. "...", Config.Locals["Progressbar"]["MakeDrinks"]["Time"], false, true, {
				disableMovement = true,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			}, {
				animDict = 'anim@amb@clubhouse@bar@drink@one',
				anim = 'one_bartender',
				flags = 49,
			}, {}, {}, function()
                QBCore.Functions.Notify(data.drinkname .. " Successfully Made", "success")
                TriggerServerEvent("Ranjit-CluckingBell:RemoveItem", data.cuptype, 1)
                TriggerServerEvent("Ranjit-CluckingBell:AddItem", data.drink, 1)
				TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[data.drink], "add")
			end, function()
				QBCore.Functions.Notify("Canceled...", "error")
			end)
        else
			if not data.coffee then
            	QBCore.Functions.Notify(Config.Locals["Notifications"]["NoCups"] ..data.cupname, "error")
			else
				QBCore.Functions.Notify(Config.Locals["Notifications"]["NoCoffeeBeans"], "error")
			end
        end
    end, data.cuptype, 1)
end)

RegisterNetEvent("Ranjit-CluckingBell:Grab", function(data)
    QBCore.Functions.Progressbar("grab_"..data.item, "Grabing " ..data.itemname .. "...", data.time, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
		animDict = data.animationdict,
		anim = data.animation,
        flags = 49,
    }, {}, {}, function()
        QBCore.Functions.Notify("You grabbed " ..data.itemname, "success")
        TriggerServerEvent("Ranjit-CluckingBell:AddItem", data.item, 1)
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[data.item], "add")
    end, function()
        QBCore.Functions.Notify("Canceled...", "error")
    end)
end)

RegisterNetEvent("Ranjit-CluckingBell:Drink", function(item, itemname, anim, animdict, model, bones, coords, thirst, cold, coffee)
	QBCore.Functions.Progressbar("drinking_"..item, Config.Locals["Progressbar"]["Drink"]["Text"] .. itemname .. "...", Config.Locals["Progressbar"]["Drink"]["Time"], false, true, {
		disableMovement = false,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = anim,
		anim = animdict,
		flags = 49,
	}, {
		model = model,
		bone = bones,
		coords = { x=coords.x, y=coords.y, z=coords.z },
	}, {}, function()
		QBCore.Functions.Notify("You Have Drank " ..itemname, "success")
		TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + thirst)
		TriggerServerEvent("Ranjit-CluckingBell:RemoveItem", item, 1)
		if coffee and Config.UseEffects then
			CoffeeEffect()
		end
		if cold and Config.UseEffects then
			drinked = drinked + 1
		end
		if drinked >= 2 and not WarningBrainFreeze and Config.UseEffects then
			QBCore.Functions.Notify(Config.Locals["Notifications"]["WarningBrainFreeze"])
			WarningBrainFreeze = true
			SetTimeout(Config.Times['BrainFreezeTimeout'] * 1000, function()
				WarningBrainFreeze = false
				drinked = 0
			end)
		elseif drinked >= 3 and Config.UseEffects then
			QBCore.Functions.Notify(Config.Locals["Notifications"]["BrainFreeze"])
			drinked = 0
			BrainFreeze()
			WarningBrainFreeze = false
		end
	end, function()
		QBCore.Functions.Notify("Canceled...", "error")
	end)
end)

RegisterNetEvent("Ranjit-CluckingBell:Eat", function(gumball, item, itemname, time, hunger, anim, animdict, model, bones, coords)
	if not gumball then
		QBCore.Functions.Progressbar("eat_"..item, Config.Locals["Progressbar"]["Eat"]["Text"] .. itemname .. "...", time, false, true, {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = anim,
			anim = animdict,
			flags = 49,
		}, {
			model = model,
			bone = bones,
			coords = { x=coords.x, y=coords.y, z=coords.z },
		}, {}, function()
			QBCore.Functions.Notify("You eated " ..itemname, "success")
			TriggerServerEvent("Ranjit-CluckingBell:RemoveItem", item, 1)
			TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[item], "remove")
			TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + hunger)
		end, function()
			QBCore.Functions.Notify("Canceled...", "error")
		end)
	else
		if Config.UseSounds then
			TriggerEvent('InteractSound_CL:PlayOnOne', 'bubble_gum', 8.0)
		end
		QBCore.Functions.Progressbar("chew_"..item, Config.Locals["Progressbar"]["Chewing"]["Text"] .. itemname, time, false, true, {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = anim,
			anim = animdict,
			flags = 49,
		}, {}, {}, function()
			TriggerServerEvent("Ranjit-CluckingBell:RemoveItem", item, 1)
			TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[item], "remove")
			TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + hunger)
		end, function()
			QBCore.Functions.Notify("Canceled...", "error")
		end)
	end
end)

RegisterNetEvent("Ranjit-CluckingBell:Make", function(data)
	QBCore.Functions.TriggerCallback('Ranjit-CluckingBell:CheckFor'..data.event..'Items', function(HasItems)
		if HasItems then
			QBCore.Functions.Progressbar("make", "Making "..data.itemname .. "...", data.time, false, true, {
				disableMovement = true,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			}, {
				animDict = data.animdict,
				anim = data.anim,
				flags = 49,
			}, {}, {}, function()
				if data.item3 then
					TriggerServerEvent("Ranjit-CluckingBell:RemoveItem", data.item3, 1)
				end
				if data.item4 then
					TriggerServerEvent("Ranjit-CluckingBell:RemoveItem", data.item4, 1)
				end
				if data.item5 then
					TriggerServerEvent("Ranjit-CluckingBell:RemoveItem", data.item5, 1)
				end
				TriggerServerEvent("Ranjit-CluckingBell:RemoveItem", data.item1, 1)
				TriggerServerEvent("Ranjit-CluckingBell:RemoveItem", data.item2, 1)
				TriggerServerEvent("Ranjit-CluckingBell:AddItem", data.recieveitem, data.number)
				TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[data.recieveitem], "add")
			end, function()
				QBCore.Functions.Notify("Canceled...", "error")
			end)
		else
			QBCore.Functions.Notify(Config.Locals['Notifications']['MissingItems'], 'error')
		end
	end)
end)

----------------
----Targets
----------------
CreateThread(function()
	exports[Config.Target]:AddBoxZone("Duty", vector3(Config.Locations["Duty"]["Coords"].x, Config.Locations["Duty"]["Coords"].y, Config.Locations["Duty"]["Coords"].z), 1.8, 0.34, {
		name = "Duty",
		heading = Config.Locations["Duty"]["Heading"],
		debugPoly = Config.DeBug,
		minZ = Config.Locations["Duty"]["minZ"],
		maxZ = Config.Locations["Duty"]["maxZ"],
		}, {
			options = { 
			{
				type = "client",
				event = "Ranjit-CluckingBell:DutyMenu",
				icon = Config.Locals['Targets']['Duty']['Icon'],
				label = Config.Locals['Targets']['Duty']['Label'],
				job = Config.Job,
			},
		},
		distance = 1.2,
	})


	for k, v in pairs(Config.Locations["Trays"]) do
        exports[Config.Target]:AddBoxZone("Tray"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.poly1, v.poly2, {
            name = "Tray"..k,
            heading = v.heading,
            debugPoly = Config.DeBug,
            minZ = v.minZ,
            maxZ = v.maxZ,
            }, {
                options = { 
                {
                    type = "client",
					event = "Ranjit-CluckingBell:OpenTray",
					icon = Config.Locals['Targets']['Tray']['Icon'],
					label = Config.Locals['Targets']['Tray']['Label'],
					number = k,
                }
            },
            distance = 1.2,
        })
    end

	exports[Config.Target]:AddBoxZone("Shop", vector3(Config.Locations["Shop"]["Coords"].x, Config.Locations["Shop"]["Coords"].y, Config.Locations["Shop"]["Coords"].z), 1.8, 0.34, {
		name = "Shop",
		heading = Config.Locations["Shop"]["Heading"],
		debugPoly = Config.DeBug,
		minZ = Config.Locations["Shop"]["minZ"],
		maxZ = Config.Locations["Shop"]["maxZ"],
		}, {
			options = { 
			{
				type = "client",
				event = "Ranjit-CluckingBell:OpenShop",
				icon = Config.Locals['Targets']['Shop']['Icon'],
				label = Config.Locals['Targets']['Shop']['Label'],
				job = Config.Job,
			},
		},
		distance = 1.2,
	})

	exports[Config.Target]:AddTargetModel(688554878, {	
    	name = "Coffee",
		options = {
			{
				type = "client",
				event = "Ranjit-CluckingBell:MakeDrink",
				icon = Config.Locals['Targets']['Coffee']['Icon'],
				label = Config.Locals['Targets']['Coffee']['Label'],
				drink = "coffee",
				cuptype = "coffeebeans",
				drinkname = "Coffee",
				coffee = true,
				job = Config.Job,
			},
		},
		distance = 1.0,
	})

	for k, v in pairs(Config.Locations["CoffeeStand"]) do
        exports[Config.Target]:AddBoxZone("CoffeeStand"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.poly1, v.poly2, {
            name = "CoffeeStand"..k,
            heading = v.heading,
            debugPoly = Config.DeBug,
            minZ = v.minZ,
            maxZ = v.maxZ,
            }, {
                options = { 
                {
                    type = "client",
					event = "Ranjit-CluckingBell:MakeDrink",
					icon = Config.Locals['Targets']['Coffee']['Icon'],
					label = Config.Locals['Targets']['Coffee']['Label'],
					drink = "coffee",
					cuptype = "coffeebeans",
					drinkname = "Coffee",
					coffee = true,
					job = Config.Job,
                }
            },
            distance = 1.2,
        })
    end

	exports[Config.Target]:AddBoxZone("SodaMachine", vector3(Config.Locations["SodaMachine"]["Coords"].x, Config.Locations["SodaMachine"]["Coords"].y, Config.Locations["SodaMachine"]["Coords"].z), 1.6, 1.6, {
		name = "SodaMachine",
		heading = Config.Locations["SodaMachine"]["Heading"],
		debugPoly = Config.DeBug,
		minZ = Config.Locations["SodaMachine"]["minZ"],
		maxZ = Config.Locations["SodaMachine"]["maxZ"],
		}, {
			options = { 
			{
				type = "client",
				event = "Ranjit-CluckingBell:SodaMenu",
				icon = Config.Locals['Targets']['SodaMachine']['Icon'],
				label = Config.Locals['Targets']['SodaMachine']['Label'],
				job = Config.Job,
			},
		},
		distance = 1.2,
	})


	exports[Config.Target]:AddBoxZone("CookingStation", vector3(Config.Locations["CookingStation"]["Coords"].x, Config.Locations["CookingStation"]["Coords"].y, Config.Locations["CookingStation"]["Coords"].z), 1.6, 1.6, {
		name = "CookingStation",
		heading = Config.Locations["CookingStation"]["Heading"],
		debugPoly = Config.DeBug,
		minZ = Config.Locations["CookingStation"]["minZ"],
		maxZ = Config.Locations["CookingStation"]["maxZ"],
		}, {
			options = { 
			{
				type = "client",
				event = "Ranjit-CluckingBell:CookingStationMenu",
				icon = Config.Locals['Targets']['CookingStation']['Icon'],
				label = Config.Locals['Targets']['CookingStation']['Label'],
				job = Config.Job,
			},
		},
		distance = 1.2,
	})
	for k, v in pairs(Config.Locations["Bill"]) do
		exports[Config.Target]:AddBoxZone("Bill"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.poly1, v.poly2, {
            name = "Bill"..k,
            heading = v.heading,
            debugPoly = Config.DeBug,
            minZ = v.minZ,
            maxZ = v.maxZ,
            }, {
		options = {
			{
            	type = "client",
            	event ="Ranjit-CluckingBell:Client:Biller",
                label = "Bill",
				job = Config.Job,
			},
		},
		distance = 1.1
	})
end
end)
----------------
----Menus
----------------
RegisterNetEvent('Ranjit-CluckingBell:Client:Biller', function()
    if Config.JimPayments then
        TriggerEvent("jim-payments:client:Charge", Config.Job)
    else
        local dialog = exports["qb-input"]:ShowInput({
            header = "Billing",
            submitText = "Submit",
            inputs = {
                { type = 'number', isRequired = true, name = 'id', text = "Paypal ID" },
                { type = 'number', isRequired = true, name = 'amount', text = "Amount" }
            }
        })
        if dialog then
            if not dialog.id or not dialog.amount then return end
            TriggerServerEvent("Ranjit-CluckingBell:Server:Billing", dialog.id, dialog.amount)
        end
    end
end)


RegisterNetEvent('Ranjit-CluckingBell:Client:Notify')
AddEventHandler("Ranjit-CluckingBell:Client:Notify", function(msg,type)
    Notify(msg,type)
end)

RegisterNetEvent("Ranjit-CluckingBell:DutyMenu", function()
    local DutyMenu = {
        {
            header = Config.Locals["Menus"]["Duty"]["MainHeader"],
            isMenuHeader = true,
        }
    }
	DutyMenu[#DutyMenu+1] = {
        header = Config.Locals["Menus"]["Duty"]["SecondHeader"],
		txt = Config.Locals["Menus"]["Duty"]["Text"],
        params = {
			isServer = true,
            event = "QBCore:ToggleDuty"
        }
    }
    DutyMenu[#DutyMenu+1] = {
        header = Config.Locals["Menus"]["Duty"]["CloseMenuHeader"],
        params = {
            event = "qb-menu:client:closemenu"
        }
    }
    exports['qb-menu']:openMenu(DutyMenu)
end)

RegisterNetEvent("Ranjit-CluckingBell:SodaMenu", function()
	QBCore.Functions.TriggerCallback('Ranjit-CluckingBell:CheckDuty', function(result)
        if result then
			local SodaMenu = {
				{
					header = Config.Locals["Menus"]["SodaMachine"]["MainHeader"],
					isMenuHeader = true,
				}
			}
            for k, v in pairs(Config.Items["Drinks"]) do
                SodaMenu[#SodaMenu+1] = {
                    header = v.image.." ┇ " ..v.drinkname,
					txt = "Pour: " .. v.drinkname .. "<br> Needed: " .. v.cupsize,
                    params = {
                        event = "Ranjit-CluckingBell:MakeDrink",
                        args = {
							cuptype = v.cupsize,
                            drinkname = v.drinkname,
							cupname = v.cupname,
                            drink = v.drink,
                        }
                    }
                }
            end
			SodaMenu[#SodaMenu+1] = {
				header = Config.Locals["Menus"]["SodaMachine"]["CloseMenuHeader"],
				params = {
					event = "qb-menu:client:closemenu"
				}
			}
			exports['qb-menu']:openMenu(SodaMenu)
		else
			QBCore.Functions.Notify(Config.Locals["Notifications"]["MustBeOnDuty"], "error")
        end
    end)
end)


RegisterNetEvent("Ranjit-CluckingBell:CookingStationMenu", function()
	QBCore.Functions.TriggerCallback('Ranjit-CluckingBell:CheckDuty', function(result)
        if result then
			local CookingStationMenu = {
				{
					header = Config.Locals["Menus"]["CookingStation"]["MainHeader"],
					isMenuHeader = true,
				}
			}
			CookingStationMenu[#CookingStationMenu+1] = {
				header =  "<img src=https://cdn.discordapp.com/attachments/1035092965418352641/1047512128975810671/chickenwings.png width=30px> ".." ┇ Chicken Wings",
				txt = "Ingredients: <br> - Raw Chicken Wings <br> - Flour <br> - Butter <br> - Hot Sauce",
				params = {
					event = "Ranjit-CluckingBell:Make",
					args = {
						event = "ChickenWings",
						time = Config.Locals['Progressbar']['CookingStationCookingTime']['Time'],
						itemname = "Chicken Wings",
						item1 = "rawchickenwings",
						item2 = "flour",
						item3 = "butter",
						item4 = "hotsauce",
						number = 1,
						recieveitem = "chickenwings",
						animdict = "amb@prop_human_bbq@male@base",
						anim = "base",
					}
				}
			}
				CookingStationMenu[#CookingStationMenu+1] = {
				header =  "<img src=https://cdn.discordapp.com/attachments/1035092965418352641/1047512104938250340/spiscychickenwrap.png width=30px> ".." ┇ Chicken Wrap",
				txt = "Ingredients: <br> - Raw Chicken <br> - Wrap <br> - Lettuce",
				params = {
					event = "Ranjit-CluckingBell:Make",
					args = {
						event = "ChickenWrap",
						time = Config.Locals['Progressbar']['CookingStationCookingTime']['Time'],
						itemname = "Chicken Wrap",
						item1 = "rawchicken",
						item2 = "wrap",
						item3 = "lettuce",
						number = 1,
						recieveitem = "chickenwrap",
						animdict = "amb@prop_human_bbq@male@idle_b",
						anim = "idle_d",
					}
				}
			}
				
			CookingStationMenu[#CookingStationMenu+1] = {
				header =  "<img src=https://cdn.discordapp.com/attachments/1035092965418352641/1047512129302962277/chickenwrap.png width=30px> ".." ┇ Spicy Chicken Wrap",
				txt = "Ingredients: <br> - Raw Chicken <br> - Wrap <br> - Lettuce <br> - Hot Sauce",
				params = {
					event = "Ranjit-CluckingBell:Make",
					args = {
						event = "SpicyChickenWrap",
						time = Config.Locals['Progressbar']['CookingStationCookingTime']['Time'],
						itemname = "Spicy Chicken Wrap",
						item1 = "rawchicken",
						item2 = "wrap",
						item3 = "lettuce",
						item4 = "hotsauce",
						number = 1,
						recieveitem = "spicychickenwrap",
						animdict = "amb@prop_human_bbq@male@idle_b",
						anim = "idle_d",
					}
				}
			}
				CookingStationMenu[#CookingStationMenu+1] = {
				header =  "<img src=https://cdn.discordapp.com/attachments/1035092965418352641/1047628087212388412/popcornchicken.png width=30px> ".." ┇ Popcorn Chicken",
				txt = "Ingredients: <br> - Raw Chicken <br> - Flour <br> - Butter ",
				params = {
					event = "Ranjit-CluckingBell:Make",
					args = {
						event = "PopcornChicken",
						time = Config.Locals['Progressbar']['CookingStationCookingTime']['Time'],
						itemname = "Popcorn Chicken",
						item1 = "rawchicken",
						item2 = "flour",
						item3 = "butter",
						number = 1,
						recieveitem = "popcornchicken",
						animdict = "amb@prop_human_bbq@male@idle_b",
						anim = "idle_d",
					}
				}
			}
					CookingStationMenu[#CookingStationMenu+1] = {
				header =  "<img src=https://cdn.discordapp.com/attachments/1035092965418352641/1047630031171625021/chickenburger.png width=30px> ".." ┇ Chicken Burger",
				txt = "Ingredients: <br> - Raw Chicken <br> - Bread Bun <br> - Lettuce ",
				params = {
					event = "Ranjit-CluckingBell:Make",
					args = {
						event = "ChickenBurger",
						time = Config.Locals['Progressbar']['CookingStationCookingTime']['Time'],
						itemname = "Chicken Burger",
						item1 = "rawchicken",
						item2 = "breadbun",
						item3 = "lettuce",
						number = 1,
						recieveitem = "chickenburger",
						animdict = "amb@prop_human_bbq@male@idle_b",
						anim = "idle_d",
					}
				}
			}
			CookingStationMenu[#CookingStationMenu+1] = {
				header = Config.Locals["Menus"]["CookingStation"]["CloseMenuHeader"],
				params = {
					event = "qb-menu:client:closeMenu"
				}
			}
			exports['qb-menu']:openMenu(CookingStationMenu)
        else
			QBCore.Functions.Notify(Config.Locals["Notifications"]["MustBeOnDuty"], "error")
        end
    end)
end)

----------------
----Functions
----------------
function LoadModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Wait(10)
	end
end


function HandleCooldown(time)
    GumBallSecondsRemaining = time
	if Config.DeBug then
		print(GumBallSecondsRemaining)
	end
    Citizen.CreateThread(function()
        while GumBallSecondsRemaining > 0 do
            Citizen.Wait(1000)
            GumBallSecondsRemaining = GumBallSecondsRemaining - 1
        end
    end)
end

function BrainFreeze()
    local startFreeze = Config.Times['BrainFreeze']
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.15)
	ApplyPedDamageDecal(PlayerPedId(), 1, 0.5, 0.513, 0, 1, unk, 0, 0, "cs_flush_anger")
    SetRunSprintMultiplierForPlayer(PlayerId(), 0.5)
    while startFreeze > 0 do
        Wait(1000)
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.18)
        startFreeze = startFreeze - 1
    end
    startFreeze = 0
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.15)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function CoffeeEffect()
    local startStamina = Config.Times['Coffee']
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.4)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
    end
    startStamina = 0
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--
