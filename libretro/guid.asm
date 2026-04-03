;****************************************************************************
;
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

;
; GUID support routines:
; - print/dump
; - compare
;
; GUIDs (at least as used in GUID partition tables are mixed-endianness
; beasts. This does not matter for comparison purposes, but makes printing
; them "interesting". See https://en.wikipedia.org/wiki/GUID_Partition_Table

;#############################################################################
; Dump the GUID pointed to by IX (consider passing in HL)
; Clobbers a,c
;#############################################################################
print_guid:
	ld	a,(ix + 3)		; Print first 4 bytes (8 digits)
	call	hexdump_a		; in big endian
	ld	a,(ix + 2)
	call	hexdump_a
	ld	a,(ix + 1)
	call	hexdump_a
	ld	a,(ix + 0)
	call	hexdump_a
	ld	c,'-'			; First hyphen
	call	con_tx_char
	ld	a,(ix + 5)		; Print next 2 bytes also
	call	hexdump_a		; in big endian
	ld	a,(ix + 4)
	call	hexdump_a
	ld	c,'-'			; Second hyphen
	call	con_tx_char
	ld	a,(ix + 7)		; Print next 2 bytes also
	call	hexdump_a		; in big endian
	ld	a,(ix + 6)
	call	hexdump_a
	ld	c,'-'			; Third hyphen
	call	con_tx_char
	ld	a,(ix + 8)		; Print next stanza little endian
	call	hexdump_a
	ld	a,(ix + 9)
	call	hexdump_a
	ld	c,'-'			; Fourth hyphen
	call	con_tx_char
	ld	a,(ix + 10)		; Print last stanza little endian
	call	hexdump_a
	ld	a,(ix + 11)
	call	hexdump_a
	ld	a,(ix + 12)
	call	hexdump_a
	ld	a,(ix + 13)
	call	hexdump_a
	ld	a,(ix + 14)
	call	hexdump_a
	ld	a,(ix + 15)
	call	hexdump_a
	ret

;#############################################################################
; Compare two GUIDs (addresses passed in HL & DE)
; Z iff equal, NZ otherwise.
; Clobbers A, B, DE, HL
;#############################################################################
compare_guid:
	ld	b,16

.cmp_guid_1:
	ld	a,(de)
	sub	(hl)			; Test this byte (no carry)
	ret	nz			; Return on first error

	dec	b
	ret	z			; Zero for loop count without finding
					; a mismatch is a perfectly good return
	inc	hl			; Move onto next byte
	inc	de
	jr	.cmp_guid_1

