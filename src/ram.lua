local wram = {}
local hram = {}

function ram_init()
	for i = 0, 0x2000 do
		wram[i] = 0
	end
	
	for i = 0, 0x80 do
		hram[i] = 0
	end
end

function wram_read(addr)
	return wram[addr - 0xC000]
end

function wram_write(addr, val)
	wram[addr - 0xC000] = val
end

function hram_read(addr)
	return hram[addr - 0xFF80]
end

function hram_write(addr, val)
	hram[addr - 0xFF80] = val
end
