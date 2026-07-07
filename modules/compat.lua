-- Compatibility shims for the modern client engine used by the Anniversary
-- realms. Loaded before any module that uses the affected APIs.

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
