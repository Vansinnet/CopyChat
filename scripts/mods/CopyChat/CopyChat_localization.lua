---@class CopyChatMod
local mod = get_mod("CopyChat")

return {
    mod_name = {
        en = "Copy Chat",
    },
    mod_description = {
        en = "Copies recent chat messages and DMF errors to clipboard via keybind.",
    },

    copy_keybind = {
        en = "Copy Chat Keybind",
    },
    copy_keybind_tooltip = {
        en = "Press to copy recent chat to clipboard, including DMF errors shown before the chat is available. Filters by time window and max message count.",
    },

    copy_seconds = {
        en = "Seconds to Copy",
    },
    copy_seconds_tooltip = {
        en = "Time window in seconds. Only messages within this window are candidates for copying. Combined with Maximum Messages — whichever limit is reached first applies.",
    },

    anonymize_names = {
        en = "Anonymize Player Names",
    },
    anonymize_names_tooltip = {
        en = "Replace player names with \"Player 1\", \"Player 2\", etc. Applied after time and count filtering. Numbers assigned in order of first appearance.",
    },

    max_messages = {
        en = "Maximum Messages",
    },
    max_messages_tooltip = {
        en = "Max messages to include (most recent first). Applied after the time window — if more than N messages exist within seconds, only the newest N are copied.",
    },
}
