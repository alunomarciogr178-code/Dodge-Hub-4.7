local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local VirtualUserService = game:GetService("VirtualUserService")

local player = Players.LocalPlayer
local Data = player:WaitForChild("Data")
local Level = Data:WaitForChild("Level")
local Beli = Data:WaitForChild("Beli")
local Fragments = Data:WaitForChild("Fragments")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local Remotes = RS:WaitForChild("Remotes")
local CommF = Remotes:WaitForChild("CommF_")

local function fireRemote(action, ...)
    pcall(CommF.InvokeServer, CommF, action, ...)
end

player.CharacterAdded:Connect(function(ch)
    character = ch
    humanoid = ch:WaitForChild("Humanoid")
    rootPart = ch:WaitForChild("HumanoidRootPart")
end)

-- Otimização gráfica básica
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 2
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then v.Enabled = false end
end

pcall(function()
    fireRemote("SetTeam", "Pirates")
end)

local function detectAdmin(p)
    local n = p.Name:lower()
    if n:find("admin") or n:find("mod") or n:find("dev") or n:find("owner") 
    or p:GetAttribute("Admin") or p:FindFirstChild("AdminTag") then
        return true
    end
    return false
end

local function hopServer()
    local ok, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    if ok and data and data.data then
        for _, s in ipairs(data.data) do
            if s.playing < 6 and s.id ~= game.JobId then
                TS:TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    task.spawn(function()
        task.wait(1.2)
        if detectAdmin(p) then hopServer() end
    end)
end)

task.spawn(function()
    while task.wait(6) do
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and detectAdmin(p) then hopServer() break end
        end
    end
end)

task.spawn(function()
    while task.wait(1800) do hopServer() end
end)

task.spawn(function()
    while task.wait(1.4) do
        pcall(function()
            if humanoid.Health <= 0 then
                humanoid:Destroy()
                Instance.new("Humanoid", character)
            end
        end)
    end
end)

-- Auto-attack loop
task.spawn(function()
    while true do
        task.wait(0.2)
        pcall(function()
            VirtualUserService:CaptureController()
            VirtualUserService:ClickButton1(Vector2.new())
        end)
    end
end)

local function getQuestInfo()
    local MyLevel = Level.Value
    local World1 = MyLevel < 700
    local World2 = MyLevel >= 700 and MyLevel < 1500
    local World3 = MyLevel >= 1500
    local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon

    if World1 then
        if MyLevel <= 9 then 
            Mon = "Bandit" 
            LevelQuest = 1 
            NameQuest = "BanditQuest1" 
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059, 17, 1546) 
            CFrameMon = CFrame.new(943, 45, 1562)
        elseif MyLevel <= 14 then 
            Mon = "Monkey" 
            LevelQuest = 1 
            NameQuest = "JungleQuest" 
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598, 37, 153) 
            CFrameMon = CFrame.new(-1524, 50, 37)
        elseif MyLevel <= 29 then 
            Mon = "Gorilla" 
            LevelQuest = 2 
            NameQuest = "JungleQuest" 
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598, 37, 153) 
            CFrameMon = CFrame.new(-1128, 40, -451)
        elseif MyLevel <= 39 then 
            Mon = "Pirate" 
            LevelQuest = 1 
            NameQuest = "BuggyQuest1" 
            NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1140, 4, 3829) 
            CFrameMon = CFrame.new(-1262, 40, 3905)
        elseif MyLevel <= 59 then 
            Mon = "Brute" 
            LevelQuest = 2 
            NameQuest = "BuggyQuest1" 
            NameMon = "Brute"
            CFrameQuest = CFrame.new(-1140, 4, 3829) 
            CFrameMon = CFrame.new(-976, 55, 4304)
        elseif MyLevel <= 74 then 
            Mon = "Desert Bandit" 
            LevelQuest = 1 
            NameQuest = "DesertQuest" 
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(897, 6, 4389) 
            CFrameMon = CFrame.new(924, 7, 4482)
        elseif MyLevel <= 89 then 
            Mon = "Desert Officer" 
            LevelQuest = 2 
            NameQuest = "DesertQuest" 
            NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(897, 6, 4389) 
            CFrameMon = CFrame.new(1608, 9, 4371)
        elseif MyLevel <= 99 then 
            Mon = "Snow Bandit" 
            LevelQuest = 1 
            NameQuest = "SnowQuest" 
            NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1385, 87, -1298) 
            CFrameMon = CFrame.new(1362, 120, -1531)
        elseif MyLevel <= 119 then 
            Mon = "Snowman" 
            LevelQuest = 2 
            NameQuest = "SnowQuest" 
            NameMon = "Snowman"
            CFrameQuest = CFrame.new(1385, 87, -1298) 
            CFrameMon = CFrame.new(1243, 140, -1437)
        elseif MyLevel <= 149 then 
            Mon = "Chief Petty Officer" 
            LevelQuest = 1 
            NameQuest = "MarineQuest2" 
            NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5035, 29, 4326) 
            CFrameMon = CFrame.new(-4881, 23, 4274)
        elseif MyLevel <= 174 then 
            Mon = "Sky Bandit" 
            LevelQuest = 1 
            NameQuest = "SkyQuest" 
            NameMon = "Sky Bandit"
            CFrameQuest = CFrame.new(-4844, 718, -2621) 
            CFrameMon = CFrame.new(-4953, 296, -2899)
        elseif MyLevel <= 189 then 
            Mon = "Dark Master" 
            LevelQuest = 2 
            NameQuest = "SkyQuest" 
            NameMon = "Dark Master"
            CFrameQuest = CFrame.new(-4844, 718, -2621) 
            CFrameMon = CFrame.new(-5260, 391, -2229)
        elseif MyLevel <= 209 then 
            Mon = "Prisoner" 
            LevelQuest = 1 
            NameQuest = "PrisonerQuest" 
            NameMon = "Prisoner"
            CFrameQuest = CFrame.new(5306, 2, 477) 
            CFrameMon = CFrame.new(5099, 0, 474)
        elseif MyLevel <= 249 then 
            Mon = "Dangerous Prisoner" 
            LevelQuest = 2 
            NameQuest = "PrisonerQuest" 
            NameMon = "Dangerous Prisoner"
            CFrameQuest = CFrame.new(5306, 2, 477) 
            CFrameMon = CFrame.new(5655, 16, 866)
        elseif MyLevel <= 274 then 
            Mon = "Toga Warrior" 
            LevelQuest = 1 
            NameQuest = "ColosseumQuest" 
            NameMon = "Toga Warrior"
            CFrameQuest = CFrame.new(-1581, 7, -2982) 
            CFrameMon = CFrame.new(-1820, 51, -2741)
            elseif MyLevel <= 299 then 
            Mon = "Gladiator" 
            LevelQuest = 2 
            NameQuest = "ColosseumQuest" 
            NameMon = "Gladiator"
            CFrameQuest = CFrame.new(-1581, 7, -2982) 
            CFrameMon = CFrame.new(-1268, 30, -2996)
        elseif MyLevel <= 324 then 
            Mon = "Military Soldier" 
            LevelQuest = 1 
            NameQuest = "MagmaQuest" 
            NameMon = "Military Soldier"
            CFrameQuest = CFrame.new(-5319, 12, 8515) 
            CFrameMon = CFrame.new(-5335, 46, 8638)
        elseif MyLevel <= 374 then 
            Mon = "Military Spy" 
            LevelQuest = 2 
            NameQuest = "MagmaQuest" 
            NameMon = "Military Spy"
            CFrameQuest = CFrame.new(-5319, 12, 8515) 
            CFrameMon = CFrame.new(-5803, 86, 8829)
        elseif MyLevel <= 399 then 
            Mon = "Fishman Warrior" 
            LevelQuest = 1 
            NameQuest = "FishmanQuest" 
            NameMon = "Fishman Warrior"
            CFrameQuest = CFrame.new(61122, 18, 1567) 
            CFrameMon = CFrame.new(60998, 50, 1534)
        elseif MyLevel <= 449 then 
            Mon = "Fishman Commando" 
            LevelQuest = 2 
            NameQuest = "FishmanQuest" 
            NameMon = "Fishman Commando"
            CFrameQuest = CFrame.new(61122, 18, 1567) 
            CFrameMon = CFrame.new(61866, 55, 1655)
        elseif MyLevel <= 474 then 
            Mon = "God's Guard" 
            LevelQuest = 1 
            NameQuest = "SkyExp1Quest" 
            NameMon = "God's Guard"
            CFrameQuest = CFrame.new(-4720, 846, -1951) 
            CFrameMon = CFrame.new(-4720, 846, -1951)
        elseif MyLevel <= 524 then 
            Mon = "Shanda" 
            LevelQuest = 2 
            NameQuest = "SkyExp1Quest" 
            NameMon = "Shanda"
            CFrameQuest = CFrame.new(-7861, 5545, -381) 
            CFrameMon = CFrame.new(-7741, 5580, -395)
        elseif MyLevel <= 549 then 
            Mon = "Royal Squad" 
            LevelQuest = 1 
            NameQuest = "SkyExp2Quest" 
            NameMon = "Royal Squad"
            CFrameQuest = CFrame.new(-7903, 5636, -1412) 
            CFrameMon = CFrame.new(-7727, 5650, -1410)
        elseif MyLevel <= 624 then 
            Mon = "Royal Soldier" 
            LevelQuest = 2 
            NameQuest = "SkyExp2Quest" 
            NameMon = "Royal Soldier"
            CFrameQuest = CFrame.new(-7903, 5636, -1412) 
            CFrameMon = CFrame.new(-7894, 5640, -1629)
        elseif MyLevel <= 649 then 
            Mon = "Galley Pirate" 
            LevelQuest = 1 
            NameQuest = "FountainQuest" 
            NameMon = "Galley Pirate"
            CFrameQuest = CFrame.new(5258, 39, 4052) 
            CFrameMon = CFrame.new(5391, 70, 4023)
        elseif MyLevel >= 650 then 
            Mon = "Galley Captain" 
            LevelQuest = 2 
            NameQuest = "FountainQuest" 
            NameMon = "Galley Captain"
            CFrameQuest = CFrame.new(5258, 39, 4052) 
            CFrameMon = CFrame.new(5985, 70, 4790)
        end
    elseif World2 then
        if MyLevel >= 700 and MyLevel <= 724 then 
            Mon = "Raider" 
            LevelQuest = 1 
            NameQuest = "Area1Quest" 
            NameMon = "Raider"
            CFrameQuest = CFrame.new(-427, 73, 1835) 
            CFrameMon = CFrame.new(-614, 90, 2240)
        elseif MyLevel >= 725 and MyLevel <= 774 then 
            Mon = "Mercenary" 
            LevelQuest = 2 
            NameQuest = "Area1Quest" 
            NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-427, 73, 1835) 
            CFrameMon = CFrame.new(-867, 110, 1621)
        elseif MyLevel >= 775 and MyLevel <= 874 then 
            Mon = "Swan Pirate" 
            LevelQuest = 1 
            NameQuest = "Area2Quest" 
            NameMon = "Swan Pirate"
            CFrameQuest = CFrame.new(635, 73, 919) 
            CFrameMon = CFrame.new(635, 73, 919)
        elseif MyLevel >= 875 and MyLevel <= 899 then 
            Mon = "Marine Lieutenant" 
            LevelQuest = 1 
            NameQuest = "MarineQuest3" 
            NameMon = "Marine Lieutenant"
            CFrameQuest = CFrame.new(-2441, 73, -3219) 
            CFrameMon = CFrame.new(-2552, 110, -3050)
        elseif MyLevel >= 900 and MyLevel <= 949 then 
            Mon = "Marine Captain" 
            LevelQuest = 2 
            NameQuest = "MarineQuest3" 
            NameMon = "Marine Captain"
            CFrameQuest = CFrame.new(-2441, 73, -3219) 
            CFrameMon = CFrame.new(-1695, 110, -3299)
        elseif MyLevel >= 950 and MyLevel <= 974 then 
            Mon = "Zombie" 
            LevelQuest = 1 
            NameQuest = "ZombieQuest" 
            NameMon = "Zombie"
            CFrameQuest = CFrame.new(-5495, 48, -794) 
            CFrameMon = CFrame.new(-5715, 90, -917)
        elseif MyLevel >= 975 and MyLevel <= 999 then 
            Mon = "Vampire" 
            LevelQuest = 2 
            NameQuest = "ZombieQuest" 
            NameMon = "Vampire"
            CFrameQuest = CFrame.new(-5495, 48, -794) 
            CFrameMon = CFrame.new(-6027, 50, -1130)
        elseif MyLevel >= 1000 and MyLevel <= 1049 then 
            Mon = "Snow Trooper" 
            LevelQuest = 1 
            NameQuest = "SnowMountainQuest" 
            NameMon = "Snow Trooper"
            CFrameQuest = CFrame.new(607, 401, -5371) 
            CFrameMon = CFrame.new(445, 440, -5175)
        elseif MyLevel >= 1050 and MyLevel <= 1099 then 
            Mon = "Winter Warrior" 
            LevelQuest = 2 
            NameQuest = "SnowMountainQuest" 
            NameMon = "Winter Warrior"
            CFrameQuest = CFrame.new(607, 401, -5371) 
            CFrameMon = CFrame.new(1224, 460, -5332)
        elseif MyLevel >= 1100 and MyLevel <= 1124 then 
            Mon = "Lab Subordinate" 
            LevelQuest = 1 
            NameQuest = "IceSideQuest" 
            NameMon = "Lab Subordinate"
            CFrameQuest = CFrame.new(-6061, 16, -4904) 
            CFrameMon = CFrame.new(-5941, 50, -4322)
        elseif MyLevel >= 1125 and MyLevel <= 1174 then 
            Mon = "Horned Warrior" 
            LevelQuest = 2 
            NameQuest = "IceSideQuest" 
            NameMon = "Horned Warrior"
            CFrameQuest = CFrame.new(-6061, 16, -4904) 
            CFrameMon = CFrame.new(-6306, 50, -5752)
        elseif MyLevel >= 1175 and MyLevel <= 1199 then 
            Mon = "Magma Ninja" 
            LevelQuest = 1 
            NameQuest = "FireSideQuest" 
            NameMon = "Magma Ninja"
            CFrameQuest = CFrame.new(-5430, 16, -5298) 
            CFrameMon = CFrame.new(-5233, 60, -6227)
        elseif MyLevel >= 1200 and MyLevel <= 1249 then 
            Mon = "Lava Pirate" 
            LevelQuest = 2 
            NameQuest = "FireSideQuest" 
            NameMon = "Lava Pirate"
            CFrameQuest = CFrame.new(-5430, 16, -5298) 
            CFrameMon = CFrame.new(-4955, 60, -4836)
        elseif MyLevel >= 1250 and MyLevel <= 1274 then 
            Mon = "Ship Deckhand" 
            LevelQuest = 1 
            NameQuest = "ShipQuest1" 
            NameMon = "Ship Deckhand"
            CFrameQuest = CFrame.new(1033, 125, 32909) 
            CFrameMon = CFrame.new(1033, 125, 32909)
        elseif MyLevel >= 1275 and MyLevel <= 1299 then 
            Mon = "Ship Engineer" 
            LevelQuest = 2 
            NameQuest = "ShipQuest1" 
            NameMon = "Ship Engineer"
            CFrameQuest = CFrame.new(1033, 125, 32909) 
            CFrameMon = CFrame.new(809, 80, 33090)
        elseif MyLevel >= 1300 and MyLevel <= 1324 then 
            Mon = "Ship Steward" 
            LevelQuest = 1 
            NameQuest = "ShipQuest2" 
            NameMon = "Ship Steward"
            CFrameQuest = CFrame.new(973, 125, 33245) 
            CFrameMon = CFrame.new(838, 160, 33408)
        elseif MyLevel >= 1325 and MyLevel <= 1349 then 
            Mon = "Ship Officer" 
            LevelQuest = 2 
            NameQuest = "ShipQuest2" 
            NameMon = "Ship Officer"
            CFrameQuest = CFrame.new(973, 125, 33245) 
            CFrameMon = CFrame.new(1238, 220, 33148)
        elseif MyLevel >= 1350 and MyLevel <= 1374 then 
            Mon = "Arctic Warrior" 
            LevelQuest = 1 
            NameQuest = "FrostQuest" 
            NameMon = "Arctic Warrior"
            CFrameQuest = CFrame.new(5668, 28, -6484) 
            CFrameMon = CFrame.new(5836, 80, -6257)
        elseif MyLevel >= 1375 and MyLevel <= 1424 then 
            Mon = "Snow Lurker" 
            LevelQuest = 2 
            NameQuest = "FrostQuest" 
            NameMon = "Snow Lurker"
            CFrameQuest = CFrame.new(5668, 28, -6484) 
            CFrameMon = CFrame.new(5700, 80, -6724)
        elseif MyLevel >= 1425 and MyLevel <= 1449 then 
            Mon = "Sea Soldier" 
            LevelQuest = 1 
            NameQuest = "ForgottenQuest" 
            NameMon = "Sea Soldier"
            CFrameQuest = CFrame.new(-3056, 240, -10145) 
            CFrameMon = CFrame.new(-2583, 80, -9821)
        elseif MyLevel >= 1450 then 
            Mon = "Water Fighter" 
            LevelQuest = 2 
            NameQuest = "ForgottenQuest" 
            NameMon = "Water Fighter"
            CFrameQuest = CFrame.new(-3056, 240, -10145) 
            CFrameMon = CFrame.new(-3339, 290, -10412)
        end
    elseif World3 then
        if MyLevel >= 1500 and MyLevel <= 1524 then 
            Mon = "Pirate Millionaire" 
            LevelQuest = 1 
            NameQuest = "PiratePortQuest" 
            NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-291, 44, 5580) 
            CFrameMon = CFrame.new(-44, 70, 5623)
        elseif MyLevel >= 1525 and MyLevel <= 1574 then 
            Mon = "Pistol Billionaire" 
            LevelQuest = 2 
            NameQuest = "PiratePortQuest" 
            NameMon = "Pistol Billionaire"
            CFrameQuest = CFrame.new(-291, 44, 5580) 
            CFrameMon = CFrame.new(219, 105, 6018)
            elseif MyLevel >= 1575 and MyLevel <= 1599 then 
            Mon = "Dragon Crew Warrior" 
            LevelQuest = 1 
            NameQuest = "AmazonQuest" 
            NameMon = "Dragon Crew Warrior"
            CFrameQuest = CFrame.new(5834, 51, -1103) 
            CFrameMon = CFrame.new(5992, 90, -1581)
        elseif MyLevel >= 1600 and MyLevel <= 1624 then 
            Mon = "Dragon Crew Archer" 
            LevelQuest = 2 
            NameQuest = "AmazonQuest" 
            NameMon = "Dragon Crew Archer"
            CFrameQuest = CFrame.new(5834, 51, -1103) 
            CFrameMon = CFrame.new(6472, 370, -151)
        elseif MyLevel >= 1625 and MyLevel <= 1649 then 
            Mon = "Female Islander" 
            LevelQuest = 1 
            NameQuest = "AmazonQuest2" 
            NameMon = "Female Islander"
            CFrameQuest = CFrame.new(5448, 602, 748) 
            CFrameMon = CFrame.new(4836, 740, 928)
        elseif MyLevel >= 1650 and MyLevel <= 1699 then 
            Mon = "Giant Islander" 
            LevelQuest = 2 
            NameQuest = "AmazonQuest2" 
            NameMon = "Giant Islander"
            CFrameQuest = CFrame.new(5448, 602, 748) 
            CFrameMon = CFrame.new(4784, 660, 155)
        elseif MyLevel >= 1700 and MyLevel <= 1724 then 
            Mon = "Marine Commodore" 
            LevelQuest = 1 
            NameQuest = "MarineTreeIsland" 
            NameMon = "Marine Commodore"
            CFrameQuest = CFrame.new(2180, 29, -6738) 
            CFrameMon = CFrame.new(3156, 120, -7837)
        elseif MyLevel >= 1725 and MyLevel <= 1774 then 
            Mon = "Marine Rear Admiral" 
            LevelQuest = 2 
            NameQuest = "MarineTreeIsland" 
            NameMon = "Marine Rear Admiral"
            CFrameQuest = CFrame.new(2180, 29, -6738) 
            CFrameMon = CFrame.new(3205, 120, -6742)
        elseif MyLevel >= 1775 and MyLevel <= 1799 then 
            Mon = "Fishman Raider" 
            LevelQuest = 1 
            NameQuest = "DeepForestIsland3" 
            NameMon = "Fishman Raider"
            CFrameQuest = CFrame.new(-10581, 332, -8758) 
            CFrameMon = CFrame.new(-10550, 380, -8574)
        elseif MyLevel >= 1800 and MyLevel <= 1824 then 
            Mon = "Fishman Captain" 
            LevelQuest = 2 
            NameQuest = "DeepForestIsland3" 
            NameMon = "Fishman Captain"
            CFrameQuest = CFrame.new(-10581, 332, -8758) 
            CFrameMon = CFrame.new(-10764, 380, -8799)
        elseif MyLevel >= 1825 and MyLevel <= 1849 then 
            Mon = "Forest Pirate" 
            LevelQuest = 1 
            NameQuest = "DeepForestIsland" 
            NameMon = "Forest Pirate"
            CFrameQuest = CFrame.new(-13233, 332, -7626) 
            CFrameMon = CFrame.new(-13335, 380, -7660)
        elseif MyLevel >= 1850 and MyLevel <= 1899 then 
            Mon = "Mythological Pirate" 
            LevelQuest = 2 
            NameQuest = "DeepForestIsland" 
            NameMon = "Mythological Pirate"
            CFrameQuest = CFrame.new(-13233, 332, -7626) 
            CFrameMon = CFrame.new(-13844, 520, -7016)
        elseif MyLevel >= 1900 and MyLevel <= 1924 then 
            Mon = "Jungle Pirate" 
            LevelQuest = 1 
            NameQuest = "DeepForestIsland2" 
            NameMon = "Jungle Pirate"
            CFrameQuest = CFrame.new(-12682, 391, -9901) 
            CFrameMon = CFrame.new(-12166, 380, -10375)
        elseif MyLevel >= 1925 and MyLevel <= 1974 then 
            Mon = "Musketeer Pirate" 
            LevelQuest = 2 
            NameQuest = "DeepForestIsland2" 
            NameMon = "Musketeer Pirate"
            CFrameQuest = CFrame.new(-12682, 391, -9901) 
            CFrameMon = CFrame.new(-13098, 450, -9831)
        elseif MyLevel >= 1975 and MyLevel <= 1999 then 
            Mon = "Reborn Skeleton" 
            LevelQuest = 1 
            NameQuest = "HauntedQuest1" 
            NameMon = "Reborn Skeleton"
            CFrameQuest = CFrame.new(-9481, 142, 5565) 
            CFrameMon = CFrame.new(-8680, 190, 5852)
        elseif MyLevel >= 2000 and MyLevel <= 2024 then 
            Mon = "Living Zombie" 
            LevelQuest = 2 
            NameQuest = "HauntedQuest1" 
            NameMon = "Living Zombie"
            CFrameQuest = CFrame.new(-9481, 142, 5565) 
            CFrameMon = CFrame.new(-10144, 140, 5932)
        elseif MyLevel >= 2025 and MyLevel <= 2049 then 
            Mon = "Demonic Soul" 
            LevelQuest = 1 
            NameQuest = "HauntedQuest2" 
            NameMon = "Demonic Soul"
            CFrameQuest = CFrame.new(-9515, 172, 6078) 
            CFrameMon = CFrame.new(-9275, 210, 6166)
        elseif MyLevel >= 2050 and MyLevel <= 2074 then 
            Mon = "Posessed Mummy" 
            LevelQuest = 2 
            NameQuest = "HauntedQuest2" 
            NameMon = "Posessed Mummy"
            CFrameQuest = CFrame.new(-9515, 172, 6078) 
            CFrameMon = CFrame.new(-9442, 60, 6304)
        elseif MyLevel >= 2075 and MyLevel <= 2099 then 
            Mon = "Peanut Scout" 
            LevelQuest = 1 
            NameQuest = "NutsIslandQuest" 
            NameMon = "Peanut Scout"
            CFrameQuest = CFrame.new(-2104, 38, -10194) 
            CFrameMon = CFrame.new(-1870, 100, -10225)
        elseif MyLevel >= 2100 and MyLevel <= 2124 then 
            Mon = "Peanut President" 
            LevelQuest = 2 
            NameQuest = "NutsIslandQuest" 
            NameMon = "Peanut President"
            CFrameQuest = CFrame.new(-2104, 38, -10194) 
            CFrameMon = CFrame.new(-2005, 100, -10585)
        elseif MyLevel >= 2125 and MyLevel <= 2149 then 
            Mon = "Ice Cream Chef" 
            LevelQuest = 1 
            NameQuest = "IceCreamIslandQuest" 
            NameMon = "Ice Cream Chef"
            CFrameQuest = CFrame.new(-818, 66, -10964) 
            CFrameMon = CFrame.new(-501, 100, -10883)
        elseif MyLevel >= 2150 and MyLevel <= 2199 then 
            Mon = "Ice Cream Commander" 
            LevelQuest = 2 
            NameQuest = "IceCreamIslandQuest" 
            NameMon = "Ice Cream Commander"
            CFrameQuest = CFrame.new(-818, 66, -10964) 
            CFrameMon = CFrame.new(-690, 100, -11350)
        elseif MyLevel >= 2200 and MyLevel <= 2224 then 
            Mon = "Cookie Crafter" 
            LevelQuest = 1 
            NameQuest = "CakeQuest1" 
            NameMon = "Cookie Crafter"
            CFrameQuest = CFrame.new(-2023, 38, -12028) 
            CFrameMon = CFrame.new(-2332, 90, -12049)
        elseif MyLevel >= 2225 and MyLevel <= 2249 then 
            Mon = "Cake Guard" 
            LevelQuest = 2 
            NameQuest = "CakeQuest1" 
            NameMon = "Cake Guard"
            CFrameQuest = CFrame.new(-2023, 38, -12028) 
            CFrameMon = CFrame.new(-1514, 90, -12422)
        elseif MyLevel >= 2250 and MyLevel <= 2274 then 
            Mon = "Baking Staff" 
            LevelQuest = 1 
            NameQuest = "CakeQuest2" 
            NameMon = "Baking Staff"
            CFrameQuest = CFrame.new(-1931, 38, -12840) 
            CFrameMon = CFrame.new(-1930, 90, -12963)
        elseif MyLevel >= 2275 and MyLevel <= 2299 then 
            Mon = "Head Baker" 
            LevelQuest = 2 
            NameQuest = "CakeQuest2" 
            NameMon = "Head Baker"
            CFrameQuest = CFrame.new(-1931, 38, -12840) 
            CFrameMon = CFrame.new(-2123, 110, -12777)
        elseif MyLevel >= 2300 and MyLevel <= 2324 then 
            Mon = "Cocoa Warrior" 
            LevelQuest = 1 
            NameQuest = "ChocQuest1" 
            NameMon = "Cocoa Warrior"
            CFrameQuest = CFrame.new(235, 25, -12199) 
            CFrameMon = CFrame.new(110, 80, -12245)
        elseif MyLevel >= 2325 and MyLevel <= 2349 then 
            Mon = "Chocolate Bar Battler" 
            LevelQuest = 2 
            NameQuest = "ChocQuest1" 
            NameMon = "Chocolate Bar Battler"
            CFrameQuest = CFrame.new(235, 25, -12199) 
            CFrameMon = CFrame.new(579, 80, -12413)
        elseif MyLevel >= 2350 and MyLevel <= 2374 then 
            Mon = "Sweet Thief" 
            LevelQuest = 1 
            NameQuest = "ChocQuest2" 
            NameMon = "Sweet Thief"
            CFrameQuest = CFrame.new(150, 25, -12777) 
            CFrameMon = CFrame.new(-68, 80, -12692)
        elseif MyLevel >= 2375 and MyLevel <= 2399 then 
            Mon = "Candy Rebel" 
            LevelQuest = 2 
            NameQuest = "ChocQuest2" 
            NameMon = "Candy Rebel"
            CFrameQuest = CFrame.new(150, 25, -12777) 
            CFrameMon = CFrame.new(17, 80, -12962)
        elseif MyLevel >= 2400 and MyLevel <= 2424 then 
            Mon = "Candy Pirate" 
            LevelQuest = 1 
            NameQuest = "CandyQuest1" 
            NameMon = "Candy Pirate"
            CFrameQuest = CFrame.new(-1148, 14, -14446) 
            CFrameMon = CFrame.new(-1371, 70, -14405)
        elseif MyLevel >= 2425 and MyLevel <= 2449 then 
            Mon = "Snow Demon" 
            LevelQuest = 2 
            NameQuest = "CandyQuest1" 
            NameMon = "Snow Demon"
            CFrameQuest = CFrame.new(-1148, 14, -14446) 
            CFrameMon = CFrame.new(-836, 70, -14326)
        elseif MyLevel >= 2450 and MyLevel <= 2474 then 
            Mon = "Isle Outlaw" 
            LevelQuest = 1 
            NameQuest = "TikiQuest1" 
            NameMon = "Isle Outlaw"
            CFrameQuest = CFrame.new(-16547, 56, -172) 
            CFrameMon = CFrame.new(-16431, 90, -223)
        elseif MyLevel >= 2475 and MyLevel <= 2499 then 
            Mon = "Island Boy" 
            LevelQuest = 2 
            NameQuest = "TikiQuest1" 
            NameMon = "Island Boy"
            CFrameQuest = CFrame.new(-16547, 56, -172) 
            CFrameMon = CFrame.new(-16668, 70, -243)
        elseif MyLevel >= 2500 and MyLevel <= 2524 then 
            Mon = "Sun-kissed Warrior" 
            LevelQuest = 1 
            NameQuest = "TikiQuest2" 
            NameMon = "Sun-kissed Warrior"
            CFrameQuest = CFrame.new(-16540, 56, 1051) 
            CFrameMon = CFrame.new(-16345, 80, 1004)
        elseif MyLevel >= 2525 and MyLevel <= 2549 then 
            Mon = "Isle Champion" 
            LevelQuest = 2 
            NameQuest = "TikiQuest2" 
            NameMon = "Isle Champion"
            CFrameQuest = CFrame.new(-16540, 56, 1051) 
            CFrameMon = CFrame.new(-16634, 85, 1106)
        elseif MyLevel >= 2550 and MyLevel <= 2574 then 
            Mon = "Serpent Hunter" 
            LevelQuest = 1 
            NameQuest = "TikiQuest3" 
            NameMon = "Serpent Hunter"
            CFrameQuest = CFrame.new(-16665, 105, 1580) 
            CFrameMon = CFrame.new(-16542.4824, 146.675156, 1529.61401, -0.999948919, 1.0729811e-8, 0.0101067368, 1.0128324e-8, 1, -5.9564663e-8, -0.0101067368, -5.9459257e-8, -0.999948919)
        elseif MyLevel >= 2575 and MyLevel <= 2600 then 
            Mon = "Skull Slayer" 
            LevelQuest = 2 
            NameQuest = "TikiQuest3" 
            NameMon = "Skull Slayer"
            CFrameQuest = CFrame.new(-16665, 105, 1580) 
            CFrameMon = CFrame.new(-16849.9336, 147.005066, 1640.88354, 0.470148534, 0.491874039, -0.732816696, 1.72165e-8, 0.83030504, 0.55730921, 0.882587314, -0.262018114, 0.390366673)
        elseif MyLevel >= 2600 and MyLevel <= 2624 then 
            Mon = "Reef Bandit" 
            LevelQuest = 1 
            NameQuest = "SubmergedQuest1" 
            NameMon = "Reef Bandit"
            CFrameQuest = CFrame.new(10882.264, -2086.322, 10034.226) 
            CFrameMon = CFrame.new(10736.6191, -2087.8439, 9338.4882)
        elseif MyLevel >= 2625 and MyLevel <= 2649 then 
            Mon = "Coral Pirate" 
            LevelQuest = 2 
            NameQuest = "SubmergedQuest1" 
            NameMon = "Coral Pirate"
            CFrameQuest = CFrame.new(10882.264, -2086.322, 10034.226) 
            CFrameMon = CFrame.new(10965.1025, -2158.8842, 9177.2597)
        elseif MyLevel >= 2650 and MyLevel <= 2674 then 
            Mon = "Sea Chanter" 
            LevelQuest = 1 
            NameQuest = "SubmergedQuest2" 
            NameMon = "Sea Chanter"
            CFrameQuest = CFrame.new(10882.264, -2086.322, 10034.226) 
            CFrameMon = CFrame.new(10621.0342, -2087.8440, 10102.0332)
        elseif MyLevel >= 2675 and MyLevel <= 2699 then 
            Mon = "Ocean Prophet" 
            LevelQuest = 2 
            NameQuest = "SubmergedQuest2" 
            NameMon = "Ocean Prophet"
            CFrameQuest = CFrame.new(10882.264, -2086.322, 10034.226) 
            CFrameMon = CFrame.new(11056.1445, -2001.6717, 10117.4493)
        elseif MyLevel >= 2700 and MyLevel <= 2724 then 
            Mon = "High Disciple" 
            LevelQuest = 1 
            NameQuest = "SubmergedQuest3" 
            NameMon = "High Disciple"
            CFrameQuest = CFrame.new(9636.52441, -1992.19507, 9609.52832) 
            CFrameMon = CFrame.new(9828.087890625, -1940.908935546875, 9693.0634765625)
        elseif MyLevel >= 2725 then 
            Mon = "Grand Devotee" 
            LevelQuest = 2 
            NameQuest = "SubmergedQuest3" 
            NameMon = "Grand Devotee"
            CFrameQuest = CFrame.new(9636.52441, -1992.19507, 9609.52832) 
            CFrameMon = CFrame.new(9557.5849609375, -1928.0404052734375, 9859.1826171875)
        end
    end
    return Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
end

local FSOrder = {
    {name = "Dark Step", buy = "BuyDarkStep", reqLevel = 80, reqBeli = 150000, cframe = CFrame.new(-987, 5, 3837), masterReq = 400,
     upgrade = "Death Step", buyUpgrade = "BuyDeathStep", reqLevelUp = 1100, reqFrag = 5000, reqBeliUp = 2500000, cframeUp = CFrame.new(-3620, 15, -3500), masterReqUp = 400},
    {name = "Electric", buy = "BuyElectro", reqLevel = 300, reqBeli = 500000, cframe = CFrame.new(-5411, 31, -2950), masterReq = 400,
     upgrade = "Electric Claw", buyUpgrade = "BuyElectricClaw", reqLevelUp = 1100, reqFrag = 3000, reqBeliUp = 3000000, cframeUp = CFrame.new(-10372, 332, -8200), masterReqUp = 400},
    {name = "Water Kung Fu", buy = "BuyFishmanKarate", reqLevel = 400, reqBeli = 750000, cframe = CFrame.new(61581, 19, 1189), masterReq = 400,
     upgrade = "Sharkman Karate", buyUpgrade = "BuySharkmanKarate", reqLevelUp = 1450, reqFrag = 5000, reqBeliUp = 2500000, cframeUp = CFrame.new(-4317, 17, -4945), masterReqUp = 400},
    {name = "Dragon Breath", buy = "BuyDragonClaw", reqLevel = 1100, reqBeli = 1500000, cframe = CFrame.new(3820, 5, -3700), masterReq = 400,
     upgrade = "Dragon Talon", buyUpgrade = "BuyDragonTalon", reqLevelUp = 1450, reqFrag = 3000, reqBeliUp = 3000000, cframeUp = CFrame.new(-255, 7, -1500), masterReqUp = 400},
}

local currentMelee = "Combat"

task.spawn(function()
    while task.wait(5) do
        local hasAllUpgraded = true
        for _, fs in ipairs(FSOrder) do
            local tool = player.Backpack:FindFirstChild(fs.name) or character:FindFirstChild(fs.name)
            if not tool then
                if Level.Value >= fs.reqLevel and Beli.Value >= fs.reqBeli then
                    rootPart.CFrame = fs.cframe
                    task.wait(1)
                    fireRemote(fs.buy)
                end
                hasAllUpgraded = false
                break
            end
            local mastery = tool:FindFirstChild("Level") and tool.Level.Value or 0
            if mastery < fs.masterReq then
                currentMelee = fs.name
                hasAllUpgraded = false
                break
            end
            local upTool = player.Backpack:FindFirstChild(fs.upgrade) or character:FindFirstChild(fs.upgrade)
            if not upTool then
                if Level.Value >= fs.reqLevelUp and Fragments.Value >= fs.reqFrag and Beli.Value >= fs.reqBeliUp then
                    rootPart.CFrame = fs.cframeUp
                    task.wait(1)
                    fireRemote(fs.buyUpgrade)
                end
                hasAllUpgraded = false
                break
            end
            local upMastery = upTool:FindFirstChild("Level") and upTool.Level.Value or 0
            if upMastery < fs.masterReqUp then
                currentMelee = fs.upgrade
                hasAllUpgraded = false
                break
            end
        end
        if hasAllUpgraded then
            local god = player.Backpack:FindFirstChild("Godhuman") or character:FindFirstChild("Godhuman")
            if not god and Level.Value >= 1900 and Fragments.Value >= 5000 and Beli.Value >= 5000000 then
                rootPart.CFrame = CFrame.new(-10372, 332, -8200)
                task.wait(1.2)
                fireRemote("BuyGodhuman")
            elseif god and god:FindFirstChild("Level") and god.Level.Value < 600 then
                currentMelee = "Godhuman"
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local Mon, LvlQ, NQ, NM, CQ, CM = getQuestInfo()
            if not player.PlayerGui.Main.Quest.Visible or not player.PlayerGui.Main.Quest.Title.Text:find(NQ or "") then
                rootPart.CFrame = CQ * CFrame.new(0, -3, 5)
                task.wait(0.6)
                fireRemote("StartQuest", NQ, LvlQ)
                task.wait(0.6)
            end
            local offset = Vector3.new(math.random(-45,45), 0, math.random(-45,45))
            rootPart.CFrame = CM * CFrame.new(0, 55, 0) * offset

            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy.Name == NM and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    enemy.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, -10, math.random(-4,4))
                    enemy.HumanoidRootPart.CanCollide = false
                    enemy.Humanoid.WalkSpeed = 0
                end
            end

            local tool = player.Backpack:FindFirstChild(currentMelee)
            if tool and not character:FindFirstChild(currentMelee) then
                humanoid:EquipTool(tool)
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1.8) do
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj:FindFirstChild("Handle") and (obj.Name:lower():find("fruit") or obj.Name:lower():find("devil")) then
                pcall(function()
                    obj.Parent = player.Backpack
                    fireRemote("StoreFruit", obj.Name, obj.Handle)
                end)
            end
        end
    end
end)

local sg = Instance.new("ScreenGui")
sg.Name = "DodgeHubUI"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 320)
frame.Position = UDim2.new(0.5, -140, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
frame.BorderColor3 = Color3.fromRGB(255, 180, 50)
frame.BorderSizePixel = 2
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
title.Text = "Dodge Hub"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.Parent = frame

local labels = {}

local items = {
    {"God Human", "Godhuman"},
    {"CDK", "Cursed Dual Katana"},
    {"Soul Guitar", "Soul Guitar"},
    {"Valkyrie do Rip Indra", "Valkyrie Helm"},
    {"Mirror Fractal", nil}  -- especial, checa fragments
}

for i, data in ipairs(items) do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.9, 0, 0, 28)
    lbl.Position = UDim2.new(0.05, 0, 0.12 + (i-1)*0.09, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 16
    lbl.Text = data[1] .. ": 🔴"
    lbl.Parent = frame
    labels[data[1]] = lbl
end

local beliLbl = Instance.new("TextLabel")
beliLbl.Size = UDim2.new(0.9, 0, 0, 28)
beliLbl.Position = UDim2.new(0.05, 0, 0.65, 0)
beliLbl.BackgroundTransparency = 1
beliLbl.TextXAlignment = Enum.TextXAlignment.Left
beliLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
beliLbl.Font = Enum.Font.GothamSemibold
beliLbl.TextSize = 16
beliLbl.Text = "Beli: 0"
beliLbl.Parent = frame
labels["Beli"] = beliLbl

local fragLbl = Instance.new("TextLabel")
fragLbl.Size = UDim2.new(0.9, 0, 0, 28)
fragLbl.Position = UDim2.new(0.05, 0, 0.74, 0)
fragLbl.BackgroundTransparency = 1
fragLbl.TextXAlignment = Enum.TextXAlignment.Left
fragLbl.TextColor3 = Color3.fromRGB(180, 220, 255)
fragLbl.Font = Enum.Font.GothamSemibold
fragLbl.TextSize = 16
fragLbl.Text = "Fragments: 0"
fragLbl.Parent = frame
labels["Fragments"] = fragLbl

-- Atualização de status a cada ~2s
task.spawn(function()
    while task.wait(2) do
        local bp = player.Backpack
        local char = character

        labels["God Human"].Text = "God Human: " .. ((bp:FindFirstChild("Godhuman") or char:FindFirstChild("Godhuman")) and "🟢" or "🔴")
        labels["CDK"].Text = "CDK: " .. ((bp:FindFirstChild("Cursed Dual Katana") or char:FindFirstChild("Cursed Dual Katana")) and "🟢" or "🔴")
        labels["Soul Guitar"].Text = "Soul Guitar: " .. ((bp:FindFirstChild("Soul Guitar") or char:FindFirstChild("Soul Guitar")) and "🟢" or "🔴")
        labels["Valkyrie do Rip Indra"].Text = "Valkyrie do Rip Indra: " .. ((bp:FindFirstChild("Valkyrie Helm") or char:FindFirstChild("Valkyrie Helm")) and "🟢" or "🔴")
        labels["Mirror Fractal"].Text = "Mirror Fractal: " .. (Fragments.Value >= 5000 and "🟢" or "🔴")

        labels["Beli"].Text = "Beli: " .. tostring(Beli.Value or 0)
        labels["Fragments"].Text = "Fragments: " .. tostring(Fragments.Value or 0)
    end
end)
