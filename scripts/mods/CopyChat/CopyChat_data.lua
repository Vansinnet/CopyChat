---@class CopyChatMod
local mod = get_mod("CopyChat")

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    allow_rehooking = true,
    options = {
        widgets = {
            {
                setting_id = "copy_keybind",
                type = "keybind",
                keybind_type = "function_call",
                keybind_trigger = "pressed",
                function_name = "copy_recent_chat",
                default_value = {},
                title = "copy_keybind",
                tooltip = "copy_keybind_tooltip",
            },
            {
                setting_id = "copy_seconds",
                type = "numeric",
                range = { 1, 120 },
                decimals_number = 0,
                default_value = 20,
                title = "copy_seconds",
                tooltip = "copy_seconds_tooltip",
            },
            {
                setting_id = "anonymize_names",
                type = "checkbox",
                default_value = false,
                title = "anonymize_names",
                tooltip = "anonymize_names_tooltip",
            },
            {
                setting_id = "max_messages",
                type = "numeric",
                range = { 1, 300 },
                decimals_number = 0,
                default_value = 100,
                title = "max_messages",
                tooltip = "max_messages_tooltip",
            },
        },
    },
}
