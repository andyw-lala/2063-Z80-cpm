;****************************************************************************
;
;	 Copyright (C) 2021 John Winans
;	 Copyright (C) 2026 Andy Warner
;
;	 This library is free software; you can redistribute it and/or
;	 modify it under the terms of the GNU Lesser General Public
;	 License as published by the Free Software Foundation; either
;	 version 2.1 of the License, or (at your option) any later version.
;
;	 This library is distributed in the hope that it will be useful,
;	 but WITHOUT ANY WARRANTY; without even the implied warranty of
;	 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;	 Lesser General Public License for more details.
;
;	 You should have received a copy of the GNU Lesser General Public
;	 License along with this library; if not, write to the Free Software
;	 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301
;	 USA
;
;****************************************************************************

; Drivers for the SIO 

; CTC values as baud rate generators
; CTC 2 => SIO A
; CTC 3 => SIO B
; CTC clock is 1.8432MHz

.ctc_baud_mode:		equ	01000111b	; Count/TC follows/Resume

; Time Constant values for common baud rates.
.baud_115200:		equ	1		; 115200
.baud_57600:		equ	2		;  57600
.baud_38400:		equ	3		;  38400
.baud_19200:		equ	6		;  19200
.baud_9600:		equ	12		;   9600
.baud_4800:		equ	24		;   4800
.baud_2400:		equ	48		;   2400
.baud_1200:		equ	96		;   1200

; Set default baud rate per port here.
.sio_baud_a:		equ	.baud_115200
.sio_baud_b:		equ	.baud_115200

;##############################################################
; Return NZ if sio A tx is ready
; Clobbers: AF
;##############################################################
sioa_tx_ready:
	in	a,(sio_ac)	; read sio control status byte
	and	4		; check the xmtr empty bit
	ret			; a = 0 = not ready

;##############################################################
; Return NZ if sio B tx is ready
; Clobbers: AF
;##############################################################
siob_tx_ready:
	in	a,(sio_bc)	; read sio control status byte
	and	4		; check the xmtr empty bit
	ret			; a = 0 = not ready

;##############################################################
; Return NZ (with A=1) if sio A rx is ready and Z (with A=0) if not ready.
; Clobbers: AF
;##############################################################
sioa_rx_ready:
	in	a,(sio_ac)	; read sio control status byte
	and	1		; check the rcvr ready bit
	ret			; 0 = not ready

;##############################################################
; Return NZ (with A=1) if sio B rx is ready and Z (with A=0) if not ready. 
; Clobbers: AF
;##############################################################
siob_rx_ready:
	in	a,(sio_bc)	; read sio control status byte
	and	1		; check the rcvr ready bit
	ret			; 0 = not ready



;##############################################################
; init SIO port A/B
; Clobbers HL, BC, AF
;##############################################################
siob_init:
	ld	c,ctc_3		; CTC channel to use for baud rate generator
	ld	b,.sio_baud_b	; default baud rate
	call	.baud_init	; set up baud rate generator

	ld	c,sio_bc	; port to write into (port B control)
	jp	.sio_init

sioa_init:
	ld	c,ctc_2		; CTC channel to use for baud rate generator
	ld	b,.sio_baud_a	; default baud rate
	call	.baud_init	; set up baud rate generator

	ld	c,sio_ac	; port to write into (port A control)

.sio_init:
	ld	hl,.sio_init_wr	; point to init string
	ld	b,.sio_init_len_wr ; number of bytes to send
	otir			; write B bytes from (HL) into port in the C reg
	ret

;##############################################################
; Initialization string for the Z80 SIO
;##############################################################
.sio_init_wr:
	db	00011000b	; wr0 = reset everything
	db	00000100b	; wr0 = select reg 4
	db	01000100b	; wr4 = /16 N1 (115200 from 1.8432 MHZ clk)
	db	00000011b	; wr0 = select reg 3
	db	11000001b	; wr3 = RX enable, 8 bits/char
	db	00000101b	; wr0 = select reg 5
	db	01101000b	; wr5 = DTR=0, TX enable, 8 bits/char
.sio_init_len_wr:   equ $-.sio_init_wr

;	Set up a CTC channel as a baud rate generator
;	c = CTC port to use (ctc_2 or ctc_3)
;	b = TC resulting in desired baud rate
.baud_init:
	ld	a,.ctc_baud_mode	; this had TC follows bit set.
	out	(c),a
	nop
	out	(c),b
	ret

;##############################################################
; Wait for the transmitter to become ready and then
; print the character in the C register.
; Clobbers: AF
;##############################################################
siob_tx_char:
	call	siob_tx_ready
	jr	z,siob_tx_char
	ld	a,c
	out	(sio_bd),a	; send the character
	ret

sioa_tx_char:
	call	sioa_tx_ready
	jr	z,sioa_tx_char
	ld	a,c
	out	(sio_ad),a	; send the character
	ret

;##############################################################
; Wait for the receiver to become ready and then return the 
; character in the A register.
; Clobbers: AF
;##############################################################
siob_rx_char:
	call	siob_rx_ready
	jr	z,siob_rx_char
	in	a,(sio_bd)
	ret

sioa_rx_char:
	call	sioa_rx_ready
	jr	z,sioa_rx_char
	in	a,(sio_ad)
	ret
