local serial_data = {}

function io_init()
	serial_data[0] = 0
	serial_data[1] = 0
end

function io_read(addr)
	if addr == 0xFF01 then
		return serial_data[0]
	elseif addr == 0xFF02 then
		return serial_data[1]
	elseif addr >= 0xFF04 and addr <= 0xFF07 then
		return timer_read(addr)
	elseif addr == 0xFF0F then
		return cpu.interrupts
	elseif addr >= 0xFF40 and addr <= 0xFF4B then
		return lcd_read(addr)
	end
	
	return 0
end

function io_write(addr, val)
	if addr == 0xFF01 then
		serial_data[0] = val
	elseif addr == 0xFF02 then
		serial_data[1] = val
	elseif addr >= 0xFF04 and addr <= 0xFF07 then
		timer_write(addr, val)
	elseif addr == 0xFF0F then
		cpu.interrupts = val
	elseif addr >= 0xFF40 and addr <= 0xFF4B then
		lcd_write(addr, val)
	end	
end
