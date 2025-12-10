;? Ten program wypisuje liczbę w systemie
;? binarnym, ósemkowym i szesnastkowym

;! ||||||||||||||||||||||||||
;! |||       UWAGA        |||
;! ||||||||||||||||||||||||||
;! Tego jeszcze nie zdążyłem opracować

global _start
; three programs oct, bin, hex

section .text
    _start:

    mov bl, [x]     ;save value for later use

    ;call the buffer modyfying functions
    mov al, bl
    call bin

    mov al, bl
    call oct

    mov al, bl
    call hex

    ;write BINARY
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_bin
    mov rdx, 9
    syscall

    ;write OCTAL
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_oct
    mov rdx, 4
    syscall

    ;write HEXADECIMAL
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_hex
    mov rdx, 3
    syscall

;! BUG: when hex used after sys_write, it segfaults
;* SOLUTION: changed 'mov cl, 1' to 'mov rcx, 1'
; seems like syscal was leaving something in the rcx register
; that was bigger than the 1st byte

    ;!exit
    mov rax, 60
    xor rdi, rdi
    syscall

    ;!functions

    bin:
    push rbp
    mov rbp, rsp

        mov rcx, 0
        bin_loop:
        test al, 128
        jnz set1
        mov byte [buf_bin+rcx], '0'
        jmp reset

        set1:
        mov byte [buf_bin+rcx], '1'

        reset:
        shl al, 1
        inc cl
        cmp cl, 8
        jl bin_loop

    mov rsp, rbp
    pop rbp
    ret


    ; PUTS oct OF NUMBER IN al INTO buf_oct AS ascii
    ; THEN WRITES buf_oct TO STDOUT
    oct:
    push rbp
    mov rbp, rsp

        ; modify buffer
        shr al, 6
        add al, 48
        mov [buf_oct], al

        mov al, bl
        shr al, 3
        and al, 7
        add al, 48
        mov byte [buf_oct+1], al

        mov al, bl
        and al, 7
        add al, 48
        mov byte [buf_oct+2], al

    mov rsp, rbp
    pop rbp
    ret

    ; PUTS hex OF NUMBER IN al INTO buf_hex AS ascii
    ; THEN WRITES buf_hex TO STDOUT
    hex:
    push rbp
    mov rbp, rsp

        ;front digit
        and al, 15
        mov rcx, 1      ;! IMPORTANT: rcx not cl, reset
                        ;! all the values after 1st byte
        call hex_cmp

        ;last digit
        mov al, bl
        shr al, 4
        mov cl, 0
        call hex_cmp

    mov rsp, rbp
    pop rbp
    ret

    ; HELPER FUNCTION FOR hex
    hex_cmp:
        cmp al, 10
        jl put_digit
        sub al, 10
        add al, 'A'
        jmp add_buf

        put_digit:
        add al, '0'

        add_buf:
        mov [buf_hex+rcx], al
    ret


;! data
section .data
    x: db 0b01101111
    buf_oct: db '***', 10
    buf_bin: db '********', 10
    buf_hex: db '**', 10