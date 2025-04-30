local ppu_oam_ram = {}
local ppu_vram = {}
local ppu_colors = {0xFFFFFFFF, 0xAAAAAAFF, 0x555555FF, 0x000000FF}
ppu_dbg_tex = nil

-- Indices for LCD struct
local LCD_LCDC     = 0
local LCD_LCDS     = 1
local LCD_SCROLL_Y = 2
local LCD_SCROLL_X = 3
local LCD_LY       = 4
local LCD_LY_CMP   = 5
local LCD_DMA      = 6
local LCD_BG_PAL   = 7
local LCD_OBJ1_PAL = 8
local LCD_OBJ2_PAL = 9
local LCD_WIN_Y    = 10
local LCD_WIN_X    = 11

local lcd_regs = {}
local bg_cols = {}
local sp1_cols = {}
local sp2_cols = {}

local band = bit32.band
local rshift = bit32.rshift

local function ppu_update_dbg_tile(num, x, y)
	for tile_y = 0, 15, 2 do
		local offs = (num * 16) + tile_y
		local b1 = ppu_vram[offs]
		local b2 = ppu_vram[offs + 1]
		for bit = 7, 0, -1 do
			local high = bit32.lshift(((bit32.band(b1, bit32.lshift(1, bit)) > 0) and 1 or 0), 1)
			local low = (bit32.band(b2, bit32.lshift(1, bit)) > 0) and 1 or 0
			local clr = bit32.bor(high, low) + 1
			Graphics.drawPixel(x + (7 - bit), y + (tile_y / 2), ppu_colors[clr], ppu_dbg_tex)
		end
	end
end

function ppu_update_dbg_tex()
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
end

function ppu_init()
	for i = 0, 39 do
		ppu_oam_ram[i] = 0
	end
	
	for i = 0, 0x1FFF do
		ppu_vram[i] = 0
	end
end

function ppu_tick()

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

function lcd_init()
	lcd_regs[LCD_LCDC] = 0x91
	lcd_regs[LCD_LCDS] = 0x00
	lcd_regs[LCD_SCROLL_Y] = 0
	lcd_regs[LCD_SCROLL_X] = 0
	lcd_regs[LCD_LY] = 0
	lcd_regs[LCD_LY_CMP] = 0
	lcd_regs[LCD_DMA] = 0
	lcd_regs[LCD_BG_PAL] = 0xFC
	lcd_regs[LCD_OBJ1_PAL] = 0xFF
	lcd_regs[LCD_OBJ2_PAL] = 0xFF
	lcd_regs[LCD_WIN_Y] = 0
	lcd_regs[LCD_WIN_X] = 0
	
	for i = 0, 3 do
		bg_cols[i] = ppu_colors[i]
		sp1_cols[i] = ppu_colors[i]
		sp2_cols[i] = ppu_colors[i]
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
		bg_cols[0] = ppu_colors[band(val, 0b11)]
		bg_cols[1] = ppu_colors[band(rshift(val, 2), 0b11)]
		bg_cols[2] = ppu_colors[band(rshift(val, 4), 0b11)]
		bg_cols[3] = ppu_colors[band(rshift(val, 6), 0b11)]
	elseif offs == 8 then
		sp1_cols[0] = ppu_colors[band(band(val, 0b11111100), 0b11)]
		sp1_cols[1] = ppu_colors[band(rshift(band(val, 0b11111100), 2), 0b11)]
		sp1_cols[2] = ppu_colors[band(rshift(band(val, 0b11111100), 4), 0b11)]
		sp1_cols[3] = ppu_colors[band(rshift(band(val, 0b11111100), 6), 0b11)]
	elseif offs == 9 then
		sp2_cols[0] = ppu_colors[band(band(val, 0b11111100), 0b11)]
		sp2_cols[1] = ppu_colors[band(rshift(band(val, 0b11111100), 2), 0b11)]
		sp2_cols[2] = ppu_colors[band(rshift(band(val, 0b11111100), 4), 0b11)]
		sp2_cols[3] = ppu_colors[band(rshift(band(val, 0b11111100), 6), 0b11)]
	end
end