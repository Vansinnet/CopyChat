return {
    version = "1.0.0",
    run = function()
        fassert(rawget(_G, "new_mod"), "`CopyChat` encountered an error loading the Darktide Mod Framework.")

        new_mod("CopyChat", {
            mod_script       = "CopyChat/scripts/mods/CopyChat/CopyChat",
            mod_data         = "CopyChat/scripts/mods/CopyChat/CopyChat_data",
            mod_localization = "CopyChat/scripts/mods/CopyChat/CopyChat_localization",
        })
    end,
    packages = {},
}
