local new_licensee_codes = {
	["00"] = "None",
	["01"] = "Nintendo Research & Development 1",
	["08"] = "Capcom",
	["13"] = "Electronic Arts",
	["18"] = "Hudson Soft",
	["19"] = "B-AI",
	["20"] = "KSS",
	["22"] = "Planning Office WADA",
	["24"] = "PCM Complete",
	["25"] = "San-X",
	["28"] = "Kemco",
	["29"] = "SETA Corporation",
	["30"] = "Viacom",
	["31"] = "Nintendo",
	["32"] = "Bandai",
	["33"] = "Ocean Software / Acclaim Entertainment",
	["34"] = "Konami",
	["35"] = "HectorSoft",
	["37"] = "Taito",
	["38"] = "Hudson Soft",
	["39"] = "Banpresto",
	["41"] = "Ubi Soft",
	["42"] = "Atlus",
	["44"] = "Malibu Interactive",
	["46"] = "Angel",
	["47"] = "Bullet-Proof Software",
	["49"] = "Irem",
	["50"] = "Absolute",
	["51"] = "Acclaim Entertainment",
	["52"] = "Activision",
	["53"] = "Sammy USA Corporation",
	["54"] = "Konami",
	["55"] = "Hi Tech Expressions",
	["56"] = "LJN",
	["57"] = "Matchbox",
	["58"] = "Mattel",
	["59"] = "Milton Bradley Company",
	["60"] = "Titus Interactive",
	["61"] = "Virgin Games Ltd.",
	["64"] = "Lucasfilm Games",
	["67"] = "Ocean Software",
	["69"] = "Electronic Arts",
	["70"] = "Infogrames",
	["71"] = "Interplay Entertainment",
	["72"] = "Broderbund",
	["73"] = "Sculptured Software",
	["75"] = "The Sales Curve Limited",
	["78"] = "THQ",
	["79"] = "Accolade",
	["80"] = "Misawa Entertainment",
	["83"] = "lozc",
	["86"] = "Tokuma Shoten",
	["87"] = "Tsukuda Original",
	["91"] = "Chunsoft Co.",
	["92"] = "Video System",
	["93"] = "Ocean Software / Acclaim Entertainment",
	["95"] = "Varie",
	["96"] = "Yonezawa's pal",
	["97"] = "Kaneko",
	["99"] = "Pack-In-Video",
	["9H"] = "Bottom Up",
	["A4"] = "Konami",
	["BL"] = "MTO",
	["DK"] = "Kodansha"
}

local licensee_codes = {
	[0x00] = "None",
	[0x01] = "Nintendo",
	[0x08] = "Capcom",
	[0x09] = "HOT-B",
	[0x0A] = "Jaleco",
	[0x0B] = "Coconuts Japan",
	[0x0C] = "Elite Systems",
	[0x13] = "Electronic Arts",
	[0x18] = "Hudson Soft",
	[0x19] = "ITC Entertainment",
	[0x1A] = "Yanoman",
	[0x1D] = "Japan Clary",
	[0x1F] = "Virgin Games Ltd.",
	[0x24] = "PCM Complete",
	[0x25] = "San-X",
	[0x28] = "Kemco",
	[0x29] = "SETA Corporation",
	[0x30] = "Infogrames",
	[0x31] = "Nintendo",
	[0x32] = "Bandai",
	[0x33] = "NEW_LICENSEE_CODE",
	[0x34] = "Konami",
	[0x35] = "HectorSoft",
	[0x38] = "Capcom",
	[0x39] = "Banpresto",
	[0x3C] = "Entertainment Interactive",
	[0x3E] = "Gremlin",
	[0x41] = "Ubi Soft",
	[0x42] = "Atlus",
	[0x44] = "Malibu Interactive",
	[0x46] = "Angel",
	[0x47] = "Spectrum HoloByte",
	[0x49] = "Irem",
	[0x4A] = "Virgin Games Ltd.",
	[0x4D] = "Malibu Interactive",
	[0x4F] = "U.S. Gold",
	[0x50] = "Absolute",
	[0x51] = "Acclaim Entertainment",
	[0x52] = "Activision",
	[0x53] = "Sammy USA Corporation",
	[0x54] = "GameTek",
	[0x55] = "Park Place",
	[0x56] = "LJN",
	[0x57] = "Matchbox",
	[0x59] = "Milton Bradley Company",
	[0x5A] = "Mindscape",
	[0x5B] = "Romstar",
	[0x5C] = "Naxat Soft",
	[0x5D] = "Tradewest",
	[0x60] = "Titus Interactive",
	[0x61] = "Virgin Games Ltd.",
	[0x67] = "Ocean Software",
	[0x69] = "Electronic Arts",
	[0x6E] = "Elite Systems",
	[0x6F] = "Electro Brain",
	[0x70] = "Infogrames",
	[0x71] = "Interplay Entertainment",
	[0x72] = "Broderbund",
	[0x73] = "Sculptured Software",
	[0x75] = "The Sales Curve Limited",
	[0x78] = "THQ",
	[0x79] = "Accolade",
	[0x7A] = "Triffix Entertainment",
	[0x7C] = "MicroProse",
	[0x7F] = "Kemco",
	[0x80] = "Misawa Entertainment",
	[0x83] = "LOZC G.",
	[0x86] = "Tokuma Shoten",
	[0x8B] = "Bullet-Proof Software",
	[0x8C] = "Vic Tokai Corp.",
	[0x8E] = "Ape Inc.",
	[0x8F] = "I'Max",
	[0x91] = "Chunsoft Co.",
	[0x92] = "Video System",
	[0x93] = "Tsubaraya Productions",
	[0x95] = "Varie",
	[0x96] = "Yonezawa's Pal",
	[0x97] = "Kemco",
	[0x99] = "Arc",
	[0x9A] = "Nihon Bussan",
	[0x9B] = "Tecmo",
	[0x9C] = "Imagineer",
	[0x9D] = "Banpresto",
	[0x9F] = "Nova",
	[0xA1] = "Hori Electric",
	[0xA2] = "Bandai",
	[0xA4] = "Konami",
	[0xA6] = "Kawada",
	[0xA7] = "Takara",
	[0xA9] = "Technos Japan",
	[0xAA] = "Broderbund",
	[0xAC] = "Toei Animation",
	[0xAD] = "Toho",
	[0xAF] = "Namco",
	[0xB0] = "Acclaim Entertainment",
	[0xB1] = "ASCII Corporation / Nexsoft",
	[0xB2] = "Bandai",
	[0xB4] = "Square Enix",
	[0xB6] = "HAL Laboratory",
	[0xB7] = "SNK",
	[0xB9] = "Pony Canyon",
	[0xBA] = "Culture Brain",
	[0xBB] = "Sunsoft",
	[0xBD] = "Sony Imagesoft",
	[0xBF] = "Sammy Corporation",
	[0xC0] = "Taito",
	[0xC2] = "Kemco",
	[0xC3] = "Square",
	[0xC4] = "Tokuma Shoten",
	[0xC5] = "Data East",
	[0xC6] = "Tonkin House",
	[0xC8] = "Koei",
	[0xC9] = "UFL",
	[0xCA] = "Ultra Games",
	[0xCB] = "VAP, Inc.",
	[0xCC] = "Use Corporation",
	[0xCD] = "Meldac",
	[0xCE] = "Pony Canyon",
	[0xCF] = "Angel",
	[0xD0] = "Taito",
	[0xD1] = "SOFEL",
	[0xD2] = "Quest",
	[0xD3] = "Sigma Enterprises",
	[0xD4] = "ASK Kodansha Co.",
	[0xD6] = "Naxat Soft",
	[0xD7] = "Copya System",
	[0xD9] = "Banpresto",
	[0xDA] = "Tomy",
	[0xDB] = "LJN",
	[0xDD] = "Nippon Computer Systems",
	[0xDE] = "Human Ent.",
	[0xDF] = "Altron",
	[0xE0] = "Jaleco",
	[0xE1] = "Towa Chiki",
	[0xE2] = "Yutaka",
	[0xE3] = "Varie",
	[0xE5] = "Epoch",
	[0xE7] = "Athena",
	[0xE8] = "Asmik Ace Entertainment",
	[0xE9] = "Natsume",
	[0xEA] = "King Records",
	[0xEB] = "Atlus",
	[0xEC] = "Epic / Sony Records",
	[0xEE] = "IGS",
	[0xF0] = "A Wave",
	[0xF3] = "Extreme Entertainment",
	[0xFF] = "LJN"
}

local cart_types = {
	[0x00] = {["name"] = "ROM", ["has_ram"] = false},
	[0x01] = {["name"] = "MBC1", ["has_ram"] = false},
	[0x02] = {["name"] = "MBC1+RAM", ["has_ram"] = true},
	[0x03] = {["name"] = "MBC1+RAM+BATTERY", ["has_ram"] = true},
	[0x05] = {["name"] = "MBC2", ["has_ram"] = false},
	[0x06] = {["name"] = "MBC2+BATTERY", ["has_ram"] = false},
	[0x08] = {["name"] = "ROM+RAM", ["has_ram"] = true},
	[0x09] = {["name"] = "ROM+RAM+BATTERY", ["has_ram"] = true},
	[0x0B] = {["name"] = "MMM01", ["has_ram"] = false},
	[0x0C] = {["name"] = "MMM01+RAM", ["has_ram"] = true},
	[0x0D] = {["name"] = "MMM01+RAM+BATTERY", ["has_ram"] = true},
	[0x0F] = {["name"] = "MBC3+TIMER+BATTERY", ["has_ram"] = false},
	[0x10] = {["name"] = "MBC3+TIMER+RAM+BATTERY", ["has_ram"] = true},
	[0x11] = {["name"] = "MBC3", ["has_ram"] = false},
	[0x12] = {["name"] = "MBC3+RAM", ["has_ram"] = true},
	[0x13] = {["name"] = "MBC3+RAM+BATTERY", ["has_ram"] = true},
	[0x19] = {["name"] = "MBC5", ["has_ram"] = false},
	[0x1A] = {["name"] = "MBC5+RAM", ["has_ram"] = true},
	[0x1B] = {["name"] = "MBC5+RAM+BATTERY", ["has_ram"] = true},
	[0x1C] = {["name"] = "MBC5+RUMBLE", ["has_ram"] = false},
	[0x1D] = {["name"] = "MBC5+RUMBLE+RAM", ["has_ram"] = true},
	[0x1E] = {["name"] = "MBC5+RUMBLE+RAM+BATTERY", ["has_ram"] = true},
	[0x20] = {["name"] = "MBC6", ["has_ram"] = false},
	[0x22] = {["name"] = "MBC7+SENSOR+RUMBLE+RAM+BATTERY", ["has_ram"] = true},
	[0xFC] = {["name"] = "POCKET CAMERA", ["has_ram"] = false},
	[0xFD] = {["name"] = "BANDAI TAMA5", ["has_ram"] = false},
	[0xFE] = {["name"] = "HuC3", ["has_ram"] = false},
	[0xFF] = {["name"] = "HuC1+RAM+BATTERY", ["has_ram"] = true}
}

local cart_addrs = {
	["entrypoint"]      = {["addr"] = 0x100, ["size"] = 4},  -- Game entrypoint
	["logo"]            = {["addr"] = 0x104, ["size"] = 48}, -- Nintendo logo sprite
	["title"]           = {["addr"] = 0x134, ["size"] = 16}, -- Game title
	["man_code"]        = {["addr"] = 0x13F, ["size"] = 4},  -- Manufacturer code (Optional)
	["cgb_flag"]        = {["addr"] = 0x143, ["size"] = 1},  -- Color Game Boy flag (Optional)
	["new_lic_code"]    = {["addr"] = 0x144, ["size"] = 2},  -- Licensee code (Newer games)
	["sgb_flag"]        = {["addr"] = 0x146, ["size"] = 1},  -- SGB functions flag
	["type"]            = {["addr"] = 0x147, ["size"] = 1},  -- Cartridge type
	["rom_size"]        = {["addr"] = 0x148, ["size"] = 1},  -- ROM size
	["ram_size"]        = {["addr"] = 0x149, ["size"] = 1},  -- RAM size
	["dest_code"]       = {["addr"] = 0x14A, ["size"] = 1},  -- Destination code
	["lic_code"]        = {["addr"] = 0x14B, ["size"] = 1},  -- Licensee code (Older games)
	["version"]         = {["addr"] = 0x14C, ["size"] = 1},  -- Version number
	["hdr_checksum"]    = {["addr"] = 0x14D, ["size"] = 1},  -- Header checksum
	["global_checksum"] = {["addr"] = 0x14E, ["size"] = 2},  -- ROM checksum
}

local ram_sizes = {
	[0] = 0,
	[1] = 2,
	[2] = 8,
	[3] = 32,
	[4] = 128,
	[5] = 64
}

-- Rom state
rom_name = nil
local rom_data = nil
local rom_size = 0
local rom_type = 0
local ram_size = 0
local rom_licensee = nil

function cartridge_load(path)
	-- Loading the ROM on memory
	rom_size = System.statFile(path).size
	local file = System.openFile(path, READ_ONLY)
	local rom_data_str = System.readFile(file, rom_size)
	System.closeFile(file)
	rom_data = {}
	for i = 1, rom_size do
		rom_data[i - 1] = string.byte(string.sub(rom_data_str, i, i + 1))
	end
		
	-- Parsing the header
	rom_name = string.sub(rom_data_str, 1 + cart_addrs.title.addr, 1 + cart_addrs.title.addr + cart_addrs.title.size)
	rom_type = rom_data[cart_addrs.type.addr]
	rom_size = bit.lshift(32, rom_data[cart_addrs.rom_size.addr])
	local licensee_val = rom_data[cart_addrs.lic_code.addr]
	if licensee_val == 0x33 then
		licensee_val = string.sub(rom_data_str, 1 + cart_addrs.new_lic_code.addr, 1 + cart_addrs.new_lic_code.addr + cart_addrs.new_lic_code.size)
		System.consolePrint(tostring(licensee_val))
		rom_licensee = new_licensee_codes[licensee_val]
	else
		rom_licensee = licensee_codes[licensee_val]
	end
	if cart_types[rom_type].has_ram then
		ram_size = ram_sizes[rom_data[cart_addrs.ram_size.addr]]
	end
	
	-- Header checksum check
	local hdr_checksum = rom_data[cart_addrs.hdr_checksum.addr]
	x = 0
	for i = 0x134, 0x14c, 1 do
		x = x - rom_data[i] - 1
	end
	if bit.band(x, 0xFF) == hdr_checksum then
		System.consolePrint("Header checksum passed!")
	else
		System.consolePrint("Header checksum failed!")
	end

	-- Debug logging
	System.consolePrint("Game Title: " .. rom_name)
	System.consolePrint("Type: " .. cart_types[rom_type].name)
	System.consolePrint("ROM Size: " .. rom_size .. " KBs")
	System.consolePrint("RAM Size: " .. ram_size .. " KBs")
	System.consolePrint("Licensed by: " .. rom_licensee)
end

function cartridge_write(addr, val)
end

function cartridge_read(addr)
	return rom_data[addr]
end
