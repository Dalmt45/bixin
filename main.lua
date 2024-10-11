local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "SONIC.EXE TD HUB",
   LoadingTitle = "runners interference",
   LoadingSubtitle = "by Len",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "EXE Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "sirius", -- The Discord invite code, do not include discord.gg/
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "SONIC.EXE TD Hub",
      Subtitle = "small exe",
      Note = "cooldown is buggy, Shadow is reccommended",
      FileName = "SonicKey",
      SaveKey = true,
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = "Hello"
   }
})

local EXETab = Window:CreateTab("EXE", nil) -- Title, Image

local SurvivorTab = Window:CreateTab("Survivor", nil) -- Title, Image

local MiscTab = Window:CreateTab("Misc", nil) -- Title, Image
local MiscSection = MiscTab:CreateSection("Misc") 

local CharacterTab = Window:CreateTab("Characters", nil) -- Title, Image
local CharacterSection = CharacterTab:CreateSection("Character") 

local Toggle = SurvivorTab:CreateToggle({
   Name = "No Cooldown (buggy, shadow reccommended)",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   loadstring(game:HttpGet("https://pastefy.app/zYqtLBzK/raw"))()
   end,
})

local Button = SurvivorTab:CreateButton({
   Name = "kill exe (metal)",
   Info = "use once you grab exe with push", -- Speaks for itself, Remove if none.
   Callback = function()
   local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- Folder where player configurations are stored
local displayPlayers = replicatedStorage:FindFirstChild("displayPlayers")

local targetPlayerName = nil  -- This will store the name of the player with "sonicexe" or "sonicexe_2"

-- Function to find the target player whose character is "sonicexe" or "sonicexe_2"
local function findTargetPlayer()
    if displayPlayers then
        for _, playerFolder in pairs(displayPlayers:GetChildren()) do
            local playerInstance = players:FindFirstChild(playerFolder.Name)
            if playerInstance then
                local statsFolder = playerFolder:FindFirstChild("stats")
                if statsFolder and statsFolder:FindFirstChild("character") then
                    local characterValue = statsFolder.character.Value
                    if characterValue == "sonicexe" or characterValue == "sonicexe_2" then
                        targetPlayerName = playerFolder.Name  -- Store the player name
                        return true  -- Stop once the player is found
                    end
                end
            end
        end
    end
    return false
end

-- Function to fire events based on the local player's character
local function fireEventsForLocalPlayer()
    local localPlayer = players.LocalPlayer
    local localPlayerName = localPlayer.Name  -- Get local player name

    local localPlayerFolder = displayPlayers:FindFirstChild(localPlayerName)

    if localPlayerFolder and localPlayerFolder:FindFirstChild("stats") and localPlayerFolder.stats:FindFirstChild("character") then
        local localCharacterValue = localPlayerFolder.stats.character.Value  -- Access character value

        if targetPlayerName and localCharacterValue == "metalsonic" then
            -- Save the local player's current position before any teleport
            local savedPosition = localPlayer.Character.PrimaryPart.Position

            -- Teleport the local player to the target player
            local targetPlayerCharacter = game:GetService("Players")[targetPlayerName].Character
            if targetPlayerCharacter then
                localPlayer.Character:SetPrimaryPartCFrame(targetPlayerCharacter.PrimaryPart.CFrame)

                -- Fire remote events after teleporting to the target player
                local args = {
                    [1] = "push"
                }
                replicatedStorage.remotes.abilities:FireServer(unpack(args))
                wait(0.2)
                -- Remote event for hit registration
                local args = {
                    [1] = game:GetService("Players")[targetPlayerName].Character
                }
                replicatedStorage.remotes.hitReg:FireServer(unpack(args))

                
                -- Calculate the void position (assuming Y position 0 is the void)
                local voidPosition = Vector3.new(savedPosition.X, 0, savedPosition.Z)  -- Assuming the void is at Y = 0

                -- Teleport local player above the void
                localPlayer.Character:SetPrimaryPartCFrame(CFrame.new(voidPosition.X, voidPosition.Y - 250, voidPosition.Z))  -- Teleport 250 units down

                -- Anchor the local player to prevent falling
                for _, part in ipairs(localPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end

                -- Wait for 5 seconds
                wait(5)

                -- Teleport back to saved position
                localPlayer.Character:SetPrimaryPartCFrame(CFrame.new(savedPosition))

                -- Unanchor the local player
                for _, part in ipairs(localPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end
        end
    end
end

-- Function to handle player joining
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()  -- Wait for the character to be added

    if findTargetPlayer() then
        fireEventsForLocalPlayer()
    end
end)

-- Initial call to find the target player and fire events if the local player is already present
if players.LocalPlayer then
    if findTargetPlayer() then
        fireEventsForLocalPlayer()
    end
end

   end,
})

local Toggle = EXETab:CreateToggle({
   Name = "Auto Attack + Range",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
    -- Define a global variable to track the state of the toggle
_G.isAutoAttackEnabled = not _G.isAutoAttackEnabled -- Toggle the state on each script run

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Function to find the closest player to the local player
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge -- Infinite distance to start with
    
    -- Iterate through all players in the game
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Calculate distance between players
            local distance = (character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            -- Check if this player is closer
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    
    return closestPlayer
end

-- Function to fire the remote events in order once, excluding the playSwing event
local function fireRemoteEventsWithClosestPlayer()
    -- First remote event: "attack"
    local args1 = {
        [1] = "attack"
    }
    game:GetService("ReplicatedStorage").remotes.abilities:FireServer(unpack(args1))
    
    -- Find the closest player to the local player
    local closestPlayer = getClosestPlayer()
    
    if closestPlayer then
        -- Fire the hit registration event with the closest player's name
        local args2 = {
            [1] = game:GetService("Players")[closestPlayer.Name].Character
        }
        game:GetService("ReplicatedStorage").remotes.hitReg:FireServer(unpack(args2))
    else
        warn("No valid players found.")
    end
    
    -- Second remote event: "cancelAttack"
    local args3 = {
        [1] = "cancelAttack"
    }
    game:GetService("ReplicatedStorage").remotes.abilities:FireServer(unpack(args3))
end

-- Callback function to repeatedly execute the script every second
local function automaticFireRemoteEvents()
    while _G.isAutoAttackEnabled do
        -- Execute the function to fire the events
        fireRemoteEventsWithClosestPlayer()
        
        -- Wait for 0.35 second before repeating
        wait(0.35)
    end
end

-- Toggle the automatic attack based on the global state
if _G.isAutoAttackEnabled then
    print("Auto attack enabled")
    automaticFireRemoteEvents() -- Start the loop if the toggle is enabled
else
    print("Auto attack disabled")
end
   end,
})

local Button = MiscTab:CreateButton({
   Name = "Goto Escape",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Function to recursively search for the "exitRing" model in the workspace
local function findExitRingInWorkspace()
    return game.Workspace:FindFirstChild("exitRing", true) -- The second argument 'true' makes the search recursive
end

-- Function to teleport player to hitbox inside exitRing
local function teleportToHitbox()
    -- Find the exitRing model anywhere in the workspace
    local exitRing = findExitRingInWorkspace()
    
    if exitRing and exitRing:IsA("Model") then
        -- Find the hitbox part inside the exitRing model
        local hitbox = exitRing:FindFirstChild("hitbox")
        
        if hitbox and hitbox:IsA("BasePart") then
            -- Get the player's HumanoidRootPart for teleportation
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                -- Teleport the player's HumanoidRootPart to the hitbox's position
                humanoidRootPart.CFrame = hitbox.CFrame
            else
                warn("HumanoidRootPart not found in character.")
            end
        else
            warn("'hitbox' part not found inside 'exitRing'.")
        end
    else
        warn("'exitRing' model not found in workspace.")
    end
end

-- Call the function to teleport the player
teleportToHitbox()

   end,
})

local Slider = MiscTab:CreateSlider({
    Name = "Running Speed",
    Range = {0, 300}, -- Adjust the range based on what you want
    Increment = 1,    -- The increment value
    Suffix = "Speed", -- Label suffix
    CurrentValue = 30, -- Starting value for the slider
    Flag = "RunnersSpeedSlider", -- Unique flag
    Callback = function(Value)
        -- Set the runnersSpeed attribute in PlayerGui.stats to the slider value
        game.Players.LocalPlayer.PlayerGui.stats:SetAttribute("runningSpeed", Value)

        -- Stop any existing update loop before starting a new one
        if SliderUpdateLoop then
            SliderUpdateLoop:Disconnect()
        end

        -- Create a new update loop
        SliderUpdateLoop = game:GetService("RunService").Heartbeat:Connect(function()
            -- Set the runnersSpeed attribute in PlayerGui.stats to the current slider value
            game.Players.LocalPlayer.PlayerGui.stats:SetAttribute("runningSpeed", Value)
        end)
    end, 
})

local Slider = MiscTab:CreateSlider({
   Name = "Walking Speed",
   Range = {0, 100}, -- Adjust the range based on what you want
   Increment = 1,    -- The increment value
   Suffix = "Speed", -- Label suffix
   CurrentValue = 14, -- Starting value for the slider
   Flag = "WalkingSpeedSlider", -- Unique flag
   Callback = function(Value)
      -- Set the walkingSpeed attribute in PlayerGui.stats to the slider value

              game.Players.LocalPlayer.PlayerGui.stats:SetAttribute("walkingSpeed", Value)
      
              -- Stop any existing update loop before starting a new one
              if SliderUpdateLoop then
                  SliderUpdateLoop:Disconnect()
              end
      
              -- Create a new update loop
              SliderUpdateLoop = game:GetService("RunService").Heartbeat:Connect(function()
                  -- Set the walkingSpeed attribute in PlayerGui.stats to the current slider value
                  game.Players.LocalPlayer.PlayerGui.stats:SetAttribute("walkingSpeed", Value)
              end)
         end,
})

local Slider = MiscTab:CreateSlider({
   Name = "Jump Power",
   Range = {0, 500}, -- Adjust the range based on what you want
   Increment = 1,    -- The increment value
   Suffix = "Jumppower", -- Label suffix
   CurrentValue = 60, -- Starting value for the slider
   Flag = "JumpPowerSlider", -- Unique flag
   Callback = function(Value)
      -- Set the JumpPower attribute in PlayerGui.stats to the slider value

              game.Players.LocalPlayer.PlayerGui.stats:SetAttribute("jumpPower", Value)
      
              -- Stop any existing update loop before starting a new one
              if SliderUpdateLoop then
                  SliderUpdateLoop:Disconnect()
              end
      
              -- Create a new update loop
              SliderUpdateLoop = game:GetService("RunService").Heartbeat:Connect(function()
                  -- Set the JumpPower attribute in PlayerGui.stats to the current slider value
                  game.Players.LocalPlayer.PlayerGui.stats:SetAttribute("jumpPower", Value)
              end)
         end,
})

local Slider = MiscTab:CreateSlider({
   Name = "Climb Speed",
   Range = {0, 300}, -- Adjust the range based on what you want
   Increment = 1,    -- The increment value
   Suffix = "Speed", -- Label suffix
   CurrentValue = 28, -- Starting value for the slider
   Flag = "ClimbSpeedSlider", -- Unique flag
   Callback = function(Value)
      -- Set the ClimbSpeed attribute in PlayerGui.stats to the slider value

              game.Players.LocalPlayer.PlayerGui.stats:SetAttribute("climbingSpeed", Value)
      
              -- Stop any existing update loop before starting a new one
              if SliderUpdateLoop then
                  SliderUpdateLoop:Disconnect()
              end
      
              -- Create a new update loop
              SliderUpdateLoop = game:GetService("RunService").Heartbeat:Connect(function()
                  -- Set the ClimbSpeed attribute in PlayerGui.stats to the current slider value
                  game.Players.LocalPlayer.PlayerGui.stats:SetAttribute("climbingSpeed", Value)
              end)
         end,
})

local Button = EXETab:CreateButton({
   Name = "grab nearest player (ungrab)",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Function to find the closest player to the local player
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge -- Infinite distance to start with
    
    -- Iterate through all players in the game
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Calculate distance between players
            local distance = (humanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            -- Check if this player is closer
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    
    return closestPlayer, shortestDistance
end

-- Function to teleport the local player to the nearest player if necessary
local function teleportToClosestPlayer()
    local closestPlayer, distance = getClosestPlayer()
    
    if closestPlayer then
        -- Check if the player is more than 10 studs away
        if distance > 10 then
            -- Teleport the local player to the closest player's position
            humanoidRootPart.CFrame = closestPlayer.Character.HumanoidRootPart.CFrame
            return true -- Indicates teleportation occurred
        end
    else
        warn("No valid players found.")
    end
    return false -- No teleportation needed
end

-- Function to fire the remote events
local function fireRemoteEventsWithClosestPlayer()
    -- Check if teleportation is needed (player is further than 10 studs)
    local teleported = teleportToClosestPlayer()
    
    if teleported then
        -- Wait 0.1 seconds after teleporting before firing the events
        wait(0.2)
    end
    
    -- First remote event: "grab"
    local args1 = {
        [1] = "grab"
    }
    game:GetService("ReplicatedStorage").remotes.abilities:FireServer(unpack(args1))
    
    -- Find the closest player again (they may be closer after teleporting)
    local closestPlayer = getClosestPlayer()
    
    if closestPlayer then
        -- Fire the hit registration event with the closest player's name
        local args2 = {
            [1] = game:GetService("Players")[closestPlayer.Name].Character
        }
        game:GetService("ReplicatedStorage").remotes.hitReg:FireServer(unpack(args2))
    else
        warn("No valid players found.")
    end
end

-- Execute the function to fire the events
fireRemoteEventsWithClosestPlayer()

   end,
})

local Button = SurvivorTab:CreateButton({
   Name = "Shoot Sonic.exe (range stunner)",
   Callback = function()
   local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- Folder where player configurations are stored
local displayPlayers = replicatedStorage:FindFirstChild("displayPlayers")

local targetPlayerName = nil  -- This will store the name of the player with "sonicexe" or "sonicexe_2"

-- Function to find the target player whose character is "sonicexe" or "sonicexe_2"
local function findTargetPlayer()
    if displayPlayers then
        for _, playerFolder in pairs(displayPlayers:GetChildren()) do
            local playerInstance = players:FindFirstChild(playerFolder.Name)
            if playerInstance then
                local statsFolder = playerFolder:FindFirstChild("stats")
                if statsFolder and statsFolder:FindFirstChild("character") then
                    local characterValue = statsFolder.character.Value
                    if characterValue == "sonicexe" or characterValue == "sonicexe_2" then
                        targetPlayerName = playerFolder.Name  -- Store the player name
                        return true  -- Stop once the player is found
                    end
                end
            end
        end
    end
    return false
end

-- Function to fire events based on the local player's character
local function fireEventsForLocalPlayer()
    local localPlayer = players.LocalPlayer
    local localPlayerName = localPlayer.Name  -- Get local player name

    local localPlayerFolder = displayPlayers:FindFirstChild(localPlayerName)

    if localPlayerFolder and localPlayerFolder:FindFirstChild("stats") and localPlayerFolder.stats:FindFirstChild("character") then
        local localCharacterValue = localPlayerFolder.stats.character.Value  -- Access character value

        if targetPlayerName then  -- Ensure the target player was found
            if localCharacterValue == "metalsonic" then
                local args = {
                    [1] = "grapple",
                    [2] = game:GetService("Players")[targetPlayerName].Character,
                    [3] = Vector3.new(194.72731018066406, 171.47462463378906, -582.0408325195312)
                }
                replicatedStorage.remotes.abilities:FireServer(unpack(args))

            elseif localCharacterValue == "tails" then
                local args = {
                    [1] = "cannonShoot",
                    [2] = Vector3.new(-156.29893493652344, 115.3377685546875, -311.6048278808594),
                    [3] = game:GetService("Players")[targetPlayerName].Character
                }
                replicatedStorage.remotes.abilities:FireServer(unpack(args))
            end
        end
    end
end

-- Function to handle player joining
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()  -- Wait for the character to be added

    if findTargetPlayer() then
        fireEventsForLocalPlayer()
    end
end)

-- Initial call to find the target player and fire events if the local player is already present
if players.LocalPlayer then
    if findTargetPlayer() then
        fireEventsForLocalPlayer()
    end
end

   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Sonic.exe",
   Callback = function()
   local args = {
    [1] = "sonicexe"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))
   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Sonic.exe 2",
   Callback = function()
   local args = {
    [1] = "sonicexe_2"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))
   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Tails",
   Callback = function()
   local args = {
    [1] = "tails"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))
   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Knuckles",
   Callback = function()
   local args = {
    [1] = "knuckles"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))
   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Eggman",
   Callback = function()
   local args = {
    [1] = "eggman"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))
   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Amy",
   Callback = function()
   local args = {
    [1] = "amy"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))
   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Cream",
   Callback = function()
   local args = {
    [1] = "cream"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))
   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Sally",
   Callback = function()
   local args = {
    [1] = "sally"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))
   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Shadow",
   Callback = function()
   local args = {
    [1] = "shadow"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))
   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Rouge",
   Callback = function()
  local args = {
    [1] = "rouge"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))
   end,
})

local Button = CharacterTab:CreateButton({
   Name = "Metal Sonic",
   Callback = function()
   local args = {
    [1] = "metalsonic"
}

game:GetService("ReplicatedStorage").remotes.morphs:FireServer(unpack(args))

   end,
})

local Toggle = SurvivorTab:CreateToggle({
   Name = "Auto Stun EXE (shadow)",
   CurrentValue = false,
   Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- Define a global variable to track the state of the toggle

   _G.isHomingAttackEnabled = not _G.isHomingAttackEnabled -- Toggle the state on each script run
   
   local replicatedStorage = game:GetService("ReplicatedStorage")
   local players = game:GetService("Players")
   
   -- Folder where player configurations are stored
   local displayPlayers = replicatedStorage:FindFirstChild("displayPlayers")
   
   local targetPlayers = {} -- This will store the names of players with "exe" in their character value
   
   -- Function to find all players whose character contains "exe"
   local function findTargetPlayers()
       targetPlayers = {} -- Reset the targetPlayers list
   
       if displayPlayers then
           for _, playerFolder in pairs(displayPlayers:GetChildren()) do
               local playerInstance = players:FindFirstChild(playerFolder.Name)
               if playerInstance then
                   local statsFolder = playerFolder:FindFirstChild("stats")
                   if statsFolder and statsFolder:FindFirstChild("character") then
                       local characterValue = statsFolder.character.Value
                       if string.find(characterValue, "exe") then -- Check if "exe" is in the character value
                           table.insert(targetPlayers, playerFolder.Name) -- Store the player name
                       end
                   end
               end
           end
       end
   
       return #targetPlayers > 0 -- Return true if any target players were found
   end
   
   -- Function to fire events for all players whose name contains "exe"
   local function fireEventsForLocalPlayer()
       local localPlayer = players.LocalPlayer
       local localPlayerName = localPlayer.Name -- Get local player name
   
       local localPlayerFolder = displayPlayers:FindFirstChild(localPlayerName)
   
       if localPlayerFolder and localPlayerFolder:FindFirstChild("stats") and localPlayerFolder.stats:FindFirstChild("character") then
           local localCharacterValue = localPlayerFolder.stats.character.Value -- Access local character value
   
           if localCharacterValue == "shadow" then -- Ensure the local player is "shadow"
               for _, targetPlayerName in pairs(targetPlayers) do
                   local args = {
                       [1] = "homingAttackTarget", -- This is the action you want to perform
                       [2] = game:GetService("Players")[targetPlayerName].Character
                   }
                   replicatedStorage.remotes.abilities:FireServer(unpack(args))
               end
           end
       end
   end
   
   -- Function to repeatedly fire the event while conditions are met
   local function automaticFireHomingAttack()
       while _G.isHomingAttackEnabled do
           if findTargetPlayers() then
               fireEventsForLocalPlayer()
           end
           wait(0.1) -- Repeat every 0.1 seconds
       end
   end
   
   -- Toggle the automatic homing attack based on the global state
   if _G.isHomingAttackEnabled then
       print("Homing attack enabled")
       automaticFireHomingAttack() -- Start the loop if the toggle is enabled
   else
       print("Homing attack disabled")
   end
            end,
})

local Toggle = SurvivorTab:CreateToggle({
   Name = " Auto Stun All (shadow)",
   CurrentValue = false,
   Flag = "Toggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- Define a global variable to track the state of the toggle

   _G.isHomingAttackEnabled = not _G.isHomingAttackEnabled -- Toggle the state on each script run
   
   local replicatedStorage = game:GetService("ReplicatedStorage")
   local players = game:GetService("Players")
   
   -- Folder where player configurations are stored
   local displayPlayers = replicatedStorage:FindFirstChild("displayPlayers")
   
   local targetPlayers = {} -- This will store the names of all players (whether they contain "exe" in character value or not)
   
   -- Function to find all players and check if they are within 40 studs
   local function findTargetPlayersWithinDistance()
       targetPlayers = {} -- Reset the targetPlayers list
       local localPlayer = players.LocalPlayer
       local localCharacter = localPlayer.Character
   
       if displayPlayers and localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") then
           local localPosition = localCharacter.HumanoidRootPart.Position -- Get local player's position
   
           for _, playerFolder in pairs(displayPlayers:GetChildren()) do
               local playerInstance = players:FindFirstChild(playerFolder.Name)
               if playerInstance and playerInstance.Character and playerInstance.Character:FindFirstChild("HumanoidRootPart") then
                   local targetPosition = playerInstance.Character.HumanoidRootPart.Position
                   local distance = (localPosition - targetPosition).Magnitude -- Calculate distance between players
   
                   if distance <= 40 then -- Only add players within 40 studs
                       table.insert(targetPlayers, playerFolder.Name) -- Store the player name
                   end
               end
           end
       end
   
       return #targetPlayers > 0 -- Return true if any players are within 40 studs
   end
   
   -- Function to fire events for all players within 40 studs
   local function fireEventsForLocalPlayer()
       local localPlayer = players.LocalPlayer
       local localPlayerName = localPlayer.Name -- Get local player name
   
       local localPlayerFolder = displayPlayers:FindFirstChild(localPlayerName)
   
       if localPlayerFolder and localPlayerFolder:FindFirstChild("stats") and localPlayerFolder.stats:FindFirstChild("character") then
           local localCharacterValue = localPlayerFolder.stats.character.Value -- Access local character value
   
           if localCharacterValue == "shadow" then -- Ensure the local player is "shadow"
               for _, targetPlayerName in pairs(targetPlayers) do
                   -- Use game:GetService("Players")[targetPlayerName].Character directly
                   local args = {
                       [1] = "homingAttackTarget", -- This is the action you want to perform
                       [2] = game:GetService("Players")[targetPlayerName].Character -- Target the player's character directly
                   }
                   replicatedStorage.remotes.abilities:FireServer(unpack(args))
               end
           end
       end
   end
   
   -- Function to repeatedly fire the event while conditions are met
   local function automaticFireHomingAttack()
       while _G.isHomingAttackEnabled do
           if findTargetPlayersWithinDistance() then -- Only proceed if players are within 40 studs
               fireEventsForLocalPlayer()
           end
           wait(0.1) -- Repeat every 0.1 seconds
       end
   end
   
   -- Toggle the automatic homing attack based on the global state
   if _G.isHomingAttackEnabled then
       print("Homing attack enabled")
       automaticFireHomingAttack() -- Start the loop if the toggle is enabled
   else
       print("Homing attack disabled")
   end
      end,
})