local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Enable noclip at the start
for _, part in ipairs(character:GetDescendants()) do
    if part:IsA("BasePart") then
        part.CanCollide = false -- Disable collision
    end
end
print("Noclip enabled at the beginning!")

local humanoid = character:WaitForChild("Humanoid") -- Ensure Humanoid exists

-- Get the Camera
local camera = workspace.CurrentCamera

-- Access the OpenableCrate model
local openableCrate = game.Workspace:WaitForChild("RuntimeItems"):WaitForChild("OpenableCrate")

if openableCrate then
    print("OpenableCrate found!")

    -- Ensure the model has a PrimaryPart assigned
    local targetPart = openableCrate.PrimaryPart or openableCrate:FindFirstChildWhichIsA("BasePart")
    if targetPart then
        -- Move the character to the OpenableCrate's position
        humanoid:MoveTo(targetPart.Position)
        local success, message = humanoid.MoveToFinished:Wait()
        if not success then
            warn("Failed to move to OpenableCrate:", message)
        else
            print("Reached OpenableCrate!")

            -- Make the character face the OpenableCrate
            character:SetPrimaryPartCFrame(CFrame.new(character.PrimaryPart.Position, targetPart.Position))

            -- Set the Camera to focus on the OpenableCrate
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 3, -5), targetPart.Position)

            print("Camera is now focused on OpenableCrate!")

            -- Open the crate using the remote event
            local args = {
                [1] = game.Workspace:WaitForChild("RuntimeItems"):FindFirstChild("OpenableCrate")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_ActivateObject"):FireServer(unpack(args))
            
            print("OpenableCrate has been activated!")

            -- Restore the camera after interacting
            camera.CameraType = Enum.CameraType.Custom
            print("Camera restored!")
        end
    else
        warn("OpenableCrate does not have a valid position! Assign a PrimaryPart or add a BasePart.")
    end
else
    print("OpenableCrate not found in Workspace hierarchy!")
end

while true do
    task.wait(1) -- Wait 1 second between each execution

    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart") -- Wait for HumanoidRootPart

    local items = game.Workspace:WaitForChild("RuntimeItems")

    -- Check for nearby RevolverAmmo and collect them
    for _, ammo in pairs(items:GetChildren()) do
        if ammo:IsA("Model") and ammo.Name == "RevolverAmmo" and ammo.PrimaryPart then
            local dist = (ammo.PrimaryPart.Position - hrp.Position).Magnitude -- Calculate distance
            if dist < 100 then -- Check if within 100 studs
                local rem = game.ReplicatedStorage.Packages.RemotePromise.Remotes.C_ActivateObject
                rem:FireServer(ammo) -- Activate the object
            end
        else
            warn("PrimaryPart missing or object name mismatch for RevolverAmmo!")
        end
    end
end
