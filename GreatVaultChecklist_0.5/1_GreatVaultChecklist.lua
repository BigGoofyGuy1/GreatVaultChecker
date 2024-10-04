-- Initialize Addon
local addonName, GVC = ...

-- Saved variables for progress
GVC_SavedProgress = GVC_SavedProgress or {}

local frame = CreateFrame("Frame", "GreatVaultChecklistFrame", UIParent)

-- Register events (ADDON_LOADED to initialize, PLAYER_ENTERING_WORLD to refresh weekly)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Function to reset weekly progress
local function ResetWeeklyProgress()
    GVC_SavedProgress = {
        mythic = { completed = 0, best = 0 },
        raid = { completed = 0, difficulty = "Normal" },
        delves = { completed = 0, best = 0 }
    }
end

-- Function to initialize when the addon is loaded
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        if GVC_SavedProgress == nil then
            ResetWeeklyProgress()
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Update weekly data (Reset progress on weekly reset)
        local resetTime = GetServerTime() % (7 * 24 * 60 * 60) -- Weekly reset in seconds
        if GVC_SavedProgress.resetTime ~= resetTime then
            ResetWeeklyProgress()
            GVC_SavedProgress.resetTime = resetTime
        end
    end
end)

-- Function to update Mythic+ progress
function GVC_UpdateMythicPlus(completed, best)
    GVC_SavedProgress.mythic.completed = completed
    GVC_SavedProgress.mythic.best = best
end

-- Function to update Raid progress
function GVC_UpdateRaid(completed, difficulty)
    GVC_SavedProgress.raid.completed = completed
    GVC_SavedProgress.raid.difficulty = difficulty
end

-- Function to update Delve progress
function GVC_UpdateDelves(completed, best)
    GVC_SavedProgress.delves.completed = completed
    GVC_SavedProgress.delves.best = best
end

-- Simple UI Display
function GVC_ShowChecklist()
    local mythic = GVC_SavedProgress.mythic
    local raid = GVC_SavedProgress.raid
    local delves = GVC_SavedProgress.delves

    print("|cFFFFD700Great Vault Checklist|r")
    print("|cFF00FF00Mythic+:|r " .. mythic.completed .. "/8 completed (Best: +" .. mythic.best .. ")")
    print("|cFF00FF00Raids:|r " .. raid.completed .. " bosses down on " .. raid.difficulty)
    print("|cFF00FF00Delves:|r " .. delves.completed .. "/5 completed (Best: Tier " .. delves.best .. ")")
end

-- Slash command to open the checklist
SLASH_GVC1 = "/vaultcheck"
SlashCmdList["GVC"] = GVC_ShowChecklist
