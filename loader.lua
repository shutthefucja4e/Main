--[[

Oᴜʀ ᴅɪsᴄᴏʀᴅ (sᴜᴘᴘᴏʀᴛ, ᴜᴘᴅᴀᴛᴇs, ɴᴇᴡ sᴄʀɪᴘᴛs, ᴇᴛᴄ):
ʟᴀsᴛ ᴜᴘᴅᴀᴛᴇ ʟᴏᴀᴅᴇʀ: 06.08.24
sᴛᴇᴅ.ʜᴜʙ /\ ʟᴏᴀᴅᴇʀ /\ Sᴜᴘᴘᴏʀᴛ: Sᴏʟᴀʀᴀ, Cᴇʟᴇʀʏ, Sʏɴᴀᴘsᴇ Z, Fʟᴜxᴜs, Cᴏᴅᴇx, Dᴇʟᴛᴀ, Aʀᴄᴇᴜs X, Vᴇɢᴀ X, AᴘᴘʟᴇWᴀʀᴇ, Cᴜʙɪx, Cʀʏᴘᴛɪᴄ, Eᴠᴏɴ, ᴏᴛʜᴇʀ ᴍᴏʙɪʟᴇ ᴀɴᴅ ᴘᴄ ᴇxᴇᴄᴜᴛᴏʀs
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
                                                            ╭━━━┳━━━━┳━━━┳━━━┳╮╱╭┳╮╱╭┳━━╮╱╭╮╱╱╭━━━┳━━━┳━━━┳━━━┳━━━╮
                                                            ┃╭━╮┃╭╮╭╮┃╭━━┻╮╭╮┃┃╱┃┃┃╱┃┃╭╮┃╱┃┃╱╱┃╭━╮┃╭━╮┣╮╭╮┃╭━━┫╭━╮┃
                                                            ┃╰━━╋╯┃┃╰┫╰━━╮┃┃┃┃╰━╯┃┃╱┃┃╰╯╰╮┃┃╱╱┃┃╱┃┃┃╱┃┃┃┃┃┃╰━━┫╰━╯┃
                                                            ╰━━╮┃╱┃┃╱┃╭━━╯┃┃┃┃╭━╮┃┃╱┃┃╭━╮┃┃┃╱╭┫┃╱┃┃╰━╯┃┃┃┃┃╭━━┫╭╮╭╯
                                                            ┃╰━╯┃╱┃┃╱┃╰━━┳╯╰╯┃┃╱┃┃╰━╯┃╰━╯┃┃╰━╯┃╰━╯┃╭━╮┣╯╰╯┃╰━━┫┃┃╰╮
                                                            ╰━━━╯╱╰╯╱╰━━━┻━━━┻╯╱╰┻━━━┻━━━╯╰━━━┻━━━┻╯╱╰┻━━━┻━━━┻╯╰━╯
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

sᴛᴇᴅ.ʜᴜʙ /\ ʟᴏᴀᴅᴇʀ /\ Sᴜᴘᴘᴏʀᴛ: Sᴏʟᴀʀᴀ, Cᴇʟᴇʀʏ, Sʏɴᴀᴘsᴇ Z, Fʟᴜxᴜs, Cᴏᴅᴇx, Dᴇʟᴛᴀ, Aʀᴄᴇᴜs X, Vᴇɢᴀ X, AᴘᴘʟᴇWᴀʀᴇ, Cᴜʙɪx, Cʀʏᴘᴛɪᴄ, Eᴠᴏɴ, ᴏᴛʜᴇʀ ᴍᴏʙɪʟᴇ ᴀɴᴅ ᴘᴄ ᴇxᴇᴄᴜᴛᴏʀs
ʟᴀsᴛ ᴜᴘᴅᴀᴛᴇ ʟᴏᴀᴅᴇʀ: 06.08.24
Oᴜʀ ᴅɪsᴄᴏʀᴅ (sᴜᴘᴘᴏʀᴛ, ᴜᴘᴅᴀᴛᴇs, ɴᴇᴡ sᴄʀɪᴘᴛs, ᴇᴛᴄ):

]]--

local placeId = game.PlaceId

local function createNotification(title, text, duration)
    local gui = Instance.new("ScreenGui")
    gui.Name = "StedHubNotification"
    gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 60)
    frame.Position = UDim2.new(1, -220, 1, -80)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 2
    frame.Parent = gui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 40)
    textLabel.Position = UDim2.new(0, 0, 0, 20)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.Parent = frame

    wait(duration)
    gui:Destroy()
end

createNotification("StedHub", "Loader.lua included", 5)

print("o_o")
print("StedHub -> Loader success included!")
print("StedHub -> Wait script implemented in your place!")
print("StedHub -> If nothing appears, then your place is not supported!")
print("o_o")

if placeId == 5041144419 then
    print("o_o")
    print("StedHub -> Game supported. Defined as: SCP: Roleplay (✅)")
    print("o_o")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/Supported/scp.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/Supported/scpMod.lua"))()
elseif placeId == 13775256536 then
    print("o_o")
    print("StedHub -> Game supported. Defined as: Toilet Tower Defense (✅)")
    print("o_o")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/Supported/ttd.lua"))()
else
    warn("o_o")
    warn("StedHub -> Your game not supported (⛔)")
    warn("StedHub -> Load Infinite Yield? (Y/N)")
    warn("o_o")
    
    local input = string.upper(string.sub(tostring(game:GetService("Players").LocalPlayer.Chatted:Wait()), 1, 1))
    
    if input == "Y" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/Yield/yield.lua"))()
        print("o_o")
        print("StedHub -> You choosed load Infinite Yield. Good Luck!")
        print("o_o")
    elseif input == "N" then
        print("o_o")
        print("StedHub -> You choosed not load Infinite Yield. Bye!")
        print("o_o")
    else
        print("o_o")
        print("StedHub -> Invalid input. Exiting. (⚠️)")
        print("o_o")
    end
    
    return
end
