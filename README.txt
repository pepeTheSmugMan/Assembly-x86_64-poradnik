W tym repozytorium zaprezentuję praktyczne przykłady programów assembly x86_64 które pisałem na studiach.
Skupiać się będę bardziej na praktycznym działaniu kodu, ale dodam też trochę o samej architekturze komputerowej która za nim stoi (Jednak tylko tyle żeby zrozumieć kod).

Do użycia ich w praktyce będziesz potrzebować:

-64bitowy system operacyjny linuks
-assembler NASM
-Podstawowa wiedza na temat działania komputerów (czym jest pamięć, bit, bajt lub pętla warunkowa)
-Podstawy wiedzy z matematyki wykorzystywanej w informatyce (Algebra Boole'a [operacje logiczne], systemy liczbowe [np. binarny])

żeby zasemblować i uruchomić przykłady programów, należy posłużyć się poniższymi komendami:

nasm -f elf64 <nazwa pliku>.asm
ld <nazwa pliku>.o -o <nazwa którą chcesz nadać>
./<nadana nazwa>

np.

nasm -f elf64 main.asm
ld main.o -o main
./main

Każdy z przykładowych programów będzie podany w 2 wersjach, zwykłej i verbose.
Wersja zwykła będzie posiadać jedynie minimalną ilość komentarzy, podczas gdy w verbose postaram się opisać jak najwięcej.
Jeśli używasz VSCode do przeglądania kodu, przydać ci się może rozszerzenie "better comments" którego używałem do kolorowania komentarzy.

Na początku każdego pliku VERBOSE przedstawię jego cele, i nowe operacje które wykorzystuje.
Zachęcam do indywidualnego eksperymentowania z programami, np. pisania własnych elementów/zmieniania istniejących.