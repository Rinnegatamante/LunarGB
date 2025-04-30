dma_active = false
local dma_byte = 0
local dma_val = 0
local dma_delay = 0

function dma_start(val)
	dma_active = true
	dma_byte = 0
	dma_delay = 2
	dma_val = val
end

function dma_tick()
	if dma_active then
		if dma_delay then
			dma_delay = dma_delay - 1
		else
			ppu_oam_write(dma.byte, bus_read((dma_val * 0x100) + dma_byte))
		end
		
		dma_byte = dma_byte + 1
		dma_active = dma_byte < 0xA0
	end
end
