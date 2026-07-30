local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local rtO = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

local acR = rtO:FindFirstChild("AC_Shared")
if acR then acR = acR.Remotes:FindFirstChild("AntiCheat") end

local h = {}
local old_nc
old_nc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if not checkcaller() then
        local m = getnamecallmethod()
        if m == "Kick" and self == lp then return end
        if acR and m == "FireServer" and self == acR then return end
    end
    return old_nc(self, ...)
end))
h.nc = old_nc

local function dac(c)
    local acC = c:FindFirstChild("AC_Client")
    if acC then
        for _, v in ipairs(acC:GetDescendants()) do
            if v:IsA("LocalScript") or v:IsA("Script") then v.Disabled = true end
        end
    end
end

WindUI:Notify({ Title = "VRA BYPASS", Content = "loaded bypass", Duration = 3 })

local rS = nil
local lL = false
local oL = {}
local fL = {L = nil, R = nil}

local function h_t(t)
    if not t or not t:FindFirstChild("Module") then return end
    local ok, mod = pcall(require, t.Module)
    if not ok or type(mod) ~= "table" then return end
    
    local act = {"Kick", "Kick2", "Tackle", "Slide", "Catch"}
    for _, n in ipairs(act) do
        if type(mod[n]) == "function" then
            local o_f = mod[n]
            mod[n] = function(...)
                local c = lp.Character
                local ll = c and c:FindFirstChild("Left Leg")
                local rl = c and c:FindFirstChild("Right Leg")
                
                local lo, ro = ll and ll.Size, rl and rl.Size
                if ll then ll.Size = Vector3.new(1, ll.Size.Y, 1) end
                if rl then rl.Size = Vector3.new(1, rl.Size.Y, 1) end
                
                local res = o_f(...)
                
                if ll then ll.Size = lo end
                if rl then rl.Size = ro end
                
                return res
            end
        end
    end
end

local function s_t(cont)
    if not cont then return end
    for _, t in ipairs(cont:GetChildren()) do
        if t:IsA("Tool") then h_t(t) end
    end
    cont.ChildAdded:Connect(function(ch)
        if ch:IsA("Tool") then h_t(ch) end
    end)
end

local function clr_fl()
    if fL.L then fL.L:Destroy() fL.L = nil end
    if fL.R then fL.R:Destroy() fL.R = nil end
end

rs.Heartbeat:Connect(function()
    local c = lp.Character
    if not c or not oL.L or not oL.L.Parent then return end
    
    local ll = oL.L
    local rl = oL.R
    
    if rS and tonumber(rS) then
        local sz = tonumber(rS)
        ll.Size = Vector3.new(sz, ll.Size.Y, sz)
        ll.Massless = true
        ll.CanCollide = false
        rl.Size = Vector3.new(sz, rl.Size.Y, sz)
        rl.Massless = true
        rl.CanCollide = false
    end
    
    if lL then
        ll.Transparency = 1
        rl.Transparency = 1
        
        if not fL.L then
            local fl = ll:Clone()
            fl.Name = "Left Leg"
            fl.Size = Vector3.new(1, ll.Size.Y, 1)
            fl.Transparency = 0
            fl.Massless = true
            fl.CanCollide = false
            local w1 = Instance.new("WeldConstraint")
            w1.Part0 = ll
            w1.Part1 = fl
            w1.Parent = fl
            fl.Parent = c
            fL.L = fl
        end
        
        if not fL.R then
            local fr = rl:Clone()
            fr.Name = "Right Leg"
            fr.Size = Vector3.new(1, rl.Size.Y, 1)
            fr.Transparency = 0
            fr.Massless = true
            fr.CanCollide = false
            local w2 = Instance.new("WeldConstraint")
            w2.Part0 = rl
            w2.Part1 = fr
            w2.Parent = fr
            fr.Parent = c
            fL.R = fr
        end
    else
        ll.Transparency = 0
        rl.Transparency = 0
        clr_fl()
    end
end)

local function o_c(c)
    dac(c)
    s_t(c)
    s_t(lp:FindFirstChild("Backpack"))
    clr_fl()
    
    oL.L = c:WaitForChild("Left Leg", 3)
    oL.R = c:WaitForChild("Right Leg", 3)
end

lp.CharacterAdded:Connect(o_c)
if lp.Character then o_c(lp.Character) end

local W = WindUI:CreateWindow({
    Title = "VRA IDK",
    Author = "itswin7y",
    Folder = "VRA_IDK",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
})

W:EditOpenButton({ Visible = false })

local T1 = W:Tab({ Title = "INFO", Icon = "info" })
T1:Paragraph({ Title = "uhhm a reach, should work idk" })

local T2 = W:Tab({ Title = "main", Icon = "box" })
local S1 = T2:Section({ Title = "reach", TextXAlignment = "Left" })

S1:Input({
    Title = "reach size",
    Default = "",
    Placeholder = "Size...",
    Numeric = true,
    Finished = true,
    Callback = function(val)
        if val == "" then rS = nil else rS = val end
    end
})

S1:Toggle({
    Title = "legit legs",
    Default = false,
    Callback = function(state)
        lL = state
    end
})

uis.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.K then
        W:Toggle()
    end
end)
