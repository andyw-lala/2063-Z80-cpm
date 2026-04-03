;****************************************************************************
;
;    Inspired heavily by the Z80-Retro project by John Winans
;
;    This library is free software; you can redistribute it and/or
;    modify it under the terms of the GNU Lesser General Public
;    License as published by the Free Software Foundation; either
;    version 2.1 of the License, or (at your option) any later version.
;
;    This library is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;    Lesser General Public License for more details.
;
;    You should have received a copy of the GNU Lesser General Public
;    License along with this library; if not, write to the Free Software
;    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301
;    USA
;
;
;****************************************************************************

; I/O port definitions (largely directly taken from Toshiba TMPZ84C015 datasheet)

;
; Note: CTC 0 & 1 available
;       CTC 2 SIO Channel A baud rate (1.8432MHz on CLK2)
;       CTC 3 SIO Channel B baud rate (1.8432MHz on CLK3)
ctc_0:			equ	0x10		; CTC port 0
ctc_1:			equ	0x11		; CTC port 1
ctc_2:			equ	0x12		; CTC port 2
ctc_3:			equ	0x13		; CTC port 3

; SIO port A optionally available on Raspberry Pi interface
; SIO port B available
sio_ad:			equ	0x18		; SIO port A, data
sio_ac:			equ	0x19		; SIO port A, command
sio_bd:			equ	0x1A		; SIO port B, data
sio_bc:			equ	0x1B		; SIO port B, command

; PIO ports A & B available
pio_ad:			equ	0x1C		; PIO port A, data
pio_ac:			equ	0x1D		; PIO port A, command
pio_bd:			equ	0x1E		; PIO port B, data
pio_bc:			equ	0x1F		; PIO port B, command

; I/O port decoder on-board
io40_base:			equ	0x40		; IO decode 0x40-0x47
io48_base:			equ	0x48		; IO decode 0x48-0x4F
io50_base:			equ	0x50		; IO decode 0x50-0x57
io58_base:			equ	0x58		; IO decode 0x58-0x5F
io60_base:			equ	0x60		; IO decode 0x60-0x67
io68_base:			equ	0x68		; IO decode 0x68-0x6F
io70_base:			equ	0x70		; IO decode 0x70-0x77
io78_base:			equ	0x78		; IO decode 0x78-0x7F

control_reg:			equ     io78_base	; R/W @ 0x78

ram_bank_mask:			equ	0x0F		; Ram bank is lowest
							; 4 bits of control reg
user_led_bit:			equ	4		; 1 = LED on
user_led:			equ	1 << user_led_bit

							; 0x20 available
							; 0x40 available

flash_bit:			equ	7		; bit 7 for set/reset
flash_enable:			equ	1 << flash_bit	; 1 = Flash mapped in


;****************************************************************************
;
; Memory banks:
;
; BANK     Usage
;   0    disk cache bank 0
;   1    disk cache bank 1
;   2    disk cache bank 2
;   3    disk cache bank 3
;   4
;   5
;   6
;   7
;   8
;   9
;   A
;   B
;   C
;   D
;   E    CP/M zero page and low half of the TPA
;   F    CP/M high half of the TPA, CCP, BDOS, and BIOS
;
;****************************************************************************

.low_bank:      equ     0x0e    ; The RAM BANK to use for the bottom 32K

init_ctl:	equ	flash_enable | .low_bank

; Hardware will set the flash enable bit on reset.
; All other bits are not defined on reset.
; Control register is R/W, bits 0x20 & 0x40 can be used as non-volatile flags

wdt:				equ	0xF0		; WDTER, WDTPR, HALTMR
wdt_command:			equ	0xF1		; Watchdog command

daisy_chain_priority:		equ	0xF4
