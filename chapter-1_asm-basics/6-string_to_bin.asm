global _start

;! ||||||||||||||||||||||||||
;! |||       UWAGA        |||
;! ||||||||||||||||||||||||||
;! Tego jeszcze nie zdążyłem opracować

section .text
_start:

mov rbx, str
call str_to_num

mov al, dil
call bin

mov rax, 60
xor rdi,rdi
syscall

; FUNCTIONS
str_to_num:
mov al, [rbx] 
xor dil, dil        ;8 bit

sub al, '0'
shl al, 6
add dil, al
shr al, 1
add dil, al
shr al, 3
add dil, al

mov al, [rbx+1]
sub al, '0'
add dil, al
add dil, al
shl al, 3
add dil, al

mov al, [rbx+2]
sub al, '0'
add dil, al

ret



bin:
mov rcx, 0

loop:
test al, 128
jnz set1
mov byte [buf+rcx], '0'
jmp reset

set1:
mov byte [buf+rcx], '1'

reset:
shl al, 1
inc cl
cmp cl, 8
jl loop

mov rax, 1
mov rdi, 1
mov rsi, buf
mov rdx, 9
syscall

ret

section .data
str: db "123", 10
buf: db '********', 10