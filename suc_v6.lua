repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local t_wait, t_spawn = task.wait, task.spawn
local m_random, m_floor, m_huge = math.random, math.floor, math.huge
local s_format = string.format

local S = {
    P = game:GetService("Players"),
    W = game:GetService("Workspace"),
    RS = game:GetService("RunService"),
    V = game:GetService("VirtualInputManager"),
    L = game:GetService("Lighting"),
    ST = game:GetService("Stats"),
    GS = game:GetService("GuiService"),
    TS = game:GetService("TeleportService")
}
local LP = S.P.LocalPlayer

t_spawn(function()
    pcall(function()
        S.GS.ErrorMessageChanged:Connect(function()
            t_wait(3)
            pcall(function() S.TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end)
        end)
    end)
end)

local TargetUI = nil
pcall(function() TargetUI = gethui() end)
if not TargetUI then pcall(function() TargetUI = game:GetService("CoreGui") end) end
if not TargetUI then TargetUI = LP:WaitForChild("PlayerGui") end

pcall(function()
    for _, v in ipairs(TargetUI:GetChildren()) do if v.Name:match("MayChemXeoCan") then v:Destroy() end end
end)

getgenv().Key = ""
getgenv().Setting = {
    ["Hitbox"] = { ["Enabled"] = true, ["Size"] = 20, ["Transparency"] = 0.7 },
    ["Team"] = "Pirate",
    ["Method Click"] = {
        ["Aim M1 Fruit"] = {["Enabled"] = false, ["Distance"] = 15000, ["Smoothness"] = 0.2},
        ["Click Gun"] = false, ["Click Melee"] = false, ["Click Sword"] = false, ["Click Fruit"] = true,
        ["LowHealth"] = 0, ["Delay Click"] = 0, 
        ["Bypass_Suspicious"] = { ["Enabled"] = true, ["Smart_Delay"] = 0.3, ["Clicks_Per_Pause"] = {4, 6}, ["Random_Interval"] = true }
    },
    ["Race V4"] = {["Enable"] = true},
    ["Webhook"] = {["Enabled"] = false, ["Url Webhook"] = ""},
    ["Misc"] = { ["AutoBuyRandomandStoreFruit"] = true, ["AutoBuySurprise"] = true, ["Auto Jump"] = true, ["Show Notification"] = true },
    ["SafeZone"] = {["Enable"] = true, ["LowHealth"] = 4500, ["MaxHealth"] = 7000, ["Teleport Y"] = 2000},
    ["Method Use Skill"] = {["Use Random"] = false, ["Use Number"] = false},
    ["Use random skill if player target low health"] = {["Enabled"] = false, ["Low Health"] = 4000},
    ["Use Portal Teleport"] = false, ["Target Time"] = 8, ["Stuck Time"] = 5, ["Aim Prediction"] = 0.185,
    ["Select Region"] = { ["Enabled"] = true, ["Region"] = {["Singapore"] = true, ["United States"] = true} },
    ["Ignore Devil Fruit"] = {"Portal-Portal","Human-Human"},
    ["Dodge Skill Player"] = false, ["Spam Dash"] = false,
    ["Equip Weapon"] = {
        ["Enabled"] = false,
        ["Melee"] = {["Enabled"] = false, ["Name Weapon"] = ""},
        ["Sword"] = {["Enabled"] = false, ["Name Weapon"] = ""},
        ["Gun"] = {["Enabled"] = false, ["Name Weapon"] = ""}
    },
    ["Weapons"] = {
        ["Melee"] = {
            ["Enable"] = false,
            ["Skills"] = {
                ["Z"] = {["Enable"] = true, ["HoldTime"] = 0, ["Number"] = 2},
                ["X"] = {["Enable"] = true, ["HoldTime"] = 0, ["Number"] = 3},
                ["C"] = {["Enable"] = true, ["HoldTime"] = 0, ["Number"] = 5}
            }
        },
        ["Blox Fruit"] = {
            ["Enable"] = true,
            ["Skills"] = {
                ["Z"] = {["Enable"] = false, ["HoldTime"] = 0.3, ["Number"] = 4},
                ["X"] = {["Enable"] = false, ["HoldTime"] = 0.3, ["Number"] = 6},
                ["C"] = {["Enable"] = false, ["HoldTime"] = 0, ["Number"] = 0},
                ["V"] = {["Enable"] = false, ["HoldTime"] = 0, ["Number"] = 0},
                ["F"] = {["Enable"] = false, ["HoldTime"] = 0, ["Number"] = 8}
            }
        },
        ["Gun"] = {
            ["Enable"] = false,
            ["Skills"] = {
                ["Z"] = {["Enable"] = true, ["HoldTime"] = 0, ["Number"] = 1},
                ["X"] = {["Enable"] = true, ["HoldTime"] = 0, ["Number"] = 7}
            }
        },
        ["Sword"] = {
            ["Enable"] = false,
            ["Skills"] = {
                ["Z"] = {["Enable"] = false, ["HoldTime"] = 0, ["Number"] = 0},
                ["X"] = {["Enable"] = true, ["HoldTime"] = 0, ["Number"] = 0}
            }
        }
    },
    ["LockFps"] = {["Disable"] = false, ["FPS"] = 60},
    ["DeleteMap"] = false,
    ["AntiAFK Move"] = {["Enabled"] = true, ["Delay"] = 1.2},
    ["Targeting_Advanced"] = { ["Priority_Mode"] = "Lowest Health", ["Ignore_Friends"] = true, ["Ignore_SafeZone"] = true, ["Ignore_ForceField"] = true }
}
getgenv().CurrentTarget = nil

local function CreateNode(className, props, parent)
    local node = Instance.new(className)
    for k, v in pairs(props) do node[k] = v end
    if parent then node.Parent = parent end
    return node
end

local UI = CreateNode("ScreenGui", {Name = "MayChemXeoCan_UI", ResetOnSpawn = false}, TargetUI)

local Core = {
    FpsBox = CreateNode("Frame", {Size = UDim2.new(0, 120, 0, 30), Position = UDim2.new(0.02, 0, 0.05, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 20), BackgroundTransparency = 0.2, BorderSizePixel = 2, BorderColor3 = Color3.fromRGB(0, 255, 100), Active = true, Draggable = true}, UI),
    MainBox = CreateNode("Frame", {Size = UDim2.new(0, 300, 0, 200), Position = UDim2.new(0.02, 0, 0.3, 30), BackgroundColor3 = Color3.fromRGB(10, 10, 15), BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(0, 255, 100), Active = true, Draggable = true}, UI),
    AlertBox = CreateNode("Frame", {Size = UDim2.new(0, 280, 0, 40), Position = UDim2.new(0.5, -140, 0.15, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 20), BackgroundTransparency = 0.1, BorderSizePixel = 2, BorderColor3 = Color3.fromRGB(255, 50, 50), Visible = false}, UI)
}
CreateNode("UICorner", {CornerRadius = UDim.new(0, 6)}, Core.FpsBox)
CreateNode("UICorner", {CornerRadius = UDim.new(0, 4)}, Core.MainBox)
CreateNode("UICorner", {CornerRadius = UDim.new(0, 6)}, Core.AlertBox)

local T_Fps = CreateNode("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "FPS: --", TextColor3 = Color3.fromRGB(0, 255, 100), Font = Enum.Font.GothamBold, TextSize = 14}, Core.FpsBox)
CreateNode("TextLabel", {Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = "> MayChemXeoCan_Scan.exe", TextColor3 = Color3.fromRGB(0, 255, 100), Font = Enum.Font.Code, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left}, Core.MainBox)
CreateNode("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "Hop Server When you see SuS", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 14}, Core.AlertBox)

local LogScroll = CreateNode("ScrollingFrame", {Size = UDim2.new(1, -10, 0.55, 0), Position = UDim2.new(0, 5, 0, 25), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100), AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new()}, Core.MainBox)
CreateNode("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, LogScroll)

local StatContainer = CreateNode("Frame", {Size = UDim2.new(1, -10, 0.3, 0), Position = UDim2.new(0, 5, 0.55, 25), BackgroundTransparency = 1}, Core.MainBox)
CreateNode("UIListLayout", {Padding = UDim.new(0, 4)}, StatContainer)

local function MakeStat(name, default)
    local row = CreateNode("Frame", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1}, StatContainer)
    CreateNode("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, Text = name, TextColor3 = Color3.fromRGB(180, 180, 180), Font = Enum.Font.Code, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, row)
    return CreateNode("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1, Text = default, TextColor3 = Color3.fromRGB(0, 255, 100), Font = Enum.Font.Code, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right}, row)
end
local T_Ram = MakeStat("[SYS] RAM Load:", "0 MB")
local T_Ping = MakeStat("[NET] Ping:", "0 ms")

local Logger = {Count = 0}
function Logger.Write(module, status, color)
    pcall(function()
        Logger.Count = Logger.Count + 1
        CreateNode("TextLabel", {Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, TextColor3 = color or Color3.fromRGB(0, 255, 100), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = Logger.Count, Text = s_format("[%s] %s -> %s", os.date("%H:%M:%S"), module, status)}, LogScroll)
        LogScroll.CanvasPosition = Vector2.new(0, 99999)
    end)
end

local Engine = {FC = 0}
S.RS.RenderStepped:Connect(function() Engine.FC = Engine.FC + 1 end)

t_spawn(function()
    while t_wait(1) do
        pcall(function()
            local fps = Engine.FC
            Engine.FC = 0
            T_Fps.Text = "FPS: " .. fps
            T_Fps.TextColor3 = fps >= 40 and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)
            if Core.MainBox.Visible then
                local ram = m_floor(S.ST:GetTotalMemoryUsageMb())
                T_Ram.Text = ram .. " MB"
                T_Ram.TextColor3 = ram < 1000 and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 150, 0)
                local s, r = pcall(function() return LP:GetNetworkPing() * 1000 end)
                T_Ping.Text = (s and m_floor(r) or "N/A") .. " ms"
            end
        end)
    end
end)

Logger.Write("System", "Init Modules...", Color3.fromRGB(200, 200, 200))
t_spawn(function()
    pcall(function()
        settings().Rendering.QualityLevel = 1
        S.L.GlobalShadows = false
        S.L.FogEnd = 9e9
        for _, v in ipairs(S.L:GetDescendants()) do if v:IsA("PostEffect") then v.Enabled = false end end
        Logger.Write("RenderEngine", "FPS Boosted", Color3.fromRGB(0, 255, 100))
    end)
end)

if getgenv().Setting.DeleteMap then
    t_spawn(function()
        pcall(function()
            for _, v in ipairs(S.W:GetDescendants()) do if v:IsA("Part") and v.Transparency < 1 then v.CanCollide = false end end
            Logger.Write("MapOptimizer", "Map wiped", Color3.fromRGB(0, 255, 100))
        end)
    end)
end

local BL = {}
local function GetTarget()
    if not LP.Character then return nil end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local cfg, pos = getgenv().Setting.Targeting_Advanced, hrp.Position
    local best, minH, maxD = nil, m_huge, 15000
    for _, v in ipairs(S.P:GetPlayers()) do
        if v ~= LP and v.Team ~= LP.Team and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and not (cfg.Ignore_Friends and LP:IsFriendsWith(v.UserId)) and not (cfg.Ignore_ForceField and v.Character:FindFirstChildOfClass("ForceField")) then
            if BL[v.Name] and tick() - BL[v.Name] < 60 then continue end
            local e_hrp = v.Character:FindFirstChild("HumanoidRootPart")
            if e_hrp then
                local d = (e_hrp.Position - pos).Magnitude
                if d <= maxD then
                    if cfg.Priority_Mode == "Lowest Health" then
                        if v.Character.Humanoid.Health < minH then minH = v.Character.Humanoid.Health; best = v.Character end
                    elseif d < maxD then
                        maxD = d; best = v.Character
                    end
                end
            end
        end
    end
    return best
end

local cTarg, lHP, fH = nil, 0, nil
t_spawn(function()
    while t_wait(0.5) do
        pcall(function()
            local t = getgenv().CurrentTarget
            if t and t.Parent and t:FindFirstChild("Humanoid") and t:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                if t.Name ~= cTarg then
                    cTarg = t.Name; lHP = t.Humanoid.Health; fH = nil
                else
                    local cH = t.Humanoid.Health
                    local d = (LP.Character.HumanoidRootPart.Position - t.HumanoidRootPart.Position).Magnitude
                    if cH < lHP then
                        if not fH then fH = tick() end
                        lHP = cH
                    end
                    if d > 15000 then
                        BL[cTarg] = tick(); getgenv().CurrentTarget = nil; cTarg = nil
                        Logger.Write("AI_Logic", "Target out of range! Blacklisted", Color3.fromRGB(255, 255, 0))
                    elseif fH and tick() - fH > 18 then
                        BL[cTarg] = tick(); getgenv().CurrentTarget = nil; cTarg = nil
                        Logger.Write("AI_Logic", "Target invincible! Blacklisted", Color3.fromRGB(255, 50, 50))
                    end
                end
            else
                cTarg = nil
            end
        end)
    end
end)

t_spawn(function()
    Logger.Write("Thread_Core", "Loaded", Color3.fromRGB(0, 255, 100))
    while t_wait(0.2) do
        pcall(function()
            getgenv().CurrentTarget = GetTarget()
            if LP.Character and getgenv().CurrentTarget and getgenv().Setting.Hitbox.Enabled then
                local e_hrp = getgenv().CurrentTarget:FindFirstChild("HumanoidRootPart")
                if e_hrp and e_hrp.Size.X ~= getgenv().Setting.Hitbox.Size then
                    e_hrp.Size = Vector3.new(getgenv().Setting.Hitbox.Size, getgenv().Setting.Hitbox.Size, getgenv().Setting.Hitbox.Size)
                    e_hrp.Transparency = getgenv().Setting.Hitbox.Transparency
                    e_hrp.CanCollide = false
                end
            end
        end)
    end
end)

t_spawn(function()
    local t_jump, keys = tick(), {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
    while t_wait(m_random(1, 3) / 10) do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health > 0 then
                if getgenv().Setting.Misc["Auto Jump"] and tick() - t_jump >= 4 then
                    S.V:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    t_wait(0.05)
                    S.V:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    t_jump = tick()
                end
                if getgenv().CurrentTarget then
                    local k = keys[m_random(1, #keys)]
                    S.V:SendKeyEvent(true, k, false, game)
                    t_wait(m_random(5, 15) / 100)
                    S.V:SendKeyEvent(false, k, false, game)
                end
            end
        end)
    end
end)

t_spawn(function()
    while t_wait(0.5) do
        pcall(function()
            if getgenv().CurrentTarget and LP.Character and getgenv().Setting["Method Click"]["Click Fruit"] then
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if not (tool and (tool.ToolTip == "Blox Fruit" or tool.Name:match("Fruit"))) then
                    for _, t in ipairs(LP.Backpack:GetChildren()) do
                        if t:IsA("Tool") and (t.ToolTip == "Blox Fruit" or t.Name:match("Fruit")) then
                            LP.Character.Humanoid:EquipTool(t)
                            break
                        end
                    end
                end
            end
        end)
    end
end)

t_spawn(function()
    Logger.Write("Network", "Fetching BananaCat...", Color3.fromRGB(150, 150, 255))
    t_wait(1.5) 
    pcall(function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/BananaCat-BountyEz.lua"))()
        Logger.Write("Network", "BananaCat [OK]", Color3.fromRGB(0, 255, 100)) 
    end)
    
    t_wait(1.5) 
    Logger.Write("Network", "Fetching W-Azure...", Color3.fromRGB(150, 150, 255))
    pcall(function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/17Hacking/Script/main/FastAttackW-Azure.lua"))()
        Logger.Write("Network", "W-Azure [OK]", Color3.fromRGB(0, 255, 100)) 
    end)
end)

t_spawn(function()
    t_wait(15)
    pcall(function()
        if Core.MainBox then Core.MainBox.Visible = false end
        if Core.AlertBox then
            Core.AlertBox.Visible = true
            t_wait(2)
            Core.AlertBox:Destroy()
        end
    end)
end)
