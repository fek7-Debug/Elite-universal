--[[
    Elite Universal V10.9 | FULL RECOVERY
    Todas las funciones recuperadas y secciones restauradas.
    Repositorio: Elite-universal
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Elite Universal V10.9 🌍",
   LoadingTitle = "Restaurando Todo el Poder...",
   LoadingSubtitle = "by fek7",
   ConfigurationSaving = {Enabled = false},
   Theme = "DarkBlue" 
})

-- --- VARIABLES GLOBALES ---
local lp = game.Players.LocalPlayer
local VU = game:GetService("VirtualUser")
_G.Speed = 0
_G.Spin = false
_G.Jump = false
_G.ESP = false
_G.AutoClick = false
_G.AntiAFK = false

-- --- 1. PESTAÑA: MAIN (🎯) ---
local TabMain = Window:CreateTab("🎯 Main")
TabMain:CreateSection("Movimiento y Combate")
TabMain:CreateSlider({Name = "CFrame Speed", Range = {0, 10}, Increment = 0.5, CurrentValue = 0, Callback = function(V) _G.Speed = V end})
TabMain:CreateToggle({Name = "Salto Infinito", CurrentValue = false, Callback = function(V) _G.Jump = V end})
TabMain:CreateToggle({Name = "SpinBot 360", CurrentValue = false, Callback = function(V) _G.Spin = V end})
TabMain:CreateButton({Name = "Phase Forward (Atravesar Muros)", Callback = function()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -5) end
end})

-- --- 2. PESTAÑA: VISUALS (👁️) ---
local TabVis = Window:CreateTab("👁️ Visuals")
TabVis:CreateSection("ESP & Cámara")
TabVis:CreateToggle({Name = "ESP Wallhack", CurrentValue = false, Callback = function(V) _G.ESP = V end})
TabVis:CreateSlider({Name = "Field of View (FOV)", Range = {30, 120}, Increment = 1, CurrentValue = 70, Callback = function(V) workspace.CurrentCamera.FieldOfView = V end})
TabVis:CreateButton({Name = "Infinite Zoom", Callback = function() lp.CameraMaxZoomDistance = 999999 end})

-- --- 3. PESTAÑA: MISC (📦) ---
local TabMisc = Window:CreateTab("📦 Misc")
TabMisc:CreateSection("Servidor y Diversión")
local EmoteID = "0"
TabMisc:CreateInput({Name = "ID Emote Personalizado", PlaceholderText = "ID Aquí...", Callback = function(T) EmoteID = T end})
TabMisc:CreateButton({Name = "▶️ Ejecutar Emote", Callback = function()
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then 
        local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://"..EmoteID
        hum:LoadAnimation(a):Play() 
    end
end})
TabMisc:CreateButton({Name = "Server Hop (Cambiar Server)", Callback = function()
    local ts = game:GetService("TeleportService")
    local rs = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, v in pairs(rs.data) do if v.playing < v.maxPlayers then ts:TeleportToPlaceInstance(game.PlaceId, v.id) end end
end})

-- --- 4. PESTAÑA: SETTINGS (⚙️) ---
local TabSet = Window:CreateTab("⚙️ Settings")
TabSet:CreateSection("Automatización")
TabSet:CreateToggle({Name = "Anti-AFK (Evitar Kick)", CurrentValue = false, Callback = function(V) _G.AntiAFK = V end})
TabSet:CreateToggle({Name = "Auto-Clicker", CurrentValue = false, Callback = function(V) _G.AutoClick = V end})
TabSet:CreateSection("Optimización")
TabSet:CreateButton({Name = "Modo Papa (FPS Boost)", Callback = function()
    for _, v in pairs(game:GetDescendants()) do 
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic 
        elseif v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end 
    end
end})
TabSet:CreateKeybind({Name = "Ocultar Interfaz", CurrentKeybind = "P", Callback = function() Rayfield:Minimize() end})

-- --- MOTOR CORE (BUCLES INDEPENDIENTES) ---

-- Bucle de Movimiento y Spin
task.spawn(function()
    while task.wait() do
        pcall(function()
            local char = lp.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                if _G.Spin then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(30), 0) end
                if _G.Speed > 0 and char.Humanoid.MoveDirection.Magnitude > 0 then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * _G.Speed)
                end
            end
        end)
    end
end)

-- Bucle de Visuals (ESP)
task.spawn(function()
    while task.wait(1) do
        if _G.ESP then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local h = p.Character:FindFirstChild("EliteHighlight") or Instance.new("Highlight", p.Character)
                    h.Name = "EliteHighlight"; h.FillColor = Color3.fromRGB(255, 0, 0); h.Enabled = true
                end
            end
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("EliteHighlight") then p.Character.EliteHighlight:Destroy() end
            end
        end
    end
end)

-- Bucle de Clicks y Anti-AFK
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoClick then VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame); task.wait(); VU:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end
        if _G.AntiAFK then VU:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame); task.wait(1); VU:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end
    end
end)

-- Sistema de Salto
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.Jump then
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

Rayfield:Notify({Title = "Elite V10.9", Content = "Script completo restaurado. 😗", Duration = 5})
