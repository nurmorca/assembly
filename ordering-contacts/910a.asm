          INCLUDE girdi.mac         ; makro dosyasinin include edilmesi.
		  EXTRN MEDYAN_HESAP:FAR    ; alt yordamin tanimlanmasi
		  PUBLIC SAYILAR, n, medyan ; alt yordamda kullanilacak verilerin public tanimlanmasi.
		  
datasg    SEGMENT PARA 'data'
CR        EQU 13                          ; girdi alinmasinda kullanilan carriage return degeri.
LF        EQU 10                          ; girdi alinmasinda kullanilan line feed degeri.
n         DW ?                            ; dizinin boyutu.
sizemsg   DB 'Enter size (<=10): ', 0     ; boyut alirken ekrana basilacak string.
numbermsg DB CR, LF, 'Enter number: ', 0  ; diziyi alirken ekrana basilacak string.
SAYILAR   DW 10 DUP(?)                    ; sayi dizisi.
medyan    DW 0                            ; medyan degeri.
datasg    ENDS

stacksg   SEGMENT PARA STACK 'stack'
          DW 38 DUP(?)
stacksg   ENDS

codesg   SEGMENT PARA 'code'
         ASSUME CS:codesg, DS:datasg, SS:stacksg

MAIN    PROC FAR
        PUSH DS
		XOR AX, AX                                 ; donulecek degerlerin ayarlanmasi.
		PUSH AX
		MOV AX, datasg                             ; data segmentin ds'ye alinmasi.
		MOV DS, AX
        
		GIRIS_DIZI sizemsg, numbermsg, n, SAYILAR  ; makroya parametre gondererek sayilar dizisi ve boyutunun alinmasi.
		CALL MEDYAN_HESAP                          ; dizinin siralanmasi ve medyanin hesaplanmasi icin gerekli yordamin cagirilmasi.
		PUTN medyan                                ; medyan bilgisinin ekrana bastirilmasi.
		
		RETF                                       ; program sonu.
        MAIN ENDP
codesg  ENDS
        END MAIN	
		
