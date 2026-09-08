local mod = get_mod("CopyChat")

local Managers = Managers
local string_gsub = string.gsub

local MAX_BUFFER_SIZE = 2000
local message_buffer = {}
local buffer_index = 0
local buffer_count = 0

local settings_cache = {}
local function get_setting(key)
    if settings_cache[key] == nil then
        settings_cache[key] = mod:get(key)
    end
    return settings_cache[key]
end

local function clear_settings_cache()
    for k in pairs(settings_cache) do
        settings_cache[k] = nil
    end
end

local function scrub_color_tags(text)
    if not text then
        return ""
    end

    local scrubbed

    while text ~= scrubbed do
        text = scrubbed or text
        scrubbed = string_gsub(text, "{#.-}", "")
    end

    scrubbed = string_gsub(scrubbed, "{#.-$", "")

    return scrubbed
end

local function store_message(text, sender, time)
    if not text or text == "" then
        return
    end

    buffer_index = buffer_index + 1

    if buffer_index > MAX_BUFFER_SIZE then
        buffer_index = 1
    end

    message_buffer[buffer_index] = {
        text = text,
        sender = sender,
        time = time or 0,
    }

    if buffer_count < MAX_BUFFER_SIZE then
        buffer_count = buffer_count + 1
    end
end

mod:hook(CLASS.ConstantElementChat, "_add_message", function(func, self, message, sender, channel)
    func(self, message, sender, channel)

    local time = Managers.time and Managers.time:time("main") or 0
    store_message(message, sender, time)
end)

mod:hook(CLASS.ConstantElementChat, "_add_notification", function(func, self, message, channel_tag)
    func(self, message, channel_tag)

    local time = Managers.time and Managers.time:time("main") or 0
    store_message(message, "SYSTEM", time)
end)

mod.copy_recent_chat = function(is_pressed)
    if not is_pressed then
        return
    end

    local copy_seconds = get_setting("copy_seconds")
    local current_time = Managers.time and Managers.time:time("main") or 0
    local cutoff_time = current_time - copy_seconds

    local collected = {}
    local count = 0

    if buffer_count > 0 then
        local idx = buffer_index

        for i = 1, buffer_count do
            local entry = message_buffer[idx]
            if entry and entry.time >= cutoff_time then
                count = count + 1
                collected[count] = entry
            end

            idx = idx - 1
            if idx < 1 then
                idx = MAX_BUFFER_SIZE
            end

            if idx == buffer_index then
                break
            end
        end
    end

    local max_messages = get_setting("max_messages")
    if count > max_messages then
        count = max_messages
    end

    if count == 0 then
        mod:echo("[CopyChat] No messages to copy from the last %d seconds.", copy_seconds)
        return
    end

    local anonymize = get_setting("anonymize_names")
    local player_name_map = {}
    if anonymize then
        local name_index = 0
        for i = count, 1, -1 do
            local sender = collected[i].sender
            if sender and sender ~= "SYSTEM" and sender ~= "" and not player_name_map[sender] then
                name_index = name_index + 1
                player_name_map[sender] = "Player " .. name_index
            end
        end
    end

    local lines = {}
    for i = count, 1, -1 do
        local entry = collected[i]
        local clean_text = scrub_color_tags(entry.text)
        local sender = entry.sender
        local line

        if sender and sender ~= "SYSTEM" and sender ~= "" then
            local name = anonymize and player_name_map[sender] or tostring(sender)
            line = name .. " " .. clean_text
        else
            line = clean_text
        end

        lines[#lines + 1] = line
    end

    local output = table.concat(lines, "\n")

    local success = Clipboard.put(output)
    if success then
        mod:echo("[CopyChat] Copied %d message(s) from the last %d second(s).", count, copy_seconds)
    else
        mod:error("[CopyChat] Failed to copy to clipboard.")
    end
end

mod.on_setting_changed = function(setting_id)
    clear_settings_cache()
end

mod.on_enabled = function()
    clear_settings_cache()
end


