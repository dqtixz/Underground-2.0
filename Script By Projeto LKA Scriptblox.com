-- Script Made By Projeto LKA --
  -- Underground war 2.0 --
    -- Create On 10/03/2024 --
      -- post on 28/03/2024

local Players = game.Players
local plr = Players.LocalPlayer
local loop = true
local retry = true
_G.name = "sword"
_G.enemOnly = true
local reach = 10
wait(0.1)
local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/lobox920/Notification-Library/Main/Library.lua"))()
wait(0.1)
NotificationLibrary:SendNotification("Warning", "Script Made By Projeto LKA", 3)
wait(0.1)
NotificationLibrary:SendNotification("Info", "Current In Beta", 3)
wait(1)
NotificationLibrary:SendNotification("Success", "Injected !", 3)
wait(0.1)
local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local Window = Library:NewWindow("Underground War 2.0")

local Section = Window:NewSection("KillAura")

function findTool(String)
    local strl = String:lower()
    for i,v in pairs(plr.Backpack: GetChildren ()) do
       if v.Name:lower():match(strl) ~= nil then
          return v
          end
       end
    for i,v in pairs(plr.Character:GetChildren()) do
       if v.Name:lower():match(strl) ~= nil then
         return v
         end
       end
    end

function getTool()
    return findTool(_G.name)
   
end

function KillAura()
    loop = true
    if _G.enemOnly == true then
    repeat
    for i,v in pairs(game.Players:GetPlayers()) do
	pcall(function()
	if v ~= game.Players.LocalPlayer and v.TeamColor.Name ~= plr.TeamColor.Name and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChildOfClass"ForceField" == nil then
    
	local Distance = (v.Character:FindFirstChildOfClass("Part").Position - game.Players.LocalPlayer.Character:FindFirstChildOfClass("Part").Position).magnitude
	if Distance <= reach then
	for i = 1,25 do
    plr.Character.Humanoid.RootPart.CFrame = v.Character.Humanoid.RootPart.CFrame * CFrame.new(-1.6,0,1.8)
    local h = getTool()
    h.Parent = plr.Character
    h:Activate()
    if plr.Character:FindFirstChildOfClass"Tool".Name ~= getTool().Name then
        plr.Character:FindFirstChildOfClass"Humanoid": UnequipTools()
        end
    if v.Character.Humanoid.Health <= 0 then
    loop = false
    if retry == true then
    wait(1)
    KillAura()
    end
    end
	end
	end 
    end
	end)
	end
    game:GetService("RunService").Heartbeat:Wait()
    until loop == false

    else

    repeat
    for i,v in pairs(game.Players:GetPlayers()) do
	pcall(function()
	if v ~= game.Players.LocalPlayer and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChildOfClass"ForceField" == nil then
    
	local Distance = (v.Character:FindFirstChildOfClass("Part").Position - game.Players.LocalPlayer.Character:FindFirstChildOfClass("Part").Position).magnitude
	if Distance <= reach then
	for i = 1,25 do
    plr.Character.Humanoid.RootPart.CFrame = v.Character.Humanoid.RootPart.CFrame * CFrame.new(-1.6,0,1.8)
    local h = getTool()
    h.Parent = plr.Character
    h:Activate()
    if plr.Character:FindFirstChildOfClass"Tool".Name ~= getTool().Name then
        plr.Character:FindFirstChildOfClass"Humanoid": UnequipTools()
        end
    if v.Character.Humanoid.Health <= 0 then
    loop = false
    if retry == true then
    wait(1)
    KillAura()
    end
    end
	end
	end 
    end
	end)
	end
    game:GetService("RunService").Heartbeat:Wait()
    until loop == false
    end
    end

  local function notify(Title, Text, Duration)
     Text = Text or "Text" 
     Title= Title or "Title"
     Duration = Duration or 5
    game:GetService("StarterGui"):SetCore("SendNotification",{
 Title = Title, 
 Text = Text,
 Duration = Duration,
})
    end

Section:CreateButton("On", function()
    loop = true
    retry = true
    KillAura()
    
end)

Section:CreateButton("off", function()
    loop = false
    retry = false
    
    loop = false
    retry = false    
end)


Section:CreateTextbox("TextBox", function(text, focuslost) --Window:Box("Reach - 10", function(text, focuslost)
   if focuslost then
   if not tonumber(text) then
    reach = tostring(10 or 10 and tonumber(string.format("%.2f", 10)))
    notify(reach, "nope string is wrong current reach is 10")
    elseif text == "" or tonumber(text) <= 10 then
    reach = 10
    notify("minimum", "the minimum reach is 10, current reach: "..reach)
    elseif text == "" or tonumber(text) >= 40 then
    reach = 40
    notify("maximum", "the maximum reach is 40, current reach: "..reach)
    end
   end
end)


Section:CreateButton("Auto Equip Sword (Beta)", function()
-- Obter o jogador local
local player = game.Players.LocalPlayer

-- Definir o nome do item a ser equipado
local itemName = "sword"

-- Verificar se o item está no inventário / Verify Tool Item
if player.Backpack:FindFirstChild(itemName) then
    -- Equip Tool / Equipar Item
    player.Backpack[itemName].Parent = player.Character
else
    warn("O item '" .. itemName .. "' não foi encontrado no inventário.")
end
end)

Section:CreateDropdown("Modes", {"Enemies", "Others"}, 2, function(o)
 if o == "enemies only" then
    _G.enemOnly = true
    elseif o == "others" then
    _G.enemOnly = false
    end
end)
