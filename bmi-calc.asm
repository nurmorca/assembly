datasg  SEGMENT PARA 'data'
n       DW 4
kilo    DW 82, 62, 64, 86
boy     DW 160, 172, 179, 182
son     DW 4 DUP(?)
datasg  ENDS

stacksg SEGMENT PARA STACK 'stack'
        DW 12 DUP(?)
stacksg ENDS

codesg SEGMENT PARA 'code'
       ASSUME DS:datasg, SS:stacksg, CS:codesg

MAIN   PROC FAR
       PUSH DS            ; geri donus adreslerinin ayarlanmasi.
	   XOR AX, AX
	   PUSH AX
	   MOV AX, datasg     ; datasg degerinin ds icine alinmasi.
	   MOV DS, AX
       
	   ; vki hesaplanmasinda izlenen mantik:
	   ;  hesaplamanin gercek sonuca en yakin sekilde olmasi icin, once boyun cm haliyle karesi aliniyor. orn: 160*160 = 25600.
	   ;  ardindan bulunan sonuc 100'e bolunuyor. orn: 25600/100 = 256.
	   ;  daha sonrasinda kilo degeri 100 ile carpiliyor. orn: 82*100 = 8200
	   ;  sonuc icin bulunan son kilo-boy degeri bolunuyor. orn: 8200/256 = 32 (gercek matematiksel sonuc ~32.03).


	   XOR SI, SI         ; si = i. i degerini sifirlanir.
	   MOV CX, n          ; loop'un n defa donmesi icin n degerini cx icine alinir.
L1:	   XOR DX, DX         ; yapilacak olan carpma islemini etkilememesi icin dx sifirlanir.
       MOV AX, boy[SI]    ; kare alma isleminin yapilmasi icin boy[i] degeri ax yazmacina alinir.
	   MUL boy[SI]        ; kare alinmasi icin boy[i] degeri kendiyle carpilir.
	   MOV BX, 100        ; kare aliminin sonucu 100'e bolunmesi icin bx yazmacina 100 degeri atanir.
	   DIV BX             ; boy[i]^2 degeri 100'e bolunur.
	   MOV BX, AX         ; ax yazmacinda olan bolum sonucu bx yazmacina alinir.
	   MOV AX, 100        ; ax yazmacina 100 degeri atanir.
       XOR DX, DX         ; dx yazmacinda bolme sonucunda kalan degerin carpmayi etkilememesi icin dx sifirlanir.
	   MUL kilo[SI]       ; kilo[i] degeri 100 ile carpilir.
	   DIV BX             ; bulunan deger, bx yazmacinda saklanan boy degerine bolunur.
	   MOV son[SI], AX    ; sonuc son[i]'ye atanir.
	   ADD SI, 2          ; word tipinden dolayi si degeri 2 arttirilir (i+1).
	   LOOP L1            ; dongunun basina donulur. 
	   
	   ; siralama (insertion sort ile).
	   
	   MOV CX, n          ; n-1 defa donguye girilecegi icin n degeri cx yazmacina alinir.
	   DEC CX             ; n degeri bir azaltilir.
	   XOR SI, SI         ; si = i, i degeri sifirlanir.
L2:	   ADD SI, 2          ; dizinin birinci elemanindan baslayacagi icin si'ya 2 eklenir (i = i+1)
	   MOV AX, son[SI]    ; karsilatirma yapilabilmesi icin son[i] degeri ax yazmaci icine alinir.
	   CMP AX, son[SI-2]  ; ax yazmacindaki degerle(boy[i]), boy[i-1] degeri karsilastirilir (boy[i] > boy[i-1])
	   JA IO              ; ifade dogruysa dongunun basina donulmesi icin dallanilir.
	   MOV DI, SI         ; ifade dogru degilse, si degeri di degerine atanir (j = i).
W1:	   MOV BX, son[DI-2]  ; bx yazmaci icine son[j-1] degeri alinir. 	    
	   MOV son[DI], BX    ; bx yazmaci icindeki deger son[j] yerine yazilir (son[j] = son[j-1] yapilir).
	   SUB DI, 2          ; bir onceki dizi elemanina erismek icin di'dan 2 cikarilir (j-1).
	   CMP DI, 0          ; dizinin basina gelip gelinmediginin kontrolu yapilir.
	   JBE WS             ; dizi sonuna gelinmisse donguden cikilir.
	   CMP AX, son[DI-2]  ; dizi sonuna gelinmediyse, ax yazmacinda bulunan boy[i] degeri, boy[j-1]'den buyuk mu diye kontrol edilir.
	   JB W1	          ; boy[i] degeri daha kucukse, kaydirma dongusunun basina donulur.
WS:	   MOV son[DI], AX    ; dongu sonunda boy[j] degerine boy[i] degeri atanir. 
IO:    LOOP L2            ; dongu basina donulur.
       RETF
       MAIN ENDP	 
codesg ENDS
       END MAIN	 