-- BUILD AN ISLAND
-- MORAISCRIPT MOBILE V4

repeat task.wait() until game:IsLoaded()

local p=game.Players.LocalPlayer
local r=game.ReplicatedStorage
local w=workspace
local ts=game:GetService("TweenService")
local vu=game:GetService("VirtualUser")
local lighting=game:GetService("Lighting")
local teleportService=game:GetService("TeleportService")

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
local fpsBoost=false

local walkSpeed=16
local craftDelay=.5

local selectedResources={}
local hittingResources={}
local resourceHits=5
local resourceHitDelay=.01

local resourceStats={}
local resourceButtons={}

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

-- NOTIFY
local notifyHolder=Instance.new("Frame",g)
notifyHolder.Size=UDim2.new(0,260,0,300)
notifyHolder.Position=UDim2.new(1,-275,0.15,0)
notifyHolder.BackgroundTransparency=1

local notifyLayout=Instance.new("UIListLayout",notifyHolder)
notifyLayout.Padding=UDim.new(0,8)

local function notify(text)
    local n=Instance.new("TextLabel",notifyHolder)
    n.Size=UDim2.new(1,0,0,42)
    n.BackgroundColor3=Color3.fromRGB(18,18,24)
    n.Text=text
    n.TextColor3=Color3.new(1,1,1)
    n.TextScaled=true
    n.Font=Enum.Font.GothamBold
    n.BackgroundTransparency=1
    n.TextTransparency=1

    Instance.new("UICorner",n).CornerRadius=UDim.new(0,10)

    ts:Create(n,TweenInfo.new(.25),{
        BackgroundTransparency=.08,
        TextTransparency=0
    }):Play()

    task.delay(2.5,function()
        ts:Create(n,TweenInfo.new(.3),{
            BackgroundTransparency=1,
            TextTransparency=1
        }):Play()

        task.wait(.35)
        n:Destroy()
    end)
end

-- MAIN
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
logo.Size=UDim2.new(0,72,0,72)
logo.Position=UDim2.new(.5,-36,0,15)
logo.BackgroundColor3=Color3.fromRGB(30,30,35)
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

local pages={}
local tabButtons={}

local function makePage(name,scroll)
    local page

    if scroll then
        page=Instance.new("ScrollingFrame",main)
        page.CanvasSize=UDim2.new(0,0,0,0)
        page.AutomaticCanvasSize=Enum.AutomaticSize.Y
        page.ScrollBarThickness=5
        page.ScrollBarImageColor3=Color3.fromRGB(90,120,255)

        local layout=Instance.new("UIListLayout",page)
        layout.Padding=UDim.new(0,8)
    else
        page=Instance.new("Frame",main)
    end

    page.Size=UDim2.new(0,310,0,250)
    page.Position=UDim2.new(0,145,0,65)
    page.BackgroundTransparency=1
    page.Visible=false

    pages[name]=page
    return page
end

local farmPage=makePage("Farm")
local craftPage=makePage("Craft")
local resourcesPage=makePage("Resources",true)
local statsPage=makePage("Stats",true)
local configPage=makePage("Config")

local function showPage(name)
    for _,v in pairs(pages) do
        v.Visible=false
    end

    pages[name].Visible=true
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

    b.MouseButton1Click:Connect(function()
        showPage(page)
        notify("Aba "..text)
    end)
end

makeTab("Farm",135,"Farm")
makeTab("Craft",172,"Craft")
makeTab("Resources",209,"Resources")
makeTab("Stats",246,"Stats")
makeTab("Config",283,"Config")

local function makeToggle(parent,text,y,callback)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,285,0,42)

    if parent:IsA("ScrollingFrame") then
        b.Position=UDim2.new(0,10,0,0)
    else
        b.Position=UDim2.new(0,10,0,y)
    end

    b.BackgroundColor3=Color3.fromRGB(28,28,35)
    b.Text=""

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

        notify(text.." "..(state and "ON" or "OFF"))
    end)

    return b
end

local function makeButton(parent,text,y,callback)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,285,0,42)
    b.Position=UDim2.new(0,10,0,y)
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
end

-- FARM
makeToggle(farmPage,"Auto Harvest",0,function(v)
    harvest=v
end)

makeToggle(farmPage,"Auto Sell",50,function(v)
    sell=v
end)

makeToggle(farmPage,"Auto Resource",100,function(v)
    resource=v
end)

makeToggle(farmPage,"Auto Fish",150,function(v)
    fish=v
end)

-- CRAFT
makeToggle(craftPage,"Auto Craft",0,function(v)
    autoCraft=v
end)

makeToggle(craftPage,"Double Craft",50,function(v)
    doubleCraft=v
end)

makeButton(craftPage,"Craft Speed +",110,function()
    craftDelay=math.max(.1,craftDelay-.1)
end)

makeButton(craftPage,"Craft Speed -",160,function()
    craftDelay=math.min(2,craftDelay+.1)
end)

-- CONFIG
makeButton(configPage,"WalkSpeed +",0,function()
    walkSpeed=walkSpeed+5
end)

makeButton(configPage,"WalkSpeed -",50,function()
    walkSpeed=math.max(16,walkSpeed-5)
end)

makeToggle(configPage,"FPS Boost",110,function(v)
    fpsBoost=v

    if fpsBoost then
        settings().Rendering.QualityLevel=Enum.QualityLevel.Level01

        for _,obj in pairs(game:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material=Enum.Material.Plastic
                obj.Reflectance=0
            end
        end
    end
end)

makeToggle(configPage,"Anti AFK",160,function(v)
    antiAfk=v
end)

makeButton(configPage,"Rejoin Server",210,function()
    teleportService:Teleport(game.PlaceId,p)
end)

showPage("Farm")

ts:Create(blur,TweenInfo.new(.25),{
    Size=8
}):Play()

ts:Create(main,TweenInfo.new(.4),{
    Position=UDim2.new(.03,0,.2,0)
}):Play()

notify("MoraiScript V4 Loaded")

-- RESOURCE SEARCH BAR
local searchBox=Instance.new("TextBox",resourcesPage)
searchBox.Size=UDim2.new(0,285,0,40)
searchBox.Position=UDim2.new(0,10,0,0)
searchBox.PlaceholderText="Search Resource..."
searchBox.Text=""
searchBox.TextColor3=Color3.new(1,1,1)
searchBox.PlaceholderColor3=Color3.fromRGB(150,150,150)
searchBox.BackgroundColor3=Color3.fromRGB(28,28,35)
searchBox.TextScaled=true
searchBox.Font=Enum.Font.GothamBold

Instance.new("UICorner",searchBox).CornerRadius=UDim.new(0,10)

local resourcesLayout=resourcesPage:FindFirstChildOfClass("UIListLayout")

local function refreshSearch()
    local txt=string.lower(searchBox.Text)

    for name,button in pairs(resourceButtons) do
        if txt=="" then
            button.Visible=true
        else
            button.Visible=string.find(string.lower(name),txt)~=nil
        end
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(refreshSearch)

-- SELECT ALL
local selectAll=Instance.new("TextButton",resourcesPage)
selectAll.Size=UDim2.new(0,138,0,38)
selectAll.Position=UDim2.new(0,10,0,0)
selectAll.BackgroundColor3=Color3.fromRGB(40,110,70)
selectAll.Text="Select All"
selectAll.TextColor3=Color3.new(1,1,1)
selectAll.TextScaled=true
selectAll.Font=Enum.Font.GothamBold

Instance.new("UICorner",selectAll).CornerRadius=UDim.new(0,10)

selectAll.MouseButton1Click:Connect(function()
    for name,_ in pairs(selectedResources) do
        selectedResources[name]=true
    end

    notify("Todos selecionados")
end)

-- UNSELECT ALL
local unselectAll=Instance.new("TextButton",resourcesPage)
unselectAll.Size=UDim2.new(0,138,0,38)
unselectAll.Position=UDim2.new(0,157,0,0)
unselectAll.BackgroundColor3=Color3.fromRGB(110,40,40)
unselectAll.Text="Unselect All"
unselectAll.TextColor3=Color3.new(1,1,1)
unselectAll.TextScaled=true
unselectAll.Font=Enum.Font.GothamBold

Instance.new("UICorner",unselectAll).CornerRadius=UDim.new(0,10)

unselectAll.MouseButton1Click:Connect(function()
    for name,_ in pairs(selectedResources) do
        selectedResources[name]=false
    end

    notify("Todos desmarcados")
end)

-- ACTIVE COUNT
local activeLabel=Instance.new("TextLabel",resourcesPage)
activeLabel.Size=UDim2.new(0,285,0,30)
activeLabel.BackgroundTransparency=1
activeLabel.Text="Active Resources: 0"
activeLabel.TextColor3=Color3.new(1,1,1)
activeLabel.TextScaled=true
activeLabel.Font=Enum.Font.GothamBold

task.spawn(function()
    while task.wait(.5) do
        local count=0

        for _,v in pairs(selectedResources) do
            if v then
                count=count+1
            end
        end

        activeLabel.Text="Active Resources: "..count
    end
end)

-- RESOURCE TOGGLES
local function createResourceToggle(resourceName)
    if selectedResources[resourceName]~=nil then
        return
    end

    selectedResources[resourceName]=false
    resourceStats[resourceName]=0

    local toggle=makeToggle(resourcesPage,resourceName,0,function(v)
        selectedResources[resourceName]=v
    end)

    resourceButtons[resourceName]=toggle
end

task.spawn(function()
    task.wait(2)

    local plots=w:FindFirstChild("Plots")
    if not plots then return end

    local myPlot=plots:FindFirstChild(p.Name)
    if not myPlot then return end

    local resources=myPlot:FindFirstChild("Resources")
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

-- STATS
local statLabels={}

local function updateStat(resourceName)
    if not statLabels[resourceName] then
        local lbl=Instance.new("TextLabel",statsPage)
        lbl.Size=UDim2.new(0,285,0,35)
        lbl.BackgroundColor3=Color3.fromRGB(28,28,35)
        lbl.TextColor3=Color3.new(1,1,1)
        lbl.TextScaled=true
        lbl.Font=Enum.Font.GothamBold

        Instance.new("UICorner",lbl).CornerRadius=UDim.new(0,10)

        statLabels[resourceName]=lbl
    end

    statLabels[resourceName].Text=
        resourceName..": "..resourceStats[resourceName]
end

task.spawn(function()
    while task.wait(1) do
        for name,_ in pairs(resourceStats) do
            updateStat(name)
        end
    end
end)

-- AUTO AFK
p.Idled:Connect(function()
    if antiAfk then
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end
end)

-- WALKSPEED
task.spawn(function()
    while task.wait(.5) do
        local char=p.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.WalkSpeed=walkSpeed
        end
    end
end)

-- AUTO HARVEST
task.spawn(function()
    while task.wait(.8) do
        if harvest then
            local plots=w:FindFirstChild("Plots")

            if plots then
                for _,v in pairs(plots:GetDescendants()) do
                    local id=tonumber(v.Name)

                    if id then
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
    while task.wait(.03) do
        if resource then
            pcall(function()

                local plots=w:FindFirstChild("Plots")
                if not plots then return end

                local myPlot=plots:FindFirstChild(p.Name)
                if not myPlot then return end

                local resources=myPlot:FindFirstChild("Resources")
                if not resources then return end

                local hasSelected=false

                for _,v in pairs(selectedResources) do
                    if v then
                        hasSelected=true
                        break
                    end
                end

                for _,v in ipairs(resources:GetChildren()) do
                    if v:IsA("Model") then

                        local canFarm=false

                        if hasSelected then
                            canFarm=selectedResources[v.Name]==true
                        else
                            canFarm=true
                        end

                        if canFarm then
                            local hp=v:GetAttribute("HP")

                            if hp==nil or hp>0 then
                                task.spawn(function()

                                    for i=1,resourceHits do
                                        hit:FireServer(v)
                                        task.wait(resourceHitDelay)
                                    end

                                    resourceStats[v.Name]=
                                        (resourceStats[v.Name] or 0)+1

                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- AUTO FISH FAST
task.spawn(function()
    while task.wait(.12) do
        if fish then
            pcall(function()
                fishRemote:InvokeServer(fishPos,fishPower)
                task.wait(.03)
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

print("MORAISCRIPT V4 LOADED")