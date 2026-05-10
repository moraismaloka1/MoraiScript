-- BUILD AN ISLAND
-- MORAISCRIPT MOBILE V2

repeat task.wait() until game:IsLoaded()

local p=game.Players.LocalPlayer
local r=game.ReplicatedStorage
local w=workspace
local ts=game:GetService("TweenService")

local h=r.Communication.Harvest
local s=r.Communication.SellToMerchant
local hit=r.Communication.HitResource
local fishRemote=r.Communication.Fish
local craftRemote=r.Communication.Craft
local doubleCraftRemote=r.Communication.DoubleCraft

local harvest=false
local sell=false
local resource=false
local fish=false
local autoCraft=false
local doubleCraft=false

local walkSpeed=16
local ids={}

local fishPos=Vector3.new(-558.3486328125,-1.6463816165924072,-99.93724822998047)
local fishPower=0.026836642797277044

local LOGO_ID="rbxassetid://0"

pcall(function()
    local old
    old=hookmetamethod(game,"__namecall",function(self,...)
        local args={...}
        local method=getnamecallmethod()

        if self==fishRemote and method=="InvokeServer" then
            if typeof(args[1])=="Vector3" and typeof(args[2])=="number" then
                fishPos=args[1]
                fishPower=args[2]
            end
        end

        return old(self,...)
    end)
end)

-- GUI
local g=Instance.new("ScreenGui",game.CoreGui)
g.Name="MoraiScript"
g.ResetOnSpawn=false

local main=Instance.new("Frame",g)
main.Size=UDim2.new(0,430,0,280)
main.Position=UDim2.new(-.5,0,.22,0)
main.BackgroundColor3=Color3.fromRGB(18,18,22)
main.BorderSizePixel=0
main.Active=true
main.Draggable=true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,12)

local stroke=Instance.new("UIStroke",main)
stroke.Color=Color3.fromRGB(70,70,85)
stroke.Thickness=1

local side=Instance.new("Frame",main)
side.Size=UDim2.new(0,115,1,0)
side.BackgroundColor3=Color3.fromRGB(13,13,17)
side.BorderSizePixel=0
Instance.new("UICorner",side).CornerRadius=UDim.new(0,12)

local logo=Instance.new("ImageLabel",side)
logo.Size=UDim2.new(0,70,0,70)
logo.Position=UDim2.new(.5,-35,0,15)
logo.BackgroundColor3=Color3.fromRGB(25,25,30)
logo.Image=LOGO_ID
logo.ScaleType=Enum.ScaleType.Crop
Instance.new("UICorner",logo).CornerRadius=UDim.new(1,0)

local name=Instance.new("TextLabel",side)
name.Size=UDim2.new(1,0,0,35)
name.Position=UDim2.new(0,0,0,92)
name.BackgroundTransparency=1
name.Text="MoraiScript"
name.TextColor3=Color3.fromRGB(255,255,255)
name.TextScaled=true
name.Font=Enum.Font.GothamBold

local title=Instance.new("TextLabel",main)
title.Size=UDim2.new(0,280,0,40)
title.Position=UDim2.new(0,135,0,15)
title.BackgroundTransparency=1
title.Text="Build An Island"
title.TextColor3=Color3.fromRGB(255,255,255)
title.TextScaled=true
title.Font=Enum.Font.GothamBold
title.TextXAlignment=Enum.TextXAlignment.Left

local pages={}
local currentPage=nil

local function makePage(name)
    local page=Instance.new("Frame",main)
    page.Size=UDim2.new(0,270,0,210)
    page.Position=UDim2.new(0,135,0,60)
    page.BackgroundTransparency=1
    page.Visible=false
    pages[name]=page
    return page
end

local farmPage=makePage("Farm")
local craftPage=makePage("Craft")
local configPage=makePage("Config")

local function showPage(name)
    for _,v in pairs(pages) do
        v.Visible=false
    end
    pages[name].Visible=true
    currentPage=name
end

local function makeTab(text,y,page)
    local b=Instance.new("TextButton",side)
    b.Size=UDim2.new(0,95,0,32)
    b.Position=UDim2.new(0,10,0,y)
    b.BackgroundColor3=Color3.fromRGB(35,35,45)
    b.Text=text
    b.TextColor3=Color3.fromRGB(255,255,255)
    b.TextScaled=true
    b.Font=Enum.Font.GothamBold
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)

    b.MouseButton1Click:Connect(function()
        showPage(page)
    end)

    return b
end

makeTab("Farm",145,"Farm")
makeTab("Craft",185,"Craft")
makeTab("Config",225,"Config")

local function makeToggle(parent,text,y,callback)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,260,0,42)
    b.Position=UDim2.new(0,0,0,y)
    b.BackgroundColor3=Color3.fromRGB(28,28,35)
    b.Text=""
    b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)

    local lbl=Instance.new("TextLabel",b)
    lbl.Size=UDim2.new(1,-65,1,0)
    lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1
    lbl.Text=text
    lbl.TextColor3=Color3.fromRGB(235,235,235)
    lbl.TextScaled=true
    lbl.Font=Enum.Font.GothamBold
    lbl.TextXAlignment=Enum.TextXAlignment.Left

    local dot=Instance.new("Frame",b)
    dot.Size=UDim2.new(0,38,0,22)
    dot.Position=UDim2.new(1,-50,.5,-11)
    dot.BackgroundColor3=Color3.fromRGB(60,60,70)
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

    local ball=Instance.new("Frame",dot)
    ball.Size=UDim2.new(0,18,0,18)
    ball.Position=UDim2.new(0,2,.5,-9)
    ball.BackgroundColor3=Color3.fromRGB(180,180,190)
    Instance.new("UICorner",ball).CornerRadius=UDim.new(1,0)

    local state=false

    b.MouseButton1Click:Connect(function()
        state=not state
        callback(state)

        ts:Create(dot,TweenInfo.new(.18),{
            BackgroundColor3=state and Color3.fromRGB(70,140,90) or Color3.fromRGB(60,60,70)
        }):Play()

        ts:Create(ball,TweenInfo.new(.18),{
            Position=state and UDim2.new(1,-20,.5,-9) or UDim2.new(0,2,.5,-9),
            BackgroundColor3=state and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,190)
        }):Play()
    end)
end

local function makeButton(parent,text,y,callback)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,260,0,42)
    b.Position=UDim2.new(0,0,0,y)
    b.BackgroundColor3=Color3.fromRGB(28,28,35)
    b.Text=text
    b.TextColor3=Color3.fromRGB(235,235,235)
    b.TextScaled=true
    b.Font=Enum.Font.GothamBold
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    b.MouseButton1Click:Connect(callback)
end

-- FARM PAGE
makeToggle(farmPage,"Auto Harvest",0,function(v) harvest=v end)
makeToggle(farmPage,"Auto Sell",50,function(v) sell=v end)
makeToggle(farmPage,"Auto Resource",100,function(v) resource=v end)
makeToggle(farmPage,"Auto Fish",150,function(v) fish=v end)

-- CRAFT PAGE
makeToggle(craftPage,"Auto Craft",0,function(v) autoCraft=v end)
makeToggle(craftPage,"Double Craft",50,function(v) doubleCraft=v end)

local speedText=Instance.new("TextLabel",craftPage)
speedText.Size=UDim2.new(0,260,0,35)
speedText.Position=UDim2.new(0,0,0,105)
speedText.BackgroundTransparency=1
speedText.Text="Craft Delay: 0.5s"
speedText.TextColor3=Color3.new(1,1,1)
speedText.TextScaled=true
speedText.Font=Enum.Font.GothamBold

local craftDelay=.5

makeButton(craftPage,"Craft Speed +",145,function()
    craftDelay=math.max(.1,craftDelay-.1)
    speedText.Text="Craft Delay: "..string.format("%.1f",craftDelay).."s"
end)

makeButton(craftPage,"Craft Speed -",190,function()
    craftDelay=math.min(2,craftDelay+.1)
    speedText.Text="Craft Delay: "..string.format("%.1f",craftDelay).."s"
end)

-- CONFIG PAGE
local speedLabel=Instance.new("TextLabel",configPage)
speedLabel.Size=UDim2.new(0,260,0,35)
speedLabel.Position=UDim2.new(0,0,0,0)
speedLabel.BackgroundTransparency=1
speedLabel.Text="WalkSpeed: "..walkSpeed
speedLabel.TextColor3=Color3.new(1,1,1)
speedLabel.TextScaled=true
speedLabel.Font=Enum.Font.GothamBold

local function applySpeed()
    local char=p.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed=walkSpeed
    end
    speedLabel.Text="WalkSpeed: "..walkSpeed
end

makeButton(configPage,"Speed +",45,function()
    walkSpeed=math.min(100,walkSpeed+5)
    applySpeed()
end)

makeButton(configPage,"Speed -",95,function()
    walkSpeed=math.max(16,walkSpeed-5)
    applySpeed()
end)

makeButton(configPage,"Reset Speed",145,function()
    walkSpeed=16
    applySpeed()
end)

p.CharacterAdded:Connect(function()
    task.wait(1)
    applySpeed()
end)

local open=Instance.new("TextButton",g)
open.Size=UDim2.new(0,55,0,55)
open.Position=UDim2.new(0.02,0,.25,0)
open.BackgroundColor3=Color3.fromRGB(18,18,22)
open.Text="+"
open.TextScaled=true
open.Font=Enum.Font.GothamBold
open.TextColor3=Color3.new(1,1,1)
open.Visible=false
Instance.new("UICorner",open).CornerRadius=UDim.new(1,0)

local close=Instance.new("TextButton",main)
close.Size=UDim2.new(0,30,0,30)
close.Position=UDim2.new(1,-40,0,10)
close.BackgroundColor3=Color3.fromRGB(35,35,45)
close.Text="×"
close.TextScaled=true
close.Font=Enum.Font.GothamBold
close.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",close).CornerRadius=UDim.new(1,0)

close.MouseButton1Click:Connect(function()
    ts:Create(main,TweenInfo.new(.3),{Position=UDim2.new(-.5,0,.22,0)}):Play()
    task.wait(.3)
    main.Visible=false
    open.Visible=true
end)

open.MouseButton1Click:Connect(function()
    main.Visible=true
    open.Visible=false
    ts:Create(main,TweenInfo.new(.35,Enum.EasingStyle.Quint),{Position=UDim2.new(.03,0,.22,0)}):Play()
end)

showPage("Farm")
ts:Create(main,TweenInfo.new(.45,Enum.EasingStyle.Quint),{Position=UDim2.new(.03,0,.22,0)}):Play()

-- AUTO HARVEST
task.spawn(function()
    while task.wait(.9) do
        if harvest then
            local plots=w:FindFirstChild("Plots")
            if plots then
                table.clear(ids)
                for _,v in pairs(plots:GetDescendants()) do
                    local id=tonumber(v.Name)
                    if id and not ids[id] then
                        ids[id]=true
                        pcall(function()
                            h:FireServer(tostring(id))
                        end)
                    end
                end
            end
        end
    end
end)

-- AUTO SELL
task.spawn(function()
    while task.wait(3) do
        if sell then
            pcall(function()
                local list={}
                for i=1,150 do
                    table.insert(list,tostring(i))
                end
                s:FireServer(false,list)
            end)
        end
    end
end)

-- AUTO RESOURCE
task.spawn(function()
    while task.wait(.50) do
        if resource then
            pcall(function()
                local plots=w:FindFirstChild("Plots")
                if not plots then return end

                local myPlot=plots:FindFirstChild(p.Name)
                if not myPlot then return end

                local resources=myPlot:FindFirstChild("Resources")
                if not resources then return end

                for _,v in pairs(resources:GetChildren()) do
                    if not resource then break end
                    if v:IsA("Model") then
                        local hp=v:GetAttribute("HP")
                        if hp==nil or hp>0 then
                            hit:FireServer(v)
                            task.wait(.02)
                        end
                    end
                end
            end)
        end
    end
end)

-- AUTO FISH
task.spawn(function()
    while task.wait(.30) do
        if fish then
            pcall(function()
                fishRemote:InvokeServer(fishPos,fishPower)
            end)
        end
    end
end)

-- AUTO CRAFT
task.spawn(function()
    while task.wait(craftDelay) do
        if autoCraft or doubleCraft then
            pcall(function()
                local plots=w:FindFirstChild("Plots")
                if not plots then return end

                local myPlot=plots:FindFirstChild(p.Name)
                if not myPlot then return end

                for _,v in pairs(myPlot:GetDescendants()) do
                    if v.Name=="Attachment"
                    and v.Parent
                    and v.Parent.Name=="Crafter" then

                        if autoCraft then
                            craftRemote:FireServer(v)
                        end

                        if doubleCraft then
                            doubleCraftRemote:FireServer(v)
                        end

                        task.wait(.05)
                    end
                end
            end)
        end
    end
end)

print("MORAISCRIPT V2 LOADED")
