-- Slash command to toggle the frame
SLASH_VAULTCHECK1 = "/vaultcheck"
SlashCmdList["VAULTCHECK"] = function()
    UpdateVaultProgress()
    vaultFrame:Show()
end



-- Function to update the progress from Great Vault API
function UpdateVaultProgress()
    local activities = C_WeeklyRewards.GetActivities()

    -- Variables to store progress
    local mythicProgress = ""
    local mythicThreshold = ""
    local mythicHighestReward = 0
    local mythicSlots = 0
    local mythicBestAvailable = 0
    local raidProgress = ""
    local raidThreshold = ""
    local raidHighestReward = 0
    local raidSlots = 0
    local raidBestAvailable = 0
    local delveProgress = ""
    local delveThreshold = ""
    local delveHighestReward = 0
    local delveSlots = 0
    local delveBestAvailable = 0
    local bestTest = 0

    -- Loop through activities and categorize based on type
    for _, activity in ipairs(activities) do
        if activity.type == 1 then
            
            -- Mythic+ progress
            mythicProgress = activity.progress
            mythicThreshold = activity.threshold
            if mythicProgress > mythicThreshold then
                mythicProgress = mythicThreshold
            end

            -- Track highest reward available
            if activity.level > mythicHighestReward then
                mythicHighestReward = activity.level
            end

             -- Track completion threshold
            if mythicHighestReward > activity.level then
                mythicSlots = mythicSlots+1
            end
        elseif activity.type == 3 then
           
            -- Raid progress
            raidProgress = activity.progress
            raidThreshold = activity.threshold
            if raidProgress > raidThreshold then
                raidProgress = raidThreshold
            end
            -- Track highest reward available
            if activity.level > raidHighestReward then
                raidHighestReward = activity.level
            end
            -- Track completion threshold
            if raidHighestReward > activity.level then
                raidSlots = raidSlots+1
            end
        elseif activity.type == 6 then
           
            -- Delve progress
            delveProgress = activity.progress
            delveThreshold = activity.threshold
            if delveProgress > delveThreshold then
                delveProgress = delveThreshold
            end
            if activity.level > delveHighestReward then
                delveHighestReward = activity.level
            end
            -- Track completion threshold
            if delveHighestReward > activity.level then
                delveSlots = delveSlots+1
            end
        end
        
    end
    
    -- Update the text on the frame
    GreatVaultChecklistFrameMythicProgressText:SetText("Mythic Progress: " .. mythicProgress .. "/" .. mythicThreshold .. " Vault Slots: " .. mythicSlots .. "/3 Highest Reward: " .. mythicHighestReward)
    vaultFrame.raidProgressText:SetText("Raid Progress: " .. raidProgress .. "/" .. raidThreshold .. " Highest Reward: " .. raidHighestReward)
    vaultFrame.delveProgressText:SetText("Delve Progress: " .. delveProgress .. "/" .. delveThreshold .. " Highest Reward: " .. delveHighestReward)
end

