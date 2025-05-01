-- 0x0000 - 0x3FFF : ROM Bank 0
-- 0x4000 - 0x7FFF : ROM Bank 1 - Switchable
-- 0x8000 - 0x97FF : CHR RAM
-- 0x9800 - 0x9BFF : BG Map 1
-- 0x9C00 - 0x9FFF : BG Map 2
-- 0xA000 - 0xBFFF : Cartridge RAM
-- 0xC000 - 0xCFFF : RAM Bank 0
-- 0xD000 - 0xDFFF : RAM Bank 1-7 - switchable - Color only
-- 0xE000 - 0xFDFF : Reserved - Echo RAM
-- 0xFE00 - 0xFE9F : Object Attribute Memory
-- 0xFEA0 - 0xFEFF : Reserved - Unusable
-- 0xFF00 - 0xFF7F : I/O Registers
-- 0xFF80 - 0xFFFE : Zero Page

local rshift = bit.rshift

function bus_write(addr, val)
	if addr < 0x8000 then
		-- ROM data
		cartridge_write(addr, val)
	elseif addr < 0xA000 then
		-- Char/Map data
		ppu_vram_write(addr, val)
	elseif addr < 0xC000 then
		-- Cartridge RAM
		cartridge_write(addr, val)
	elseif addr < 0xE000 then
		-- Working RAM
		wram_write(addr, val)
	elseif addr < 0xFE00 then
		-- Reerved echo RAM
		return 0
	elseif addr < 0xFEA0 then
		-- OAM
		if not dma_active then
			ppu_oam_write(addr, val)
		end
	elseif addr < 0xFF00 then
		-- Reserved section
		return 0
	elseif addr < 0xFF80 then
		-- IO Registers
		io_write(addr, val)
	elseif addr == 0xFFFF then
		-- Interrupt Enable register
		cpu_write_ie_reg(val)
	else
		-- HRAM
		hram_write(addr, val)
	end
end

function bus_write16(addr, val)
	bus_write(addr, val % 0x100)
	bus_write(addr + 1, rshift(val, 8) % 0x100)
end

function bus_read(addr)
	if addr < 0x8000 then
		-- ROM data
		return cartridge_read(addr)
	elseif addr < 0xA000 then
		-- Char/Map data
		return ppu_vram_read(addr)
	elseif addr < 0xC000 then
		-- Cartridge RAM
		return cartridge_read(addr)
	elseif addr < 0xE000 then
		-- Working RAM
		return wram_read(addr)
	elseif addr < 0xFE00 then
		-- Reerved echo RAM
		return 0
	elseif addr < 0xFEA0 then
		-- OAM
		if dma.active then
			return 0xFF
		end
		return ppu_oam_read(addr)
	elseif addr < 0xFF00 then
		-- Reserved section
		return 0
	elseif addr < 0xFF80 then
		-- IO Registers
		return io_read(addr)
	elseif addr == 0xFFFF then
		-- Interrupt Enable register
		return cpu_read_ie_reg()
	else
		-- HRAM
		return hram_read(addr)
	end
end

function bus_read16(addr)
	local low = bus_read(addr)
	local high = bus_read(addr + 1)
	return bit32.bor(low, bit32.lshift(high, 8))
end
