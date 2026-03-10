-- ==========================================
-- TÊN: ĐỘC LẬP - BOUNTY TRACKER & WEBHOOK
-- ==========================================

local WebhookURL = "ĐIỀN_LINK_WEBHOOK_DISCORD_CỦA_BRO_VÀO_ĐÂY"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Hàm gửi dữ liệu lên Discord (Request support cho nhiều loại Executor)
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
if not httprequest then
    warn("Executor của bro không hỗ trợ gửi Webhook!")
end

-- Khởi tạo hoặc Tải dữ liệu cũ (Để lưu tổng số khi Hop Server)
local BountyData = { StartTime = os.time(), Earned = 0, Kills = 0 }

pcall(function()
    if isfile and readfile and isfile("Standalone_BountyTrack.json") then
        local data = HttpService:JSONDecode(readfile("Standalone_BountyTrack.json"))
        -- Nếu dữ liệu cách đây chưa tới 12 tiếng (43200s), thì giữ nguyên để cộng dồn
        if data and data.StartTime and (os.time() - data.StartTime < 43200) then
            BountyData = data
        end
    end
end)

-- Hàm tính toán BPH (Bounty / 1 Giờ)
local function CalculateBPH()
    local elapsedSeconds = os.time() - BountyData.StartTime
    if elapsedSeconds < 60 then elapsedSeconds = 60 end -- Tránh lỗi chia cho 0 hoặc số quá to lúc mới bật
    local bph = math.floor((BountyData.Earned / elapsedSeconds) * 3600)
    return bph
end

-- Hàm format số cho đẹp (VD: 1.5M, 15K)
local function FormatNumber(n)
    if n >= 1000000 then return string.format("%.1fM", n / 1000000)
    elseif n >= 1000 then return string.format("%.1fK", n / 1000)
    else return tostring(n) end
end

-- Hàm Đóng gói và Bắn lên Discord
local function GửiBáoCáoDiscord(bountyVuaNhan)
    if WebhookURL == "" or not string.find(WebhookURL, "discord.com") then return end
    
    local currentBPH = CalculateBPH()
    
    local payload = {
        ["content"] = "", -- Bro có thể để ping @everyone ở đây nếu thích
        ["embeds"] = {
            {
                ["title"] = "🔥 GẶT ĐẦU THÀNH CÔNG!",
                ["description"] = "Vừa chém bay đầu một khứa và nhận thưởng!",
                ["color"] = tonumber(0xFF0055), -- Màu đỏ máu
                ["fields"] = {
                    {
                        ["name"] = "🔪 Mạng Vừa Nhận",
                        ["value"] = "**+" .. tostring(bountyVuaNhan) .. "** Tiền Thưởng",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "🏆 Tổng Nhận (Cộng Dồn)",
                        ["value"] = FormatNumber(BountyData.Earned),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "📈 Tốc Độ / 1 Giờ (BPH)",
                        ["value"] = FormatNumber(currentBPH) .. "/Giờ",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "💀 Số Lần Hạ Gục",
                        ["value"] = tostring(BountyData.Kills) .. " Mạng",
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "Tài khoản: " .. LocalPlayer.Name .. " | Thời gian: " .. os.date("%H:%M:%S")
                }
            }
        }
    }

    task.spawn(function()
        pcall(function()
            httprequest({
                Url = WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end)
end

-- ==========================================
-- BỘ QUÉT THÔNG BÁO UI (TEXT SCANNER)
-- ==========================================
local processedLabels = setmetatable({}, {__mode = "k"}) -- Tránh đầy RAM

local function CheckBountyText(lbl)
    if processedLabels[lbl] then return end
    local text = lbl.Text
    if not text then return end
    
    -- Quét các dòng chữ đỏ báo nhận Bounty/Honor trong Blox Fruits
    local matchedNumber = string.match(text, "nhận (%d+) Tiền Thưởng") or 
                          string.match(text, "nhận (%d+) Danh Dự") or 
                          string.match(text, "(%d+) Bounty") or 
                          string.match(text, "(%d+) Honor")
                          
    if matchedNumber then
        processedLabels[lbl] = true
        local val = tonumber(matchedNumber)
        
        -- Chỉ tính nếu số Bounty < 50k (để loại bỏ thông báo lúc mới load game)
        if val and val > 0 and val < 50000 then
            -- Cập nhật dữ liệu
            BountyData.Earned = BountyData.Earned + val
            BountyData.Kills = BountyData.Kills + 1
            
            -- Lưu file phòng trường hợp văng game
            pcall(function() 
                if writefile then writefile("Standalone_BountyTrack.json", HttpService:JSONEncode(BountyData)) end 
            end)
            
            -- Bắn Webhook
            GửiBáoCáoDiscord(val)
            print("Đã phát hiện và bắn Discord: +" .. val .. " Bounty")
        end
    end
end

-- Gắn cảm biến vào toàn bộ UI của người chơi
task.spawn(function()
    pcall(function()
        -- Quét những cái đang có sẵn
        for _, v in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") then
                CheckBountyText(v)
                v:GetPropertyChangedSignal("Text"):Connect(function() CheckBountyText(v) end)
            end
        end
        
        -- Bắt những UI Text mới hiện lên
        LocalPlayer.PlayerGui.DescendantAdded:Connect(function(v)
            if v:IsA("TextLabel") then
                CheckBountyText(v)
                v:GetPropertyChangedSignal("Text"):Connect(function() CheckBountyText(v) end)
            end
        end)
    end)
end)

print("✔️ Khởi động Standalone Webhook Tracker thành công!")
