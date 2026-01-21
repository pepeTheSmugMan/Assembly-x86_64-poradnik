;? ten program pobiera napis od użytkownika
;? następnie przemienia jego wszystkie litery
;? wielkie na małe
;       Nauczymy się o:
; -operacji SYS_READ
; -modyfikowaniu wartości znaku ASCII operacją logiczną
; -flagach, oraz pętlach i skokach warunkowych

global _start

section .text
    _start:

    ;! pobieranie wejścia od użytkownika
    xor rax, rax        ; 0 - instrukcja SYS_READ (czytanie)
    xor rdi, rdi        ; 0 - standardowe wejście (STDOUT)
    mov rsi, buf        ; adres w pamięci do którego zapisać wiadomość
    mov rdx, 80         ; maksymalna długość wiadomości
    syscall             ; wołanie systemu
    ;? powyższa instrukcja wczyta od użytkownika (maksymalnie 80)
    ;? znaków ASCII po tym gdy on wciśnie ENTER 
    ;? (znak enter wlicza się do wiadomości)

    ;* System po wykonaniu czytania pozostawi w rejestrze RAX
    ; długość wczytanego napisu, co wykorzystamy w następnym kroku



    ;! Iterowanie przez buffer, zmieniając
    ;! znaki wielkie na małe
    mov rbx, rax        ; przenosimy wartość z rax do rbx
    dec rbx             ; zmniejszamy rbx o 1 (ż)

    _loop:  ; adres pętli
        or byte [buf + rbx - 1], 0x20       ; przeprowadź operację OR 
                                            ; na wartości w pamięci pod adresem:
                                            ;? [adres w buf +
                                            ;?  wartość w rbx +
                                            ;?  offset -1 ]
                                            ; a wartością 32 (zapisaną szesnastkowo)
                                            ;* [przypis 0]

        dec rbx                             ;zmniejsz wartość w RBX o 1
        jnz _loop                           ;*skok warunkowy [przypis 1] do 
                                            ; etykiety _loop
    


    ; sys_write - ;? lekcja 1
    mov rdx, rax        ; długość napisu (znajduje się w RAX)
                        ;? przenosimy ją teraz, zanim nadpiszemy RAX 
                        ;? w następnym roku. Jeśli zrobilibyśmy to
                        ;? po tym, stracilibyśmy tą wartość.
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, buf        ; adres wiadomośći do napisania
    syscall

    ;sys_exit - ;? lekcja 0
    mov rax, 60
    xor rsi, rsi
    syscall

section .data
    buf: times 80 db '*'    ;rezerwujemy 80 bajtów i piszemy do nich *


;! PRZYPISY:
    ;* [0] - or byte [buf + rbx - 1], 0x20
;? or - operacja logiczna OR
;? byte - wielkość którą pobieramy z pamięci (1 bajt)
;? [buf] - adres buffora w którym zapisaliśmy wiadomość
;? [buf + rbx - 1] - adres z uwzględnionym iteratorem i offsetem
;? 0x20 - liczba 32 zapisana w systemie szesnastkowym
;
;* Co robimy w tym fragmencie kodu?
; W tym fragmencie kodu iterujemy po wszystkich bajtach w bufforze.
; Wykorzystujemy do tego wartośc w RBX która jest tutaj iteratorem.
; (coś podobnego do konstrukcji pętli FOR w innych językach).
;       Zaczynamy od końca buffora, i zmniejszamy RBX zbliżając
; się do jego początku. Uwzględniliśmy offset żeby poprawnie wskazywać
; na bajty w pamięci i nie wyjść poza granice buffora.
;       Jeśli przypadkiem wyszlibyśmy poza granice buf,
; spowodowało by to błąd segmentacji pamięci (segfault).
;
;* W jaki sposób zmieniamy znaki wielkie na małe?
; Wszystkie dane w komputerze są zapisane w formie liczb binarnych.
; Liczby wielkie i małe w ASCII różnią się jedynie 1 bitem na pozycji
; 3 od lewej (czyli 32). Np:
;       01000001 - A
;       01100001 - a    ;?( więcej na https://www.ascii-code.com/ )
; Zatem jeśli wykonamy operację OR na 32 bicie i wielkiej literze,
; zamieni się ona w literę mała. Litera mała pozostanie taka sama.
; Powtarzamy to dla wszystkich znaków.

;-----------------------------------------------------------------

    ;* [1] jnz _loop
;? jnz <etykieta> - jump not zero, skok warunkowy
;?                  Skacze on do etykiety jeśli 
;?                  flaga CF nie wynosi 0
;
;* Czym są flag procesora?
; Procesor wyposażony jest we flagi kontrolne.
; Są to takie jakby booleany, które mogą przyjąc wartości 0 (fałsz)
; lub 1 (prawda) w zależności od wyniku ostatnio wykonanej operacji.
;       najważniejsze flagi dla nas w tym poradniku to CF, ZF
;? ZF - Zero Flag - mówi czy wynikiem ostatniej operacji było 0
;? CF - Carry Flag - mówi czy wynik ostatniej operacji przekroczył
;?      maksymalny limit (np. 8 bitów) / Czy wydarzył się overflow
;? SF - Sign Flag - Sprawdza znak (+/-) wyniku ostatniej operacji.
;?      1 dla negatywnych, 0 dla pozytywnych
;
;* Czym są skoki warunkowe?
; Skoki warunkowe przenoszą nas do etykiety (wskaźnika w pamięci)
; w zależności od wartości w jakiejś fladze.
;       Za pomocą kombinacji etykiety (np _loop:) i skoku możemy
; stworzyć pętlę warunkową.
;       Przydatne skoki warunkowe:
;? JZ - Jump Zero - Skacze do etykiety jeśli wynik operacji to 0
;? JNZ - Jump Not Zero - przeciwieństwo powyższego
;? JL/JG - Jump Less/Jump Greater - wynik operacji porównania
;?       był mniejszy/większy od liczby do której go porównywaliśmy
;?       (Wykorzystuje flagę SF)
;? JNL/JNG - Jump Not Less/Jump Not Greater - odwrotności powyższych

; istnieje też skok bezwarunkowy:
;? JMP - skocz do danej etykiety, zawsze