local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5[' .. GetCurrentResourceName() .. ']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest(
        'https://raw.githubusercontent.com/Rexshack-RedM/rsg-witchdoctor/main/version.txt',
        function(err, text, headers)
            local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

            if not text then
                versionCheckPrint('error', 'Currently unable to run a version check.')
                return
            end

            --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
            --versionCheckPrint('success', ('Latest Version: %s'):format(text))

            if text == currentVersion then
                versionCheckPrint('success', 'You are running the latest version.')
            else
                versionCheckPrint(
                    'error',
                    ('You are currently running an outdated version, please update to version %s'):format(text)
                )
            end
        end
    )
end

-----------------------------------------------------------------------

RegisterServerEvent('rsg-storerobbery:server:takeMoney')
AddEventHandler(
    'rsg-storerobbery:server:takeMoney',
    function()
        local src = source
        local Player = RSGCore.Functions.GetPlayer(src)

        if Config.RewardType == true then
            Player.Functions.AddItem(Config.RewardItem, Config.RewardAmount)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.RewardItem], 'add')
        else
            Player.Functions.AddMoney(Config.CurrencyType, Config.CurrencyAmount)
        end
    end
)

RegisterNetEvent(
    'rsg-storerobbery:server:setRegisterStatus',
    function(register)
        Config.Registers[register].robbed = true
        Config.Registers[register].time = Config.resetTime
        TriggerClientEvent('rsg-storerobbery:client:setRegisterStatus', -1, register, Config.Registers[register])
    end
)

CreateThread(
    function()
        while true do
            local toSend = {}
            for k in ipairs(Config.Registers) do
                if Config.Registers[k].time > 0 and (Config.Registers[k].time - Config.tickInterval) >= 0 then
                    Config.Registers[k].time = Config.Registers[k].time - Config.tickInterval
                else
                    if Config.Registers[k].robbed then
                        Config.Registers[k].time = 0
                        Config.Registers[k].robbed = false
                        toSend[#toSend + 1] = Config.Registers[k]
                    end
                end
            end

            if #toSend > 0 then
                TriggerClientEvent('rsg-storerobbery:client:setRegisterStatus', -1, toSend, false)
            end

            Wait(Config.tickInterval)
        end
    end
)

RSGCore.Functions.CreateUseableItem(
    'lockpick',
    function(source, item)
        local src = source
        local Player = RSGCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item.name) ~= nil then
            TriggerClientEvent('lockpicks:UseLockpick', src)
        end
    end
)

RSGCore.Functions.CreateUseableItem(
    'advancedlockpick',
    function(source, item)
        local src = source
        local Player = RSGCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item.name) ~= nil then
            TriggerClientEvent('lockpicks:UseLockpick', src)
        end
    end
)

-- remove item
RegisterNetEvent(
    'rsg-storerobbery:Server:RemoveItem',
    function(item, amount)
        local src = source
        local Player = RSGCore.Functions.GetPlayer(src)
        Player.Functions.RemoveItem(item, amount)
    end
)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()
