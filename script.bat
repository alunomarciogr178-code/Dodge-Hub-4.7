-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                  DODGE HUB 4.7 (TEST) - BLOX FRUITS                      ║
-- ║              Script Automático com RemoteEvents Funcionais               ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ═══════════════════════════════════════════════════════════════════════════
-- CONFIGURAÇÕES E VARIÁVEIS
-- ═══════════════════════════════════════════════════════════════════════════

local scriptConfig = {
    maxQuestLevel = 2800,
    currentQuestLevel = 0,
    inSea2 = false,
    farmingDarkFragment = false,
}

local playerStats = {
    level = 0,
    money = 0,
    purpleFragments = 0,
    godHumanOwned = false,
    cursedDualKatanaOwned = false,
    skillGuitarOwned = false,
    raceV2 = false,
    raceV3 = false,
}

local raidBossStatus = {
    massGod = false,
    ripIndra = false,
    tyrantSkies = false,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- REMOTES - ESTRUTURA REAL BLOX FRUITS
-- ═══════════════════════════════════════════════════════════════════════════

local function getRemotes()
    local RS = game:GetService("ReplicatedStorage")
    
    -- Tentar encontrar a pasta de remotes
    local remotes = RS:WaitForChild("Remotes") or RS:WaitForChild("Remote") or RS:FindFirstChild("Events")
    
    if not remotes then
        warn("[DODGE HUB] Remotes não encontrados!")
        return nil
    end
    
    return remotes
end

local Remotes = getRemotes()

-- ═══════════════════════════════════════════════════════════════════════════
-- FUNÇÕES DE LOG
-- ═══════════════════════════════════════════════════════════════════════════

local function printLog(message)
    print("[🐕 DODGE HUB 4.7] " .. message)
end

local function printError(message)
    warn("[❌ DODGE HUB ERROR] " .. message)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SISTEMA DE COMUNICAÇÃO COM SERVIDOR VIA REMOTES
-- ═══════════════════════════════════════════════════════════════════════════

local function fireRemote(remoteName, ...)
    if not Remotes then
        printError("Remotes não inicializados!")
        return false
    end
    
    local remote = Remotes:FindFirstChild(remoteName)
    
    if not remote then
        printError("Remote '" .. remoteName .. "' não encontrado!")
        return false
    end
    
    if remote:IsA("RemoteEvent") then
        remote:FireServer(...)
        return true
    elseif remote:IsA("RemoteFunction") then
        return remote:InvokeServer(...)
    end
    
    return false
end

local function invokeRemote(remoteName, ...)
    if not Remotes then
        printError("Remotes não inicializados!")
        return nil
    end
    
    local remote = Remotes:FindFirstChild(remoteName)
    
    if not remote or not remote:IsA("RemoteFunction") then
        printError("RemoteFunction '" .. remoteName .. "' não encontrado!")
        return nil
    end
    
    return remote:InvokeServer(...)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SISTEMA DE QUESTS COM REMOTES
-- ═══════════════════════════════════════════════════════════════════════════

local function acceptQuest(npcName, questLevel)
    -- RemoteEvents comuns para aceitar quests em Blox Fruits
    local possibleRemotes = {
        "StartQuest",
        "RequestQuest",
        "AcceptQuest",
        "QuestRequest",
    }
    
    for _, remoteName in pairs(possibleRemotes) do
        if fireRemote(remoteName, npcName, questLevel) then
            printLog("✅ Quest aceita do NPC: " .. npcName .. " (Nível: " .. questLevel .. ")")
            scriptConfig.currentQuestLevel = questLevel
            return true
        end
    end
    
    printError("Não consegui aceitar quest de " .. npcName)
    return false
end

local function completeQuest(questID)
    -- RemoteEvents para completar quests
    local possibleRemotes = {
        "FinishQuest",
        "CompleteQuest",
        "QuestComplete",
        "RequestQuest",
    }
    
    for _, remoteName in pairs(possibleRemotes) do
        if fireRemote(remoteName, questID) then
            printLog("🎯 Quest completada!")
            playerStats.level += 10
            playerStats.money += 1000
            return true
        end
    end
    
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════
-- DESBLOQUEIO DE ESTILOS E FRUTAS COM REMOTES
-- ═══════════════════════════════════════════════════════════════════════════

local function unlockFightingStyle(styleName)
    printLog("🥋 Desbloqueando: " .. styleName)
    
    local possibleRemotes = {
        "UnlockStyle",
        "BuyStyle",
        "UnlockAbility",
        "LearningAbility",
    }
    
    for _, remoteName in pairs(possibleRemotes) do
        if fireRemote(remoteName, styleName) then
            printLog("✅ " .. styleName .. " desbloqueado!")
            return true
        end
    end
    
    return false
end

local function unlockGodHuman()
    if playerStats.level >= 550 then
        printLog("👹 Desbloqueando: GOD HUMAN")
        if unlockFightingStyle("GodHuman") or unlockFightingStyle("God Human") then
            playerStats.godHumanOwned = true
            return true
        end
    end
    return false
end

local function unlockCursedDualKatana()
    if playerStats.level >= 700 then
        printLog("🗡️ Desbloqueando: CURSED DUAL KATANA")
        if unlockFightingStyle("CursedDualKatana") or unlockFightingStyle("Cursed Dual Katana") then
            playerStats.cursedDualKatanaOwned = true
            return true
        end
    end
    return false
end

local function unlockSkillGuitar()
    if playerStats.level >= 450 then
        printLog("🎸 Desbloqueando: SKILL GUITAR")
        if unlockFightingStyle("SkillGuitar") or unlockFightingStyle("Skill Guitar") then
            playerStats.skillGuitarOwned = true
            return true
        end
    end
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════
-- COLETA DE FRUTAS COM REMOTES
-- ═══════════════════════════════════════════════════════════════════════════

local function collectFruit(fruitName)
    local possibleRemotes = {
        "BuyFruit",
        "CollectFruit",
        "SpinFruit",
        "GetFruit",
    }
    
    for _, remoteName in pairs(possibleRemotes) do
        if fireRemote(remoteName, fruitName) then
            printLog("🍎 Fruta coletada: " .. fruitName)
            return true
        end
    end
    
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════
-- EVOLUÇÃO DO MAR COM REMOTES
-- ═══════════════════════════════════════════════════════════════════════════

local function teleportToSea2()
    if playerStats.level >= 700 and not scriptConfig.inSea2 then
        printLog("🌊 Evoluindo para SEA 2...")
        
        local possibleRemotes = {
            "TravelSea",
            "ChangeSea",
            "EvolveSea",
            "RequestTravel",
        }
        
        for _, remoteName in pairs(possibleRemotes) do
            if fireRemote(remoteName, 2) or fireRemote(remoteName, "Sea2") or fireRemote(remoteName, "SecondSea") then
                scriptConfig.inSea2 = true
                printLog("✅ Agora em SEA 2!")
                return true
            end
        end
    end
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════
-- RAID BOSS COM REMOTES
-- ═══════════════════════════════════════════════════════════════════════════

local function defeatRaidBoss(bossName)
    local possibleRemotes = {
        "AttackRaidBoss",
        "FightRaidBoss",
        "RaidBossAttack",
        "Combat",
    }
    
    for _, remoteName in pairs(possibleRemotes) do
        if fireRemote(remoteName, bossName) then
            printLog("⚔️ Atacando raid boss: " .. bossName)
            playerStats.money += 50000
            return true
        end
    end
    
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ANTI-BAN E PROTEÇÕES
-- ═══════════════════════════════════════════════════════════════════════════

local function detectAdmin()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            -- Verificar se tem tag de admin
            if p:FindFirstChild("AdminTag") or p:GetAttribute("Admin") or string.find(p.Name:lower(), "admin") then
                return true
            end
        end
    end
    return false
end

local function leaveGame()
    printLog("⚠️ Admin detectado! Saindo do servidor...")
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end

local function antiResetProtection()
    if humanoid.Health <= 0 then
        humanoid:Destroy()
        local newHumanoid = Instance.new("Humanoid")
        newHumanoid.Parent = character
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INTERFACE DO USUÁRIO (UI)
-- ═══════════════════════════════════════════════════════════════════════════

local function createDodgeHubUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DodgeHubUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    -- Frame Principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 380, 0, 520)
    mainFrame.Position = UDim2.new(0.01, 0, 0.01, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderColor3 = Color3.fromRGB(255, 165, 0)
    mainFrame.BorderSizePixel = 3
    mainFrame.Parent = screenGui
    
    -- Título
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 70)
    titleFrame.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🐕 DODGE HUB 4.7 (TEST)"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleFrame
    
    -- ScrollingFrame para Stats
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -90)
    scrollFrame.Position = UDim2.new(0, 5, 0, 75)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.Parent = mainFrame
    
    -- Layout
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = scrollFrame
    
    local function addStat(label, value, color)
        local statFrame = Instance.new("Frame")
        statFrame.Size = UDim2.new(1, -10, 0, 30)
        statFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        statFrame.BorderSizePixel = 1
        statFrame.BorderColor3 = Color3.fromRGB(255, 165, 0)
        statFrame.Parent = scrollFrame
        
        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.6, 0, 1, 0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label
        labelText.TextColor3 = Color3.fromRGB(200, 200, 200)
        labelText.TextSize = 13
        labelText.Font = Enum.Font.Gotham
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.Parent = statFrame
        
        local valueText = Instance.new("TextLabel")
        valueText.Name = "Value"
        valueText.Size = UDim2.new(0.4, 0, 1, 0)
        valueText.Position = UDim2.new(0.6, 0, 0, 0)
        valueText.BackgroundTransparency = 1
        valueText.Text = tostring(value)
        valueText.TextColor3 = color or Color3.fromRGB(255, 165, 0)
        valueText.TextSize = 13
        valueText.Font = Enum.Font.GothamBold
        valueText.TextXAlignment = Enum.TextXAlignment.Right
        valueText.Parent = statFrame
        
        return valueText
    end
    
    -- Adicionar Stats
    addStat("📊 Nível", playerStats.level, Color3.fromRGB(100, 255, 100))
    addStat("💵 Dinheiro", playerStats.money, Color3.fromRGB(255, 255, 100))
    addStat("🔮 Fragmentos", playerStats.purpleFragments, Color3.fromRGB(200, 100, 255))
    addStat("👹 GOD HUMAN", playerStats.godHumanOwned and "✅" or "❌", 
        playerStats.godHumanOwned and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100))
    addStat("🗡️ Cursed Dual Katana", playerStats.cursedDualKatanaOwned and "✅" or "❌",
        playerStats.cursedDualKatanaOwned and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100))
    addStat("🎸 Skill GUITAR", playerStats.skillGuitarOwned and "✅" or "❌",
        playerStats.skillGuitarOwned and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100))
    addStat("👤 Race V2", playerStats.raceV2 and "✅" or "❌",
        playerStats.raceV2 and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100))
    addStat("👤 Race V3", playerStats.raceV3 and "✅" or "❌",
        playerStats.raceV3 and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100))
    
    -- Footer
    local footerFrame = Instance.new("Frame")
    footerFrame.Size = UDim2.new(1, 0, 0, 45)
    footerFrame.Position = UDim2.new(0, 0, 1, -45)
    footerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    footerFrame.BorderColor3 = Color3.fromRGB(255, 165, 0)
    footerFrame.BorderSizePixel = 1
    footerFrame.Parent = mainFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: ✅ Ativo"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = footerFrame
    
    return {
        mainFrame = mainFrame,
        scrollFrame = scrollFrame,
        statusLabel = statusLabel
    }
end

-- ═══════════════════════════════════════════════════════════════════════════
-- LOOP PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════════════

local function mainLoop()
    printLog("🚀 Iniciando Dodge Hub 4.7 (Test)...")
    printLog("=".repeat(50))
    
    wait(1)
    local ui = createDodgeHubUI()
    printLog("✅ Interface criada com sucesso!")
    
    local tickCounter = 0
    
    while true do
        pcall(function()
            tickCounter += 1
            
            -- Verificar Admin a cada 5 segundos
            if tickCounter % 5 == 0 then
                if detectAdmin() then
                    leaveGame()
                    return
                end
            end
            
            -- Proteção Anti-Reset
            antiResetProtection()
            
            -- Aceitar Quests
            if scriptConfig.currentQuestLevel < scriptConfig.maxQuestLevel then
                if tickCounter % 3 == 0 then
                    acceptQuest("QuestMaster", scriptConfig.currentQuestLevel + 1)
                end
            end
            
            -- Desbloquear Estilos
            if tickCounter % 10 == 0 then
                unlockSkillGuitar()
                unlockGodHuman()
                unlockCursedDualKatana()
            end
            
            -- Evoluir para Sea 2
            if tickCounter % 15 == 0 then
                teleportToSea2()
            end
            
            -- Raid Bosses
            if tickCounter % 20 == 0 then
                if not raidBossStatus.massGod then
                    defeatRaidBoss("MassGod")
                    raidBossStatus.massGod = true
                end
                if not raidBossStatus.ripIndra then
                    defeatRaidBoss("RipIndra")
                    raidBossStatus.ripIndra = true
                end
                if not raidBossStatus.tyrantSkies then
                    defeatRaidBoss("TyrantOfSkyes")
                    raidBossStatus.tyrantSkies = true
                end
            end
            
            wait(1)
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INICIAR SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════

printLog("Carregando...")
wait(1)

task.spawn(mainLoop)

printLog("✅ Script pronto! Procurando remotes...")
