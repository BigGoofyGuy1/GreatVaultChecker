-- Create a basic frame for the checklist
local vaultFrame = CreateFrame("Frame", "GreatVaultChecklistFrame", UIParent, "BasicFrameTemplateWithInset")
vaultFrame:SetSize(400, 200)
vaultFrame:SetPoint("CENTER")
vaultFrame:Hide()

-- Title text
vaultFrame.title = vaultFrame:CreateFontString(nil, "OVERLAY")
vaultFrame.title:SetFontObject("GameFontHighlightLarge")
vaultFrame.title:SetPoint("TOP", 0, -10)
vaultFrame.title:SetText("Great Vault Checklist")

-- Mythic+ Progress Text
vaultFrame.mythicProgressText = vaultFrame:CreateFontString(nil, "OVERLAY")
vaultFrame.mythicProgressText:SetFontObject("GameFontNormal")
vaultFrame.mythicProgressText:SetPoint("TOPLEFT", 20, -60)
vaultFrame.mythicProgressText:SetText("Mythic+ Progress:")

-- Raid Progress Text
vaultFrame.raidProgressText = vaultFrame:CreateFontString(nil, "OVERLAY")
vaultFrame.raidProgressText:SetFontObject("GameFontNormal")
vaultFrame.raidProgressText:SetPoint("TOPLEFT", 20, -90)
vaultFrame.raidProgressText:SetText("Raid Progress:")

-- Delve Progress Text
vaultFrame.delveProgressText = vaultFrame:CreateFontString(nil, "OVERLAY")
vaultFrame.delveProgressText:SetFontObject("GameFontNormal")
vaultFrame.delveProgressText:SetPoint("TOPLEFT", 20, -120)
vaultFrame.delveProgressText:SetText("Delve Progress:")

-- Close Button
vaultFrame.closeButton = CreateFrame("Button", nil, vaultFrame, "UIPanelButtonTemplate")
vaultFrame.closeButton:SetSize(80, 22)
vaultFrame.closeButton:SetPoint("BOTTOM", 0, 10)
vaultFrame.closeButton:SetText("Close")
vaultFrame.closeButton:SetScript("OnClick", function()
    vaultFrame:Hide()
end)

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
    local mythicBestAvailable = 0
    local raidProgress = ""
    local raidThreshold = ""
    local raidHighestReward = 0
    local raidBestAvailable = 0
    local delveProgress = ""
    local delveThreshold = ""
    local delveHighestReward = 0
    local delveBestAvailable = 0

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
        end
    end
    
    -- Update the text on the frame
    vaultFrame.mythicProgressText:SetText("Mythic Progress: " .. mythicProgress .. "/" .. mythicThreshold .. " Highest Reward: " .. mythicHighestReward)
    vaultFrame.raidProgressText:SetText("Raid Progress: " .. raidProgress .. "/" .. raidThreshold .. " Highest Reward: " .. raidHighestReward)
    vaultFrame.delveProgressText:SetText("Delve Progress: " .. delveProgress .. "/" .. delveThreshold .. " Highest Reward: " .. delveHighestReward)
end

