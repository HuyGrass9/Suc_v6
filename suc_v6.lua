-- ==========================================
-- [MODULE]: REAPER WEBHOOK (GIAO TIẾP DISCORD)
-- ==========================================
local function SendDiscordWebhook(bountyVuaNhan, tongBounty, bph, totalKills)
    -- Ném vào task.spawn để chạy luồng riêng, tuyệt đối không làm lag nhịp chém của game
    task.spawn(function()
        pcall(function()
            -- 1. Lấy URL từ Config bên ngoài (Người dùng tự nhập ở Executor)
            -- Quét qua getgenv().MyDiscordWebhook hoặc lấy từ getgenv().Setting nếu có
            local webhookUrl = getgenv().MyDiscordWebhook or (getgenv().Setting and getgenv().Setting.Webhook and getgenv().Setting.Webhook["Url Webhook"])
            
            -- 2. Kiểm tra an toàn: Nếu không có URL hoặc URL fake -> Hủy lệnh, im lặng rút lui
            if not webhookUrl or webhookUrl == "" or not string.find(webhookUrl, "discord.com/api/webhooks") then 
                return 
            end
            
            -- 3. Tìm hàm request API (Tương thích 99% các loại Executor hiện nay như Delta, Fluxus, Arceus, Synapse...)
            local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
            if not httprequest then return end
            
            local HttpService = game:GetService("HttpService")
            local LocalPlayer = game:GetService("Players").LocalPlayer
            
            -- 4. Đóng gói Báo cáo Kế toán thành Form màu Đỏ Máu siêu ngầu
            local payload = {
                ["username"] = "Omni Reaper",
                ["avatar_url"] = "https://i.imgur.com/OwaX2Z8.png", -- Đổi logo tùy ý bro
                ["embeds"] = {
                    {
                        ["title"] = "💀 MỤC TIÊU ĐÃ BỊ TIÊU DIỆT!",
                        ["description"] = "Hệ thống vừa bón hành thành công một nạn nhân.",
                        ["color"] = tonumber(0xFF0055), -- Mã màu Đỏ Crimson
                        ["fields"] = {
                            {
                                ["name"] = "🔥 Lợi Nhuận", 
                                ["value"] = "```diff\n+ " .. tostring(bountyVuaNhan) .. " Bounty\n```", 
                                ["inline"] = true
                            },
                            {
                                ["name"] = "📈 Tốc Độ (BPH)", 
                                ["value"] = "```fix\n" .. tostring(bph) .. " / Giờ\n```", 
                                ["inline"] = true
                            },
                            {
                                ["name"] = "🏆 Tổng Nhận Cày Được", 
                                ["value"] = "**" .. tostring(tongBounty) .. "**", 
                                ["inline"] = false
                            },
                            {
                                ["name"] = "🔪 Số Mạng Hạ Gục", 
                                ["value"] = "**" .. tostring(totalKills) .. "** Mạng", 
                                ["inline"] = true
                            },
                            {
                                ["name"] = "👤 Sát Thủ (Player)", 
                                ["value"] = LocalPlayer.Name, 
                                ["inline"] = true
                            }
                        },
                        ["footer"] = {
                            ["text"] = "SUC_CORE :: OMNI MODULE | " .. os.date("%H:%M:%S")
                        }
                    }
                }
            }
            
            -- 5. Khai hỏa! Bắn gói dữ liệu lên server Discord của người dùng
            httprequest({
                Url = webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end)
end
