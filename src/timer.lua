local timer_div = 0
local timer_tima = 0
local timer_tma = 0
local timer_tac = 0
local band = bit32.band

function timer_init()
	timer_div = 0xAC00
	timer_tima = 0
	timer_tma = 0
	timer_tac = 0
end

function timer_tick()
	local timer_update
	local prev_div = timer_div
	timer_div = band(timer_div + 1, 0xFFFF)
	
	local tac_bits = band(timer_tac, 0x03)
	if tac_bits == 0 then
		timer_update = (band(prev_div, 0x200) == 0x200) and not (band(timer_div, 0x200) == 0x200)
	elseif tac_bits == 1 then
		timer_update = (band(prev_div, 0x08) == 0x08) and not (band(timer_div, 0x08) == 0x08)
	elseif tac_bits == 2 then
		timer_update = (band(prev_div, 0x20) == 0x20) and not (band(timer_div, 0x20) == 0x20)
	else
		timer_update = (band(prev_div, 0x80) == 0x80) and not (band(timer_div, 0x80) == 0x80)
	end
	
	if timer_update and band(timer_tac, 0x04) == 0x04 then
		timer_tima = timer_tima + 1
		if timer_tima == 0xFF then
			timer_tima = timer_tma
			cpu_set_interrupt(IT_TIMER)
		end
	end
end

function timer_read(addr)
	if addr == 0xFF04 then
		return timer_div
	elseif addr == 0xFF05 then
		return timer_tima
	elseif addr == 0xFF06 then
		return timer_tma
	else
		return timer_tac
	end	
end

function timer_write(addr, val)
	if addr == 0xFF04 then
		timer_div = val
	elseif addr == 0xFF05 then
		timer_tima = val
	elseif addr == 0xFF06 then
		timer_tma = val
	else
		timer_tac = val
	end
end
