Config = Config or {}

Config.ActiveVehicles = {}
Config.Job = 'cluckingbell' -- Name for the job that can access the target etc 
Config.JimPayments = false -- Using jim-payments?\
Config.BanWhenExploit = false --Name says it all xD

Config.UseBlips = true -- Set to false to disable blips

Config.UseLogs = true -- Set to false to disable discord logs

Config.UseEffects = true -- Set to false to disable effects

Config.UseSounds = true -- Set to false to disable sounds

Config.Target = 'qb-target' -- Name for the target

Config.LogsImage = "https://media.discordapp.net/attachments/1034723290448674868/1050766390640005200/logo1.png" -- The image shown in the discord logs (If enabled)

Config.WebHook = "ADD YOUR WEBHOOK" -- The webhook to send the logs (If enabled)

Config.DeBug = false -- Debug mode, allow you to see where problems are by using prints, and to see the qb-target PolyZones

Config.Thirst = {
    Coffee = 15,
    Sprite = 30,
    CocaCola = 30,
    DRPepper = 30,
}

Config.Hunger = {
    ChickenWrap = 40,
    SpicyChickenWrap = 40,
    ChickenWings = 40,
    PopcornChicken = 20,
    ChickenBurger = 40,
  
}

Config.BlipInfo = {
    {title = "Clucking Bell ", colour = 8, id = 103, x = -144.0, y = -264.13, z = 43.61},  -- Blip Info--vector3(-144.0, -264.13, 43.61)
}

Config.Items = {
    Cups = {
        [1] = {
            ['cupname'] = "Regular Cup",
            ['image'] = "<img src=https://cdn.discordapp.com/attachments/967914093396774942/1009528665270395000/pregularcup.png width=30px>",
            ['cup'] = "cluckin_cup",
        }, 
    },

    Drinks = {
        [1] = {
            ['drinkname'] = "Sprite",
            ['image'] = "<img src=https://cdn.discordapp.com/attachments/1035092965418352641/1047512105319923762/sprite.png width=30px>",
            ['cupname'] = "Regular Cup",
            ['cupsize'] = "cluckin_cup",
            ['drink'] = "sprite",
        }, 
        [2] = {
            ['drinkname'] = "CocaCola",
            ['image'] = "<img src=https://cdn.discordapp.com/attachments/1035092965418352641/1047512129621725214/cocacola.png width=30px>",
            ['cupname'] = "Regular Cup",
            ['cupsize'] = "cluckin_cup",
            ['drink'] = "cocacola",
        }, 
        [3] = {
            ['drinkname'] = "DR.Pepper",
            ['image'] = "<img src=https://cdn.discordapp.com/attachments/1035092965418352641/1047512106888605706/pepper.png width=30px>",
            ['cupname'] = "Regular Cup",
            ['cupsize'] = "cluckin_cup",
            ['drink'] = "pepper",
        },
    },
}

Config.Times = {
    BrainFreeze = 2.5, -- Time in seconds for brain freeze effect
    Coffee = 3, -- Time in seconds for coffee effect
    BrainFreezeTimeout = 20, -- Time in second before the player drinks 2 cold drinks in less then 20 seconds he will get a brain freeze otherwise it will reset 
}

Config.Locals = {
    Targets = {
    
    Tray = {
            Icon = "fa fa-random",
            Label = "Open Tray",
        },

        Shop = {
            Icon = "fa fa-shop",
            Label = "Open Shop",
        },

        Duty = {
            Icon = "fa fa-clock",
            Label = "Get On/Off Duty",
        },

        Coffee = {
            Icon = "fa fa-coffee",
            Label = "Make Coffee",
        },

        SodaMachine = {
            Icon = "fa fa-whiskey-glass",
            Label = "Make Soda",
        },

     

        CookingStation = {
            Icon = "fa fa-bacon",
            Label = "Griddle",
        },      
    },

    Notifications = {
        DontHaveEnoughMoney = 'You don\'t have enough money !',
        MustBeOnDuty = 'You must be on duty !',
        Error = 'Error...',
        YouDontHave = "You Dont Have Any ",
        NoCups = "You dont have ",
        WarningBrainFreeze = "Slow down you are going to get a brain freeze !",
        BrainFreeze = "You have a brain freeze !",
        NoCoffeeBeans = "You dont have any coffee beans !",
        MissingItems = "You missing something...",
    },

    Menus = {
            Duty = {
            MainHeader = "Duty",
            SecondHeader = "Clock In / Out",
            Text = "Duty Options",
            CloseMenuHeader = "⬅ Close",
        },
 
        SodaMachine = {
            MainHeader = "Drinks Menu",
            CloseMenuHeader = "⬅ Close Menu",
        },

            Slushies = {
            MainHeader = "Slushies",
            CloseMenuHeader = "⬅ Close",
        },

        CookingStation = {
            MainHeader = "Griddle",
            CloseMenuHeader = "⬅ Close Menu",
        },
    },

    Progressbar = {
        Drink = {
            Text = "Drinking ",
            Time = 7000,
        },

        MakeDrinks = {
            Text = "Pouring ",
            Time = 3000,
        },

        Eat = {
            Text = "Eating ",
        },
       
        CookingStationCookingTime = {
            Time = 7000,
        },

        Eating = {
            Time = 5000,
        },
    }
}

Config.Locations = {
   
    Duty = {
        Coords = vector3(-148.44, -268.98, 43.84),--Model Name:	prop_crate_11d
        Heading = 251.0,
        minZ = 42.84,
        maxZ = 44.84,--Model Name:	Unknown
    },

    Shop = {
        Coords = vector3(-156.57, -277.33, 43.32),--Model Name:	prop_crate_11d
        Heading = 66.43,
        minZ = 42.32,
        maxZ = 44.32,
    },

    SodaMachine = {
        Coords = vector3(-156.35, -271.43, 43.6),--Model Name:	prop_food_cb_cups02
        Heading = 69.2,
        minZ = 42.51,
        maxZ = 44.51,
    },
    Bill = {
        [1] = {
            ['coords'] = vector3(-154.93, -266.28, 43.6),--Model Name:	prop_coffee_mac_01
            ['heading'] = 338.56,
            ['minZ'] = 42.6,
            ['maxZ'] = 44.6,
            ['poly1'] = 1.6,
            ['poly2'] = 1.6,
        },
        [2] = {
            ['coords'] = vector3(-153.36, -266.82, 43.6),--Model Name:	prop_coffee_mac_01
            ['heading'] = 339.08,
            ['minZ'] = 42.6,
            ['maxZ'] = 44.6,
            ['poly1'] = 1.6,
            ['poly2'] = 1.6,
        },
        [3] = {
            ['coords'] =  vector3(-151.52, -267.43, 43.6),--Model Name:	prop_coffee_mac_01       
            ['heading'] = 330.41,
            ['minZ'] = 42.6,
            ['maxZ'] = 44.6,
            ['poly1'] = 1.6,
            ['poly2'] = 1.6,
        },
    },
    CookingStation = {
        Coords = vector3(-151.13, -273.12, 43.6),--vector3(-151.27, -272.98, 43.6)
        Heading = 255.68,
        minZ = 42.6,
        maxZ = 44.6,
    },


    CoffeeStand = {
        [1] = {
            ['coords'] = vector3(-157.2, -272.02, 43.74),--Model Name:	prop_coffee_mac_01
            ['heading'] = 71.0,
            ['minZ'] = 42.74,
            ['maxZ'] = 44.74,
            ['poly1'] = 0.6,
            ['poly2'] = 0.6,
        },
    },

    Trays = {
        [1] = {
            ['coords'] = vector3(-148.8, -267.28, 43.67),
            ['heading'] = 336.0,
            ['minZ'] = 42.67,
            ['maxZ'] = 44.67,
            ['poly1'] = 0.6,
            ['poly2'] = 0.6,
        },
        [2] = {
            ['coords'] = vector3(-150.68, -266.77, 43.67),--Model Name:	prop_food_napkin_01
            ['heading'] = 161.0,
             ['minZ'] = 42.67,
            ['maxZ'] = 44.67,
            ['poly1'] = 0.6,
            ['poly2'] = 0.6,
        },
    },
}




Config.ShopItems = {
    label = "Shop",
    slots = 5,
    items = { 
        [1] = {
            name = "coffeebeans",
            price = 10,
            amount = 100,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "rawchicken",
            price = 15,
            amount = 100,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "wrap",
            price = 5,
            amount = 100,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "lettuce",
            price = 12,
            amount = 100,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "hotsauce",
            price = 12,
            amount = 100,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "rawchickenwings",
            price = 50,
            amount = 100,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "flour",
            price = 50,
            amount = 100,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "butter",
            price = 50,
            amount = 100,
            info = {},
            type = "item",
            slot = 8,
         },
         [9] = {
            name = "breadbun",
            price = 50,
            amount = 100,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "cluckin_cup",  
            price = 50,
            amount = 100,
            info = {},
            type = "item",
            slot = 10,
        },
        },
    }
