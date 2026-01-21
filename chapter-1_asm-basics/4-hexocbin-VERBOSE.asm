;? Ten program wypisuje liczbę w systemie
;? binarnym, ósemkowym i szesnastkowym
; Jest to przykład programu wywołującego
; większą ilość procedur.

global _start

section .text
    _start:

    mov bl, [x]     ;przepisujemy wartość pod adresem x do 
                    ;rejestru al. Kwadratowe nawiasy [] mówią 
                    ;żeby przepisać wartość, a nie adres 
                    ;zmiennej x
                    ;* pod adresem x - liczba któremy chcą wypisać

    ; wpisujemy reprezentacje liczby x do bufferów
    ; przy użyciu odpowiednich procedur
    mov al, bl      ;wpisujemy liczbę do al, wymaga tego procedura
    call bin        ;wołamy procedurę bin

    mov al, bl      ;przywracamy liczbę do al, wymaga tego procedura
    call oct        ;wołamy procedurę oct

    mov al, bl      ;przywracamy liczbę do al, wymaga tego procedura
    call hex        ;wołamy procedurę hex

    ;sys_write - ;? lekcja 1
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_bin
    mov rdx, 9
    syscall

    ;sys_write - ;? lekcja 1
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_oct
    mov rdx, 4
    syscall

    ;sys_write - ;? lekcja 1
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_hex
    mov rdx, 3
    syscall

    ;sys_exit - ;? lekcja 0
    mov rax, 60
    xor rdi, rdi
    syscall

    ;!procedury

;*      Procedura BIN
; Procedura bin bierze liczbę w al i w zmiennej buf_bin
; zapisuje reprezentację tej liczby w systemie binarnym
; jako ciąg znaków.
;
; Procedura ta, w przeciwieństwie do OCT robi to w sposób
; bardziej automatyczny, używając pętlę. Przy każdym okrążeniu
; bierze bit z lewej i wpisuje go do bin_buf, po czym przesuwa
; całą liczbę w lewo, dzięki czemu ma dostęp do następnego bitu.
;
;* żeby procedura bin działała, musimy najpierw wstawić tą
;* liczbę do al, co robimy wyżej przed zawołaniem.
;* wymaga też zarezerwowanej zmiennej buf_bin o 8 znakach, co
;* robimy w sekcji .data
    bin:
        mov bl, al      ;zapisujemy liczbę na później ;*[przypis 0]
        xor rcx, rcx    ;zerujemy rejestr rcx ;*[przypis 1]
                        ;użyjemy go jako iteratora w pętli bin_loop
        bin_loop:
            test al, 128    ;sprawdzamy czy pierwszy od lewej bit to 1
            jnz set1        ;jeśli tak, skocz do adresu "set1"
            mov byte [buf_bin+rcx], '0' ;jeśli nie, wstaw do buf_bin '0'
                                        ;z offsetem podanym w rcx
            jmp reset       ;skocz do adresu "reset"

            set1:
            mov byte [buf_bin+rcx], '1' ;wstaw '1' do buf_bin z offsetem w rcx

            reset:
            shl al, 1       ;przesuń liczbę w rejestrze al
            inc cl          ;zwiększ iterator w rcx
            cmp cl, 8       ;sprawdź czy cl == 8
            jl bin_loop     ;("jump less") jeśli cl < 8, skocz do początku pętli

    ret     ;zakończ procedurę i wróc do adresu z którego ją zawołano


;*      Procedura OCT
;?  zostala omówiona w lekcji 3
;* wymaga liczby do wypisania w al i 3 znakowego buffera buf_oct
    oct:
        mov bl, al ;zapisujemy liczbę żeby móc ją przywrócić
    ;! pierwsza cyfra od lewej
        shr al, 6
        add al, 48
        mov [buf_oct], al

    ;! druga cyfra od lewej
        mov al, bl
        shr al, 3
        and al, 7
        add al, 48
        mov byte [buf_oct+1], al

    ;! trzecia cyfra od lewej
        mov al, bl
        and al, 7
        add al, 48
        mov byte [buf_oct+2], al

    ret ;zakończ procedurę i wróc do adresu z którego ją zawołano

;*      Procedura HEX
; Tu zaczynają się większe schody, ponieważ w znakach ASCII
; istnieje pewien odstęp między cyframi '0'-'9' (wartości 48-57)
; a znakami A-Z (65-90) lub a-z (97-122)
;
; Dla cyfr 0-255 potrzebujemy tylko stworzyć 2 cyfry dla
; systemu szesnastkowego. Wykorzystamy drugą procedurę do pomocy
; z porównywaniem wartości by sprawdzić czy należy do '0'-'9'
; czy 'A'-'F' i wstawianiem ich do buffera.
;
;* wymaga liczby w al, 2 bajtowego buffera buf_hex i procedury hex_cmp
    hex:
        mov bl, al      ;zapisujemy liczbę na później

        ;! cyfra z lewej
        and al, 15      ;operacja AND na wartości al i liczbie 1111
                        ;spowoduje to usunięcie 4 bitów z lewej
                        ; (zmienienie ich w 0)

        mov rcx, 1      ;wymagane przez hex_cmp, który wstawi
                        ;cyfrę na drugą pozycję w buf_hex
        call hex_cmp    ;wołamy procedurę pomocniczą hex_cmp

        ;! cyfra z prawej
        mov al, bl      ;przywracamy liczbę do al
        shr al, 4       ;przesuwamy al o 4 bity w prawo,
                        ;pozwoli to dostać się nam do 2 cyfry
                        ;dla systemu szesnastkowego
        mov cl, 0       ;wymagane przez buf_hex, wstawi znak na początek buf_hex
        call hex_cmp    ;wołamy procedurę pomocniczą hex_cmp

    ret

;* procedura pomocnicza do HEX_CMP
; sprawdza czy liczba w  al jest większa od 10.
; jeśli tak, wstawi znak od 'A'
; jeśli nie, wstawi znak z grupy '0'-'9'.
; Procedura wstawia znak do buf_hex, robi to
; z offsetem zapisanym w rejestrze rcx
;* wymaga 4 bitów liczby w al i offsetu w rcx
    hex_cmp:
        cmp al, 10      ;porównaj wartość w al z 10
        jl put_digit    ;jeśli al mniejsze, skocz do put_digit

        ;wstawianie 'A'-'F'
        sub al, 10      ;odejmij 10 od al. Teraz mamy w al tylko offset
                        ;dla cyfr A-F, czyli liczbę od 0 do 5.
                        ;? np. jeśli w al było 15, teraz mamy tam 5
                        
        add al, 'A'     ;dodaj 'A' (65) do al
                        ;? 'A' + 6 = 'F', czyli 15 w szesnastkowym
        jmp add_buf     ;skocz do add_buf

        ;wstawianie '0'-'9'
        put_digit:
        add al, '0'     ;dodajemy '0' do al
                        ;uzyskamy w ten sposób reprezentację cyfry 0-9
                        ;w ASCII, czyli '0'-'9'

        ;wstawianie znaku do buffera
        add_buf:
        mov [buf_hex+rcx], al   ;dodajemy znak który uzykaliśmy do buffera
                                ;tutaj, rcx pomaga nam zrobić to w
                                ;odpowiednim miejscu
    ret


;! data
section .data
    x: db 0b01101111            ;definiujemy liczbę 111
    buf_oct: db '***', 10       ;tworzymy 3 buffery dla
    buf_bin: db '********', 10  ;reprezentacji powyższej liczby
    buf_hex: db '**', 10        ;jako stringi

;! PRZYPISY
    ;*[0] - mov bl, al
;? wstawienie wartości z rejestru al do bl
; technicznie w tym programie nie jest to wymagane, ponieważ 
; zapisujemy tą liczbę w bl już na początku programu, lecz 
; zostawiłem to by zwrócić uwagę na to żeby zapisywać wartości
; i uważać żeby nie zostały nadpisane, +żeby można było łatwo
; skopiować powyższe procedury bez potrzebu dużego setupu
;-----------------------------------------------------------------

    ;*[1] - xor rcx, rcx
;? przeprowadzenie operacji xor na rejestrze rcx z nim samym
;? (taka operacja zawsze zwróci 0)
; podczas pisania tego programu sam spotkałem się z pewnym bugiem,
; który powodował segfault jeśli procedura bin została wywołana
; po wykonaniu sys_write.
; Mój program wywoływał wtedy `mov cl, 0` zamiast `xor rcx, rcx`.
; Spowodowane to było tym, że sys_write zostawiało w rcx jakąś wartość,
; a samo `mov cl, 0` działa tylko na pierwszym bajcie rejestru rcx.
; zatem, rejestr nie był wyzerowany tak jak na początku myślałem, i 
; w linijce `mov byte [buf_bin+rcx], '0'` program próbował zmodyfikować
; wartość poza zarezerwowaną, co było dla systemu operacyjnego oburzające.
; Innym sposobem na naprawienie tego bugu byłoby użycie `mov rcx, 0` co
; wstawiło by 0 do CAŁEGO rejestru. Operacja xor jest jednak szybsza.
