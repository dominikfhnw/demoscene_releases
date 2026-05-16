%if 0
set -e;OUT=${0%%.*};nasm "$0" -o "$OUT";chmod +x "$OUT";objdas2 "$OUT"||:;ls -l "$OUT";exit
%endif

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
mov	ecx, esp

.loop:
inc	edx
lea	eax, [esi+4]
int	0x80			; write(FD, *esp, len++)

jmp	.loop
