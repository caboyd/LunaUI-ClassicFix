-- Compatibility shims for the modern client engine used by the Anniversary
-- realms. Loaded first, before the libraries and modules that use these APIs.

-- DebuffTypeColor is no longer defined when addons load. oUF copies it into
-- oUF.colors.debuff, which drives the dispellable-debuff highlight and the
-- raid status indicators. Values from classic FrameXML/BuffFrame.lua.
if not DebuffTypeColor then
	DebuffTypeColor = {
		["none"]    = { r = 0.80, g = 0.00, b = 0.00 },
		[""]        = { r = 0.80, g = 0.00, b = 0.00 },
		["Magic"]   = { r = 0.20, g = 0.60, b = 1.00 },
		["Curse"]   = { r = 0.60, g = 0.00, b = 1.00 },
		["Disease"] = { r = 0.60, g = 0.40, b = 0.00 },
		["Poison"]  = { r = 0.00, g = 0.60, b = 0.00 },
	}
end

-- GetScreenResolutions()/GetCurrentResolution() were removed, and the new
-- engine has no public API that enumerates display modes. Expose only the
-- current mode; it is re-read on each call, so resolution-based profile
-- autoswitching still resolves correctly after DISPLAY_SIZE_CHANGED.
if not GetScreenResolutions then
	function GetScreenResolutions()
		local width, height = GetPhysicalScreenSize()
		return string.format("%dx%d", width, height)
	end

	function GetCurrentResolution()
		return 1
	end
end
