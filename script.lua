repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main")
repeat task.wait() until (game.Players.LocalPlayer.Neutral == false) == true

local __script__host = "http://110.164.203.137:3000"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MeleeRequestList = {
    ["Death Step"] = "BuyDeathStep",
    ["Sharkman Karate"] = "BuySharkmanKarate",
    ["Electric Claw"] = "BuyElectricClaw",
    ["Dragon Talon"] = "BuyDragonTalon",
    ["Godhuman"] = "BuyGodhuman",
    ["Super human"] = "BuySuperhuman",
    ["Sanguine Art"] = "BuySanguineArt"
}
function getLevel()
    return LocalPlayer.Data.Level.Value
end
function getWorld() 
	local placeId = game.PlaceId
	if placeId == 2753915549 then
		return 1
	elseif placeId == 4442272183 then
		return 2
	elseif placeId == 7449423635 then
		return 3
	end
end
function getItem(itemName) 
    for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v) == "table" then
            if v.Type == "Material" then
                if v.Name == itemName then
                    return true
                end
            end
        end
    end
    return false
end
function getFruitMastery()
    if game:GetService("Players").LocalPlayer.Data.DevilFruit.Value == '' then return 0 end
    if LocalPlayer:FindFirstChild("Backpack") then 
        for i,v in pairs(LocalPlayer:FindFirstChild("Backpack"):GetChildren()) do 
            if v.ToolTip == "Blox Fruit" then 
                if v:FindFirstChild("Level") then 
                    return v.Level.Value
                end
            end
        end
    end
    repeat wait() until LocalPlayer.Character
    if LocalPlayer.Character:FindFirstChildOfClass("Tool") then 
        local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if Tool.ToolTip == "Blox Fruit" then
            if Tool:FindFirstChild("Level") then 
                return Tool.Level.Value
            end
        end
    end
    return 0
end

function getFruitName()
    return string.split(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value,"-")[2] or "None"
end

function getAwakend()
    local SkillAWakenedList = {}
    local getAwakenedAbilitiesRequests = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getAwakenedAbilities")
    if getAwakenedAbilitiesRequests then
    for i, v in pairs(getAwakenedAbilitiesRequests) do
        if v["Awakened"] then 
                table.insert(SkillAWakenedList, i)
            end
        end
    end
    return SkillAWakenedList;
end

function getMeele()
    local MeleeName = {}
    local MeleeRequestList = {
        ["Death Step"] = "BuyDeathStep",
        ["Sharkman Karate"] = "BuySharkmanKarate",
        ["Electric Claw"] = "BuyElectricClaw",
        ["Dragon Talon"] = "BuyDragonTalon",
        ["Godhuman"] = "BuyGodhuman",
        ["Super human"] = "BuySuperhuman",
        ["Sanguine Art"] = "BuySanguineArt"
    }

    for meleeName, requestName in pairs(MeleeRequestList) do
        -- ตรวจสอบว่าผู้เล่นมี Melee นี้หรือไม่
        local hasMelee = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(requestName, true)
        if tonumber(hasMelee) == 1 then
            -- ค้นหา Melee ใน Backpack เพื่อดึง Mastery Level
            local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(meleeName)
            if tool and tool:FindFirstChild("Level") then
                local masteryLevel = tool.Level.Value  -- ดึงค่า Mastery Level
                table.insert(MeleeName, meleeName .. ":" .. masteryLevel)
            else
                -- ถ้าไม่มี Mastery Level ให้แสดงเฉพาะชื่อ
                table.insert(MeleeName, meleeName)
            end
        end
    end

    return MeleeName
end

function getSword()
    local SwordList, RequestGetInventory = {}, nil
    RequestGetInventory = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
    
    for _, v in pairs(RequestGetInventory) do
        if v['Type'] == "Sword" and v['Rarity'] >= 3 then
            local swordEntry = v['Name'] .. ":" .. tostring(v['Mastery'])  -- รูปแบบ Sword : Mastery
            table.insert(SwordList, swordEntry)
        end
    end
    
    return SwordList
end


function GetFruitInU()
    local ReturnText = {}
    local check = game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryFruits")
    if type(check) ~= "table" then
        return ReturnText
    end
    for i,v in pairs(check) do
        if type(v) == "table" then
            if v ~= nil then
                if v.Price >= 100000  then
                    table.insert(ReturnText,string.split(v.Name,"-")[2])
                end
            end
        end
    end
    return ReturnText
end
function len(x)
    local q = 0
    for i, v in pairs(x) do
        q = q + 1
    end
    return q
end
function findItem(item) 
    local RequestgetInventory;
    RequestgetInventory = game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventory")
    for i, __ in pairs(RequestgetInventory) do
        if __["Name"] == item then
            return true
        end
    end
    return false
end
function getType()
    local ReturnText = {}

    if findItem("Cursed Dual Katana") then 
        table.insert(ReturnText, "CDK")
    end
    if findItem("Shark Anchor") then 
        table.insert(ReturnText, "SA")
    end
    if findItem("Soul Guitar") then
        table.insert(ReturnText, "SG")
    end
    if findItem("Leviathan Heart") then
        table.insert(ReturnText, "Heart")
    end

    local GodHuman = tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman",true))
    if GodHuman then
            if GodHuman == 1 then
                table.insert(ReturnText, "GOD")
            end
    end
    if len(ReturnText) == 0 then
        table.insert(ReturnText, "NOOB")
    end
    return table.concat(ReturnText, " ")
end

function getVK()
	for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryWeapons")) do -- เช็คในกระเป๋า
            for i1,v1 in pairs(v) do
                if v1 == 'Valkyrie Helm' then
                    return true
                end
            end
        end
     if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild('Valkyrie Helm') or game:GetService("Players").LocalPlayer.Character:FindFirstChild('Valkyrie Helm') then
           return true
        end
    return false
end

function getEvoTier()
    local CheckAlchemist = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
    if CheckAlchemist == -2 then
        local CheckWenlocktoad = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        if CheckWenlocktoad == -2 then
            if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
                return 4
            end
            return 3
        end
        return 2
    end
    return 1
end


function getAwakendTier()
    local q, _ = pcall(function()
        return tonumber(game:GetService("Players").LocalPlayer.Data.Race.C.Value)
    end)
    if q then return _ end 
    return 0
end

function checkDoor()
    return game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("CheckTempleDoor")
end

function sendRequest()
    local res = request({
        Url = __script__host .. "/addbot", -- ปรับ URL ให้ถูกต้อง
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            ["account"] = LocalPlayer.DisplayName,
            ["type"] = getType(),
            ["level"] = getLevel(),
            ["world"] = getWorld(),
            ["mirror"] = getItem("Mirror Fractal"),
            ["valk"] = getVK(),
            ["fruitMas"] = getFruitMastery(),
            ["fruit"] = getFruitName() or "None",
            ["awaken"] = getAwakend(),
            ["melee"] = getMeele(),
            ["beli"] = LocalPlayer.Data.Beli.Value,
            ["fragment"] = LocalPlayer.Data.Fragments.Value,
            ["inventory"] = getSword(),
            ["fruitInv"] = GetFruitInU(),
            ["race"] = game:GetService("Players").LocalPlayer.Data.Race.Value,
            ["raceV"] = getEvoTier(),
            ["tier"] = getAwakendTier(),
            ["unlockDoor"] = checkDoor()
        })
    })
   warn(res.Body)
end

task.spawn(function()
    while true do
        print("mammozzz")
        sendRequest()
        -- local x, p = pcall(function()
        -- end)
        if not x then warn(p) end
        task.wait(10)
    end
end)