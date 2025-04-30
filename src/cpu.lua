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
local AM_IMP    = 0x00
local AM_R_D16  = 0x01
local AM_R_R    = 0x02
local AM_MR_R   = 0x03
local AM_R      = 0x04
local AM_R_D8   = 0x05
local AM_R_MR   = 0x06
local AM_R_HLI  = 0x07
local AM_R_HLD  = 0x08
local AM_HLI_R  = 0x09
local AM_HLD_R  = 0x0A
local AM_R_A8   = 0x0B
local AM_A8_R   = 0x0C
local AM_HL_SPR = 0x0D
local AM_D16    = 0x0E
local AM_D8     = 0x0F
local AM_D16_R  = 0x10
local AM_MR_D8  = 0x11
local AM_MR     = 0x12
local AM_A16_R  = 0x13
local AM_R_A16  = 0x14

-- Register access types
local RT_A    = 0x01
local RT_F    = 0x02
local RT_B    = 0x03
local RT_C    = 0x04
local RT_D    = 0x05
local RT_E    = 0x06
local RT_H    = 0x07
local RT_L    = 0x08
local RT_SP   = 0x09
local RT_PC   = 0x0A
local RT_AF   = 0x0B
local RT_BC   = 0x0C
local RT_DE   = 0x0D
local RT_HL   = 0x0E

-- Register names lookup table
local reg_names = {
	[RT_A]  = "A",
	[RT_F]  = "F",
	[RT_B]  = "B",
	[RT_C]  = "C",
	[RT_D]  = "D",
	[RT_E]  = "E",
	[RT_H]  = "H",
	[RT_L]  = "L",
	[RT_SP] = "SP",
	[RT_PC] = "PC",	
	[RT_AF] = "AF",
	[RT_BC] = "BC",	
	[RT_DE] = "DE",
	[RT_HL] = "HL",	
}

-- Localized bit32 funcs
local bxor = bit32.bxor
local band = bit32.band
local bnot = bit32.bnot
local bor = bit32.bor
local lshift = bit32.lshift
local rshift = bit32.rshift

-- Condition types
local CT_NZ   = 0x01
local CT_Z    = 0x02
local CT_NC   = 0x03
local CT_C    = 0x04

-- Register F flags bitmask
local FLAG_C = 0x10
local FLAG_N = 0x20
local FLAG_H = 0x40
local FLAG_Z = 0x80

-- Interrupt types
IT_VBLANK    = 0x01
IT_LCD_START = 0x02
IT_TIMER     = 0x04
IT_SERIAL    = 0x08
IT_JOYPAD    = 0x10

local instrs = {
	[0x00] = {["type"] = IN.NOP},
	[0x01] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D16, ["reg1"] = RT_BC},
	[0x02] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_R, ["reg1"] = RT_BC, ["reg2"] = RT_A},
	[0x03] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_BC},
	[0x04] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_B},
	[0x05] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_B},
	[0x06] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_B},
	[0x07] = {["type"] = IN.RLCA},
	[0x08] = {["type"] = IN.LD, ["addr_mode"] = AM_A16_R, ["reg2"] = RT_SP},
	[0x09] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_HL, ["reg2"] = RT_BC},
	[0x0A] = {["type"] = IN.LD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_BC},
	[0x0B] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_BC},
	[0x0C] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_C},
	[0x0D] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_C},
	[0x0E] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_C},
	[0x0F] = {["type"] = IN.RRCA},
	[0x10] = {["type"] = IN.STOP},
	[0x11] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D16, ["reg1"] = RT_DE},
	[0x12] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_R, ["reg1"] = RT_DE, ["reg2"] = RT_A},
	[0x13] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_DE},
	[0x14] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_D},
	[0x15] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_D},
	[0x16] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_D},
	[0x17] = {["type"] = IN.RLA},
	[0x18] = {["type"] = IN.JR, ["addr_mode"] = AM_D8},
	[0x19] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_HL, ["reg2"] = RT_DE},
	[0x1A] = {["type"] = IN.LD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_DE},
	[0x1B] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_DE},
	[0x1C] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_E},
	[0x1D] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_E},
	[0x1E] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_E},
	[0x1F] = {["type"] = IN.RRA},
	[0x20] = {["type"] = IN.JR, ["addr_mode"] = AM_D8, ["cnd"] = CT_NZ},
	[0x21] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D16, ["reg1"] = RT_HL},
	[0x22] = {["type"] = IN.LD, ["addr_mode"] = AM_HLI_R, ["reg1"] = RT_HL, ["reg2"] = RT_A},
	[0x23] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_HL},
	[0x24] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_H},
	[0x25] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_H},
	[0x26] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_H},
	[0x27] = {["type"] = IN.DAA},
	[0x28] = {["type"] = IN.JR, ["addr_mode"] = AM_D8, ["cnd"] = CT_Z},
	[0x29] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_HL, ["reg2"] = RT_HL},
	[0x2A] = {["type"] = IN.LD, ["addr_mode"] = AM_R_HLI, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0x2B] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_HL},
	[0x2C] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_L},
	[0x2D] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_L},
	[0x2E] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_L},
	[0x2F] = {["type"] = IN.CPL},
	[0x30] = {["type"] = IN.JR, ["addr_mode"] = AM_D8, ["cnd"] = CT_NC},
	[0x31] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D16, ["reg1"] = RT_SP},
	[0x32] = {["type"] = IN.LD, ["addr_mode"] = AM_HLD_R, ["reg1"] = RT_HL, ["reg2"] = RT_A},
	[0x33] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_SP},
	[0x34] = {["type"] = IN.INC, ["addr_mode"] = AM_MR, ["reg1"] = RT_HL},
	[0x35] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_HL},
	[0x36] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_D8, ["reg1"] = RT_HL},
	[0x37] = {["type"] = IN.SCF},
	[0x38] = {["type"] = IN.JR, ["addr_mode"] = AM_D8, ["cnd"] = CT_C},
	[0x39] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, RT_HL, RT_SP},
	[0x3A] = {["type"] = IN.LD, ["addr_mode"] = AM_R_HLD, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0x3B] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_SP},
	[0x3C] = {["type"] = IN.INC, ["addr_mode"] = AM_R, ["reg1"] = RT_A},
	[0x3D] = {["type"] = IN.DEC, ["addr_mode"] = AM_R, ["reg1"] = RT_A},
	[0x3E] = {["type"] = IN.LD, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_A},
	[0x3F] = {["type"] = IN.CCF},
	[0x40] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_B, ["reg2"] = RT_B},
	[0x41] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_B, ["reg2"] = RT_C},
	[0x42] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_B, ["reg2"] = RT_D},
	[0x43] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_B, ["reg2"] = RT_E},
	[0x44] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_B, ["reg2"] = RT_H},
	[0x45] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_B, ["reg2"] = RT_L},
	[0x46] = {["type"] = IN.LD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_B, ["reg2"] = RT_HL},
	[0x47] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_B, ["reg2"] = RT_A},
	[0x48] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_C, ["reg2"] = RT_B},
	[0x49] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_C, ["reg2"] = RT_C},
	[0x4A] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_C, ["reg2"] = RT_D},
	[0x4B] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_C, ["reg2"] = RT_E},
	[0x4C] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_C, ["reg2"] = RT_H},
	[0x4D] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_C, ["reg2"] = RT_L},
	[0x4E] = {["type"] = IN.LD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_C, ["reg2"] = RT_HL},
	[0x4F] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_C, ["reg2"] = RT_A},
	[0x50] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_D, ["reg2"] = RT_B},
	[0x51] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_D, ["reg2"] = RT_C},
	[0x52] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_D, ["reg2"] = RT_D},
	[0x53] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_D, ["reg2"] = RT_E},
	[0x54] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_D, ["reg2"] = RT_H},
	[0x55] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_D, ["reg2"] = RT_L},
	[0x56] = {["type"] = IN.LD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_D, ["reg2"] = RT_HL},
	[0x57] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_D, ["reg2"] = RT_A},
	[0x58] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_E, ["reg2"] = RT_B},
	[0x59] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_E, ["reg2"] = RT_C},
	[0x5A] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_E, ["reg2"] = RT_D},
	[0x5B] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_E, ["reg2"] = RT_E},
	[0x5C] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_E, ["reg2"] = RT_H},
	[0x5D] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_E, ["reg2"] = RT_L},
	[0x5E] = {["type"] = IN.LD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_E, ["reg2"] = RT_HL},
	[0x5F] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_E, ["reg2"] = RT_A},
	[0x60] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_H, ["reg2"] = RT_B},
	[0x61] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_H, ["reg2"] = RT_C},
	[0x62] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_H, ["reg2"] = RT_D},
	[0x63] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_H, ["reg2"] = RT_E},
	[0x64] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_H, ["reg2"] = RT_H},
	[0x65] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_H, ["reg2"] = RT_L},
	[0x66] = {["type"] = IN.LD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_H, ["reg2"] = RT_HL},
	[0x67] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_H, ["reg2"] = RT_A},
	[0x68] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_L, ["reg2"] = RT_B},
	[0x69] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_L, ["reg2"] = RT_C},
	[0x6A] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_L, ["reg2"] = RT_D},
	[0x6B] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_L, ["reg2"] = RT_E},
	[0x6C] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_L, ["reg2"] = RT_H},
	[0x6D] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_L, ["reg2"] = RT_L},
	[0x6E] = {["type"] = IN.LD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_L, ["reg2"] = RT_HL},
	[0x6F] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_L, ["reg2"] = RT_A},
	[0x70] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_R, ["reg1"] = RT_HL, ["reg2"] = RT_B},
	[0x71] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_R, ["reg1"] = RT_HL, ["reg2"] = RT_C},
	[0x72] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_R, ["reg1"] = RT_HL, ["reg2"] = RT_D},
	[0x73] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_R, ["reg1"] = RT_HL, ["reg2"] = RT_E},
	[0x74] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_R, ["reg1"] = RT_HL, ["reg2"] = RT_H},
	[0x75] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_R, ["reg1"] = RT_HL, ["reg2"] = RT_L},
	[0x76] = {["type"] = IN.HALT},
	[0x77] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_R, ["reg1"] = RT_HL, ["reg2"] = RT_A},
	[0x78] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_B},
	[0x79] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_C},
	[0x7A] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_D},
	[0x7B] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_E},
	[0x7C] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_H},
	[0x7D] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_L},
	[0x7E] = {["type"] = IN.LD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0x7F] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_A},
	[0x80] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_B},
	[0x81] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_C},
	[0x82] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_D},
	[0x83] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_E},
	[0x84] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_H},
	[0x85] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_L},
	[0x86] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0x87] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_A},
	[0x88] = {["type"] = IN.ADC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_B},
	[0x89] = {["type"] = IN.ADC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_C},
	[0x8A] = {["type"] = IN.ADC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_D},
	[0x8B] = {["type"] = IN.ADC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_E},
	[0x8C] = {["type"] = IN.ADC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_H},
	[0x8D] = {["type"] = IN.ADC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_L},
	[0x8E] = {["type"] = IN.ADC, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0x8F] = {["type"] = IN.ADC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_A},
	[0x90] = {["type"] = IN.SUB, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_B},
	[0x91] = {["type"] = IN.SUB, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_C},
	[0x92] = {["type"] = IN.SUB, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_D},
	[0x93] = {["type"] = IN.SUB, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_E},
	[0x94] = {["type"] = IN.SUB, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_H},
	[0x95] = {["type"] = IN.SUB, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_L},
	[0x96] = {["type"] = IN.SUB, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0x97] = {["type"] = IN.SUB, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_A},
	[0x98] = {["type"] = IN.SBC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_B},
	[0x99] = {["type"] = IN.SBC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_C},
	[0x9A] = {["type"] = IN.SBC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_D},
	[0x9B] = {["type"] = IN.SBC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_E},
	[0x9C] = {["type"] = IN.SBC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_H},
	[0x9D] = {["type"] = IN.SBC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_L},
	[0x9E] = {["type"] = IN.SBC, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0x9F] = {["type"] = IN.SBC, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_A},
	[0xA0] = {["type"] = IN.AND, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_B},
	[0xA1] = {["type"] = IN.AND, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_C},
	[0xA2] = {["type"] = IN.AND, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_D},
	[0xA3] = {["type"] = IN.AND, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_E},
	[0xA4] = {["type"] = IN.AND, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_H},
	[0xA5] = {["type"] = IN.AND, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_L},
	[0xA6] = {["type"] = IN.AND, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0xA7] = {["type"] = IN.AND, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_A},
	[0xA8] = {["type"] = IN.XOR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_B},
	[0xA9] = {["type"] = IN.XOR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_C},
	[0xAA] = {["type"] = IN.XOR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_D},
	[0xAB] = {["type"] = IN.XOR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_E},
	[0xAC] = {["type"] = IN.XOR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_H},
	[0xAD] = {["type"] = IN.XOR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_L},
	[0xAE] = {["type"] = IN.XOR, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0xAF] = {["type"] = IN.XOR, ["addr_mode"] = AM_R, ["reg1"] = RT_A},
	[0xB0] = {["type"] = IN.OR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_B},
	[0xB1] = {["type"] = IN.OR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_C},
	[0xB2] = {["type"] = IN.OR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_D},
	[0xB3] = {["type"] = IN.OR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_E},
	[0xB4] = {["type"] = IN.OR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_H},
	[0xB5] = {["type"] = IN.OR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_L},
	[0xB6] = {["type"] = IN.OR, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0xB7] = {["type"] = IN.OR, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_A},
	[0xB8] = {["type"] = IN.CP, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_B},
	[0xB9] = {["type"] = IN.CP, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_C},
	[0xBA] = {["type"] = IN.CP, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_D},
	[0xBB] = {["type"] = IN.CP, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_E},
	[0xBC] = {["type"] = IN.CP, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_H},
	[0xBD] = {["type"] = IN.CP, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_L},
	[0xBE] = {["type"] = IN.CP, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_HL},
	[0xBF] = {["type"] = IN.CP, ["addr_mode"] = AM_R_R, ["reg1"] = RT_A, ["reg2"] = RT_A},
	[0xC0] = {["type"] = IN.RET, ["cnd"] = CT_NZ},
	[0xC1] = {["type"] = IN.POP, ["addr_mode"] = AM_R, ["reg1"] = RT_BC},
	[0xC2] = {["type"] = IN.JP, ["addr_mode"] = AM_D16, ["cnd"] = CT_NZ},
	[0xC3] = {["type"] = IN.JP, ["addr_mode"] = AM_D16},
	[0xC4] = {["type"] = IN.CALL, ["addr_mode"] = AM_D16},
	[0xC5] = {["type"] = IN.PUSH, ["addr_mode"] = AM_R, ["reg1"] = RT_BC},
	[0xC6] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_A},
	[0xC7] = {["type"] = IN.RST, ["param"] = 0x00},
	[0xC8] = {["type"] = IN.RET, ["cnd"] = CT_Z},
	[0xC9] = {["type"] = IN.RET},
	[0xCA] = {["type"] = IN.JP, ["addr_mode"] = AM_D16, ["cnd"] = CT_Z},
	[0xCB] = {["type"] = IN.CB, ["addr_mode"] = AM_D8},
	[0xCC] = {["type"] = IN.CALL, ["addr_mode"] = AM_D16, ["cnd"] = CT_Z},
	[0xCD] = {["type"] = IN.CALL, ["addr_mode"] = AM_D16},
	[0xCE] = {["type"] = IN.ADC, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_A},
	[0xCF] = {["type"] = IN.RST, ["param"] = 0x08},
	[0xD0] = {["type"] = IN.RET, CT_NC},
	[0xD1] = {["type"] = IN.POP, ["addr_mode"] = AM_R, ["reg1"] = RT_DE},
	[0xD2] = {["type"] = IN.JP, ["addr_mode"] = AM_D16, ["cnd"] = CT_NC},
	[0xD4] = {["type"] = IN.CALL, ["addr_mode"] = AM_D16, ["cnd"] = CT_NC},
	[0xD5] = {["type"] = IN.PUSH, ["addr_mode"] = AM_R, ["reg1"] = RT_DE},
	[0xD6] = {["type"] = IN.SUB, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_A},
	[0xD7] = {["type"] = IN.RST, ["param"] = 0x10},
	[0xD8] = {["type"] = IN.RET, ["cnd"] = CT_C},
	[0xD9] = {["type"] = IN.RETI},
	[0xDA] = {["type"] = IN.JP, ["addr_mode"] = AM_D16, ["cnd"] = CT_C},
	[0xDC] = {["type"] = IN.CALL, ["addr_mode"] = AM_D16, ["cnd"] = CT_C},
	[0xDE] = {["type"] = IN.SBC, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_A},
	[0xDF] = {["type"] = IN.RST, ["param"] = 0x18},
	[0xE0] = {["type"] = IN.LDH, ["addr_mode"] = AM_A8_R, ["reg2"] = RT_A},
	[0xE1] = {["type"] = IN.POP, ["addr_mode"] = AM_R, ["reg1"] = RT_HL},
	[0xE2] = {["type"] = IN.LD, ["addr_mode"] = AM_MR_R, ["reg1"] = RT_C, ["reg2"] = RT_A},
	[0xE5] = {["type"] = IN.PUSH, ["addr_mode"] = AM_R, ["reg1"] = RT_HL},
	[0xE6] = {["type"] = IN.AND, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_A},
	[0xE7] = {["type"] = IN.RST, ["param"] = 0x20},
	[0xE8] = {["type"] = IN.ADD, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_SP},
	[0xE9] = {["type"] = IN.JP, ["addr_mode"] = AM_R, ["reg1"] = RT_HL},
	[0xEA] = {["type"] = IN.LD, ["addr_mode"] = AM_A16_R, ["reg2"] = RT_A},
	[0xEE] = {["type"] = IN.XOR, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_A},
	[0xEF] = {["type"] = IN.RST, ["param"] = 0x28},
	[0xF0] = {["type"] = IN.LDH, ["addr_mode"] = AM_R_A8, ["reg1"] = RT_A},
	[0xF1] = {["type"] = IN.POP, ["addr_mode"] = AM_R, ["reg1"] = RT_AF},
	[0xF2] = {["type"] = IN.LD, ["addr_mode"] = AM_R_MR, ["reg1"] = RT_A, ["reg2"] = RT_C},
	[0xF3] = {["type"] = IN.DI},
	[0xF5] = {["type"] = IN.PUSH, ["addr_mode"] = AM_R, ["reg1"] = RT_AF},
	[0xF6] = {["type"] = IN.OR, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_A},
	[0xF7] = {["type"] = IN.RST, ["param"] = 0x30},
	[0xF8] = {["type"] = IN.LD, ["addr_mode"] = AM_HL_SPR, ["reg1"] = RT_HL, ["reg2"] = RT_SP},
	[0xF9] = {["type"] = IN.LD, ["addr_mode"] = AM_R_R, ["reg1"] = RT_SP, ["reg2"] = RT_HL},
	[0xFA] = {["type"] = IN.LD, ["addr_mode"] = AM_R_A16, ["reg1"] = RT_A},
	[0xFB] = {["type"] = IN.EI},
	[0xFE] = {["type"] = IN.CP, ["addr_mode"] = AM_R_D8, ["reg1"] = RT_A},
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
	stack_push(band(rshift(val, 8), 0xFF))
	stack_push(band(val, 0xFF))
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
local function _RT_A()
	return A
end
local function _RT_F()
	return F
end
local function _RT_B()
	return B
end
local function _RT_C()
	return C
end
local function _RT_D()
	return D
end
local function _RT_E()
	return E
end
local function _RT_H()
	return H
end
local function _RT_L()
	return L
end
local function _RT_SP()
	return SP
end
local function _RT_PC()
	return PC
end
local function _RT_AF()
	return bor(F, lshift(A, 8))
end
local function _RT_BC()
	return bor(C, lshift(B, 8))
end
local function _RT_DE()
	return bor(E, lshift(D, 8))
end
local function _RT_HL()
	return bor(L, lshift(H, 8))
end
local regs_read_funcs = {
	[RT_A] = _RT_A,
	[RT_F] = _RT_F,
	[RT_B] = _RT_B,
	[RT_C] = _RT_C,
	[RT_D] = _RT_D,
	[RT_E] = _RT_E,
	[RT_H] = _RT_H,
	[RT_L] = _RT_L,
	[RT_SP] = _RT_SP,
	[RT_PC] = _RT_PC,
	[RT_AF] = _RT_AF,	
	[RT_BC] = _RT_BC,	
	[RT_DE] = _RT_DE,	
	[RT_HL] = _RT_HL,	
}

-- Registers writing functions
local function _WRT_A(val)
	A = band(val, 0xFF)
end
local function _WRT_F(val)
	F = band(val, 0xFF)
end
local function _WRT_B(val)
	B = band(val, 0xFF)
end
local function _WRT_C(val)
	C = band(val, 0xFF)
end
local function _WRT_D(val)
	D = band(val, 0xFF)
end
local function _WRT_E(val)
	E = band(val, 0xFF)
end
local function _WRT_H(val)
	H = band(val, 0xFF)
end
local function _WRT_L(val)
	L = band(val, 0xFF)
end
local function _WRT_SP(val)
	SP = band(val, 0xFFFF)
end
local function _WRT_PC(val)
	PC = band(val, 0xFFFF)
end
local function _WRT_AF(val)
	F = band(val, 0xFF)
	A = rshift(band(val, 0xFF00), 8)
end
local function _WRT_BC(val)
	C = band(val, 0xFF)
	B = rshift(band(val, 0xFF00), 8)
end
local function _WRT_DE(val)
	E = band(val, 0xFF)
	D = rshift(band(val, 0xFF00), 8)
end
local function _WRT_HL(val)
	L = band(val, 0xFF)
	H = rshift(band(val, 0xFF00), 8)
end
local regs_write_funcs = {
	[RT_A] = _WRT_A,
	[RT_F] = _WRT_F,
	[RT_B] = _WRT_B,
	[RT_C] = _WRT_C,
	[RT_D] = _WRT_D,
	[RT_E] = _WRT_E,
	[RT_H] = _WRT_H,
	[RT_L] = _WRT_L,
	[RT_SP] = _WRT_SP,
	[RT_PC] = _WRT_PC,
	[RT_AF] = _WRT_AF,	
	[RT_BC] = _WRT_BC,	
	[RT_DE] = _WRT_DE,	
	[RT_HL] = _WRT_HL,	
}
function cpu_write_ie_reg(val)
	IE = val
end
function cpu_read_ie_reg()
	return IE
end

-- Data fetching functions
local function NOP()
end
local function _AM_R()
	cpu_fetched_data = regs_read_funcs[cpu_instr.reg1]()
end
local function _AM_R_R()
	cpu_fetched_data = regs_read_funcs[cpu_instr.reg2]()
end
local function _AM_R_D8()
	cpu_fetched_data = bus_read(PC)
	emu_incr_cycles(1)
	PC = PC + 1
end
local function _AM_D16()
	local low = bus_read(PC)
	emu_incr_cycles(1)
	local high = bus_read(PC + 1)
	emu_incr_cycles(1)
	cpu_fetched_data = bor(low, lshift(high, 8))
	PC = PC + 2
end
local function _AM_MR_R()
	cpu_fetched_data = regs_read_funcs[cpu_instr.reg2]()
	cpu_mem_dest = regs_read_funcs[cpu_instr.reg1]()
	cpu_use_mem_dest = true
	
	if cpu_instr.reg1 == RT_C then
		cpu_mem_dest = bor(cpu_mem_dest, 0xFF00)
	end
end
local function _AM_R_MR()
	local addr = regs_read_funcs[cpu_instr.reg2]()
	
	if cpu_instr.reg2 == RT_C then
		addr = bor(addr, 0xFF00)
	end
	
	cpu_fetched_data = bus_read(addr)
	emu_incr_cycles(1)
end
local function _AM_R_HLI()
	cpu_fetched_data = bus_read(regs_read_funcs[cpu_instr.reg2]())
	emu_incr_cycles(1)
	regs_write_funcs[RT_HL](regs_read_funcs[RT_HL]() + 1)
end
local function _AM_R_HLD()
	cpu_fetched_data = bus_read(regs_read_funcs[cpu_instr.reg2]())
	emu_incr_cycles(1)
	regs_write_funcs[RT_HL](regs_read_funcs[RT_HL]() - 1)
end
local function _AM_HLI_R()
	cpu_fetched_data = regs_read_funcs[cpu_instr.reg2]()
	cpu_mem_dest = regs_read_funcs[cpu_instr.reg1]()
	cpu_use_mem_dest = true
	regs_write_funcs[RT_HL](regs_read_funcs[RT_HL]() + 1)
end
local function _AM_HLD_R()
	cpu_fetched_data = regs_read_funcs[cpu_instr.reg2]()
	cpu_mem_dest = regs_read_funcs[cpu_instr.reg1]()
	cpu_use_mem_dest = true
	regs_write_funcs[RT_HL](regs_read_funcs[RT_HL]() - 1)
end
local function _AM_A8_R()
	cpu_mem_dest = bor(bus_read(PC), 0xFF00)
	cpu_use_mem_dest = true
	emu_incr_cycles(1)
	PC = PC + 1
end
local function _AM_A16_R()
	local low = bus_read(PC)
	emu_incr_cycles(1)
	local high = bus_read(PC + 1)
	emu_incr_cycles(1)
	cpu_mem_dest = bor(low, lshift(high, 8))
	cpu_use_mem_dest = true
	PC = PC + 2
	cpu_fetched_data = regs_read_funcs[cpu_instr.reg2]()
end
local function _AM_MR_D8()
	cpu_fetched_data = bus_read(PC)
	emu_incr_cycles(1)
	PC = PC + 1
	cpu_mem_dest = regs_read_funcs[cpu_instr.reg1]()
	cpu_use_mem_dest = true
end
local function _AM_MR()
	cpu_mem_dest = regs_read_funcs[cpu_instr.reg1]()
	cpu_use_mem_dest = true
	cpu_fetched_data = bus_read(cpu_mem_dest)
	emu_incr_cycles(1)
end
local function _AM_R_A16()
	local low = bus_read(PC)
	emu_incr_cycles(1)
	local high = bus_read(PC + 1)
	emu_incr_cycles(1)
	local addr = bor(low, lshift(high, 8))
	PC = PC + 2
	cpu_fetched_data = bus_read(addr)
	emu_incr_cycles(1)
end

local data_fetch_funcs = {
	[AM_R] = _AM_R,
	[AM_R_R] = _AM_R_R,
	[AM_R_D8] = _AM_R_D8,
	[AM_D16] = _AM_D16,
	[AM_R_D16] = _AM_D16,
	[AM_MR_R] = _AM_MR_R,
	[AM_R_MR] = _AM_R_MR,
	[AM_R_HLI] = _AM_R_HLI,
	[AM_R_HLD] = _AM_R_HLD,
	[AM_HLI_R] = _AM_HLI_R,
	[AM_HLD_R] = _AM_HLD_R,
	[AM_R_A8] = _AM_R_D8,
	[AM_A8_R] = _AM_A8_R,
	[AM_HL_SPR] = _AM_R_D8,
	[AM_D8] = _AM_R_D8,
	[AM_A16_R] = _AM_A16_R,
	[AM_D16_R] = _AM_A16_R,
	[AM_MR_D8] = _AM_MR_D8,
	[AM_MR] = _AM_MR,
	[AM_R_A16] = _AM_R_A16
}

-- Condition checking functions
local function _CT_NZ()
	return band(F, FLAG_Z) == 0
end
local function _CT_Z()
	return band(F, FLAG_Z) == FLAG_Z
end
local function _CT_NC()
	return band(F, FLAG_C) == 0
end
local function _CT_C()
	return band(F, FLAG_C) == FLAG_C
end
local cond_funcs = {
	[CT_C] = _CT_C,
	[CT_NC] = _CT_NC,
	[CT_Z] = _CT_Z,
	[CT_NZ] = _CT_NZ
}
local function cpu_check_cond()
	if cpu_instr.cnd then
		return cond_funcs[cpu_instr.cnd]()
	end
	
	return true
end

-- Goto function
local function _goto(addr, push_pc)
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
	[0x00] = RT_B,
	[0x01] = RT_C,
	[0x02] = RT_D,
	[0x03] = RT_E,
	[0x04] = RT_H,
	[0x05] = RT_L,
	[0x06] = RT_HL,
	[0x07] = RT_A,	
}

-- CPU flags setter function
local function cpu_set_flags(z, s, h, c)
	if z == 1 then
		F = bor(F, FLAG_Z)
	elseif z == 0 then
		F = band(F, bnot(FLAG_Z))
	end
	if s == 1 then
		F = bor(F, FLAG_N)
	elseif s == 0 then
		F = band(F, bnot(FLAG_N))
	end
	if h == 1 then
		F = bor(F, FLAG_H)
	elseif h == 0 then
		F = band(F, bnot(FLAG_H))
	end
	if c == 1 then
		F = bor(F, FLAG_C)
	elseif c == 0 then
		F = band(F, bnot(FLAG_C))
	end
end

-- CPU instr execution functions
local function _IN_CB()
	local op = cpu_fetched_data
	local reg = rt_lookup[band(op, 0x07)]
	local bit = band(rshift(op, 3), 0x07)
	local bit_op = band(rshift(op, 6), 0x07)
	local reg_val = regs_read_funcs[reg]()
	emu_incr_cycles(1)
	
	if reg == RT_HL then
		emu_incr_cycles(2)
	end
	
	if bit_op == 1 then -- BIT
		cpu_set_flags((band(reg_val, lshift(1, bit)) == 0) and 1 or 0, 0, 1, -1)
	elseif bit_op == 2 then -- RST
		reg_val = band(reg_val, bnot(lshift(1, bit)))
		if reg == RT_HL then
			bus_write(regs_read_funcs[RT_HL](), reg_val)
		else
			regs_write_funcs[reg](band(reg_val, 0xFF))
		end
	elseif bit_op == 3 then -- SET
		reg_val = bor(reg_val, lshift(1, bit))
		if reg == RT_HL then
			bus_write(regs_read_funcs[RT_HL](), reg_val)
		else
			regs_write_funcs[reg](band(reg_val, 0xFF))
		end
	elseif bit == 0 then -- RLC
		local c = 0
		local res = band(lshift(reg_val, 1), 0xFF)
		if band(reg_val, FLAG_Z) ~= 0 then
			res = bor(res, 0x01)
			c = 1
		end
		if reg == RT_HL then
			bus_write(regs_read_funcs[RT_HL](), res)
		else
			regs_write_funcs[reg](band(res, 0xFF))
		end
		cpu_set_flags((res == 0) and 1 or 0, 0, 0, c)
	elseif bit == 1 then -- RRC
		local old = reg_val
		reg_val = bor(rshift(reg_val, 1), lshift(old, 7))
		if reg == RT_HL then
			bus_write(regs_read_funcs[RT_HL](), reg_val)
		else
			regs_write_funcs[reg](band(reg_val, 0xFF))
		end
		cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 1) and 1 or 0)
	elseif bit == 2 then -- RL
		local old = reg_val
		reg_val = bor(lshift(reg_val, 1), band(F, FLAG_C))
		if reg == RT_HL then
			bus_write(regs_read_funcs[RT_HL](), reg_val)
		else
			regs_write_funcs[reg](band(reg_val, 0xFF))
		end
		cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 0x80) and 1 or 0)
	elseif bit == 3 then -- RR
		local old = reg_val
		reg_val = bor(rshift(reg_val, 1), lshift(band(F, FLAG_C), 7))
		if reg == RT_HL then
			bus_write(regs_read_funcs[RT_HL](), reg_val)
		else
			regs_write_funcs[reg](band(reg_val, 0xFF))
		end
		cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 1) and 1 or 0)
	elseif bit == 4 then -- SLA
		local old = reg_val
		reg_val = rshift(reg_val, 1)
		if reg == RT_HL then
			bus_write(regs_read_funcs[RT_HL](), reg_val)
		else
			regs_write_funcs[reg](band(reg_val, 0xFF))
		end
		cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 0x80) and 1 or 0)
	elseif bit == 5 then -- SRA
		local old = reg_val
		reg_val = bor(rshift(reg_val, 1), band(reg_val, 0x80))
		if reg == RT_HL then
			bus_write(regs_read_funcs[RT_HL](), reg_val)
		else
			regs_write_funcs[reg](band(reg_val, 0xFF))
		end
		cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 1) and 1 or 0)
	elseif bit == 6 then -- SWAP
		reg_val = bor(rshift(band(reg_val, 0xF0), 4), lshift(band(reg_val, 0x0F), 4))
		if reg == RT_HL then
			bus_write(regs_read_funcs[RT_HL](), reg_val)
		else
			regs_write_funcs[reg](band(reg_val, 0xFF))
		end
		cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, 0)
	elseif bit == 7 then -- SRL
		local old = reg_val
		reg_val = rshift(reg_val, 1)
		if reg == RT_HL then
			bus_write(regs_read_funcs[RT_HL](), reg_val)
		else
			regs_write_funcs[reg](band(reg_val, 0xFF))
		end
		cpu_set_flags((reg_val == 0) and 1 or 0, 0, 0, band(old, 1) and 1 or 0)
	end
end

local function _IN_LD()
	if cpu_use_mem_dest then
		if cpu_instr.reg2 and cpu_instr.reg2 >= RT_SP then
			emu_incr_cycles(1)
			bus_write16(cpu_mem_dest, cpu_fetched_data)
		else
			bus_write(cpu_mem_dest, cpu_fetched_data)
		end
		emu_incr_cycles(1)
	elseif cpu_instr.addr_mode == AM_HL_SPR then
		local r2 = regs_read_funcs[cpu_instr.reg2]()
		local h = ((band(r2, 0x0F) + band(cpu_fetched_data, 0x0F)) >= 0x10) and 1 or 0
		local c = ((band(r2, 0xFF) + band(cpu_fetched_data, 0xFF)) >= 0x100) and 1 or 0
		cpu_set_flags(0, 0, h, c)
		if cpu_fetched_data > 0x7F then
			regs_write_funcs[cpu_instr.reg1](r2 + (cpu_fetched_data - 0x100))
		else
			regs_write_funcs[cpu_instr.reg1](r2 + cpu_fetched_data)
		end
	else
		regs_write_funcs[cpu_instr.reg1](cpu_fetched_data)
	end
end
local function _IN_DI()
	cpu_master_interrupts = false
end
local function _IN_EI()
	cpu_enable_interrupts = true
end
local function _IN_XOR()
	A = bxor(A, band(cpu_fetched_data, 0xFF))
	cpu_set_flags((A == 0) and 1 or 0, 0, 0, 0)
end
local function _IN_LDH()
	if cpu_instr.reg1 == RT_A then
		regs_write_funcs[cpu_instr.reg1](bus_read(bor(0xFF00, cpu_fetched_data)))
	else
		bus_write(bor(0xFF00, cpu_fetched_data), A)
	end
	emu_incr_cycles(1)
end
local function _IN_POP()
	local low = stack_pop()
	emu_incr_cycles(1)
	local high = stack_pop()
	emu_incr_cycles(1)
	
	local val = bor(lshift(high, 8), low)

	if cpu_instr.reg1 == RT_AF then
		regs_write_funcs[cpu_instr.reg1](band(val, 0xFFF0))
	else
		regs_write_funcs[cpu_instr.reg1](val)
	end
end
local function _IN_PUSH()
	local high = band(rshift(regs_read_funcs[cpu_instr.reg1](), 8), 0xFF)
	emu_incr_cycles(1)
	stack_push(high)
	local low = band(regs_read_funcs[cpu_instr.reg1](), 0xFF)
	emu_incr_cycles(1)
	stack_push(low)
	emu_incr_cycles(1)
end
local function _IN_CALL()
	_goto(cpu_fetched_data, true)
end
local function _IN_JP()
	_goto(cpu_fetched_data, false)
end
local function _IN_JR()
	local rel = band(cpu_fetched_data, 0xFF)
	if rel > 0x7F then
		rel = rel - 0x100
	end
	local addr = PC + rel
	_goto(addr, false)
end
local function _IN_RST()
	_goto(cpu_instr.param, true)
end
local function _IN_RET()
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
end
local function _IN_RETI()
	cpu_master_interrupts = true
	_IN_RET()
end
local function _IN_INC()
	local val
	if cpu_instr.reg1 >= RT_SP then
		emu_incr_cycles(1)
	end
	
	if cpu_instr.reg1 == RT_HL and cpu_instr.addr_mode == AM_MR then
		local hl = regs_read_funcs[RT_HL]()
		val = band(bus_read(hl) + 1, 0xFF)
		bus_write(hl, val)
	else
		val = regs_read_funcs[cpu_instr.reg1]() + 1
		regs_write_funcs[cpu_instr.reg1](val)
		val = regs_read_funcs[cpu_instr.reg1]()
	end
	
	if band(cpu_opcode, 0x03) ~= 0x03 then
		cpu_set_flags((val == 0) and 1 or 0, 0, (band(val, 0x0F) == 0x00) and 1 or 0, -1)
	end
end
local function _IN_DEC()
	local val
	if cpu_instr.reg1 >= RT_SP then
		emu_incr_cycles(1)
	end
	
	if cpu_instr.reg1 == RT_HL and cpu_instr.addr_mode == AM_MR then
		local hl = regs_read_funcs[RT_HL]()
		val = bus_read(hl) - 1
		if val < 0 then
			val = 0x10000 + val
		end
		bus_write(hl, val)
	else
		val = regs_read_funcs[cpu_instr.reg1]() - 1
		if cpu_instr.reg1 >= RT_SP then
			if val < 0 then
				val = 0x10000 + val
			end
		else
			if val < 0 then
				val = 0x100 + val
			end
		end
		regs_write_funcs[cpu_instr.reg1](val)
	end
	
	if band(cpu_opcode, 0x0B) ~= 0x0B then
		cpu_set_flags((val == 0) and 1 or 0, 1, (band(val, 0x0F) == 0x0F) and 1 or 0, -1)
	end
end
local function _IN_ADD()
	local val
	if cpu_instr.reg1 >= RT_SP then
		emu_incr_cycles(1)
	end
	
	local r1 = regs_read_funcs[cpu_instr.reg1]()
	if cpu_instr.reg1 == RT_SP then
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
	if cpu_instr.reg1 >= RT_SP then
		z = -1
		h = ((band(r1, 0x0FFF) + band(cpu_fetched_data, 0x0FFF)) >= 0x1000) and 1 or 0
		c = ((r1 + cpu_fetched_data) >= 0x10000) and 1 or 0		
	elseif cpu_instr.reg1 == RT_SP then
		z = 0
		h = ((band(r1, 0x0F) + band(cpu_fetched_data, 0x0F)) >= 0x10) and 1 or 0
		c = ((band(r1, 0xFF) + band(cpu_fetched_data, 0xFF)) >= 0x100) and 1 or 0
	else
		z = (band(val, 0xFF) == 0) and 1 or 0
		h = ((band(r1, 0x0F) + band(cpu_fetched_data, 0x0F)) >= 0x10) and 1 or 0
		c = ((band(r1, 0xFF) + band(cpu_fetched_data, 0xFF)) >= 0x100) and 1 or 0
	end
	
	regs_write_funcs[cpu_instr.reg1](band(val, 0xFFFF))
	cpu_set_flags(z, 0, h, c)
end
local function _IN_SUB()
	local r1 = regs_read_funcs[cpu_instr.reg1]()
	local val = band(r1 - cpu_fetched_data, 0xFFFF)
	local z = (val == 0) and 1 or 0
	local h = ((regs_read_funcs[cpu_instr.reg1]() - cpu_fetched_data) == 0) and 1 or 0
	local c = ((regs_read_funcs[cpu_instr.reg1]() - cpu_fetched_data) == 0) and 1 or 0
	regs_write_funcs[cpu_instr.reg1](val)
	cpu_set_flags(z, 1, h, c)
end
local function _IN_ADC()
	local c = band(F, FLAG_C)
	A = band(A + cpu_fetched_data + c)
	cpu_set_flags((A == 0) and 1 or 0, 0, ((band(A, 0x0F) + band(cpu_fetched_data, 0x0F) + c) > 0x0F) and 1 or 0, (A + cpu_fetched_data + c > 0xFF) and 1 or 0)
end
local function _IN_SBC()
	local c = band(F, FLAG_C)
	local val = cpu_fetched_data + c
	local r1 = regs_read_funcs[cpu_instr.reg1]()
	local z = ((r1 - val) == 0) and 1 or 0
	local h = ((band(r1, 0x0F) - band(cpu_fetched_data, 0x0F) - c) < 0) and 1 or 0
	local c = ((r1 - cpu_fetched_data - c) < 0) and 1 or 0
	regs_write_funcs[cpu_instr.reg1](r1 - val)
	cpu_set_flags(z, 1, h, c)
end
local function _IN_OR()
	A = bor(A, band(cpu_fetched_data, 0xFF))
	cpu_set_flags((A == 0) and 1 or 0, 0, 0, 0)
end
local function _IN_CP()
	local val = A - cpu_fetched_data
	local val2 = band(A, 0x0F) - band(cpu_fetched_data, 0x0F)
	cpu_set_flags((val == 0) and 1 or 0, 1, (val2 < 0) and 1 or 0, (val < 0) and 1 or 0);
end
local function _IN_AND()
	A = band(A, band(cpu_fetched_data, 0xFF))
	cpu_set_flags((A == 0) and 1 or 0, 0, 1, 0)
end
local function _IN_RLCA()
	local c = band(rshift(A, 7), 1)
	A = bor(lshift(A, 1), c)
	cpu_set_flags(0, 0, 0, c)
end
local function _IN_RRCA()
	local c = band(A, 1)
	A = bor(rshift(A, 1), lshift(c, 7))
	cpu_set_flags(0, 0, 0, c and 1 or 0)
end
local function _IN_RLA()
	local c = band(rshift(A, 7), 1)
	A = bor(lshift(A, 1), band(F, FLAG_C))
	cpu_set_flags(0, 0, 0, c and 1 or 0)
end
local function _IN_RRA()
	local c = band(A, 1) and 1 or 0
	A = bor(rshift(A, 1), rshift(band(F, FLAG_C), 7))
	cpu_set_flags(0, 0, 0, c)
end
local function _IN_STOP()
	System.consolePrint("IN_STOP: NOIMPL")
end
local function _IN_DAA()
	local u = 0
	local fc = 0
	local has_h = band(F, FLAG_H)
	local has_n = band(F, FLAG_N)
	local has_c = band(F, FLAG_C)
	if has_h or (band(A, 0x0F) > 9 and not has_n) then
		u = 6
	end
	if has_c or (A > 0x99 and not has_n) then
		u = bor(u, 0x60)
		fc = 1
	end
	if has_n then
		A = band(A - u, 0xFF)
	else
		A = band(A + u, 0xFF)
	end
	cpu_set_flags((A == 0) and 1 or 0, -1, 0, fc)
end
local function _IN_CPL()
	A = bnot(A)
	cpu_set_flags(-1, 1, 1, -1)
end
local function _IN_SCF()
	cpu_set_flags(-1, 0, 0, 1)
end
local function _IN_CCF()
	cpu_set_flags(-1, 0, 0, bxor(band(F, FLAG_C), 1))
end
local function _IN_HALT()
	cpu_halted = true
end
local cpu_exec_funcs = {
	[IN.NOP] = NOP,
	[IN.LD] = _IN_LD,
	[IN.LDH] = _IN_LDH,
	[IN.JP] = _IN_JP,
	[IN.DI] = _IN_DI,
	[IN.EI] = _IN_EI,
	[IN.XOR] = _IN_XOR,
	[IN.POP] = _IN_POP,
	[IN.PUSH] = _IN_PUSH,
	[IN.CALL] = _IN_CALL,
	[IN.JP] = _IN_JP,
	[IN.JR] = _IN_JR,
	[IN.RST] = _IN_RST,
	[IN.RET] = _IN_RET,
	[IN.RETI] = _IN_RETI,
	[IN.INC] = _IN_INC,
	[IN.DEC] = _IN_DEC,
	[IN.ADD] = _IN_ADD,
	[IN.SUB] = _IN_SUB,
	[IN.ADC] = _IN_ADC,
	[IN.SBC] = _IN_SBC,
	[IN.OR] = _IN_OR,
	[IN.CP] = _IN_CP,
	[IN.CB] = _IN_CB,
	[IN.AND] = _IN_AND,
	[IN.RLCA] = _IN_RLCA,
	[IN.RRCA] = _IN_RRCA,
	[IN.RLA] = _IN_RLA,
	[IN.RRA] = _IN_RRA,
	[IN.STOP] = _IN_STOP,
	[IN.DAA] = _IN_DAA,
	[IN.CPL] = _IN_CPL,
	[IN.SCF] = _IN_SCF,
	[IN.CCF] = _IN_CCF,
	[IN.HALT] = _IN_HALT,
}
local cpu_name_funcs = {
	[IN.NOP] ="NOP",
	[IN.LD] ="LD",
	[IN.LDH] ="LDH",
	[IN.JP] ="JP",
	[IN.DI] ="DI",
	[IN.EI] ="EI",
	[IN.XOR] ="XOR",
	[IN.POP] ="POP",
	[IN.PUSH] ="PUSH",
	[IN.CALL] ="CALL",
	[IN.JP] ="JP",
	[IN.JR] ="JR",
	[IN.RST] ="RST",
	[IN.RET] ="RET",
	[IN.RETI] ="RETI",
	[IN.INC] ="INC",
	[IN.DEC] ="DEC",
	[IN.ADD] ="ADD",
	[IN.SUB] ="SUB",
	[IN.ADC] ="ADC",
	[IN.SBC] ="SBC",
	[IN.OR] ="OR",
	[IN.CP] ="CP",
	[IN.CB] ="CB",
	[IN.AND] ="AND",
	[IN.RLCA] ="RLCA",
	[IN.RRCA] ="RRCA",
	[IN.RLA] ="RLA",
	[IN.RRA] ="RRA",
	[IN.STOP] ="STOP",
	[IN.DAA] ="DAA",
	[IN.CPL] ="CPL",
	[IN.SCF] ="SCF",
	[IN.CCF] ="CCF",
	[IN.HALT] ="HALT",
}

-- Instructions logging functions
local function LOG_AM_R_D16()
	return string.format("%s %s,0x%04X", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], cpu_fetched_data)
end
local function LOG_AM_R()
	return string.format("%s %s", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1])
end
local function LOG_AM_R_R()
	return string.format("%s %s,%s", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
end
local function LOG_AM_MR_R()
	return string.format("%s (%s),%s", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
end
local function LOG_AM_MR()
	return string.format("%s (%s)", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1])
end
local function LOG_AM_R_MR()
	return string.format("%s %s,(%s)", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
end
local function LOG_AM_R_D8()
	return string.format("%s %s,0x%02X", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], band(cpu_fetched_data, 0xFF))
end
local function LOG_AM_R_HLI()
	return string.format("%s %s,(%s+)", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
end
local function LOG_AM_R_HLD()
	return string.format("%s %s,(%s-)", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
end
local function LOG_AM_HLI_R()
	return string.format("%s (%s+),%s", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
end
local function LOG_AM_HLD_R()
	return string.format("%s (%s-),%s", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], reg_names[cpu_instr.reg2])
end
local function LOG_AM_A8_R()
	return string.format("%s 0x%02X,%s", cpu_name_funcs[cpu_instr.type], bus_read(PC - 1), reg_names[cpu_instr.reg2])
end
local function LOG_AM_HL_SPR()
	return string.format("%s (%s),SP+%d", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], band(cpu_fetched_data, 0xFF))
end
local function LOG_AM_D8()
	return string.format("%s 0x%02X", cpu_name_funcs[cpu_instr.type], band(cpu_fetched_data, 0xFF))
end
local function LOG_AM_D16()
	return string.format("%s 0x%04X", cpu_name_funcs[cpu_instr.type], cpu_fetched_data)
end
local function LOG_AM_MR_D8()
	return string.format("%s (%s),0x%02X", cpu_name_funcs[cpu_instr.type], reg_names[cpu_instr.reg1], band(cpu_fetched_data, 0xFF))
end
local function LOG_AM_A16_R()
	return string.format("%s (0x%04X),%s", cpu_name_funcs[cpu_instr.type], cpu_fetched_data, reg_names[cpu_instr.reg2])
end
local instr_log_funcs = {
	[AM_R_D16] = LOG_AM_R_D16,
	[AM_R_A16] = LOG_AM_R_D16,
	[AM_R] = LOG_AM_R,
	[AM_R_R] = LOG_AM_R_R,
	[AM_MR_R] = LOG_AM_MR_R,
	[AM_MR] = LOG_AM_MR,
	[AM_R_D8] = LOG_AM_R_D8,
	[AM_R_A8] = LOG_AM_R_D8,
	[AM_R_HLI] = LOG_AM_R_HLI,
	[AM_R_HLD] = LOG_AM_R_HLD,
	[AM_HLI_R] = LOG_AM_HLI_R,
	[AM_HLD_R] = LOG_AM_HLD_R,
	[AM_A8_R] = LOG_AM_A8_R,
	[AM_HL_SPR] = LOG_AM_HL_SPR,
	[AM_D8] = LOG_AM_D8,
	[AM_D16] = LOG_AM_D16,
	[AM_MR_D8] = LOG_AM_MR_D8,
	[AM_A16_R] = LOG_AM_A16_R,
	[AM_D16_R] = LOG_AM_A16_R,
	[AM_R_MR] = LOG_AM_R_MR,	
}
local function cpu_stringify_instr()
	if cpu_instr.addr_mode then
		return instr_log_funcs[cpu_instr.addr_mode]()
	else
		return cpu_name_funcs[cpu_instr.type]
	end
end

-- Serial port output string
local serial_out = ""

function cpu_step()
	local t = Timer.new()
	if cpu_halted then
		-- CPU is halted due to an interrupt
		emu_incr_cycles(1)
		
		if cpu_interrupts then
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
		if cpu_instr.addr_mode then
			data_fetch_funcs[cpu_instr.addr_mode]()
		end
		
		-- Interpreter debugger
		if debug_log then
			local c = ((band(F, FLAG_C) == FLAG_C) and"C") or"-"
			local z = ((band(F, FLAG_Z) == FLAG_Z) and"Z") or"-"
			local n = ((band(F, FLAG_N) == FLAG_N) and"N") or"-"
			local h = ((band(F, FLAG_H) == FLAG_H) and"H") or"-"
			System.consolePrint(
				string.format("%08X - %04X: %-16s (%02X) A: %02X F: %s%s%s%s BC: %02X%02X DE: %02X%02X HL: %02X%02X",
					emu.ticks, instr_pc, cpu_stringify_instr(), cpu_opcode, A, z, n, h, c, B, C, D, E, H, L))
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
		cpu_exec_funcs[cpu_instr.type]()
	end

	-- Interrupts handling
	if cpu_master_interrupts then
		if band(cpu_interrupts, IT_VBLANK) and band(IE, IT_VBLANK) then
			stack_push16(PC)
			PC = 0x40
			cpu_interrupts = band(cpu_interrupts, bnot(IT_VBLANK))
			cpu_halted = false
			cpu_master_interrupts = false
		elseif band(cpu_interrupts, IT_LCD_START) and band(IE, IT_LCD_START) then
			stack_push16(PC)
			PC = 0x48
			cpu_interrupts = band(cpu_interrupts, bnot(IT_LCD_START))
			cpu_halted = false
			cpu_master_interrupts = false
		elseif band(cpu_interrupts, IT_TIMER) and band(IE, IT_TIMER) then
			stack_push16(PC)
			PC = 0x50
			cpu_interrupts = band(cpu_interrupts, bnot(IT_TIMER))
			cpu_halted = false
			cpu_master_interrupts = false
		elseif band(cpu_interrupts, IT_SERIAL) and band(IE, IT_SERIAL) then
			stack_push16(PC)
			PC = 0x58
			cpu_interrupts = band(cpu_interrupts, bnot(IT_SERIAL))
			cpu_halted = false
			cpu_master_interrupts = false
		elseif band(cpu_interrupts, IT_JOYPAD) and band(IE, IT_JOYPAD) then
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

	return false
end

function cpu_set_interrupt(intr)
	cpu_interrupts = bor(cpu_interrupts, intr)
end
