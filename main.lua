--[[
    Elite Universal V10.3 | fek7-Debug
    FIX: SpinBot, InfJump y ESP reconectados.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Elite Universal V10.3 🌍",
   LoadingTitle = "Reparando Módulos...",
   LoadingSubtitle = "by fek7",
   ConfigurationSaving = {Enabled = false},
   Theme = "DarkBlue" 
})

-- --- VARIABLES DE CONTROL (GLOBALES PARA LOS LOOPS) ---
_G.CFrameSpeed = 0
_G.SpinBot = false
_G.InfJump = false
_G.AutoClick = false
_G.AntiAFK = false
_G.ESP = false

local lp = game.Players.LocalPlayer
local VU = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- --- 1. SETTINGS (⚙️) ---
local TabSet = Window:CreateTab("⚙️ Settings")
TabSet:CreateToggle({Name = "Anti-AFK (Stay Online)", CurrentValue = false, Callback = function(V) _G.AntiAFK = V end})
TabSet:CreateToggle({Name = "Auto-Clicker", CurrentValue = false, Callback = function(V) _G.AutoClick = V end})
TabSet:CreateButton({Name = "Modo Papa (FPS Boost)", Callback = function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
    end
end})
TabSet:CreateKeybind({Name = "Ocultar UI (P)", CurrentKeybind = "P", Callback = function() Rayfield:Minimize() end})

-- --- 2. MAIN (🎯) ---
local TabMain = Window:CreateTab("🎯 Main")
TabMain:CreateSlider({Name = "CFrame Speed", Range = {0, 10}, Increment = 0.5, CurrentValue = 0, Callback = function(V) _G.CFrameSpeed = V end})
TabMain:CreateToggle({Name = "Salto Infinito", CurrentValue = false, Callback = function(V) _G.InfJump = V end})
TabMain:CreateToggle({Name = "SpinBot 360", CurrentValue = false, Callback = function(V) _G.SpinBot = V end})
TabMain:CreateButton({Name = "Phase Forward (Muros)", Callback = function()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -5) end
end})

-- --- 3. VISUALS (👁️) ---
local TabVis = Window:CreateTab("👁️ Visuals")
TabVis:CreateButton({Name = "Infinite Zoom", Callback = function() lp.CameraMaxZoomDistance = 999999 end})
TabVis:CreateSlider({Name = "FOV", Range = {30, 120}, Increment = 1, CurrentValue = 70, Callback = function(V) workspace.CurrentCamera.FieldOfView = V end})
TabVis:CreateToggle({Name = "ESP Wallhack", CurrentValue = false, Callback = function(V) _G.ESP = V end})

-- --- 4. MISC (📦) ---
local TabMisc = Window:CreateTab("📦 Misc")
local EmoteID = "0"
TabMisc:CreateInput({Name = "ID Emote", Callback = function(T) EmoteID = T end})
TabMisc:CreateButton({Name = "▶️ Ejecutar Emote", Callback = function()
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then 
        local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://"..EmoteID
        hum:LoadAnimation(a):Play() 
    end
end})
TabMisc:CreateButton({Name = "Server Hop", Callback = function()
    local ts = game:GetService("TeleportService")
    local rs = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, v in pairs(rs.data) do if v.playing < v.maxPlayers then ts:TeleportToPlaceInstance(game.PlaceId, v.id) end end
end})

-- --- SISTEMAS DE EJECUCIÓN (LOOPS) ---

-- Loop de Movimiento y SpinBot
RS.RenderStepped:Connect(function()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if hrp and hum then
        -- CFrame Speed
        if _G.CFrameSpeed > 0 and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * _G.CFrameSpeed)
        end
        -- SpinBot
        if _G.SpinBot then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(25), 0)
        end
    end
end)

-- Sistema de Salto Infinito
UIS.JumpRequest:Connect(function()
    if _G.InfJump then
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState("Jumping")
        end
    end
end)

-- Loop de ESP y AutoClick
spawn(function()
    while task.wait(0.1) do
        if _G.AutoClick then 
            VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait()
            VU:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) 
        end
        
        if _G.ESP then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and not p.Character:FindFirstChild("EliteESP") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "EliteESP"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("EliteESP") then 
                    p.Character.EliteESP:Destroy() 
                end
            end
        end
    end
end)

-- Anti-AFK
lp.Idled:Connect(function()
    if _G.AntiAFK then 
        VU:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VU:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) 
    end
end)

Rayfield:Notify({Title = "Elite V10.3", Content = "Módulos reconectados correctamente. 😗", Duration = 5})
