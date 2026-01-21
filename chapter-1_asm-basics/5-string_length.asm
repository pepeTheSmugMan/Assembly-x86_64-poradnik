;? Ten program wyszukuje w arrayu indeksu znaków,
;? i oblicza jego długość

;! ||||||||||||||||||||||||||
;! |||       UWAGA        |||
;! ||||||||||||||||||||||||||
;! Tego jeszcze nie zdążyłem opracować

global _start

; policz długość napisu
    ;? musimy wymyslić czym jest zakończenie napisu. np \0
    ;? czyli u nas 0 == NULL
; sprawdź indeks jakiejś litery
; weź input użytkownika

STR_END EQU 0       ;* tak się robi makro

section .text

    _start:

    ; get index
    mov rax, msg
    mov rbx, 'a'
    call index
    call bin

    ; print length
    mov rax, msg
    call len

    ;! exit
    mov rax, 60
    xor rdi, rdi
    syscall

;! FUNCTIONS

    ;* (VOID) returns length of string
    ; (not accounting for \0)
    ; needs:
    ; -string pointer in RAX
    len:
    push rbp
    mov rbp, rsp

        mov rbx, STR_END
        call index
        inc al
        call bin

    mov rsp, rbp
    pop rbp
    ret
    


    ;* (INT) finds index of string
    ; needs:
    ; -string poitner in RAX
    ; -number we're searching for in RBX

    ; leaves:
    ; -length in RAX
    index:
    push rbp
    mov rbp, rsp

        xor rcx, rcx            ;reset the counter

        _iterate:
        cmp [rax + rcx], bl
        jz _iterate_end         ;? NOTATKA Z LEKCJI:
        inc rcx                 ; zazwyczaj pętle mają
        jmp _iterate            ; conajmniej 2 skoki
        _iterate_end:

        mov al, cl

    mov rsp, rbp
    pop rbp
    ret

    ;? z poprzednich zajęć
    ; binary write
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

        ;write
        mov rax, 1
        mov rdi, 1
        mov rsi, buf_bin
        mov rdx, 9
        syscall

    mov rsp, rbp
    pop rbp
    ret


;! DATA
section .data
    msg: db "siema siema", 10, 0
    buf_bin: db '********', 10
