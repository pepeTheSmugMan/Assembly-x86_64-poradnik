;? ten program rozpoczyna się, i kończy.
global _start

    section .text
_start:
    ; sys_exit
    mov rax, 60
    xor rdi, rdi
    mov rdi, 4
    syscall