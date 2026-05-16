%if 0
set -e;OUT=${0%%.*};nasm "$0" -o "$OUT";chmod +x "$OUT";objdas2 "$OUT"||:;ls -l "$OUT";exit
%endif
; Sea of Holes
; 64b executable graphics for Linux
; by dominikr ^ dSr
; Released at Outline 2026
; ------------------------
;
; transmission from a far away world
;
; first 64b prod for linux featuring framebuffer graphics

BITS 32
org 0x10000
%assign OFF `D\r`		; dominikr / Desire
dd `\x7fELF`, 1, OFF, $$+OFF, 0x60002, _start, _start, 4

fb: db "/dev/fb0", 0		; address 0x10020

_start:
mov	ebx, fb			; this is also the rest of the ELF and program header
mov	al, 5
inc	ecx
int	0x80
xchg	eax, ebx		; ebx = open(*0x10020, O_WRONLY)


push	ebx			; make slightly thicker features, and fill up to 64b
push	ebx			; HellMood thinks those bytes could be used for
				; making some kind of effect, but he still owes me
				; the proof :)
mov	ecx, esp		; the stack - source of free data

.loop:
inc	edx
lea	eax, [esi+4]
int	0x80			; write(FD, *esp, len++)

jmp	.loop

; as already said in the README... about 32b is taken by the headers, 20b just
; for opening /dev/fb0.
; Leaves about 12 bytes for "graphics". An mmap() to map the framebuffer into
; memory would take up all those bytes.
; So instead, the graphics are purely an interference pattern that happens
; when you do a while(1){ write(FD, *esp, len++); }
; This has also the nice side-effect that syscalls do not create segfaults.
; There's no room for any error handling and/or exit conditions.
; The program just tries to write more data to the framebuffer device, even
; if len is bigger than the stack, or the end of the fb is reached.
; But that's for the Kernel to worry about.
