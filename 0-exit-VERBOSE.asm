;? ten program rozpoczyna się, i kończy.
;       Nauczymy się o:
; -podstawach assemblera (np. rejestry)
; -instrukcji wyjścia
; -sekcji .text
; -segmentation fault

;program należy rozpocząć od wskaźnika _start potrzebnego do programu scalającego 
global _start   ;! ADRES START (etykieta, wskazuje na adres w pamięci/programie)

;* sekcja .text - w niej znajdują się instrukcje programu
    section .text
_start:             ;! ADRES START - tutaj rozpocznie się wykonywanie programu


;? w assembly musimy samemu napisać instrukcję wyjścia z programu.
;? Robimy to dlatego, żeby komputer wiedział kiedy jest jego koniec.
;? Jeśli tego nie zrobimy, komputer spróbuje poruszać się naprzód w pamięci
;? już poza naszym programem, co spowoduje segmentation fault.
;?
;? Segmentation fault to sytuacja w której próbujemy użyć pamięci do której
;? dostępu nie udzielił nam system operacyjny.

; powrót do systemu
    mov rax, 60     ;* wstaw 60 do rejestru RAX [przypis 0]
    xor rdi, rdi    ;* wykonaj operację XOR na rejestrze RDI z samym sobą
                    ;* [przypis 1]
    syscall         ; zawołaj system operacyjny żeby coś zrobił

;* co stało się powyżej?
;? wstawiliśmy odpowiednie liczby do odpowiednich rejestrów procesora,
;? po czym wywołaliśmy system operacyjny (syscall).
;? Kiedy system zobaczy w rejestrach te liczby, to wie już co zrobić.
;? W tym przypadku oznaczają one:
;?
;  RAX = 60 - operacja wyjścia
;  RDI = 0  - kod zakończenia programu
;               (można go wyświetlić za pomocą `echo $?`
;               po wywołaniu programu)
;?
;? Argumenty w assembly x86_64 podaje się do systemu w kolejności:
;  RAX, RDI, RSI, RDX, RCX, R9



;! PRZYPISY
    ;* [0] REJESTRY
; Rejestry to miejsca w rdzeniu procesora w którym tymczasowo
; przechowywane są wartości. Można na tych wartościach wykonywać
; różne operacje.
; Poszeczególne rejestry mają różne zadania i tradycyjne wykorzystania,
; które zależą od innych konwencji/programów/systemów operacyjnych.
; np. W rejestrze RAX wstawiamy numer operacji o wykonanie której
; prosimy system (wywołaniem syscall).

; Pierwsze rejestry (a,b,c...) mają wersje 8, 16, 32 i 64 bitowe. Np:
;? RAX - 64 bit (8 bajtów)
;? EAX - 32 bit (4 bajty)
;? AX - 16 bit (2 bajty)
;? AH, AL - 8 bit (1 bajt)
;jeden rejestr RAX możemy podzielić na kilka, zależnie od wielkośći.
; Nie są jednak to zupełnie inne miejsca, rejestry większe są po prostu
; rozszerzeniem tych mniejszych, jak tutaj:
; |RAX                                      | rejestr rax
; |RAX                |EAX                  | rejestr eax (1/2 raxa)
; |RAX                |AX       |AH    |AL  | składowe rejestru eax

;-----------------------------------------------------------------

    ;* [1] DLACZEGO "xor rdi, rdi" ?
; żeby wstawić do rejestru rdi 0.
; Można by zrobić to samo instrukcją 'mov rdi, 0'
; jednak przyjęło się to robić za pomocą xor,
; ponieważ procesor wykonuje operacje logiczne
; najszybciej.
;
; Jeśli chcemy jednak zwrócić inny kod wyjścia niż 0,
; używamy zazwyczaj mov rdi, (kod wyjścia)