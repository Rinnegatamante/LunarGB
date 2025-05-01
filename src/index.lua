-- Emulator state management
EMU_NOT_RUNNING = 0
EMU_RUNNING = 1
EMU_PAUSED = 2
emu_state = EMU_NOT_RUNNING

local rom_folder = "ux0:data/LunarGB/roms/"
rom_path = nil

-- Cycles incrementing function
function emu_incr_cycles(cycles)
	for i = 0, cycles - 1 do
		for j = 0, 3 do
			timer_tick()
			ppu_tick()
		end
		
		dma_tick()
	end
end

-- Emulator options
emu_version = "0.1" 
debug_log = false -- Log debug info on system console
debug_ppu = true -- Show PPU data on screen
use_profiler = false -- Enable profiler
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
dofile("app0:profile.lua")

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
	local oldpad = 0
	local show_options = false
	while rom_path == nil do
		local pad = Controls.read()
		Graphics.initBlend()
		Screen.clear()
		if show_options then
			gui_emu_options()
		else
			rom_path = gui_rom_selector(roms)
		end
		if Controls.check(pad, SCE_CTRL_LTRIGGER) and not Controls.check(oldpad, SCE_CTRL_LTRIGGER) then
			show_options = not show_options
		end
		Graphics.termBlend()
		Screen.flip()
		oldpad = pad
	end
	
	-- Main emulator code start
	cartridge_load(rom_folder .. rom_path)
	ram_init()
	ppu_init(debug_ppu)
	cpu_init()
	timer_init()
	io_init()
	emu_state = EMU_RUNNING
	emu_ticks = 0

	while emu_state ~= EMU_NOT_RUNNING do
		Graphics.initBlend()
		Screen.clear()
		local pad = Controls.read()
		if emu_state == EMU_PAUSED then -- Emulation paused
			gui_pause_menu()
		else -- Emulation active
			if use_profiler then
				profile.start()
			end
			local work_frame = ppu_cur_frame
			while work_frame == ppu_cur_frame and emu_state == EMU_RUNNING do
				-- Perform one CPU step
				cpu_step()
			
				-- Check if we want to pause the emulator
				if Controls.check(pad, SCE_CTRL_LTRIGGER) and not Controls.check(oldpad, SCE_CTRL_LTRIGGER) then
					emu_state = EMU_PAUSED
				end
			end
			if use_profiler then
				profile.stop()
				System.consolePrint(profile.report(30))
				profile.reset()
			end
			-- Render PPU debug stuffs on screen
			if debug_ppu then
				ppu_show_dbg_tex()
			end
		end
		Graphics.termBlend()
		Screen.flip()
		oldpad = pad
	end
end