codesg    SEGMENT PARA 'all'
          ORG 100h
		  ASSUME CS:codesg, DS:codesg, SS:codesg


START:    JMP fibprime
prime     DW 15 DUP(0)       ; asal sayilarin tutulacagi dizi.
nonprime  DW 15 DUP(0)       ; asal olmayan sayilarin tutulacagi dizi.
n         DW 20              ; ilk kac sayinin hesaplanacagi bilgisi.
number1   DW 0               ; birinci fib sayisi.
number2   DW 1               ; ikinci fib sayisi.
divby     DW (?)             ; asal sayi kontrolunda kullanilacak bolme degerleri.
FIBPRIME PROC NEAR           ; com tipi program icin baslama komutu.
          XOR SI, SI         ; asal sayilarin tutulacagi dizi icin sayacin sifirlanmasi.
		  XOR DI, DI         ; asal olmayan sayilarin tutulacagi dizi icin sayacin sifirlanmasi.
          MOV CX, n          ; dongunun 20 defa donmesi icin n sayisinin cx'e alinmasi.
L1:		  TEST CX, 1         ; cx tek mi cift mi kontrolu (ciftse, bx icine number1; tekse bx icine number2 aliniyor).
		  JNZ ODD            ; cx tekse dallanir.
		  MOV BX, number1    ; tek degilse bx icine number1 degerini alinir.
		  JMP ISPRIME        ; asallik kontrolu kismina dallanir.
ODD:      MOV BX, number2    ; cx tekse bx'e number2 degerini alinir.
ISPRIME:  MOV divby, BX      ; bx registerindeki fib sayisini divby degerine atanir.
          SHR divby, 1       ; sayi ikiye bolunur.
          JNC NOPRIME        ; carry yoksa sayi cift oldugundan kontrol dongusune girmeden dallanma yapilir.
          CMP divby, 0       ; div by 0 durumu olmamasi icin divby 0 mi kontrolu yapilir.
          JE NOPRIME         ; divby 0 ise sayi prime olmadigi icin dallanilir.
W1:       MOV AX, BX         ; bolme islemi icin bx registerindeki sayi degeri ax'e atanir.
          DIV divby          ; sayi divby degerine bolunur.
		  CMP DX, 0          ; kalanin 0 olup olmadigi kontrol edilir.
		  JE NOPRIME         ; kalan 0'sa sayi asal olmadigi icin dallanilir.
		  DEC divby          ; kalan 0 degilse yeni islem icin divby degeri 1 azaltilir
		  XOR DX, DX         ; bolme islemini etkilememesi icin dx sifirlanir.
		  CMP divby, 3       ; divby degeri 3'un altina inmis mi diye kontrol edilir (3 altina inmisse sayi asaldir).
		  JAE W1             ; divby degeri 3 altina inmediyse kontrol dongusunun basina dallanilir.
PR:	      MOV prime[SI], BX  ; sayi asal sayi dizine atanir.
		  ADD SI, 2          ; sayac degeri 2 artar.
		  JMP CONTROL        ; number1 ve number2 degerlerinin guncellenme durumunu kontrol icin dallanma yapilir.
NOPRIME:  CMP divby, 1       ; divby degeri 1 kontrolu yapilir.
          JE PR              ; divby 1'e esitse sayi asaldir, asal sayi komutlarina dallanma yapilir.
          MOV nonprime[DI], BX ; divby 1 degilse sayi asal degildir, asal olmayan sayi dizisine atanir.
          ADD DI, 2          ; sayac degeri 2 artar.
CONTROL:  CMP BX, number1    ; bx degeri number1'a esitse, daha number2 kontrol edilmedigi icin dongu sonuna dallanir.
          JE LEND            
          MOV DX, number1    ; eger number2 kontrol edilmisse, guncelleme icin number1 degeri dx'e alinir.
          ADD DX, number2    ; number2 degeri ile number1 degeri dx'te toplanir.
          MOV number1, DX    ; olusan yeni sayi, number1 degerine atanir.
          ADD number2, DX    ; yeni sayiya number2 degeri eklenerek bir sonraki fibonacci sayisi da bulunur.
		  XOR DX, DX         ; dx'in dongudeki bolme islemlerini etkilememesi icin sifirlama islemi yapilir.
LEND:     LOOP L1		     ; dongunun basina donulur.
		  RET                ; program sonlanir.

FIBPRIME  ENDP
codesg    ENDS
          END START		  