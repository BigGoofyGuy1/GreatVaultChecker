-- Reference the frame from the XML
local vaultFrame = GreatVaultChecklistFrame

-- Slash command to toggle the frame
SLASH_VAULTCHECK1 = "/vaultcheck"
SlashCmdList["VAULTCHECK"] = function()
    UpdateVaultProgress()
    vaultFrame:Show()
end

-- Load the reward strings from the separate file
local mythicRewards = MythicRewards or {}
local delveRewards = DelveRewards or {}
local raidRewards = RaidRewards or {}

-- Function to update the progress from Great Vault API
function UpdateVaultProgress()
    local activities = C_WeeklyRewards.GetActivities()

    -- Variables to store progress
    local mythicProgress = 0
    local mythicThreshold = 0
    local mythicHighestReward = 0
    local mythicSlots = 0
    local mythicBestAvailable = 0
    local raidProgress = 0
    local raidThreshold = 0
    local raidHighestReward = 0
    local raidSlots = 0
    local raidBestAvailable = 0
    local delveProgress = 0
    local delveThreshold = 0
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
             if mythicProgress > 1 and mythicProgress <= 3 then
                mythicSlots = 1
            elseif mythicProgress > 3 and mythicProgress <= 8 then
                mythicSlots = 2
            elseif mythicProgress > 8 then
                mythicSlots = 3
            end
            
        elseif activity.type == 3 then
           
            -- Raid progress
            raidProgress = activity.progress
            raidThreshold = activity.threshold
            if raidProgress > raidThreshold then
                raidProgress = raidThreshold
            end

            if raidProgress > 6 then
                raidProgress = 6
            end

            -- Track highest reward available
            if activity.level > raidHighestReward then
                raidHighestReward = activity.level
                print(raidHighestReward)
            end
            -- Track completion threshold
            if raidProgress > 1 and raidProgress <= 3 then
                raidSlots = 1
            elseif raidProgress > 3 and raidProgress <=5  then
                raidSlots = 2
            elseif raidProgress > 5 then
                raidSlots = 3
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
            if delveProgress > 1 and delveProgress <= 3 then
                delveSlots = 1
            elseif delveProgress > 3 and delveProgress <= 7 then
                delveSlots = 2
            elseif delveProgress > 7 then
                delveSlots = 3
            end
        end
        
    end

    -- Lookup the reward string for each highest reward
    local mythicRewardString = mythicRewards[mythicHighestReward] or "None"
    local raidRewardString = raidRewards[raidHighestReward] or "None"
    local delveRewardString = delveRewards[delveHighestReward] or "None"    

    
    
    -- Update the text in the table layout

    -- Raid Row

    GreatVaultChecklistFrameRaidCompletion:SetText(raidProgress .. "/" .. raidThreshold)
    GreatVaultChecklistFrameRaidVaultSlots:SetText(raidSlots .. "/3")
    GreatVaultChecklistFrameRaidRewards:SetText(raidRewardString)

    -- Mythic+ Row
    
    GreatVaultChecklistFrameMythicCompletion:SetText(mythicProgress .. "/" .. mythicThreshold)
    GreatVaultChecklistFrameMythicVaultSlots:SetText(mythicSlots .. "/3")
    GreatVaultChecklistFrameMythicRewards:SetText(mythicRewardString)

    -- Delve Row
    
    GreatVaultChecklistFrameDelveCompletion:SetText(delveProgress .. "/" .. delveThreshold)
    GreatVaultChecklistFrameDelveVaultSlots:SetText(delveSlots .. "/3")
    GreatVaultChecklistFrameDelveRewards:SetText(delveRewardString)
end

