;? ten program wypisuje w konsoli "Hello world" z newlinem
;       Nauczymy się o:
; -instrukcji SYS_WRITE
; -sekcji .data
; -dodatkowe info o rezerwowaniu pamięci

global _start

;* sekcja text - kod programu
section .text
    _start:

    ;!wysłanie napisu do stdout
    mov rax, 1          ; 1 - intrukcja SYS_WRITE (pisanie)
    mov rdi, 1          ; 1 - standardowe wyjście (STDOUT)
    mov rsi, msg        ; adres napisu z którego czytać wiadomość
    mov rdx, msg_len    ; długość napisu
    syscall             ; wołamy system który wie co zrobić,
                        ; dzięki liczbom w rejestrach.

    ;sys_exit - ;? lekcja 0
    mov rax, 60         ; 60 - SYS_EXIT
    xor rdi, rdi        ; kod zakończenia 0 -
                        ; pomyślnie zakończony program
    syscall             ; wołamy system


;! sekcja .data - tutaj rezerwujemy pamięć
; w sekcji data rezerwujemy pamięć dla zmiennych
; które inicjujemy już na początku działania programu.
;
;? Niektórzy mówią że w .data definiujemy stałe.
; To nieprawda, możemy je modyfikować za pomocą kodu.
section .data
    msg: db 'Hello world', 10   ; pod etykietą "msg", zdefiniuj bajty:
                                ; kolejno 'Hello world' i 10 (newline)
    ;* Tutaj tworzymy napis który jest ciągiem bajtów w pamięci kolejno po sobie.
    ; db - define byte (po 1 bajcie - 8 bitów)
    ; możemy też używać:
    ; dw - define word (2 bajty - 16 bitów)
    ; dd - define doubleword (4 bajty - 32 bity)
    ; dq - define quadword (8 bajtów - 64 bity)
    ;
    ; każdy znak ASCII (char) to 1 bajt

    msg_len: equ $-msg      ; pod etykietą msg_len zdefiniuj:
                            ; wartość aktualnego adresu ($)
                            ; odjąć
                            ; adres początku wiadomości msg
    ;* Tutaj definiujemy długość napisu msg.
    ; $ - wskazuje na aktualny adres w programie, który po
    ; stworzeniu zmiennej msg będzie wskazywać na jej koniec.
    ; Odejmując zatem koniec msg od jej początku, otrzymamy długość.