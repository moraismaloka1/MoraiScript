--// MORAISHUB UNIVERSAL V1
--// BUILD AN ISLAND + OIL EMPIRE

repeat task.wait() until game:IsLoaded()

local PLACE_ID = game.PlaceId

--////////////////////////////////////////////////////
-- PLACE IDS
--////////////////////////////////////////////////////

local BUILD_AN_ISLAND = {
    [101949297449238] = true
}

local OIL_EMPIRE = {
    [107095834793267] = true
}

--////////////////////////////////////////////////////
-- BUILD AN ISLAND
--////////////////////////////////////////////////////

local function LoadBuildAnIsland()

    loadstring([[
        -- BUILD AN ISLAND
-- MORAISCRIPT V4 LITE

repeat task.wait() until game:IsLoaded()

local p=game.Players.LocalPlayer
local r=game.ReplicatedStorage
local w=workspace
local ts=game:GetService("TweenService")
local vu=game:GetService("VirtualUser")
local lighting=game:GetService("Lighting")
local tp=game:GetService("TeleportService")

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
local antiAfk=false

local walkSpeed=16
local craftDelay=.5
local resourceHits=5
local resourceHitDelay=.01

local selectedResources={}
local resourceButtons={}
local hittingResources={}

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

local g=Instance.new("ScreenGui",game.CoreGui)
g.Name="MoraiScript"
g.ResetOnSpawn=false

local blur=Instance.new("BlurEffect",lighting)
blur.Size=0

local function notify(txt)
    game.StarterGui:SetCore("SendNotification",{
        Title="MoraiScript",
        Text=txt,
        Duration=2
    })
end

local main=Instance.new("Frame",g)
main.Size=UDim2.new(0,470,0,330)
main.Position=UDim2.new(-.5,0,.2,0)
main.BackgroundColor3=Color3.fromRGB(18,18,22)
main.BorderSizePixel=0
main.Active=true
main.Draggable=true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,12)

local side=Instance.new("Frame",main)
side.Size=UDim2.new(0,120,1,0)
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
name.TextColor3=Color3.new(1,1,1)
name.TextScaled=true
name.Font=Enum.Font.GothamBold

local title=Instance.new("TextLabel",main)
title.Size=UDim2.new(0,280,0,40)
title.Position=UDim2.new(0,140,0,12)
title.BackgroundTransparency=1
title.Text="Build An Island"
title.TextColor3=Color3.new(1,1,1)
title.TextScaled=true
title.Font=Enum.Font.GothamBold
title.TextXAlignment=Enum.TextXAlignment.Left

local close=Instance.new("TextButton",main)
close.Size=UDim2.new(0,30,0,30)
close.Position=UDim2.new(1,-40,0,10)
close.BackgroundColor3=Color3.fromRGB(35,35,45)
close.Text="–"
close.TextScaled=true
close.Font=Enum.Font.GothamBold
close.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",close).CornerRadius=UDim.new(1,0)

local open=Instance.new("TextButton",g)
open.Size=UDim2.new(0,55,0,55)
open.Position=UDim2.new(.02,0,.25,0)
open.BackgroundColor3=Color3.fromRGB(18,18,22)
open.Text="+"
open.TextScaled=true
open.Font=Enum.Font.GothamBold
open.TextColor3=Color3.new(1,1,1)
open.Visible=false
open.Active=true
open.Draggable=true
Instance.new("UICorner",open).CornerRadius=UDim.new(1,0)

close.MouseButton1Click:Connect(function()
    ts:Create(blur,TweenInfo.new(.25),{Size=0}):Play()
    ts:Create(main,TweenInfo.new(.25),{Position=UDim2.new(-.5,0,.2,0)}):Play()
    task.wait(.25)
    main.Visible=false
    open.Visible=true
end)

open.MouseButton1Click:Connect(function()
    main.Visible=true
    open.Visible=false
    ts:Create(blur,TweenInfo.new(.25),{Size=8}):Play()
    ts:Create(main,TweenInfo.new(.35),{Position=UDim2.new(.03,0,.2,0)}):Play()
end)

local pages={}
local tabButtons={}

local function makePage(name)
    local page=Instance.new("ScrollingFrame",main)
    page.Size=UDim2.new(0,310,0,250)
    page.Position=UDim2.new(0,145,0,65)
    page.BackgroundTransparency=1
    page.BorderSizePixel=0
    page.Visible=false
    page.CanvasSize=UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    page.ScrollBarThickness=5
    page.ScrollBarImageColor3=Color3.fromRGB(90,120,255)

    local layout=Instance.new("UIListLayout",page)
    layout.Padding=UDim.new(0,8)
    layout.SortOrder=Enum.SortOrder.LayoutOrder

    pages[name]=page
    return page
end

local farmPage=makePage("Farm")
local craftPage=makePage("Craft")
local resourcesPage=makePage("Resources")
local configPage=makePage("Config")

local function showPage(name)
    for _,v in pairs(pages) do
        v.Visible=false
    end

    pages[name].Visible=true

    for tabName,btn in pairs(tabButtons) do
        btn.BackgroundColor3=tabName==name and Color3.fromRGB(70,90,190) or Color3.fromRGB(35,35,45)
    end
end

local function makeTab(text,y,page)
    local b=Instance.new("TextButton",side)
    b.Size=UDim2.new(0,98,0,30)
    b.Position=UDim2.new(0,10,0,y)
    b.BackgroundColor3=Color3.fromRGB(35,35,45)
    b.Text=text
    b.TextColor3=Color3.new(1,1,1)
    b.TextScaled=true
    b.Font=Enum.Font.GothamBold
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)

    tabButtons[page]=b

    b.MouseButton1Click:Connect(function()
        showPage(page)
    end)
end

makeTab("Farm",135,"Farm")
makeTab("Craft",172,"Craft")
makeTab("Resources",209,"Resources")
makeTab("Config",246,"Config")

local function makeToggle(parent,text,callback)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,285,0,42)
    b.BackgroundColor3=Color3.fromRGB(28,28,35)
    b.Text=""
    b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)

    local lbl=Instance.new("TextLabel",b)
    lbl.Size=UDim2.new(1,-65,1,0)
    lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1
    lbl.Text=text
    lbl.TextColor3=Color3.new(1,1,1)
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
    ball.BackgroundColor3=Color3.new(1,1,1)
    Instance.new("UICorner",ball).CornerRadius=UDim.new(1,0)

    local state=false

    b.MouseButton1Click:Connect(function()
        state=not state
        callback(state)

        ts:Create(ball,TweenInfo.new(.15),{
            Position=state and UDim2.new(1,-20,.5,-9) or UDim2.new(0,2,.5,-9)
        }):Play()

        ts:Create(dot,TweenInfo.new(.15),{
            BackgroundColor3=state and Color3.fromRGB(70,140,90) or Color3.fromRGB(60,60,70)
        }):Play()

        notify(text.." "..(state and "ON" or "OFF"))
    end)

    return b
end

local function makeButton(parent,text,callback)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,285,0,42)
    b.BackgroundColor3=Color3.fromRGB(28,28,35)
    b.Text=text
    b.TextColor3=Color3.new(1,1,1)
    b.TextScaled=true
    b.Font=Enum.Font.GothamBold
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)

    b.MouseButton1Click:Connect(function()
        callback()
        notify(text)
    end)

    return b
end

-- FARM
makeToggle(farmPage,"Auto Harvest",function(v) harvest=v end)
makeToggle(farmPage,"Auto Sell",function(v) sell=v end)
makeToggle(farmPage,"Auto Resource",function(v) resource=v end)
makeToggle(farmPage,"Auto Fish",function(v) fish=v end)

-- CRAFT
makeToggle(craftPage,"Auto Craft",function(v) autoCraft=v end)
makeToggle(craftPage,"Double Craft",function(v) doubleCraft=v end)

makeButton(craftPage,"Craft Speed +",function()
    craftDelay=math.max(.1,craftDelay-.1)
end)

makeButton(craftPage,"Craft Speed -",function()
    craftDelay=math.min(2,craftDelay+.1)
end)

-- RESOURCES
local searchBox=Instance.new("TextBox",resourcesPage)
searchBox.Size=UDim2.new(0,285,0,40)
searchBox.BackgroundColor3=Color3.fromRGB(28,28,35)
searchBox.PlaceholderText="Search Resource..."
searchBox.Text=""
searchBox.TextColor3=Color3.new(1,1,1)
searchBox.PlaceholderColor3=Color3.fromRGB(150,150,150)
searchBox.TextScaled=true
searchBox.Font=Enum.Font.GothamBold
Instance.new("UICorner",searchBox).CornerRadius=UDim.new(0,10)

local selectAll=makeButton(resourcesPage,"Select All",function()
    for k in pairs(selectedResources) do
        selectedResources[k]=true
    end
end)

local unselectAll=makeButton(resourcesPage,"Unselect All",function()
    for k in pairs(selectedResources) do
        selectedResources[k]=false
    end
end)

local activeLabel=Instance.new("TextLabel",resourcesPage)
activeLabel.Size=UDim2.new(0,285,0,32)
activeLabel.BackgroundTransparency=1
activeLabel.Text="Active Resources: 0"
activeLabel.TextColor3=Color3.new(1,1,1)
activeLabel.TextScaled=true
activeLabel.Font=Enum.Font.GothamBold

local function refreshSearch()
    local txt=string.lower(searchBox.Text)

    for name,button in pairs(resourceButtons) do
        button.Visible=txt=="" or string.find(string.lower(name),txt)~=nil
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(refreshSearch)

local function createResourceToggle(resourceName)
    if selectedResources[resourceName]~=nil then return end

    selectedResources[resourceName]=false

    local button=makeToggle(resourcesPage,resourceName,function(v)
        selectedResources[resourceName]=v
    end)

    resourceButtons[resourceName]=button
    refreshSearch()
end

task.spawn(function()
    task.wait(2)

    local plot=w:FindFirstChild("Plots") and w.Plots:FindFirstChild(p.Name)
    local resources=plot and plot:FindFirstChild("Resources")
    if not resources then return end

    for _,v in pairs(resources:GetChildren()) do
        if v:IsA("Model") then
            createResourceToggle(v.Name)
        end
    end

    resources.ChildAdded:Connect(function(v)
        task.wait(.2)
        if v:IsA("Model") then
            createResourceToggle(v.Name)
        end
    end)
end)

task.spawn(function()
    while task.wait(.5) do
        local count=0
        for _,v in pairs(selectedResources) do
            if v then count+=1 end
        end
        activeLabel.Text="Active Resources: "..count
    end
end)

-- CONFIG
makeButton(configPage,"WalkSpeed +",function()
    walkSpeed+=5
end)

makeButton(configPage,"WalkSpeed -",function()
    walkSpeed=math.max(16,walkSpeed-5)
end)

makeButton(configPage,"Reset Speed",function()
    walkSpeed=16
end)

makeToggle(configPage,"FPS Boost",function(v)
    if v then
        settings().Rendering.QualityLevel=Enum.QualityLevel.Level01
        for _,obj in pairs(w:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material=Enum.Material.Plastic
                obj.Reflectance=0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency=1
            end
        end
    end
end)

makeToggle(configPage,"Anti AFK",function(v)
    antiAfk=v
end)

makeButton(configPage,"Rejoin Server",function()
    tp:Teleport(game.PlaceId,p)
end)

showPage("Farm")
ts:Create(blur,TweenInfo.new(.25),{Size=8}):Play()
ts:Create(main,TweenInfo.new(.35),{Position=UDim2.new(.03,0,.2,0)}):Play()

notify("MoraiScript Lite carregado")

-- ANTI AFK
p.Idled:Connect(function()
    if antiAfk then
        vu:Button2Down(Vector2.new(0,0),w.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),w.CurrentCamera.CFrame)
    end
end)

-- WALKSPEED
task.spawn(function()
    while task.wait(.5) do
        local hum=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed=walkSpeed end
    end
end)

-- AUTO HARVEST
task.spawn(function()
    while task.wait(.8) do
        if harvest then
            pcall(function()
                local plots=w:FindFirstChild("Plots")
                if not plots then return end

                for _,v in pairs(plots:GetDescendants()) do
                    local id=tonumber(v.Name)
                    if id then
                        h:FireServer(tostring(id))
                    end
                end
            end)
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
    while task.wait(.05) do
        if resource then
            pcall(function()
                local plot=w:FindFirstChild("Plots") and w.Plots:FindFirstChild(p.Name)
                local resources=plot and plot:FindFirstChild("Resources")
                if not resources then return end

                for _,v in ipairs(resources:GetChildren()) do
                    if v:IsA("Model") then
                        local canFarm = selectedResources[v.Name] == true

                        if canFarm and not hittingResources[v] then
                            local hp=v:GetAttribute("HP")

                            if hp==nil or hp>0 then
                                hittingResources[v]=true

                                task.spawn(function()
                                    for i=1,resourceHits do
                                        if not resource then break end
                                        if selectedResources[v.Name] ~= true then break end

                                        hit:FireServer(v)
                                        task.wait(resourceHitDelay)
                                    end

                                    task.wait(.03)
                                    hittingResources[v]=nil
                                end)
                            end
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
                local plot=w:FindFirstChild("Plots") and w.Plots:FindFirstChild(p.Name)
                if not plot then return end

                for _,v in pairs(plot:GetDescendants()) do
                    if v.Name=="Attachment" and v.Parent and v.Parent.Name=="Crafter" then
                        if autoCraft then craftRemote:FireServer(v) end
                        if doubleCraft then doubleCraftRemote:FireServer(v) end
                        task.wait(.05)
                    end
                end
            end)
        end
    end
end)

print("MORAISCRIPT V4 LITE LOADED")
        print("BUILD AN ISLAND LOADED")
    ]])()

end

--////////////////////////////////////////////////////
-- OIL EMPIRE
--////////////////////////////////////////////////////

local function LoadOilEmpire()

    loadstring([[
        --// OIL EMPIRE HUB V4

        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local TweenService = game:GetService("TweenService")

        local p = Players.LocalPlayer
        local char = p.Character or p.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        local sellGas = ReplicatedStorage.Packages.Knit.Services.BaseService.RE.SellGas

        local autoCollect = false
        local smartSell = true

        local savedPosition = nil
        local moveRadius = 3

        local allowedPrices = {
            [10] = true,
            [11] = true,
            [12] = true,
            [13] = true,
            [14] = true,
            [15] = true
        }

        local lastSell = 0

        local gui = Instance.new("ScreenGui")
        gui.Name = "OilEmpireHub"
        gui.ResetOnSpawn = false
        gui.Parent = game.CoreGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0,220,0,180)
        frame.Position = UDim2.new(0,20,0.5,-90)
        frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
        frame.BorderSizePixel = 0
        frame.Parent = gui

        Instance.new("UICorner", frame)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1,0,0,35)
        title.BackgroundTransparency = 1
        title.Text = "Oil Empire Hub"
        title.TextColor3 = Color3.new(1,1,1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        title.Parent = frame

        local miniBtn = Instance.new("TextButton")
        miniBtn.Size = UDim2.new(0,30,0,30)
        miniBtn.Position = UDim2.new(1,-35,0,5)
        miniBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        miniBtn.Text = "-"
        miniBtn.TextColor3 = Color3.new(1,1,1)
        miniBtn.Font = Enum.Font.GothamBold
        miniBtn.TextSize = 18
        miniBtn.Parent = frame

        Instance.new("UICorner", miniBtn)

        local openBtn = Instance.new("TextButton")
        openBtn.Size = UDim2.new(0,60,0,60)
        openBtn.Position = UDim2.new(0,20,0.5,-30)
        openBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        openBtn.Text = "HUB"
        openBtn.TextColor3 = Color3.new(1,1,1)
        openBtn.Font = Enum.Font.GothamBold
        openBtn.TextSize = 16
        openBtn.Visible = false
        openBtn.Parent = gui

        Instance.new("UICorner", openBtn)

        local collectBtn = Instance.new("TextButton")
        collectBtn.Size = UDim2.new(0,180,0,40)
        collectBtn.Position = UDim2.new(0,20,0,50)
        collectBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        collectBtn.Text = "AUTO COLETAR: OFF"
        collectBtn.TextColor3 = Color3.new(1,1,1)
        collectBtn.Font = Enum.Font.GothamBold
        collectBtn.TextSize = 14
        collectBtn.Parent = frame

        Instance.new("UICorner", collectBtn)

        local sellBtn = Instance.new("TextButton")
        sellBtn.Size = UDim2.new(0,180,0,40)
        sellBtn.Position = UDim2.new(0,20,0,100)
        sellBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
        sellBtn.Text = "SMART SELL: ON"
        sellBtn.TextColor3 = Color3.new(1,1,1)
        sellBtn.Font = Enum.Font.GothamBold
        sellBtn.TextSize = 14
        sellBtn.Parent = frame

        Instance.new("UICorner", sellBtn)

        local function notify(txt)
            pcall(function()
                game.StarterGui:SetCore("SendNotification",{
                    Title = "Oil Empire Hub",
                    Text = txt,
                    Duration = 3
                })
            end)
        end

        local function getGasPrice()

            local guiPlayer = p:FindFirstChild("PlayerGui")
            if not guiPlayer then
                return nil
            end

            for _,v in pairs(guiPlayer:GetDescendants()) do

                if v:IsA("TextLabel") or v:IsA("TextButton") then

                    local text = tostring(v.Text)

                    local price =
                        text:match("Preço Atual:%s*%$(%d+)")
                        or text:match("Gasoline Price Changed:%s*%$(%d+)")

                    if price then

                        price = tonumber(price)

                        if price and price >= 1 and price <= 15 then
                            return price
                        end
                    end
                end
            end

            return nil
        end

        task.spawn(function()

            while task.wait(0.6) do

                if autoCollect and savedPosition then

                    local pos1 = savedPosition + Vector3.new(moveRadius,0,0)
                    local pos2 = savedPosition + Vector3.new(-moveRadius,0,0)

                    local tween1 = TweenService:Create(
                        hrp,
                        TweenInfo.new(0.3, Enum.EasingStyle.Linear),
                        {
                            CFrame = CFrame.new(pos1)
                        }
                    )

                    tween1:Play()
                    tween1.Completed:Wait()

                    local tween2 = TweenService:Create(
                        hrp,
                        TweenInfo.new(0.3, Enum.EasingStyle.Linear),
                        {
                            CFrame = CFrame.new(pos2)
                        }
                    )

                    tween2:Play()
                    tween2.Completed:Wait()
                end
            end
        end)

        task.spawn(function()

            while task.wait(1) do

                if smartSell then

                    pcall(function()

                        local price = getGasPrice()

                        if price and allowedPrices[price] then

                            if os.clock() - lastSell >= 25 then

                                lastSell = os.clock()

                                sellGas:FireServer()

                                notify("VENDEU NO $"..price)
                            end
                        end
                    end)
                end
            end
        end)

        collectBtn.MouseButton1Click:Connect(function()

            autoCollect = not autoCollect

            if autoCollect then

                savedPosition = hrp.Position

                collectBtn.Text = "AUTO COLETAR: ON"
                collectBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)

                notify("POSIÇÃO SALVA")

            else

                collectBtn.Text = "AUTO COLETAR: OFF"
                collectBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)

                notify("AUTO COLETAR DESLIGADO")
            end
        end)

        sellBtn.MouseButton1Click:Connect(function()

            smartSell = not smartSell

            if smartSell then

                sellBtn.Text = "SMART SELL: ON"
                sellBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)

            else

                sellBtn.Text = "SMART SELL: OFF"
                sellBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            end
        end)

        miniBtn.MouseButton1Click:Connect(function()

            frame.Visible = false
            openBtn.Visible = true
        end)

        openBtn.MouseButton1Click:Connect(function()

            frame.Visible = true
            openBtn.Visible = false
        end)
    ]])()

end

--////////////////////////////////////////////////////
-- GAME DETECTION
--////////////////////////////////////////////////////

if BUILD_AN_ISLAND[PLACE_ID] then

    LoadBuildAnIsland()

elseif OIL_EMPIRE[PLACE_ID] then

    LoadOilEmpire()

else

    warn("GAME NOT SUPPORTED")
end