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
