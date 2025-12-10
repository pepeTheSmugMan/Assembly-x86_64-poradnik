;? ten program pobiera napis od użytkownika
;? następnie przemienia jego wszystkie litery
;? wielkie na małe
global _start

section .text
    _start:

    ; sys_read
    xor rax, rax
    xor rdi, rdi
    mov rsi, buf
    mov rdx, 80
    syscall

    ; modyfikacja wartości buffora do małych liter
    mov rbx, rax        ; zachowujemy wartość w rax na później
    dec rbx
    _loop:
        or byte [buf + rbx - 1], 0x20   ; operacja OR na znaku w buforze a 32
        dec rbx
        jnz _loop
    
    ; sys_write
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    syscall

    ; sys_exit
    mov rax, 60
    xor rsi, rsi
    syscall

section .data
    buf: times 80 db '*'    ; buffer
