function gui_init()
	Gui.init()
	Gui.setInputMode(false, false, true, false)
end

function gui_rom_selector(roms)
	local ret = nil
	Gui.initBlend()
	Gui.setWindowPos(0, 0, SET_ALWAYS)
	Gui.setWindowSize(960, 544, SET_ALWAYS)
	Gui.initWindow("LunarGB v." .. emu_version .. " - Rom selector", FLAG_NO_MOVE + FLAG_NO_RESIZE + FLAG_NO_COLLAPSE)
	for k, v in ipairs(roms) do
		if Gui.drawButton(v) then
			ret = v
		end
	end
	Gui.termWindow()
	Gui.termBlend()
	return ret
end

function gui_emu_options()
	Gui.initBlend()
	Gui.setWindowPos(0, 0, SET_ALWAYS)
	Gui.setWindowSize(960, 544, SET_ALWAYS)
	Gui.initWindow("LunarGB v." .. emu_version .. " - Emulator options", FLAG_NO_MOVE + FLAG_NO_RESIZE + FLAG_NO_COLLAPSE)
	debug_log = Gui.drawCheckbox("Verbose CPU interpreter logging", debug_log)
	debug_ppu = Gui.drawCheckbox("Show PPU Vram content on screen", debug_ppu)
	use_profiler = Gui.drawCheckbox("Enable CPU Profiler", use_profiler)
	serial_port_enabled = Gui.drawCheckbox("Enable I/O Serial Port logging", serial_port_enabled)
	Gui.termWindow()
	Gui.termBlend()
end

function gui_pause_menu()
	Gui.initBlend()
	Gui.setWindowPos(0, 0, SET_ALWAYS)
	Gui.setWindowSize(960, 544, SET_ALWAYS)
	Gui.initWindow("LunarGB v." .. emu_version .. " - " .. rom_name, FLAG_NO_MOVE + FLAG_NO_RESIZE + FLAG_NO_COLLAPSE)
	if Gui.drawButton("Resume emulation") then
		emu_state = EMU_RUNNING
	end
	if Gui.drawButton("Close game") then
		emu_state = EMU_NOT_RUNNING
		rom_path = nil
	end
	Gui.termWindow()
	Gui.termBlend()
end