Config = {}

--Rewards
Config.RewardType = false -- If true you recieve an item if false you will recieve currency(Like cash,bank or any other currencys)

Config.RewardItem = 'apple' -- Make sure item is in the rsg-core/shared/items
Config.RewardAmount = math.random(1, 3) -- or remove math.random(1, 3) and change to 1 ect

Config.CurrencyType = 'cash' -- Currency type cash,bank ect
Config.CurrencyAmount = math.random(10, 25) -- or remove math.random(10, 25) and change to 20 ect

Config.LockpickBreak = 40 -- Lower the smaller chance of breaking (Currently 40%)
Config.AdvLockpickBreak = 5 -- Lower the smaller chance of breaking (Currently 5%)

Config.resetTime = (60 * 1000) * 30 -- Every 30 minutes the store can be robbed again
Config.tickInterval = 1000 -- Ignore

Config.Alerts = true

Config.MinimumLawmen = 1 -- amount of lawman needed for heist

--Add new registers to rob by easily
--First Copy and paste a line
--Change the first number to keep them in in order
--then change the vector to location
--Good Luck! (Do NOT Change the robbed or time status)
Config.Registers = {
    [1] = {vector3(1330.27, -1293.57, 77.02), robbed = false, time = 0}, -- rhodes
    [2] = {vector3(-324.28, 804.29, 117.88), robbed = false, time = 0}, -- valentine
    [3] = {vector3(-1789.33, -387.55, 160.33), robbed = false, time = 0}, -- strawberry
    [4] = {vector3(2860.15, -1202.15, 49.59), robbed = false, time = 0}, -- saint denis
    [5] = {vector3(-5486.36, -2937.69, -0.4), robbed = false, time = 0}, -- tumbleweed
    [6] = {vector3(-3687.3, -2622.49, -13.43), robbed = false, time = 0}, -- armadillo
    [7] = {vector3(-785.49, -1322.16, 43.88), robbed = false, time = 0}, -- blackwater
    [8] = {vector3(3025.48, 561.57, 44.72), robbed = false, time = 0}, -- van horn
    [9] = {vector3(-1302.14, 392.88, 95.43), robbed = false, time = 0}, -- wallace station
}
