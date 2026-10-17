-- Script taken from https://robloxscripts.com website
-- Enhanced with UI by Coney Bunny 🐰✨

local Players = game:GetService('Players')
local lplr = Players.LocalPlayer

-- ================= UI =================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Animation Spammer",
   Icon = 0,
   LoadingTitle = "Animation Spammer",
   LoadingSubtitle = "by Coney Bunny",
   Theme = "Default",
   ToggleUIKeybind = Enum.KeyCode.RightShift,
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AnimationSpammer",
      FileName = "Config"
   },
   Discord = { Enabled = false, Invite = "no", RememberJoins = false },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 0)
local MainSection = MainTab:CreateSection("Settings")

-- State
local Running = false
local MessageText = "anticheat developers be dammed"
local LoopCount = 0           -- 0 = infinite
local LoopDelay = 0.01        -- wait between spams
local Count = 0               -- how many times we've spammed
local CurrentThread = nil

-- Toggle
local Toggle = MainSection:CreateToggle({
   Name = "Enable Spam",
   CurrentValue = false,
   Flag = "EnableSpam",
   Callback = function(Value)
       Running = Value
       if Running then
           if not CurrentThread then
               CurrentThread = task.spawn(function()
                   while Running do
                       local char = lplr.Character
                       local animator = char and char:FindFirstChildWhichIsA('Animator', true) or nil

                       if animator then
                           local anim = Instance.new('Animation')
                           anim.AnimationId = ('http=jews67jews67' .. utf8.char(Random.new():NextInteger(1, 65535)) .. MessageText):sub(1, 256)
                           local loaded = animator:LoadAnimation(anim)
                           loaded:Play(0, 0.0001, 0)
                           Count = Count + 1
                           Rayfield:Notify({
                               Title = "Spam",
                               Content = "Played animation #" .. Count,
                               Duration = 0.5,
                           })
                       end

                       if LoopCount > 0 and Count >= LoopCount then
                           Running = false
                           break
                       end

                       task.wait(LoopDelay)
                   end
                   CurrentThread = nil
               end)
           end
       end
   end,
})

-- Message input
local Input = MainSection:CreateInput({
   Name = "Message",
   CurrentValue = MessageText,
   PlaceholderText = "Type your custom message...",
   RemoveTextAfterFocusLost = false,
   Flag = "Message",
   Callback = function(Text)
       if Text and Text ~= "" then
           MessageText = Text
       end
   end,
})

-- How many times (0 = infinite)
local Slider = MainSection:CreateSlider({
   Name = "How Many Times (0 = Infinite)",
   Range = {0, 500},
   Increment = 1,
   Suffix = "times",
   CurrentValue = LoopCount,
   Flag = "LoopCount",
   Callback = function(Value)
       LoopCount = Value
   end,
})

-- Delay between spams
local DelaySlider = MainSection:CreateSlider({
   Name = "Delay Between Spams",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "sec",
   CurrentValue = LoopDelay,
   Flag = "LoopDelay",
   Callback = function(Value)
       LoopDelay = Value
   end,
})

-- Reset counter
local ResetBtn = MainSection:CreateButton({
   Name = "Reset Counter",
   Callback = function()
       Count = 0
   end,
})

-- Live status
Rayfield:Notify({
   Title = "Animation Spammer Loaded",
   Content = "Press RightShift to toggle UI",
   Duration = 3,
})
