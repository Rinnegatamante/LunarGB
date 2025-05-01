-- Instructions types
local IN = {
	["NOP"] = 0x01,
	["LD"] = 0x02,
	["INC"] = 0x03,
	["DEC"] = 0x04,
	["RLCA"] = 0x05,
	["ADD"] = 0x06,
	["RRCA"] = 0x07,
	["STOP"] = 0x08,
	["RLA"] = 0x09,
	["JR"] = 0x0A,
	["RRA"] = 0x0B,
	["DAA"] = 0x0C,
	["CPL"] = 0x0D,
	["SCF"] = 0x0E,
	["CCF"] = 0x0F,
	["HALT"] = 0x10,
	["ADC"] = 0x11,
	["SUB"] = 0x12,
	["SBC"] = 0x13,
	["AND"] = 0x14,
	["XOR"] = 0x15,
	["OR"] = 0x16,
	["CP"] = 0x17,
	["POP"] = 0x18,
	["JP"] = 0x19,
	["PUSH"] = 0x1A,
	["RET"] = 0x1B,
	["CB"] = 0x1C,
	["CALL"] = 0x1D,
	["RETI"] = 0x1E,
	["LDH"] = 0x1F,
	["JPHL"] = 0x20,
	["DI"] = 0x21,
	["EI"] = 0x22,
	["RST"] = 0x23,
	["ERR"] = 0x24,
	["RLC"] = 0x25,
	["RRC"] = 0x26,
	["RL"] = 0x27,
	["RR"] = 0x28,
	["SLA"] = 0x29,
	["SRA"] = 0x2A,
	["SWAP"] = 0x2B,
	["SRL"] = 0x2C,
	["BIT"] = 0x2D,
	["RES"] = 0x2E,
	["SET"] = 0x2F,
}

-- Address mode types
-- AM_R_D16  = 0x01
-- AM_R_R    = 0x02
-- AM_MR_R   = 0x03
-- AM_R      = 0x04
-- AM_R_D8   = 0x05
-- AM_R_MR   = 0x06
-- AM_R_HLI  = 0x07
-- AM_R_HLD  = 0x08
-- AM_HLI_R  = 0x09
-- AM_HLD_R  = 0x0A
-- AM_R_A8   = 0x0B
-- AM_A8_R   = 0x0C
-- AM_HL_SPR = 0x0D
-- AM_D16    = 0x0E
-- AM_D8     = 0x0F
-- AM_D16_R  = 0x10
-- AM_MR_D8  = 0x11
-- AM_MR     = 0x12
-- AM_A16_R  = 0x13
-- AM_R_A16  = 0x14

-- Register access types
-- RT_A    = 0x01
-- RT_F    = 0x02
-- RT_B    = 0x03
-- RT_C    = 0x04
-- RT_D    = 0x05
-- RT_E    = 0x06
-- RT_H    = 0x07
-- RT_L    = 0x08
-- RT_SP   = 0x09
-- RT_PC   = 0x0A
-- RT_AF   = 0x0B
-- RT_BC   = 0x0C
-- RT_DE   = 0x0D
-- RT_HL   = 0x0E

-- Register names lookup table
local reg_names = {
	[0x01]  = "A",
	[0x02]  = "F",
	[0x03]  = "B",
	[0x04]  = "C",
	[0x05]  = "D",
	[0x06]  = "E",
	[0x07]  = "H",
	[0x08]  = "L",
	[0x09] = "SP",
	[0x0A] = "PC",	
	[0x0B] = "AF",
	[0x0C] = "BC",	
	[0x0D] = "DE",
	[0x0E] = "HL",	
}

-- Localized bit32 funcs
local bxor = bit32.bxor
local band = bit32.band
local bnot = bit32.bnot
local bor = bit32.bor
local lshift = bit32.lshift
local rshift = bit32.rshift

-- Condition types
-- CT_NZ   = 0x01
-- CT_Z    = 0x02
-- CT_NC   = 0x03
-- CT_C    = 0x04

-- Register F flags bitmask
-- FLAG_C = 0x10
-- FLAG_H = 0x20
-- FLAG_N = 0x40
-- FLAG_Z = 0x80

-- Interrupt types
IT_VBLANK    = 0x01
IT_LCD_START = 0x02
IT_TIMER     = 0x04
IT_SERIAL    = 0x08
IT_JOYPAD    = 0x10

-- 0x01
local instrs = {
	[0x00] = {["type"] = IN.NOP},
	[0x01] = {["type"] = IN.LD, ["addr_mode"] = 0x01, ["reg1"] = 0x0C},
	[0x02] = {["type"] = IN.LD, ["addr_mode"] = 0x03, ["reg1"] = 0x0C, ["reg2"] = 0x01},
	[0x03] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x0C},
	[0x04] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x03},
	[0x05] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x03},
	[0x06] = {["type"] = IN.LD, ["addr_mode"] = 0x05, ["reg1"] = 0x03},
	[0x07] = {["type"] = IN.RLCA},
	[0x08] = {["type"] = IN.LD, ["addr_mode"] = 0x13, ["reg2"] = 0x09},
	[0x09] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, ["reg1"] = 0x0E, ["reg2"] = 0x0C},
	[0x0A] = {["type"] = IN.LD, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0C},
	[0x0B] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x0C},
	[0x0C] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x04},
	[0x0D] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x04},
	[0x0E] = {["type"] = IN.LD, ["addr_mode"] = 0x05, ["reg1"] = 0x04},
	[0x0F] = {["type"] = IN.RRCA},
	[0x10] = {["type"] = IN.STOP},
	[0x11] = {["type"] = IN.LD, ["addr_mode"] = 0x01, ["reg1"] = 0x0D},
	[0x12] = {["type"] = IN.LD, ["addr_mode"] = 0x03, ["reg1"] = 0x0D, ["reg2"] = 0x01},
	[0x13] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x0D},
	[0x14] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x05},
	[0x15] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x05},
	[0x16] = {["type"] = IN.LD, ["addr_mode"] = 0x05, ["reg1"] = 0x05},
	[0x17] = {["type"] = IN.RLA},
	[0x18] = {["type"] = IN.JR, ["addr_mode"] = 0x0F},
	[0x19] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, ["reg1"] = 0x0E, ["reg2"] = 0x0D},
	[0x1A] = {["type"] = IN.LD, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0D},
	[0x1B] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x0D},
	[0x1C] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x06},
	[0x1D] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x06},
	[0x1E] = {["type"] = IN.LD, ["addr_mode"] = 0x05, ["reg1"] = 0x06},
	[0x1F] = {["type"] = IN.RRA},
	[0x20] = {["type"] = IN.JR, ["addr_mode"] = 0x0F, ["cnd"] = 0x01},
	[0x21] = {["type"] = IN.LD, ["addr_mode"] = 0x01, ["reg1"] = 0x0E},
	[0x22] = {["type"] = IN.LD, ["addr_mode"] = 0x09, ["reg1"] = 0x0E, ["reg2"] = 0x01},
	[0x23] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x0E},
	[0x24] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x07},
	[0x25] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x07},
	[0x26] = {["type"] = IN.LD, ["addr_mode"] = 0x05, ["reg1"] = 0x07},
	[0x27] = {["type"] = IN.DAA},
	[0x28] = {["type"] = IN.JR, ["addr_mode"] = 0x0F, ["cnd"] = 0x02},
	[0x29] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, ["reg1"] = 0x0E, ["reg2"] = 0x0E},
	[0x2A] = {["type"] = IN.LD, ["addr_mode"] = 0x07, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0x2B] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x0E},
	[0x2C] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x08},
	[0x2D] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x08},
	[0x2E] = {["type"] = IN.LD, ["addr_mode"] = 0x05, ["reg1"] = 0x08},
	[0x2F] = {["type"] = IN.CPL},
	[0x30] = {["type"] = IN.JR, ["addr_mode"] = 0x0F, ["cnd"] = 0x03},
	[0x31] = {["type"] = IN.LD, ["addr_mode"] = 0x01, ["reg1"] = 0x09},
	[0x32] = {["type"] = IN.LD, ["addr_mode"] = 0x0A, ["reg1"] = 0x0E, ["reg2"] = 0x01},
	[0x33] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x09},
	[0x34] = {["type"] = IN.INC, ["addr_mode"] = 0x12, ["reg1"] = 0x0E},
	[0x35] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x0E},
	[0x36] = {["type"] = IN.LD, ["addr_mode"] = 0x11, ["reg1"] = 0x0E},
	[0x37] = {["type"] = IN.SCF},
	[0x38] = {["type"] = IN.JR, ["addr_mode"] = 0x0F, ["cnd"] = 0x04},
	[0x39] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, 0x0E, 0x09},
	[0x3A] = {["type"] = IN.LD, ["addr_mode"] = 0x08, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0x3B] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x09},
	[0x3C] = {["type"] = IN.INC, ["addr_mode"] = 0x04, ["reg1"] = 0x01},
	[0x3D] = {["type"] = IN.DEC, ["addr_mode"] = 0x04, ["reg1"] = 0x01},
	[0x3E] = {["type"] = IN.LD, ["addr_mode"] = 0x05, ["reg1"] = 0x01},
	[0x3F] = {["type"] = IN.CCF},
	[0x40] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x03, ["reg2"] = 0x03},
	[0x41] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x03, ["reg2"] = 0x04},
	[0x42] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x03, ["reg2"] = 0x05},
	[0x43] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x03, ["reg2"] = 0x06},
	[0x44] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x03, ["reg2"] = 0x07},
	[0x45] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x03, ["reg2"] = 0x08},
	[0x46] = {["type"] = IN.LD, ["addr_mode"] = 0x06, ["reg1"] = 0x03, ["reg2"] = 0x0E},
	[0x47] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x03, ["reg2"] = 0x01},
	[0x48] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x04, ["reg2"] = 0x03},
	[0x49] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x04, ["reg2"] = 0x04},
	[0x4A] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x04, ["reg2"] = 0x05},
	[0x4B] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x04, ["reg2"] = 0x06},
	[0x4C] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x04, ["reg2"] = 0x07},
	[0x4D] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x04, ["reg2"] = 0x08},
	[0x4E] = {["type"] = IN.LD, ["addr_mode"] = 0x06, ["reg1"] = 0x04, ["reg2"] = 0x0E},
	[0x4F] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x04, ["reg2"] = 0x01},
	[0x50] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x05, ["reg2"] = 0x03},
	[0x51] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x05, ["reg2"] = 0x04},
	[0x52] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x05, ["reg2"] = 0x05},
	[0x53] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x05, ["reg2"] = 0x06},
	[0x54] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x05, ["reg2"] = 0x07},
	[0x55] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x05, ["reg2"] = 0x08},
	[0x56] = {["type"] = IN.LD, ["addr_mode"] = 0x06, ["reg1"] = 0x05, ["reg2"] = 0x0E},
	[0x57] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x05, ["reg2"] = 0x01},
	[0x58] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x06, ["reg2"] = 0x03},
	[0x59] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x06, ["reg2"] = 0x04},
	[0x5A] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x06, ["reg2"] = 0x05},
	[0x5B] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x06, ["reg2"] = 0x06},
	[0x5C] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x06, ["reg2"] = 0x07},
	[0x5D] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x06, ["reg2"] = 0x08},
	[0x5E] = {["type"] = IN.LD, ["addr_mode"] = 0x06, ["reg1"] = 0x06, ["reg2"] = 0x0E},
	[0x5F] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x06, ["reg2"] = 0x01},
	[0x60] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x07, ["reg2"] = 0x03},
	[0x61] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x07, ["reg2"] = 0x04},
	[0x62] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x07, ["reg2"] = 0x05},
	[0x63] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x07, ["reg2"] = 0x06},
	[0x64] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x07, ["reg2"] = 0x07},
	[0x65] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x07, ["reg2"] = 0x08},
	[0x66] = {["type"] = IN.LD, ["addr_mode"] = 0x06, ["reg1"] = 0x07, ["reg2"] = 0x0E},
	[0x67] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x07, ["reg2"] = 0x01},
	[0x68] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x08, ["reg2"] = 0x03},
	[0x69] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x08, ["reg2"] = 0x04},
	[0x6A] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x08, ["reg2"] = 0x05},
	[0x6B] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x08, ["reg2"] = 0x06},
	[0x6C] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x08, ["reg2"] = 0x07},
	[0x6D] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x08, ["reg2"] = 0x08},
	[0x6E] = {["type"] = IN.LD, ["addr_mode"] = 0x06, ["reg1"] = 0x08, ["reg2"] = 0x0E},
	[0x6F] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x08, ["reg2"] = 0x01},
	[0x70] = {["type"] = IN.LD, ["addr_mode"] = 0x03, ["reg1"] = 0x0E, ["reg2"] = 0x03},
	[0x71] = {["type"] = IN.LD, ["addr_mode"] = 0x03, ["reg1"] = 0x0E, ["reg2"] = 0x04},
	[0x72] = {["type"] = IN.LD, ["addr_mode"] = 0x03, ["reg1"] = 0x0E, ["reg2"] = 0x05},
	[0x73] = {["type"] = IN.LD, ["addr_mode"] = 0x03, ["reg1"] = 0x0E, ["reg2"] = 0x06},
	[0x74] = {["type"] = IN.LD, ["addr_mode"] = 0x03, ["reg1"] = 0x0E, ["reg2"] = 0x07},
	[0x75] = {["type"] = IN.LD, ["addr_mode"] = 0x03, ["reg1"] = 0x0E, ["reg2"] = 0x08},
	[0x76] = {["type"] = IN.HALT},
	[0x77] = {["type"] = IN.LD, ["addr_mode"] = 0x03, ["reg1"] = 0x0E, ["reg2"] = 0x01},
	[0x78] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x03},
	[0x79] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x04},
	[0x7A] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x05},
	[0x7B] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x06},
	[0x7C] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x07},
	[0x7D] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x08},
	[0x7E] = {["type"] = IN.LD, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0x7F] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x01},
	[0x80] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x03},
	[0x81] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x04},
	[0x82] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x05},
	[0x83] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x06},
	[0x84] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x07},
	[0x85] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x08},
	[0x86] = {["type"] = IN.ADD, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0x87] = {["type"] = IN.ADD, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x01},
	[0x88] = {["type"] = IN.ADC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x03},
	[0x89] = {["type"] = IN.ADC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x04},
	[0x8A] = {["type"] = IN.ADC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x05},
	[0x8B] = {["type"] = IN.ADC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x06},
	[0x8C] = {["type"] = IN.ADC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x07},
	[0x8D] = {["type"] = IN.ADC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x08},
	[0x8E] = {["type"] = IN.ADC, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0x8F] = {["type"] = IN.ADC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x01},
	[0x90] = {["type"] = IN.SUB, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x03},
	[0x91] = {["type"] = IN.SUB, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x04},
	[0x92] = {["type"] = IN.SUB, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x05},
	[0x93] = {["type"] = IN.SUB, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x06},
	[0x94] = {["type"] = IN.SUB, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x07},
	[0x95] = {["type"] = IN.SUB, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x08},
	[0x96] = {["type"] = IN.SUB, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0x97] = {["type"] = IN.SUB, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x01},
	[0x98] = {["type"] = IN.SBC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x03},
	[0x99] = {["type"] = IN.SBC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x04},
	[0x9A] = {["type"] = IN.SBC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x05},
	[0x9B] = {["type"] = IN.SBC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x06},
	[0x9C] = {["type"] = IN.SBC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x07},
	[0x9D] = {["type"] = IN.SBC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x08},
	[0x9E] = {["type"] = IN.SBC, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0x9F] = {["type"] = IN.SBC, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x01},
	[0xA0] = {["type"] = IN.AND, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x03},
	[0xA1] = {["type"] = IN.AND, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x04},
	[0xA2] = {["type"] = IN.AND, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x05},
	[0xA3] = {["type"] = IN.AND, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x06},
	[0xA4] = {["type"] = IN.AND, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x07},
	[0xA5] = {["type"] = IN.AND, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x08},
	[0xA6] = {["type"] = IN.AND, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0xA7] = {["type"] = IN.AND, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x01},
	[0xA8] = {["type"] = IN.XOR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x03},
	[0xA9] = {["type"] = IN.XOR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x04},
	[0xAA] = {["type"] = IN.XOR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x05},
	[0xAB] = {["type"] = IN.XOR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x06},
	[0xAC] = {["type"] = IN.XOR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x07},
	[0xAD] = {["type"] = IN.XOR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x08},
	[0xAE] = {["type"] = IN.XOR, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0xAF] = {["type"] = IN.XOR, ["addr_mode"] = 0x04, ["reg1"] = 0x01},
	[0xB0] = {["type"] = IN.OR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x03},
	[0xB1] = {["type"] = IN.OR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x04},
	[0xB2] = {["type"] = IN.OR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x05},
	[0xB3] = {["type"] = IN.OR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x06},
	[0xB4] = {["type"] = IN.OR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x07},
	[0xB5] = {["type"] = IN.OR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x08},
	[0xB6] = {["type"] = IN.OR, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0xB7] = {["type"] = IN.OR, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x01},
	[0xB8] = {["type"] = IN.CP, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x03},
	[0xB9] = {["type"] = IN.CP, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x04},
	[0xBA] = {["type"] = IN.CP, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x05},
	[0xBB] = {["type"] = IN.CP, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x06},
	[0xBC] = {["type"] = IN.CP, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x07},
	[0xBD] = {["type"] = IN.CP, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x08},
	[0xBE] = {["type"] = IN.CP, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x0E},
	[0xBF] = {["type"] = IN.CP, ["addr_mode"] = 0x02, ["reg1"] = 0x01, ["reg2"] = 0x01},
	[0xC0] = {["type"] = IN.RET, ["cnd"] = 0x01},
	[0xC1] = {["type"] = IN.POP, ["addr_mode"] = 0x04, ["reg1"] = 0x0C},
	[0xC2] = {["type"] = IN.JP, ["addr_mode"] = 0x0E, ["cnd"] = 0x01},
	[0xC3] = {["type"] = IN.JP, ["addr_mode"] = 0x0E},
	[0xC4] = {["type"] = IN.CALL, ["addr_mode"] = 0x0E},
	[0xC5] = {["type"] = IN.PUSH, ["addr_mode"] = 0x04, ["reg1"] = 0x0C},
	[0xC6] = {["type"] = IN.ADD, ["addr_mode"] = 0x05, ["reg1"] = 0x01},
	[0xC7] = {["type"] = IN.RST, ["param"] = 0x00},
	[0xC8] = {["type"] = IN.RET, ["cnd"] = 0x02},
	[0xC9] = {["type"] = IN.RET},
	[0xCA] = {["type"] = IN.JP, ["addr_mode"] = 0x0E, ["cnd"] = 0x02},
	[0xCB] = {["type"] = IN.CB, ["addr_mode"] = 0x0F},
	[0xCC] = {["type"] = IN.CALL, ["addr_mode"] = 0x0E, ["cnd"] = 0x02},
	[0xCD] = {["type"] = IN.CALL, ["addr_mode"] = 0x0E},
	[0xCE] = {["type"] = IN.ADC, ["addr_mode"] = 0x05, ["reg1"] = 0x01},
	[0xCF] = {["type"] = IN.RST, ["param"] = 0x08},
	[0xD0] = {["type"] = IN.RET, 0x03},
	[0xD1] = {["type"] = IN.POP, ["addr_mode"] = 0x04, ["reg1"] = 0x0D},
	[0xD2] = {["type"] = IN.JP, ["addr_mode"] = 0x0E, ["cnd"] = 0x03},
	[0xD4] = {["type"] = IN.CALL, ["addr_mode"] = 0x0E, ["cnd"] = 0x03},
	[0xD5] = {["type"] = IN.PUSH, ["addr_mode"] = 0x04, ["reg1"] = 0x0D},
	[0xD6] = {["type"] = IN.SUB, ["addr_mode"] = 0x05, ["reg1"] = 0x01},
	[0xD7] = {["type"] = IN.RST, ["param"] = 0x10},
	[0xD8] = {["type"] = IN.RET, ["cnd"] = 0x04},
	[0xD9] = {["type"] = IN.RETI},
	[0xDA] = {["type"] = IN.JP, ["addr_mode"] = 0x0E, ["cnd"] = 0x04},
	[0xDC] = {["type"] = IN.CALL, ["addr_mode"] = 0x0E, ["cnd"] = 0x04},
	[0xDE] = {["type"] = IN.SBC, ["addr_mode"] = 0x05, ["reg1"] = 0x01},
	[0xDF] = {["type"] = IN.RST, ["param"] = 0x18},
	[0xE0] = {["type"] = IN.LDH, ["addr_mode"] = 0x0C, ["reg2"] = 0x01},
	[0xE1] = {["type"] = IN.POP, ["addr_mode"] = 0x04, ["reg1"] = 0x0E},
	[0xE2] = {["type"] = IN.LD, ["addr_mode"] = 0x03, ["reg1"] = 0x04, ["reg2"] = 0x01},
	[0xE5] = {["type"] = IN.PUSH, ["addr_mode"] = 0x04, ["reg1"] = 0x0E},
	[0xE6] = {["type"] = IN.AND, ["addr_mode"] = 0x05, ["reg1"] = 0x01},
	[0xE7] = {["type"] = IN.RST, ["param"] = 0x20},
	[0xE8] = {["type"] = IN.ADD, ["addr_mode"] = 0x05, ["reg1"] = 0x09},
	[0xE9] = {["type"] = IN.JP, ["addr_mode"] = 0x04, ["reg1"] = 0x0E},
	[0xEA] = {["type"] = IN.LD, ["addr_mode"] = 0x13, ["reg2"] = 0x01},
	[0xEE] = {["type"] = IN.XOR, ["addr_mode"] = 0x05, ["reg1"] = 0x01},
	[0xEF] = {["type"] = IN.RST, ["param"] = 0x28},
	[0xF0] = {["type"] = IN.LDH, ["addr_mode"] = 0x0B, ["reg1"] = 0x01},
	[0xF1] = {["type"] = IN.POP, ["addr_mode"] = 0x04, ["reg1"] = 0x0B},
	[0xF2] = {["type"] = IN.LD, ["addr_mode"] = 0x06, ["reg1"] = 0x01, ["reg2"] = 0x04},
	[0xF3] = {["type"] = IN.DI},
	[0xF5] = {["type"] = IN.PUSH, ["addr_mode"] = 0x04, ["reg1"] = 0x0B},
	[0xF6] = {["type"] = IN.OR, ["addr_mode"] = 0x05, ["reg1"] = 0x01},
	[0xF7] = {["type"] = IN.RST, ["param"] = 0x30},
	[0xF8] = {["type"] = IN.LD, ["addr_mode"] = 0x0D, ["reg1"] = 0x0E, ["reg2"] = 0x09},
	[0xF9] = {["type"] = IN.LD, ["addr_mode"] = 0x02, ["reg1"] = 0x09, ["reg2"] = 0x0E},
	[0xFA] = {["type"] = IN.LD, ["addr_mode"] = 0x14, ["reg1"] = 0x01},
	[0xFB] = {["type"] = IN.EI},
	[0xFE] = {["type"] = IN.CP, ["addr_mode"] = 0x05, ["reg1"] = 0x01},
	[0xFF] = {["type"] = IN.RST, ["param"] = 0x38}
}

-- CPU state
local A = 0
local F = 0
local B = 0
local C = 0
local D = 0
local E = 0
local H = 0
local L = 0
local PC = 0
local SP = 0
local IE = 0
local cpu_instr = nil
local cpu_fetched_data = 0
local cpu_mem_dest = 0
local cpu_opcode = 0
local cpu_use_mem_dest = false
local cpu_interrupts = 0
local cpu_halted = true
local cpu_master_interrupts = true
local cpu_enable_interrupts = false

-- Stack functions
local function stack_push(val)
	SP = SP - 1
	bus_write(SP, val)
end
local function stack_push16(val)
	stack_push(rshift(val, 8) % 0x100)
	stack_push(val % 0x100)
end
local function stack_pop()
	local ret = bus_read(SP)
	SP = SP + 1
	return ret
end
local function stack_pop16()
	local low = stack_pop()
	local high = stack_pop()
	return bor(lshift(high, 8), low)
end

-- CPU initialization
function cpu_init()
	PC = 0x100 -- Entrypoint is fixed to 0x100
	A = 0x01
	B = 0x00
	C = 0x13
	D = 0x00
	E = 0xD8
	F = 0xB0
	H = 0x01
	L = 0x4D
	SP = 0xFFFE
	IE = 0x00
	cpu_fetched_data = 0
	cpu_mem_dest = 0
	cpu_use_mem_dest = false
	cpu_master_interrupts = false
	cpu_interrupts = 0
	cpu_enable_interrupts = false
	cpu_halted = false
end

-- Registers reading functions
local function cpu_read_reg(reg)
	local r = reg
	if r == 0x01 then
		return A
	elseif r == 0x02 then
		return F
	elseif r == 0x03 then
		return B
	elseif r == 0x04 then
		return C
	elseif r == 0x05 then
		return D
	elseif r == 0x06 then
		return E
	elseif r == 0x07 then
		return H
	elseif r == 0x08 then
		return L
	elseif r == 0x09 then
		return SP
	elseif r == 0x0A then
		return PC
	elseif r == 0x0B then
		return bor(F, lshift(A, 8))
	elseif r == 0x0C then
		return bor(C, lshift(B, 8))
	elseif r == 0x0D then
		return bor(E, lshift(D, 8))
	elseif r == 0x0E then
		return bor(L, lshift(H, 8))
	end
end
function cpu_read_ie_reg()
	return IE
end

-- Registers writing functions
local function cpu_write_reg(reg, val)
	local r = reg
	if r == 0x01 then
		A = val % 0x100
	elseif r == 0x02 then
		F = val % 0x100
	elseif r == 0x03 then
		B = val % 0x100
	elseif r == 0x04 then
		C = val % 0x100
	elseif r == 0x05 then
		D = val % 0x100
	elseif r == 0x06 then
		E = val % 0x100
	elseif r == 0x07 then
		H = val % 0x100
	elseif r == 0x08 then
		L = val % 0x100
	elseif r == 0x09 then
		SP = val % 0x10000
	elseif r == 0x0A then
		PC = val % 0x10000
	elseif r == 0x0B then
		F = val % 0x100
		A = rshift(val, 8) % 0x100
	elseif r == 0x0C then
		C = val % 0x100
		B = rshift(val, 8) % 0x100
	elseif r == 0x0D then
		E = val % 0x100
		D = rshift(val, 8) % 0x100
	elseif r == 0x0E then
		L = val % 0x100
		H = rshift(val, 8) % 0x100
	end
end
function cpu_write_ie_reg(val)
	IE = val
end

-- Condition checking functions
local function cpu_check_cond()
	if cpu_instr.cnd == 0x04 then
		return band(F, 0x10) == 0x10
	elseif cpu_instr.cnd == 0x03 then
		return band(F, 0x10) == 0
	elseif cpu_instr.cnd == 0x02 then
		return band(F, 0x80) == 0x80
	elseif cpu_instr.cnd == 0x01 then
		return band(F, 0x80) == 0
	end
	
	return true
end

-- Goto function
local function cpu_goto(addr, push_pc)
	if cpu_check_cond() then
		if push_pc then
			emu_incr_cycles(2)
			stack_push16(PC)
		end
		
		PC = addr
		emu_incr_cycles(1)
	end
end

-- Registers lookup table
local rt_lookup = {
	[0x00] = 0x03,
	[0x01] = 0x04,
	[0x02] = 0x05,
	[0x03] = 0x06,
	[0x04] = 0x07,
	[0x05] = 0x08,
	[0x06] = 0x0E,
	[0x07] = 0x01,	
}

-- CPU flags setter function
local function cpu_set_flags(z, n, h, c)
	if z == 1 then
		F = bor(F, 0x80)
	elseif z == 0 then
		F = band(F, bnot(0x80))
	end
	if n == 1 then
		F = bor(F, 0x40)
	elseif n == 0 then
		F = band(F, bnot(0x40))
	end
	if h == 1 then
		F = bor(F, 0x20)
	elseif h == 0 then
		F = band(F, bnot(0x20))
	end
	if c == 1 then
		F = bor(F, 0x10)
	elseif c == 0 then
		F = band(F, bnot(0x10))
	end
end

-- CPU instr execution functions
local function cpu_exec_instr()
	local instr = cpu_instr.type
	if instr == IN.NOP then
	elseif instr == IN.LD then
		if cpu_use_mem_dest then
			if cpu_instr.reg2 and cpu_instr.reg2 >= 0x09 then
				emu_incr_cycles(1)
				bus_write16(cpu_mem_dest, cpu_fetched_data)
			else
				bus_write(cpu_mem_dest, cpu_fetched_data)
			end
			emu_incr_cycles(1)
		elseif cpu_instr.addr_mode == 0x0D then
			local r2 = cpu_read_reg(cpu_instr.reg2)
			cpu_set_flags(0, 0, (((r2 % 0x10) + (cpu_fetched_data % 0x10)) >= 0x10) and 1 or 0, (((r2 % 0x100) + (cpu_fetched_data % 0x100)) >= 0x100) and 1 or 0)
			if cpu_fetched_data > 0x7F then
				cpu_write_reg(cpu_instr.reg1, r2 + (cpu_fetched_data - 0x100))
			else
				cpu_write_reg(cpu_instr.reg1, r2 + cpu_fetched_data)
			end
		else
			cpu_write_reg(cpu_instr.reg1, cpu_fetched_data)
		end
	elseif instr == IN.LDH then
		if cpu_instr.reg1 == 0x01 then
			cpu_write_reg(cpu_instr.reg1, bus_read(bor(0xFF00, cpu_fetched_data)))
		else
			bus_write(bor(0xFF00, cpu_fetched_data), A)
		end
		emu_incr_cycles(1)
	elseif instr == IN.DI then
		cpu_master_interrupts = false
	elseif instr == IN.EI then
		cpu_enable_interrupts = true
	elseif instr == IN.XOR then
		A = bxor(A, cpu_fetched_data % 0x100)
		cpu_set_flags((A == 0) and 1 or 0, 0, 0, 0)
	elseif instr == IN.POP then
		local low = stack_pop()
		emu_incr_cycles(1)
		local high = stack_pop()
		emu_incr_cycles(1)
	
		local val = bor(lshift(high, 8), low)

		if cpu_instr.reg1 == 0x0B then
			cpu_write_reg(cpu_instr.reg1, band(val, 0xFFF0))
		else
			cpu_write_reg(cpu_instr.reg1, val)
		end
	elseif instr == IN.PUSH then
		local high = rshift(cpu_read_reg(cpu_instr.reg1), 8) % 0x100
		emu_incr_cycles(1)
		stack_push(high)
		local low = cpu_read_reg(cpu_instr.reg1) % 0x100
		emu_incr_cycles(1)
		stack_push(low)
		emu_incr_cycles(1)
	elseif instr == IN.CALL then
		cpu_goto(cpu_fetched_data, true)
	elseif instr == IN.JP then
		cpu_goto(cpu_fetched_data, false)
	elseif instr == IN.JR then
		local rel = cpu_fetched_data % 0x100
		if rel > 0x7F then
			rel = rel - 0x100
		end
		local addr = PC + rel
		cpu_goto(addr, false)
	elseif instr == IN.RST then
		cpu_goto(cpu_instr.param, true)
	elseif instr == IN.RET then
		if cpu_instr.cnd then
			emu_incr_cycles(1)
		end
		if cpu_check_cond() then
			local low = stack_pop()
			emu_incr_cycles(1)
			local high = stack_pop()
			emu_incr_cycles(1)
	
			local val = bor(lshift(high, 8), low)
			PC = val
			emu_incr_cycles(1)
		end
	elseif instr == IN.RETI then
		cpu_master_interrupts = true
		if cpu_instr.cnd then
			emu_incr_cycles(1)
		end
		if cpu_check_cond() then
			local low = stack_pop()
			emu_incr_cycles(1)
			local high = stack_pop()
			emu_incr_cycles(1)
	
			local val = bor(lshift(high, 8), low)
			PC = val
			emu_incr_cycles(1)
		end
	elseif instr == IN.INC then
		local val
		if cpu_instr.reg1 >= 0x09 then
			emu_incr_cycles(1)
		end
	
		if cpu_instr.reg1 == 0x0E and cpu_instr.addr_mode == 0x12 then
			local hl = cpu_read_reg(0x0E)
			val = (bus_read(hl) + 1) % 0x100
			bus_write(hl, val)
		else
			val = cpu_read_reg(cpu_instr.reg1) + 1
			cpu_write_reg(cpu_instr.reg1, val)
			val = cpu_read_reg(cpu_instr.reg1)
		end
	
		if (cpu_opcode % 0x04) ~= 0x03 then
			cpu_set_flags((val == 0) and 1 or 0, 0, ((val % 0x10) == 0x00) and 1 or 0, -1)
		end
	elseif instr == IN.DEC then
		local val
		if cpu_instr.reg1 >= 0x09 then
			emu_incr_cycles(1)
		end
	
		if cpu_instr.reg1 == 0x0E and cpu_instr.addr_mode == 0x12 then
			local hl = cpu_read_reg(0x0E)
			val = bus_read(hl) - 1
			if val < 0 then
				val = 0x10000 + val
			end
			bus_write(hl, val)
		else
			val = cpu_read_reg(cpu_instr.reg1) - 1
			if cpu_instr.reg1 >= 0x09 then
				if val < 0 then
					val = 0x10000 + val
				end
			else
				if val < 0 then
					val = 0x100 + val
				end
			end
			cpu_write_reg(cpu_instr.reg1, val)
		end
		if band(cpu_opcode, 0x0B) ~= 0x0B then
			cpu_set_flags((val == 0) and 1 or 0, 1, ((val % 0x10) == 0x0F) and 1 or 0, -1)
		end
	elseif instr == IN.ADD then
		local val
		if cpu_instr.reg1 >= 0x09 then
			emu_incr_cycles(1)
		end
		local r1 = cpu_read_reg(cpu_instr.reg1)
		if cpu_instr.reg1 == 0x09 then
			if cpu_fetched_data > 0x7F then
				val = r1 + (cpu_fetched_data - 0x100)
			else
				val = r1 + cpu_fetched_data
			end
		else
			val = r1 + cpu_fetched_data
		end
		local z
		local h
		local c
		if cpu_instr.reg1 >= 0x09 then
			z = -1
			h = (((r1 % 0x1000) + (cpu_fetched_data % 0x1000)) >= 0x1000) and 1 or 0
			c = ((r1 + cpu_fetched_data) >= 0x10000) and 1 or 0		
		elseif cpu_instr.reg1 == 0x09 then
			z = 0
			h = (((r1 % 0x10) + (cpu_fetched_data % 0x10)) >= 0x10) and 1 or 0
			c = (((r1 % 0x100) + (cpu_fetched_data % 0x100)) >= 0x100) and 1 or 0
		else
			z = ((val % 0x100) == 0) and 1 or 0
			h = (((r1 % 0x10) + (cpu_fetched_data % 0x10)) >= 0x10) and 1 or 0
			c = (((r1 % 0x100) + (cpu_fetched_data % 0x100)) >= 0x100) and 1 or 0
		end
		cpu_write_reg(cpu_instr.reg1, val % 0x10000)
		cpu_set_flags(z, 0, h, c)
	elseif instr == IN.SUB then
		local r1 = cpu_read_reg(cpu_instr.reg1)
		local val = (r1 - cpu_fetched_data) % 0x10000
		local z = (val == 0) and 1 or 0
		local h = ((cpu_read_reg(cpu_instr.reg1) - cpu_fetched_data) == 0) and 1 or 0
		local c = ((cpu_read_reg(cpu_instr.reg1) - cpu_fetched_data) == 0) and 1 or 0
		cpu_write_reg(cpu_instr.reg1, val)
		cpu_set_flags(z, 1, h, c)
	elseif instr == IN.ADC then
		local c = band(F, 0x10)
		A = (A + cpu_fetched_data + c) % 0x100
		cpu_set_flags((A == 0) and 1 or 0, 0, (((A % 0x10) + (cpu_fetched_data % 0x10) + c) > 0x0F) and 1 or 0, (A + cpu_fetched_data + c > 0xFF) and 1 or 0)
	elseif instr == IN.SBC then
		local _c = band(F, 0x10)
		local val = cpu_fetched_data + _c
		local r1 = cpu_read_reg(cpu_instr.reg1)
		local z = ((r1 - val) == 0) and 1 or 0
		local h = (((r1 % 0x10) - (cpu_fetched_data % 0x10) - _c) < 0) and 1 or 0
		local c = ((r1 - cpu_fetched_data - _c) < 0) and 1 or 0
		cpu_write_reg(cpu_instr.reg1, r1 - val)
		cpu_set_flags(z, 1, h, c)
	elseif instr == IN.OR then
		A = bor(A, cpu_fetched_data % 0x100)
		cpu_set_flags((A == 0) and 1 or 0, 0, 0, 0)
	elseif instr == IN.CP then
		local val = A - cpu_fetched_data
		local val2 = (A % 0x10) - (cpu_fetched_data % 0x10)
		cpu_set_flags((val == 0) and 1 or 0, 1, (val2 < 0) and 1 or 0, (val < 0) and 1 or 0);
	elseif instr == IN.CB then
		local op = cpu_fetched_data
		local reg = rt_lookup[op % 0x08]
		local bit = rshift(op, 3) % 0x08
		local bit_op = rshift(op, 6) % 0x08
		local reg_val = cpu_read_reg(reg)
		emu_incr_cycles(1)
		if reg == 0x0E then
			emu_incr_cycles(2)
		end
		if bit_op == 1 then -- BIT
			cpu_set_flags((band(reg_val, lshift(1, bit)) == 0) and 1 or 0, 0, 1, -1)
		elseif bit_op == 2 then -- RST
			reg_val = band(reg_val, bnot(lshift(1, bit)))
			if reg == 0x0E then
				bus_write(cpu_read_reg(0x0E), reg_val)
			else
				cpu_write_reg(reg, reg_val % 0x100)
			end
		elseif bit_op == 3 then -- SET
			reg_val = bor(reg_val, lshift(1, bit))
			if reg == 0x0E then
				bus_write(cpu_read_reg(0x0E), reg_val)
			else
				cpu_write_reg(reg, reg_val % 0x100)
			end
		elseif bit == 0 then -- RLC
			local c = 0
			local res = lshift(reg_val, 1) % 0x100
			if band(reg_val, 0x80) == 0x80 then
				res = bor(res, 0x01)
				c = 1
			end
			if reg == 0x0E then
				bus_write(cpu_read_reg(0x0E), res)
			else
				cpu_write_reg(reg, res % 0x100)
			end
			cpu_set_flags((res == 0) and 1 or 0, 0, 0, c)
		elseif bit == 1 then -- RRC
			local old = reg_val
			reg_val = bor(rshift(reg_val, 1), lshift(old, 7))
			if reg == 0x0E then
				bus_write(cpu_read_reg(0x0E), reg_val)
			else
				cpu_write_reg(reg, reg_val % 0x100)
			end
			cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 1) and 1 or 0)
		elseif bit == 2 then -- RL
			local old = reg_val
			reg_val = bor(lshift(reg_val, 1), (band(F, 0x10) == 0x10) and 1 or 0)
			if reg == 0x0E then
				bus_write(cpu_read_reg(0x0E), reg_val)
			else
				cpu_write_reg(reg, reg_val % 0x100)
			end
			cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 0x80) and 1 or 0)
		elseif bit == 3 then -- RR
			local old = reg_val
			reg_val = bor(rshift(reg_val, 1), lshift((band(F, 0x10) == 0x10) and 1 or 0, 7))
			if reg == 0x0E then
				bus_write(cpu_read_reg(0x0E), reg_val)
			else
				cpu_write_reg(reg, reg_val % 0x100)
			end
			cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 1) and 1 or 0)
		elseif bit == 4 then -- SLA
			local old = reg_val
			reg_val = rshift(reg_val, 1)
			if reg == 0x0E then
				bus_write(cpu_read_reg(0x0E), reg_val)
			else
				cpu_write_reg(reg, reg_val % 0x100)
			end
			cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 0x80) and 1 or 0)
		elseif bit == 5 then -- SRA
			local old = reg_val
			reg_val = bor(rshift(reg_val, 1), band(reg_val, 0x80))
			if reg == 0x0E then
				bus_write(cpu_read_reg(0x0E), reg_val)
			else
				cpu_write_reg(reg, reg_val % 0x100)
			end
			cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 1) and 1 or 0)
		elseif bit == 6 then -- SWAP
			reg_val = bor(rshift(band(reg_val, 0xF0), 4), lshift(reg_val % 0x10, 4))
			if reg == 0x0E then
				bus_write(cpu_read_reg(0x0E), reg_val)
			else
				cpu_write_reg(reg, reg_val % 0x100)
			end
			cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, 0)
		elseif bit == 7 then -- SRL
			local old = reg_val
			reg_val = rshift(reg_val, 1)
			if reg == 0x0E then
				bus_write(cpu_read_reg(0x0E), reg_val)
			else
				cpu_write_reg(reg, reg_val % 0x100)
			end
			cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 1) and 1 or 0)
		end
	elseif instr == IN.AND then
		A = band(A, cpu_fetched_data % 0x100)
		cpu_set_flags((A == 0) and 1 or 0, 0, 1, 0)
	elseif instr == IN.RLCA then
		local c = band(rshift(A, 7), 1)
		A = bor(lshift(A, 1), c)
		cpu_set_flags(0, 0, 0, c)
	elseif instr == IN.RRCA then
		local c = band(A, 1)
		A = bor(rshift(A, 1), lshift(c, 7))
		cpu_set_flags(0, 0, 0, c)
	elseif instr == IN.RLA then
		local c = band(rshift(A, 7), 1)
		A = bor(lshift(A, 1), (band(F, 0x10) == 0x10) and 1 or 0)
		cpu_set_flags(0, 0, 0, c)
	elseif instr == IN.RRA then
		local c = band(A, 1)
		A = bor(rshift(A, 1), rshift((band(F, 0x10) == 0x10) and 1 or 0, 7))
		cpu_set_flags(0, 0, 0, c)
	elseif instr == IN.STOP then
		System.consolePrint("IN_STOP: NOIMPL")
	elseif instr == IN.DAA then
		local u = 0
		local fc = 0
		local has_h = band(F, 0x20) == 0x20
		local has_n = band(F, 0x40) == 0x40
		local has_c = band(F, 0x10) == 0x10
		if has_h or (band(A, 0x0F) > 9 and not has_n) then
			u = 6
		end
		if has_c or (A > 0x99 and not has_n) then
			u = bor(u, 0x60)
			fc = 1
		end
		if has_n then
			A = (A - u) % 0x100
		else
			A = (A + u) % 0x100
		end
		cpu_set_flags((A == 0) and 1 or 0, -1, 0, fc)
	elseif instr == IN.CPL then
		A = bnot(A)
		cpu_set_flags(-1, 1, 1, -1)
	elseif instr == IN.SCF then
		cpu_set_flags(-1, 0, 0, 1)
	elseif instr == IN.CCF then
		cpu_set_flags(-1, 0, 0, bxor((band(F, 0x10) == 0x10) and 1 or 0, 1))
	elseif instr == IN.HALT then
		cpu_halted = true
	end
end

-- Instructions logging function
local cpu_name_funcs = {
	[IN.NOP] = "NOP",
	[IN.LD] = "LD",
	[IN.LDH] = "LDH",
	[IN.JP] = "JP",
	[IN.DI] = "DI",
	[IN.EI] = "EI",
	[IN.XOR] = "XOR",
	[IN.POP] = "POP",
	[IN.PUSH] = "PUSH",
	[IN.CALL] = "CALL",
	[IN.JP] = "JP",
	[IN.JR] = "JR",
	[IN.RST] = "RST",
	[IN.RET] = "RET",
	[IN.RETI] = "RETI",
	[IN.INC] = "INC",
	[IN.DEC] = "DEC",
	[IN.ADD] = "ADD",
	[IN.SUB] = "SUB",
	[IN.ADC] = "ADC",
	[IN.SBC] = "SBC",
	[IN.OR] = "OR",
	[IN.CP] = "CP",
	[IN.CB] = "CB",
	[IN.AND] = "AND",
	[IN.RLCA] = "RLCA",
	[IN.RRCA] = "RRCA",
	[IN.RLA] = "RLA",
	[IN.RRA] = "RRA",
	[IN.STOP] = "STOP",
	[IN.DAA] = "DAA",
	[IN.CPL] = "CPL",
	[IN.SCF] = "SCF",
	[IN.CCF] = "CCF",
	[IN.HALT] = "HALT",
}
local function cpu_stringify_instr()
	local addr_mode = cpu_instr.addr_mode
	if addr_mode then
		if addr_mode == 0x04 then
			return string.format("%s %s", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1])
		elseif addr_mode == 0x02 then
			return string.format("%s %s,%s", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
		elseif addr_mode == 0x0D then
			return string.format("%s (%s),SP+%d", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], cpu_fetched_data % 0x100)
		elseif addr_mode == 0x0F then
			return string.format("%s 0x%02X", cpu_name_funcs[cpu_instr.type], cpu_fetched_data % 0x100)
		elseif addr_mode == 0x0B or addr_mode == 0x05 then
			return string.format("%s %s,0x%02X", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], cpu_fetched_data % 0x100)
		elseif addr_mode == 0x0E then
			return string.format("%s 0x%04X", cpu_name_funcs[cpu_instr.type], cpu_fetched_data)
		elseif addr_mode == 0x01 or addr_mode == 0x14 then
			return string.format("%s %s,0x%04X", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], cpu_fetched_data)
		elseif addr_mode == 0x03 then
			return string.format("%s (%s),%s", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
		elseif addr_mode == 0x06 then
			return string.format("%s %s,(%s)", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
		elseif addr_mode == 0x07 then
			return string.format("%s %s,(%s+)", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
		elseif addr_mode == 0x08 then
			return string.format("%s %s,(%s-)", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
		elseif addr_mode == 0x09 then
			return string.format("%s (%s+),%s", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
		elseif addr_mode == 0x0A then
			return string.format("%s (%s-),%s", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
		elseif addr_mode == 0x0C then
			return string.format("%s 0x%02X,%s", cpu_name_funcs[cpu_instr.type], bus_read(PC - 1), reg_names[cpu_instr.reg2])
		elseif addr_mode == 0x13 or addr_mode == 0x10 then
			return string.format("%s (0x%04X),%s", cpu_name_funcs[cpu_instr.type], cpu_fetched_data, reg_names[cpu_instr.reg2])
		elseif addr_mode == 0x11 then
			return string.format("%s (%s),0x%02X", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], cpu_fetched_data % 0x100)
		elseif addr_mode == 0x12 then
			return string.format("%s (%s)", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1])
		end
	else
		return cpu_name_funcs[cpu_instr.type]
	end
end

-- Serial port output string
local serial_out = ""

local function cpu_fetch_data()
	local addr_mode = cpu_instr.addr_mode
	if addr_mode then
		if addr_mode == 0x04 then
			cpu_fetched_data = cpu_read_reg(cpu_instr.reg1)
		elseif addr_mode == 0x02 then
			cpu_fetched_data = cpu_read_reg(cpu_instr.reg2)
		elseif addr_mode == 0x05 or addr_mode == 0x0D or addr_mode == 0x0F or addr_mode == 0x0B then
			cpu_fetched_data = bus_read(PC)
			emu_incr_cycles(1)
			PC = PC + 1
		elseif addr_mode == 0x0E or addr_mode == 0x01 then
			local low = bus_read(PC)
			emu_incr_cycles(1)
			local high = bus_read(PC + 1)
			emu_incr_cycles(1)
			cpu_fetched_data = bor(low, lshift(high, 8))
			PC = PC + 2
		elseif addr_mode == 0x03 then
			cpu_fetched_data = cpu_read_reg(cpu_instr.reg2)
			cpu_mem_dest = cpu_read_reg(cpu_instr.reg1)
			cpu_use_mem_dest = true
			if cpu_instr.reg1 == 0x04 then
				cpu_mem_dest = bor(cpu_mem_dest, 0xFF00)
			end
		elseif addr_mode == 0x06 then
			local addr = cpu_read_reg(cpu_instr.reg2)
			if cpu_instr.reg2 == 0x04 then
				addr = bor(addr, 0xFF00)
			end
			cpu_fetched_data = bus_read(addr)
			emu_incr_cycles(1)
		elseif addr_mode == 0x07 then
			cpu_fetched_data = bus_read(cpu_read_reg(cpu_instr.reg2))
			emu_incr_cycles(1)
			cpu_write_reg(0x0E, cpu_read_reg(0x0E) + 1)
		elseif addr_mode == 0x08 then
			cpu_fetched_data = bus_read(cpu_read_reg(cpu_instr.reg2))
			emu_incr_cycles(1)
			cpu_write_reg(0x0E, cpu_read_reg(0x0E) - 1)
		elseif addr_mode == 0x09 then
			cpu_fetched_data = cpu_read_reg(cpu_instr.reg2)
			cpu_mem_dest = cpu_read_reg(cpu_instr.reg1)
			cpu_use_mem_dest = true
			cpu_write_reg(0x0E, cpu_read_reg(0x0E) + 1)
		elseif addr_mode == 0x0A then
			cpu_fetched_data = cpu_read_reg(cpu_instr.reg2)
			cpu_mem_dest = cpu_read_reg(cpu_instr.reg1)
			cpu_use_mem_dest = true
			cpu_write_reg(0x0E, cpu_read_reg(0x0E) - 1)
		elseif addr_mode == 0x0C then
			cpu_mem_dest = bor(bus_read(PC), 0xFF00)
			cpu_use_mem_dest = true
			emu_incr_cycles(1)
			PC = PC + 1
		elseif addr_mode == 0x13 or addr_mode == 0x10 then
			local low = bus_read(PC)
			emu_incr_cycles(1)
			local high = bus_read(PC + 1)
			emu_incr_cycles(1)
			cpu_mem_dest = bor(low, lshift(high, 8))
			cpu_use_mem_dest = true
			PC = PC + 2
			cpu_fetched_data = cpu_read_reg(cpu_instr.reg2)
		elseif addr_mode == 0x11 then
			cpu_fetched_data = bus_read(PC)
			emu_incr_cycles(1)
			PC = PC + 1
			cpu_mem_dest = cpu_read_reg(cpu_instr.reg1)
			cpu_use_mem_dest = true
		elseif addr_mode == 0x12 then
			cpu_mem_dest = cpu_read_reg(cpu_instr.reg1)
			cpu_use_mem_dest = true
			cpu_fetched_data = bus_read(cpu_mem_dest)
			emu_incr_cycles(1)
		elseif addr_mode == 0x14 then
			local low = bus_read(PC)
			emu_incr_cycles(1)
			local high = bus_read(PC + 1)
			emu_incr_cycles(1)
			local addr = bor(low, lshift(high, 8))
			PC = PC + 2
			cpu_fetched_data = bus_read(addr)
			emu_incr_cycles(1)
		end
	end
end

function cpu_step()
	local t = Timer.new()
	if cpu_halted then
		-- CPU is halted due to an interrupt
		emu_incr_cycles(1)
		
		if cpu_interrupts ~= 0 then
			cpu_halted = false
		end
	else
		-- Fetch next instruction to execute and move forward program counter
		local instr_pc = PC
		cpu_opcode = bus_read(PC)
		cpu_instr = instrs[cpu_opcode]
		PC = PC + 1

		-- Fetching any required data for the given instruction
		cpu_mem_dest = 0
		cpu_use_mem_dest = false
		cpu_fetch_data()
		
		-- Interpreter debugger
		if debug_log then
			local c = ((band(F, 0x10) == 0x10) and "C") or "-"
			local z = ((band(F, 0x80) == 0x80) and "Z") or "-"
			local n = ((band(F, 0x40) == 0x40) and "N") or "-"
			local h = ((band(F, 0x20) == 0x20) and "H") or "-"
			System.consolePrint(
				string.format("%04X: %-16s (%02X) A: %02X F: %s%s%s%s BC: %02X%02X DE: %02X%02X HL: %02X%02X",
					instr_pc, cpu_stringify_instr(), cpu_opcode, A, z, n, h, c, B, C, D, E, H, L))
		end
		
		-- Serial data handling
		if serial_port_enabled then
			if bus_read(0xFF02) == 0x81 then
				local ch = bus_read(0xFF01)
				if ch then
					serial_out = serial_out .. string.char(ch)
				end
				bus_write(0xFF02, 0)
			end
			if string.len(serial_out) > 0 then
				System.consolePrint("I/O: " .. serial_out)
			end
		end
		
		-- Executing the given instruction
		cpu_exec_instr()
	end

	-- Interrupts handling
	if cpu_master_interrupts then
		if (band(cpu_interrupts, IT_VBLANK) == IT_VBLANK) and (band(IE, IT_VBLANK) == IT_VBLANK) then
			stack_push16(PC)
			PC = 0x40
			cpu_interrupts = band(cpu_interrupts, bnot(IT_VBLANK))
			cpu_halted = false
			cpu_master_interrupts = false
		elseif (band(cpu_interrupts, IT_LCD_START) == IT_LCD_START) and (band(IE, IT_LCD_START) == IT_LCD_START) then
			stack_push16(PC)
			PC = 0x48
			cpu_interrupts = band(cpu_interrupts, bnot(IT_LCD_START))
			cpu_halted = false
			cpu_master_interrupts = false
		elseif (band(cpu_interrupts, IT_TIMER) == IT_TIMER) and (band(IE, IT_TIMER) == IT_TIMER) then
			stack_push16(PC)
			PC = 0x50
			cpu_interrupts = band(cpu_interrupts, bnot(IT_TIMER))
			cpu_halted = false
			cpu_master_interrupts = false
		elseif (band(cpu_interrupts, IT_SERIAL) == IT_SERIAL) and (band(IE, IT_SERIAL) == IT_SERIAL) then
			stack_push16(PC)
			PC = 0x58
			cpu_interrupts = band(cpu_interrupts, bnot(IT_SERIAL))
			cpu_halted = false
			cpu_master_interrupts = false
		elseif (band(cpu_interrupts, IT_JOYPAD) == IT_JOYPAD) and (band(IE, IT_JOYPAD) == IT_JOYPAD) then
			stack_push16(PC)
			PC = 0x60
			cpu_interrupts = band(cpu_interrupts, bnot(IT_JOYPAD))
			cpu_halted = false
			cpu_master_interrupts = false
		end
		cpu_enable_interrupts = false
	elseif cpu_enable_interrupts then
		cpu_master_interrupts = true
	end
end

function cpu_set_interrupt(intr)
	cpu_interrupts = bor(cpu_interrupts, intr)
end
