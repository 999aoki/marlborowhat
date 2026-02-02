local AI = {}

function AI.GetMouse()
    local UserInputService = game:GetService("UserInputService")
    return UserInputService:GetMouseLocation()
end

function AI.GetClosestPlayer()
    local closestDistance = math.huge
    local closestTarget = nil
    for _, v in pairs(game:GetService("Workspace").Alive:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer.Character then
            local humanoidRootPart = v.HumanoidRootPart
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestTarget = v
            end
        end
    end
    return closestTarget
end

function AI.PlayerSafetyLoop()
    spawn(function()
        while task.wait() do
            if _G.PlayerSaftey then
                if not game.Players.LocalPlayer.Character or game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end
                pcall(function()
                    local closestPlayer = AI.GetClosestPlayer()
                    if closestPlayer and (closestPlayer.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= _G.PlayerSaftey_Distance then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = closestPlayer.HumanoidRootPart.CFrame * CFrame.new(-25, 0, -_G.PlayerSaftey_Distance)
                    end
                end)
            end
        end
    end)
end

function AI.GetBall()
    for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
        if v:IsA("Part") then
            return v
        end
    end
    return nil
end

function AI.GetBallFromPlayerPos(Ball)
    return (Ball.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
end

function AI.getSpeed(part)
    if part:IsA("BasePart") then
        local speed = part.Velocity.Magnitude
        if speed > 1 then
            return part, speed
        end
        return nil, nil
    end
    return nil, nil
end

function AI.measureVerticalDistance(humanoidRootPart, targetPart)
    local humanoidRootPartY = humanoidRootPart.Position.Y
    local targetPartY = targetPart.Position.Y
    return math.abs(humanoidRootPartY - targetPartY)
end

function AI.GetHotKey()
    for _, v in pairs(game.Players.LocalPlayer.PlayerGui.Hotbar.Block.HotkeyFrame:GetChildren()) do
        if v:IsA("TextLabel") then
            return v.Text
        end
    end
    return ""
end

function AI.InitializeHotKeyTracking()
    local text = game.Players.LocalPlayer.PlayerGui.Hotbar.Block.HotkeyFrame:FindFirstChild("F")
    if text then
        local KeyCodeBlock = text.Text
        text:GetPropertyChangedSignal("Text"):Connect(function()
            KeyCodeBlock = text.Text
        end)
        return KeyCodeBlock
    end
    return nil
end

function AI.RandomAutoParryLoop(KeyCodeBlock)
    local CanSlash = false
    local BallSpeed = 0
    
    spawn(function()
        while task.wait() do
            if _G.RandAutoaParry and _G.RandAutoaParry[tostring(_G.RandRNG)] then
                pcall(function()
                    for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                        if v:IsA("Part") then
                            if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("Highlight") then return end
                            local part, speed = AI.getSpeed(v)
                            if part and speed then
                                local minDistance = 2.5 * (speed * 0.1) + 2
                                if minDistance == 0 or minDistance <= 20 then
                                    BallSpeed = 23
                                elseif minDistance > 20 and minDistance <= 88 then
                                    BallSpeed = 2.5 * (speed * 0.1) + 5
                                elseif minDistance > 88 and minDistance <= 110 then
                                    BallSpeed = 90
                                end
                                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude <= BallSpeed then
                                    CanSlash = true
                                else
                                    CanSlash = false
                                end
                            end
                        end
                    end

                    if CanSlash then
                        if math.random(1, 5) == 5 then
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        else
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[KeyCodeBlock], false, game)
                        end
                        CanSlash = false
                    end
                end)
            end
        end
    end)
end

function AI.AutoWalkAndJumpLoop()
    spawn(function()
        while task.wait() do
            if _G.AutoWalk then
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local character = player.Character

                    if character and character.Parent and character.Parent.Name ~= "Dead" then
                        local targetPosition
                        for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                            if v:IsA("Part") then
                                local part, speed = AI.getSpeed(v)
                                if part and speed and speed > 5 then
                                    targetPosition = part.Position + Vector3.new(_G.AutoWalkDistanceX, 0, _G.AutoWalkDistanceZ)
                                    break
                                end
                            end
                        end

                        if not targetPosition then
                            for _, p in pairs(game:GetService("Workspace").Alive:GetChildren()) do
                                if p ~= character and p:FindFirstChild("HumanoidRootPart") then
                                    targetPosition = p.HumanoidRootPart.Position + Vector3.new(_G.AutoWalkDistanceX, 0, _G.AutoWalkDistanceZ)
                                    break
                                end
                            end
                        end

                        if targetPosition then
                            character:FindFirstChildOfClass("Humanoid"):MoveTo(targetPosition)
                        end
                    end
                end)
            end

            if _G.AutoDoubleJump then
                local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    if humanoid:GetState() == Enum.HumanoidStateType.Freefall or humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                        task.wait(0.1)
                    else
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait(0.3)
                    end
                end
            end
        end
    end)
end

function AI.ClosestPlayerCameraLoop()
    spawn(function()
        while task.wait() do
            if _G.ClosestPlayer_var then
                pcall(function()
                    local character = game.Players.LocalPlayer.Character
                    if character and character.Parent.Name ~= "Dead" then
                        local closestPlayer = AI.GetClosestPlayer()
                        if closestPlayer and closestPlayer:FindFirstChild("Head") then
                            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Head.Position)
                        end
                    end
                end)
            end
        end
    end)
end

function AI.RandomTeleportLoop()
    spawn(function()
        while task.wait(math.random(1, 2)) do
            if _G.RandomTeleports then
                pcall(function()
                    local character = game.Players.LocalPlayer.Character
                    if character and character.Parent.Name ~= "Dead" then
                        for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                            if v:IsA("Part") then
                                local targetPlayer = AI.GetClosestPlayer()
                                if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
                                    local randomOffset = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
                                    character.HumanoidRootPart.CFrame = CFrame.new(targetPlayer.HumanoidRootPart.Position + randomOffset)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end

function AI.CreateAutoParrySystem()
    local Auto_Parry = {}
    local Closest_Entity = nil
    local Parried = false
    local Parries = 0
    local Curving = 0
    local Phantom = false
    local Connections_Manager = {}
    
    local Player = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StatsService = game:GetService("Stats")
    
    function Auto_Parry.Get_Ball()
        for _, v in pairs(workspace.Balls:GetChildren()) do
            if v:IsA("Part") then
                return v
            end
        end
        return nil
    end
    
    function Auto_Parry.Closest_Player()
        local Distance = math.huge
        for _, v in pairs(workspace.Alive:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v ~= Player.Character then
                local Magnitude = (Player.Character.PrimaryPart.Position - v.HumanoidRootPart.Position).Magnitude
                if Magnitude < Distance then
                    Distance = Magnitude
                    Closest_Entity = v
                end
            end
        end
    end
    
    function Auto_Parry.Is_Curved()
        if tick() - Curving <= 0.10 then
            return true
        end
        return false
    end
    
    function Auto_Parry.Parry(ParryType)
        if ParryType == "Key Press" then
            local KeyCodeBlock = AI.GetHotKey()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[KeyCodeBlock], false, game)
        elseif ParryType == "Mouse Click" then
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
        end
    end
    
    ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
        if _G.hit_Sound_Enabled and _G.hit_Sound then
            _G.hit_Sound:Play()
        end
    end)
    
    ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
        if root.Parent and root.Parent ~= Player.Character then
            if root.Parent.Parent ~= workspace.Alive then
                return
            end
        end
        
        Auto_Parry.Closest_Player()
        
        local Ball = Auto_Parry.Get_Ball()
        
        if not Ball then
            return
        end
        
        local Target_Distance = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
        local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
        local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
        local Dot = Direction:Dot(Ball.AssemblyLinearVelocity.Unit)
        
        local Curve_Detected = Auto_Parry.Is_Curved()
        
        if Target_Distance < 15 and Distance < 15 and Dot > -0.25 then
            if Curve_Detected then
                Auto_Parry.Parry(_G.Selected_Parry_Type)
            end
        end
        
        if not _G.Grab_Parry then
            return
        end
        
        _G.Grab_Parry:Stop()
    end)
    
    ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
        if Player.Character.Parent ~= workspace.Alive then
            return
        end
        
        if not _G.Grab_Parry then
            return
        end
        
        _G.Grab_Parry:Stop()
    end)
    
    workspace.Balls.ChildAdded:Connect(function()
        Parried = false
    end)
    
    workspace.Balls.ChildRemoved:Connect(function(Value)
        Parries = 0
        Parried = false
        
        if Connections_Manager['Target Change'] then
            Connections_Manager['Target Change']:Disconnect()
            Connections_Manager['Target Change'] = nil
        end
    end)
    
    ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(a, b)
        local Primary_Part = Player.Character.PrimaryPart
        local Ball = Auto_Parry.Get_Ball()
        
        if not Ball then
            return
        end
        
        local Zoomies = Ball:FindFirstChild('zoomies')
        
        if not Zoomies then
            return
        end
        
        local Speed = Zoomies.VectorVelocity.Magnitude
        
        local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
        local Velocity = Zoomies.VectorVelocity
        
        local Ball_Direction = Velocity.Unit
        
        local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
        local Dot = Direction:Dot(Ball_Direction)
        
        local Pings = StatsService and StatsService.Network and StatsService.Network.ServerStatsItem and StatsService.Network.ServerStatsItem["Data Ping"] and StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() or 0
        
        local Speed_Threshold = math.min(Speed / 100, 40)
        local Reach_Time = Distance / Speed - (Pings / 1000)
        
        local Enough_Speed = Speed > 100
        local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Speed_Threshold
        
        if Enough_Speed and Reach_Time > Pings / 10 then
            Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
        end
        
        if b ~= Primary_Part and Distance > Ball_Distance_Threshold then
            Curving = tick()
        end
    end)
    
    game:GetService('ReplicatedStorage').Remotes.Phantom.OnClientEvent:Connect(function(a, b)
        if b.Name == tostring(Player) then
            Phantom = true
        else
            Phantom = false
        end
    end)
    
    local Balls = workspace:WaitForChild('Balls')
    
    Balls.ChildRemoved:Connect(function()
        Phantom = false
    end)
    
    return Auto_Parry
end

return AI
