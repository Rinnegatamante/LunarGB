-- Indices for LCD struct
-- LCD_LCDC     = 0
-- LCD_LCDS     = 1
-- LCD_SCROLL_Y = 2
-- LCD_SCROLL_X = 3
-- LCD_LY       = 4
-- LCD_LY_CMP   = 5
-- LCD_DMA      = 6
-- LCD_BG_PAL   = 7
-- LCD_OBJ1_PAL = 8
-- LCD_OBJ2_PAL = 9
-- LCD_WIN_Y    = 10
-- LCD_WIN_X    = 11

-- LCDS modes
-- MODE_HBLANK = 0
-- MODE_VBLANK = 1
-- MODE_OAM    = 2
-- MODE_XFER   = 3

-- LCDS stat modes
-- SS_HBLANK = 0x08
-- SS_VBLANK = 0x10
-- SS_OAM = 0x20
-- SS_LYC = 0x40

-- Fetch state modes
-- FS_TILE  = 0
-- FS_DATA0 = 1
-- FS_DATA1 = 2
-- FS_IDLE  = 3
-- FS_PUSH  = 4

-- Localized commonly used functions
local bor = bit32.bor
local band = bit32.band
local rshift = bit32.rshift
local lshift = bit32.lshift
local bnot = bit32.bnot
local drawPixel = Graphics.drawPixel
local drawImage = Graphics.drawScaleImage

-- PPU state
local ppu_oam_ram = {}
local ppu_vram = {}
local ppu_colors = {}
local ppu_lines = 0
local ppu_fifo_line_x = 0
local ppu_fifo_pushed_x = 0
local ppu_fifo_fetch_x = 0
local ppu_fifo_fifo_x = 0
local ppu_fifo = {}
local ppu_fifo_fetch_state = 0
local ppu_fifo_map_y = 0
local ppu_fifo_map_x = 0
local ppu_fifo_tile_y = 0
local ppu_bgw_fetch_data0 = 0
local ppu_bgw_fetch_data1 = 0
local ppu_bgw_fetch_data2 = 0
local ppu_dbg_tex = nil
local screen_tex = nil
ppu_cur_frame = 0

-- LCD state
local lcd_regs = {}
local bg_cols = {}
local sp1_cols = {}
local sp2_cols = {}

local function lcd_set_mode(mode)
	lcd_regs[1] = band(lcd_regs[1], bnot(0x03))
	lcd_regs[1] = bor(lcd_regs[1], mode)
end

local function ppu_update_dbg_tile(num, x, y)
	for tile_y = 0, 15, 2 do
		local offs = (num * 16) + tile_y
		local b1 = ppu_vram[offs]
		local b2 = ppu_vram[offs + 1]
		for bit = 7, 0, -1 do
			local high = (band(b1, lshift(1, bit)) > 0) and 2 or 0
			local low = (band(b2, lshift(1, bit)) > 0) and 1 or 0
			local clr = high + low
			drawPixel(x + (7 - bit), y + (tile_y / 2), ppu_colors[clr], ppu_dbg_tex)
		end
	end
end

function ppu_show_dbg_tex()
	local tile_id = 0
	local tile_x = 0
	local tile_y = 0
	for y = 0, 23 do
		for x = 0, 15 do
			ppu_update_dbg_tile(tile_id, tile_x, tile_y)
			tile_x = tile_x + 8
			tile_id = tile_id + 1
		end
		tile_y = tile_y + 8
		tile_x = 0
	end
	
	drawImage(650, 80, ppu_dbg_tex, 2, 2)
end

local function ppu_fetch_pipeline()
	if ppu_fifo_fetch_state == 0 then -- FS_TILE
		if band(lcd_regs[0], 0x01) == 0x01 then
			local bg_map_area
			if band(lcd_regs[0], 0x08) == 0x08 then
				bg_map_area = 0x9C00
			else
				bg_map_area = 0x9800
			end
			ppu_bgw_fetch_data0 = bus_read(bg_map_area + (ppu_fifo_map_x / 8) + ((ppu_fifo_map_y / 8) * 32))
			if band(lcd_regs[0], 0x10) == 0x00 then
				ppu_bgw_fetch_data0 = ppu_bgw_fetch_data0 + 128
			end
		end
		ppu_fifo_fetch_state = 1
		ppu_fifo_fetch_x = ppu_fifo_fetch_x + 8
	elseif ppu_fifo_fetch_state == 1 then -- FS_DATA0
		local bgw_data_area
		if band(lcd_regs[0], 0x10) == 0x10 then
			bgw_data_area = 0x8000
		else
			bgw_data_area = 0x8800
		end
		ppu_bgw_fetch_data1 = bus_read(bgw_data_area + ppu_bgw_fetch_data0 * 16 + ppu_fifo_tile_y)
		ppu_fifo_fetch_state = 2
	elseif ppu_fifo_fetch_state == 2 then -- FS_DATA1
		local bgw_data_area
		if band(lcd_regs[0], 0x10) == 0x10 then
			bgw_data_area = 0x8000
		else
			bgw_data_area = 0x8800
		end
		ppu_bgw_fetch_data2 = bus_read(bgw_data_area + ppu_bgw_fetch_data0 * 16 + ppu_fifo_tile_y + 1)
		ppu_fifo_fetch_state = 3
	elseif ppu_fifo_fetch_state == 3 then -- FS_IDLE
		ppu_fifo_fetch_state = 4
	elseif ppu_fifo_fetch_state == 4 then -- FS_PUSH
		if table.getn(ppu_fifo) <= 8 then
			local x = ppu_fifo_fetch_x - (8 - (lcd_regs[3] % 8))
			for i = 0, 7 do
				local bit = 7 - i
				local high = (band(ppu_bgw_fetch_data1, lshift(1, bit)) > 0) and 1 or 0
				local low = (band(ppu_bgw_fetch_data2, lshift(1, bit)) > 0) and 2 or 0
				if x >= 0 then
					table.insert(ppu_fifo, bg_cols[high + low])
					ppu_fifo_fifo_x = ppu_fifo_fifo_x + 1
				end
			end
			ppu_fifo_fetch_state = 0
		end
	end
end

function ppu_tick()
	ppu_lines = ppu_lines + 1
	
	local ppu_mode = lcd_regs[1] % 4
	if ppu_mode == 0 then -- MODE_HBLANK
		if ppu_lines >= 456 then
			lcd_regs[4] = lcd_regs[4] + 1
			if lcd_regs[4] == lcd_regs[5] then
				lcd_regs[1] = bor(lcd_regs[1], 0x04)
				if band(lcd_regs[1], 0x40) == 0x40 then
					cpu_set_interrupt(IT_LCD_STAT)
				end
			else
				lcd_regs[1] = band(lcd_regs[1], bnot(0x04))
			end
			if lcd_regs[4] >= 144 then
				lcd_set_mode(1)
				cpu_set_interrupt(IT_VBLANK)
				if band(lcd_regs[1], 0x10) == 0x10 then
					cpu_set_interrupt(IT_LCD_STAT)
				end
				ppu_cur_frame = ppu_cur_frame + 1
				drawImage(100, 56, screen_tex, 3, 3)
			else
				lcd_set_mode(2)
			end
			ppu_lines = 0
		end
	elseif ppu_mode == 1 then -- MODE_VBLANK
		if ppu_lines >= 456 then
			lcd_regs[4] = lcd_regs[4] + 1
			if lcd_regs[4] == lcd_regs[5] then
				lcd_regs[1] = bor(lcd_regs[1], 0x04)
				if band(lcd_regs[1], 0x40) == 0x40 then
					cpu_set_interrupt(IT_LCD_STAT)
				end
			else
				lcd_regs[1] = band(lcd_regs[1], bnot(0x04))
			end
			if lcd_regs[4] >= 154 then
				lcd_set_mode(2)
				lcd_regs[4] = 0
			end
			ppu_lines = 0
		end
	elseif ppu_mode == 2 then -- MODE_OAM
		if ppu_lines >= 80 then
			lcd_set_mode(3)
			ppu_fifo_fetch_state = 0
			ppu_fifo_line_x = 0
			ppu_fifo_fetch_x = 0
			ppu_fifo_pushed_x = 0
			ppu_fifo_fifo_x = 0
		end
	elseif ppu_mode == 3 then -- MODE_XFER
		ppu_fifo_map_y = lcd_regs[4] + lcd_regs[2]
		ppu_fifo_map_x = ppu_fifo_fetch_x + lcd_regs[3]
		ppu_fifo_tile_y = (ppu_fifo_map_y % 8) * 2
		if band(ppu_lines, 1) == 0 then
			ppu_fetch_pipeline()
		end
		if #ppu_fifo > 8 then
			local clr = ppu_fifo[1]
			table.remove(ppu_fifo, 1)
			if ppu_fifo_line_x >= (lcd_regs[3] % 8) then
				drawPixel(ppu_fifo_pushed_x, lcd_regs[4], clr, screen_tex)
				ppu_fifo_pushed_x = ppu_fifo_pushed_x + 1
			end
			ppu_fifo_line_x = ppu_fifo_line_x + 1
		end
		if ppu_fifo_pushed_x >= 160 then
			ppu_fifo = {}
			lcd_set_mode(0)
			if band(lcd_regs[1], 0x08) == 0x08 then
				cpu_set_interrupt(IT_LCD_STAT)
			end
		end
	end
end

function ppu_oam_write(addr, val)
	if addr >= 0xFE00 then
		addr = addr - 0xFE00
	end
	
	ppu_oam_ram[addr] = val
end

function ppu_oam_read(addr)
	if addr >= 0xFE00 then
		addr = addr - 0xFE00
	end
	
	return ppu_oam_ram[addr]
end

function ppu_vram_write(addr, val)
	ppu_vram[addr - 0x8000] = val
end

function ppu_vram_read(addr)
	return ppu_vram[addr - 0x8000]
end

local function lcd_init()
	lcd_regs[0] = 0x91
	lcd_regs[1] = 0x00
	lcd_regs[2] = 0
	lcd_regs[3] = 0
	lcd_regs[4] = 0
	lcd_regs[5] = 0
	lcd_regs[6] = 0
	lcd_regs[7] = 0xFC
	lcd_regs[8] = 0xFF
	lcd_regs[9] = 0xFF
	lcd_regs[10] = 0
	lcd_regs[11] = 0
	
	ppu_colors[0] = 0xFFFFFFFF
	ppu_colors[1] = 0xAAAAAAFF
	ppu_colors[2] = 0x555555FF
	ppu_colors[3] = 0x000000FF
	
	for i = 0, 3 do
		bg_cols[i] = ppu_colors[i]
		sp1_cols[i] = ppu_colors[i]
		sp2_cols[i] = ppu_colors[i]
	end
end

function ppu_init(debug)
	ppu_cur_frame = 0
	ppu_lines = 0
	screen_tex = Graphics.createImage(160, 144, Color.new(0, 0, 0), MEM_RAM)
	if debug then
		ppu_dbg_tex = Graphics.createImage(128, 192, Color.new(0, 0, 0), MEM_RAM)
	end
	
	ppu_fifo_line_x = 0
	ppu_fifo_pushed_x = 0
	ppu_fifo_fetch_x = 0
	ppu_fifo_fetch_state = 0
	ppu_fifo_fifo_x = 0
	ppu_fifo = {}
	
	lcd_init()
	lcd_set_mode(2)
	
	for i = 0, 39 do
		ppu_oam_ram[i] = 0
	end
	
	for i = 0, 0x1FFF do
		ppu_vram[i] = 0
	end
end

function lcd_read(addr)
	return lcd_regs[addr - 0xFF40]
end

function lcd_write(addr, val)
	local offs = addr - 0xFF40
	lcd_regs[offs] = val
	
	if offs == 6 then
		dma_start(val)
	elseif offs == 7 then
		bg_cols[0] = ppu_colors[val % 4]
		bg_cols[1] = ppu_colors[rshift(val, 2) % 4]
		bg_cols[2] = ppu_colors[rshift(val, 4) % 4]
		bg_cols[3] = ppu_colors[rshift(val, 6) % 4]
	elseif offs == 8 then
		local v = band(val, 0b11111100)
		sp1_cols[0] = ppu_colors[0]
		sp1_cols[1] = ppu_colors[rshift(v, 2) % 4]
		sp1_cols[2] = ppu_colors[rshift(v, 4) % 4]
		sp1_cols[3] = ppu_colors[rshift(v, 6) % 4]
	elseif offs == 9 then
		local v = band(val, 0b11111100)
		sp2_cols[0] = ppu_colors[0]
		sp2_cols[1] = ppu_colors[rshift(v, 2) % 4]
		sp2_cols[2] = ppu_colors[rshift(v, 4) % 4]
		sp2_cols[3] = ppu_colors[rshift(v, 6) % 4]
	end
end