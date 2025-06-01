local nativeSettings = GetMod("nativeSettings")
local settings = false

nativeSettings.addTab("/NorthFix", "North Fix") -- (path, label, optional[callback-on-close])

nativeSettings.addSwitch(
    "/NorthFix",
    "North Fix",
    "Fix Minimap Orientation; North is up",
    false, false,
    function(state)
        settings = state
        print("Changed North Fix to <", settings, ">")
    end
    )