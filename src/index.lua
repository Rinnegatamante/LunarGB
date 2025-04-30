-- Emulator state management
EMU_NOT_RUNNING = 0
EMU_RUNNING = 1
EMU_PAUSED = 2
emu = {
	["state"] = EMU_NOT_RUNNING,
	["ticks"] = 0,
	["frame_ticks"] = 0
}

local rom_folder = "ux0:data/LunarGB/roms/"
rom_path = nil

-- Cycles incrementing function
function emu_incr_cycles(cycles)
	for i = 0, cycles - 1 do
		for j = 0, 3 do
			emu.ticks = emu.ticks + 1
			timer_tick()
		end
		
		dma_tick()
	end
end

local cycles_per_frame = 69905 -- Maximum number of cycles per frame

-- Emulator options
emu_version = "0.1" 
debug_log = true -- Log debug info on system console
debug_ppu = true -- Show PPU data on screen
serial_port_enabled = true -- Log serial port output to system console

-- Loading emulator components
dofile("app0:cartridge.lua")
dofile("app0:cpu.lua")
dofile("app0:bus.lua")
dofile("app0:ppu.lua")
dofile("app0:timer.lua")
dofile("app0:ram.lua")
dofile("app0:gui.lua")
dofile("app0:io.lua")
dofile("app0:dma.lua")

-- Scan roms folder and keep only .gb files
local tmp = System.listDirectory(rom_folder)
for k, v in ipairs(tmp) do
	if string.len(v.name) < 4 or string.sub(v.name, -3) ~= ".gb" then
		tmp[k] = nil
	end
end
local roms = {}
local roms_num = 0
for k, v in ipairs(tmp) do
	if v then
		roms_num = roms_num + 1
		table.insert(roms, roms_num, v.name)
	end
end

-- Initing UI
gui_init()

while true do
	while rom_path == nil do
		Graphics.initBlend()
		Screen.clear()
		rom_path = gui_rom_selector(roms)
		Graphics.termBlend()
		Screen.flip()
	end
	
	-- Main emulator code start
	cartridge_load(rom_folder .. rom_path)
	ram_init()
	ppu_init()
	cpu_init()
	lcd_init()
	timer_init()
	io_init()
	emu.state = EMU_RUNNING
	emu.ticks = 0
	
	-- Init any optional stuffs
	if debug_ppu then
		ppu_dbg_tex = Graphics.createImage(128, 192, Color.new(0, 0, 0), MEM_RAM)
	end
	
	local oldpad = 0
	while emu.state ~= EMU_NOT_RUNNING do
		Graphics.initBlend()
		Screen.clear()
		local pad = Controls.read()
		if emu.state == EMU_PAUSED then -- Emulation paused
			gui_pause_menu()
		else -- Emulation active
			emu.frame_ticks = 0
			while emu.frame_ticks < cycles_per_frame do
				-- Perform one CPU step
				local start_tick = emu.ticks
				cpu_step()
				emu.frame_ticks = emu.frame_ticks + (emu.ticks - start_tick)
			
				-- Check if we want to pause the emulator
				if Controls.check(pad, SCE_CTRL_LTRIGGER) and not Controls.check(oldpad, SCE_CTRL_LTRIGGER) then
					emu.state = EMU_PAUSED
				end
			end
			
			-- Render on screen
			if debug_ppu then
				ppu_update_dbg_tex()
				Graphics.drawImage(700, 144, ppu_dbg_tex)
			end
		end
		Graphics.termBlend()
		Screen.flip()
		oldpad = pad
	end
end