;? ten program wypisuje w konsoli "Hello world" z newlinem
global _start

section .text
    _start:

    ; sys_write
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    ; sys_exit
    mov rax, 60
    xor rdi, rdi
    syscall

section .data   ; zmienne
    msg: db 'Hello world', 10   ; ciąg bajtów zdefiniowany
                                ; podczas kompilacji
    msg_len: equ $-msg          ; długość ciągu msg