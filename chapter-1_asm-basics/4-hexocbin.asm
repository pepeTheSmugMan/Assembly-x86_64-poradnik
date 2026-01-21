;? Ten program wypisuje liczbę w systemie
;? binarnym, ósemkowym i szesnastkowym

global _start

section .text
    _start:

    mov bl, [x]     ;pod adresem x - liczba któremy chcą wypisać

    ; wpisujemy reprezentacje liczby x do bufferów
    ; przy użyciu odpowiednich procedur
    mov al, bl  
    call bin

    mov al, bl
    call oct

    mov al, bl
    call hex

    ;sys_write
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_bin
    mov rdx, 9
    syscall

    ;sys_write
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_oct
    mov rdx, 4
    syscall

    ;sys_write
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_hex
    mov rdx, 3
    syscall

    ;sys_exit
    mov rax, 60
    xor rdi, rdi
    syscall

    ;!procedury

;*      Procedura BIN
; Przepisuje liczbę z al do buf_bin w systemie binarnym
;* wymaga liczby w al i 8 bajtowego buf_bin
    bin:
        mov bl, al      ;zapisujemy liczbę na później 
        xor rcx, rcx    ;rcx będzie iteratorem dla bin_loop

        bin_loop:
            test al, 128    ;sprawdzamy czy pierwszy od lewej bit to 1
            jnz set1        
            mov byte [buf_bin+rcx], '0' ;jeśli nie, wstaw do buf_bin '0'
            jmp reset

            set1:
            mov byte [buf_bin+rcx], '1' ;jeśli tak, wstaw do buf_bin '1'

            reset:
            shl al, 1       ;idziemy do kolejnego bitu
            inc cl          ;zwiększ iterator w rcx
            cmp cl, 8       ;skończ pętlę przy cl == 8
            jl bin_loop

    ret


;*      Procedura OCT
; Przepisuje liczbę z al do buf_oct w systemie ósemkowym
;* wymaga liczby do wypisania w al i 3 znakowego buffera buf_oct
    oct:
        mov bl, al ;zapisujemy liczbę żeby móc ją przywrócić
    ; pierwsza cyfra od lewej
        shr al, 6
        add al, 48
        mov [buf_oct], al

    ; druga cyfra od lewej
        mov al, bl
        shr al, 3
        and al, 7
        add al, 48
        mov byte [buf_oct+1], al

    ; trzecia cyfra od lewej
        mov al, bl
        and al, 7
        add al, 48
        mov byte [buf_oct+2], al

    ret ;zakończ procedurę i wróc do adresu z którego ją zawołano

;*      Procedura HEX
; Przepisuje liczbę z al do buf_hex w systemie szesnastkowym
;* wymaga liczby w al, 2 bajtowego buffera buf_hex i procedury hex_cmp
    hex:
        mov bl, al      ;zapisujemy liczbę na później

        ; cyfra z lewej
        and al, 15      ;usuwamy 4 bity z lewej
        mov rcx, 1      ;wymagane przez hex_cmp
        call hex_cmp    ;wołamy procedurę pomocniczą hex_cmp

        ; cyfra z prawej
        mov al, bl      ;przywracamy liczbę do al
        shr al, 4       ;przesuwamy al o 4 bity w prawo
        mov cl, 0       ;wymagane przez buf_hex
        call hex_cmp    ;wołamy procedurę pomocniczą hex_cmp

    ret

;* procedura pomocnicza do HEX_CMP
; sprawdza czy liczba w  al jest większa od 10.
; i wstawia do buf_hex '0'-'9' lub 'A'-'F'
;* wymaga 4 bitów liczby w al i offsetu w rcx
    hex_cmp:
        cmp al, 10      ;porównaj wartość w al z 10
        jl put_digit    ;jeśli al mniejsze, skocz do put_digit

        ;wstawianie 'A'-'F'
        sub al, 10      
        add al, 'A'     
        jmp add_buf     

        ;wstawianie '0'-'9'
        put_digit:
        add al, '0'    

        add_buf:
        mov [buf_hex+rcx], al   ;dodajemy znak który uzykaliśmy do buffera z offsetem w rcx
    ret


;! data
section .data
    x: db 0b01101111            ;tą liczbę wydrukujemy
    buf_oct: db '***', 10       ;tworzymy 3 buffery dla
    buf_bin: db '********', 10  ;reprezentacji powyższej liczby
    buf_hex: db '**', 10        ;jako stringi