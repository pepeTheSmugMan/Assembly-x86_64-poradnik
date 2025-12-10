;? Ten program wypisuje liczbę w systemie ósemkowym
;       Nauczymy się o:
; -procedurach
; -manipulacji wartością w rejestrze
; -różnicą między [x] a x

global _start

section .text
    _start:

    ;! użycie procedury oct
    mov al, [x]     ;*wstawiamy wartość liczby z adresu X [przypis 0]
    call oct        ;*wołamy procedurę oct [przypis 1]

    ;sys_exit - ;? lekcja 0
    mov rax, 60
    xor rdi, rdi
    syscall

;*      Procedura OCT
; W assembly znak liczby '1' a rzeczywista wartość 1 to 2 inne rzeczy.
; Jeśli chcemy wypisać '1' na ekran, musimy dodać do 1 znak '0' ('0' == 48).
; Jeśli mamy jednak liczbę 2 cyfrową, musimy bardziej kombinować żeby ją
; wyświetlić, gdyż bazowo w komputerze wszystkie wartości są w binarnym.
;
; Procedura OCT przetwarza liczbę w al na system ósemkowy,
; zapisuje ją po kolei do buffera, i wypisuje buffer.
;
; Robimy to korzystając z własności 2^3 = 8, czyli 3 cyfry
; w systemie binarnym odpowiadają jednej w ósemkowym, np:
;?      bin: 01011100 -> (0)01 | 011 | 100
;?      oct:      134 ->     1 |   3 |   4
; Będziemy modyfikować liczbę 1 bajtową, czyli maksymalnie 3 cyfry

    oct:
        mov bl, al      ;zapisujemy liczbę do bl, żeby jej nie nadpisać

        ;! PIERWSZA CYFRA OD LEWEJ
        shr al, 6       ;*przesuń wartość al o 6 w prawo (shift right)
                        ;? 01011100 --> (000000)01
                        ;takim sposobem zdobywamy pierwsze 3 bity, czyli
                        ;1 cyfrę w systemie ósemkowym

        add al, 48      ;*dodajemy 48, czyli '0'. Synchronizuje to liczbę z
                        ;alfabetem ascii. Np 1 stanie się '1' po dodaniu 48

        mov [buf], al   ;*wstawiamy cyfrę na pierwszą pozycję bufora

        ;! DRUGA CYFRA
        mov al, bl      ;*przywracamy wartość do rejestru al
        shr al, 3       ;przesuwamy w prawo o 3 (pozbywamy się 3 bitów)
                        ;? 01011100 --> (000)01011
        and al, 7       ;*operacja AND wartości w AL i 7
                        ;w ten sposób pozbywamy się bitów poza 3 z prawej
                        ;? 00001|011 AND 00000|111 --> 00000|011
                        ;tak zdobyliśmy drugą cyfrę
        add al, 48
        mov byte [buf+1], al    ;*wstawiamy na drugą pozycję w buforze

        mov al, bl
        and al, 7       ;wydobywamy ostatnią potrzebną cyfrę
                        ;? 01011|100 AND 00000|111 --> 00000|100
        add al, 48
        mov byte [buf+2], al    ;*wstawiamy na trzecią pozycję w buforze

        ; sys_write - ;? lekcja 1
        mov rax, 1
        mov rdi, 1
        mov rsi, buf
        mov rdx, 4
        syscall

        ret     ;! POWRÓT Z PROCEDURY DO KODU KTÓRY JĄ WYWOŁAŁ

section .data
    x: db 0b01011100    ;definiujemy liczbę w systemie binarnym ( 0bLICZBA ), 1 bajt
    buf: db '***', 10   ;tworzymy buffor zakończony znakiem nowej linii (10), 4 bajty


;! PRZYPISY:
    ;*[0] - mov al, [x]
;? mov [miejsce docelowe], [wartość] - operacja wstawienia
;? al - 8 bitowy rejestr al

;-----------------------------------------------------------------

    ;*[1] - call oct - PROCEDURY
;? call - wywołanie procedury
;? oct - nadana przez nas nazwa procedury
; Procedury w assembly to coś na kształt funkcji.
; Po wywołaniu ich, program przemieszcza się do wywołanego
; adresu i wykonuje tam kod.
; Musimy pamiętać by zapewnić procedurze odpowiednie wartości
; w rejestrach i wiedzieć do których rejestrów zapisane zostaną
; wyniki. 

; Według konwencji linuksowej w asm x86_65 (System V AMD64 ABI)
; po zakończeniu procedury, wartości w rejestrach:
;? RBX, RBP, R12, R13, R14, R15 i RSP
; Powinny pozostać takie same jak były na początku (działa też po syscall).
; Natomiast rejestry:
;? RAX, RCX, RDX, RSI, RDI, R8, R9, R10, XMM0-XMM15
; zazwyczaj zostają nadpisane/zwracają wyniki.

; W tym poradniku nie będziemy zaprzątać sobię głowy konwencjami.