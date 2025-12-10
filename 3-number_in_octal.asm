;? Ten program wypisuje liczbę w systemie ósemkowym
global _start

section .text
    _start:

    ; wypisujemy liczbę x w systemie ósemkowym
    mov al, [x]
    call oct        ; wołamy procedurę oct

    ; sys_exit
    mov rax, 60
    xor rdi, rdi
    syscall

    oct:
        mov al, bl      ;zapisujemy na później

        ;wydobywamy pierwsze 2 bity z lewej
        ;i zapisujemy je w buforze na pozycji 0
        ;jako cyfrę
        shr al, 6       ;shr - shift right
        add al, 48      ; 48 == '0'
        mov [buf], al

        ;wydobywamy 3 bity ze środka
        ;i zapisujemy w buforze na pozycji 1
        ;jako cyfrę
        mov al, bl      ;przywracamy wartość do al
        shr al, 3
        and al, 7
        add al, 48
        mov byte [buf+1], al

        ;wydobywamy 3 bity z końca
        ;i zapisujemy w buforze na pozycji 1
        ;jako cyfrę
        mov al, bl
        and al, 7
        add al, 48
        mov byte [buf+2], al

        ; sys_write
        mov rax, 1
        mov rdi, 1
        mov rsi, buf
        mov rdx, 4
        syscall

        ret

section .data
    x: db 0b01011100   ;liczba zapisana binarnie ( 0bLICZBA )
    buf: db '***', 10