              PUBLIC MEDYAN_HESAP
	          EXTRN SAYILAR:WORD, n:WORD, medyan:WORD
cdsg          SEGMENT PARA 'kod'
              ASSUME CS:cdsg
MEDYAN_HESAP  PROC FAR   

              ; siralama islemi (insertion sort ile).
			  
              MOV CX, n              ; n-1 defa donguye girilecegi icin n degeri cx yazmacina alinir.
	          DEC CX                 ; n degeri bir azaltilir.
	          XOR SI, SI             ; si = i, i degeri sifirlanir.
L2:	          ADD SI, 2              ; dizinin birinci elemanindan baslayacagi icin si'ya 2 eklenir (i = i+1)
	          MOV AX, SAYILAR[SI]    ; karsilatirma yapilabilmesi icin SAYILAR[i] degeri ax yazmaci icine alinir.
	          CMP AX, SAYILAR[SI-2]  ; ax yazmacindaki degerle(SAYILAR[i]), SAYILAR[i-1] degeri karsilastirilir (SAYILAR[i] > SAYILAR[i-1])
	          JA IO                  ; ifade dogruysa dongunun basina donulmesi icin dallanilir.
	          MOV DI, SI             ; ifade dogru degilse, si degeri di degerine atanir (j = i).
W1:	          MOV BX, SAYILAR[DI-2]  ; bx yazmaci icine SAYILAR[j-1] degeri alinir. 	    
	          MOV SAYILAR[DI], BX    ; bx yazmaci icindeki deger SAYILAR[j] yerine yazilir (SAYILAR[j] = SAYILAR[j-1] yapilir).
	          SUB DI, 2              ; bir onceki dizi elemanina erismek icin di'dan 2 cikarilir (j-1).
	          CMP DI, 0              ; dizinin basina gelip gelinmediginin kontrolu yapilir.
	          JBE WS                 ; dizi sonuna gelinmisse donguden cikilir.
	          CMP AX, SAYILAR[DI-2]  ; dizi sonuna gelinmediyse, ax yazmacinda bulunan SAYILAR[i] degeri, SAYILAR[j-1]'den buyuk mu diye kontrol edilir.
	          JB W1	                 ; boy[i] degeri daha kucukse, kaydirma dongusunun basina donulur.
WS:	          MOV SAYILAR[DI], AX    ; dongu sonunda SAYILAR[j] degerine SAYILAR[i] degeri atanir. 
IO:           LOOP L2                ; dongu basina donulur.

              ; medyan hesaplama islemi
			  ; burada mantik su: dizinin boyutu tekse, dizi word tipinde saklandigi icin medyan degeri (n-1). indiste oluyor (indislerin ikiser artmasi durumu sebebiyle).
              ; orn: dizinin boyutu 3'se, medyan degeri sayilar[02] degerindedir (elemanlar sirasiyla 00, 02, 04 indislerinde saklandigi icin).
              ;      yine boyut 5'se, medyan degeri sayilar[04] degerindedir (dizinin indisleri 00, 02, 04, 06, 08 seklinde).
              ; dizinin boyutu ciftse bu sefer (sayilar[n] + sayilar[n-1])/2 yapiyoruz.
              ; orn: dizinin boyutu 4'se medyan hesaplamak icin 04 ve 02 indislerindeki sayilar kullanilacak (dizideki 2. ve 3. sayilar).			  
              		  
			  TEST n, 1              ; dizi boyutu olan n tek mi cift mi kontrol edilir.
			  JNZ ODD                ; tek olmasi durumunda ilgili yere dallanma yapilir.
			  MOV SI, n              ; tek degilse, n degeri indis olarak kullanilabilmesi icin si'ya atanir.
			  MOV AX, SAYILAR[SI]    ; ax icine sayilar[si] degeri alinir.
			  ADD AX, SAYILAR[SI-2]  ; ax icindeki deger sayilar[si-1] degeri ile toplanir (sayilar[n] + sayilar[n-1).
			  SHR AX, 1              ; ax'deki deger ikiye bolunur [(sayilar[n] + sayilar[n-1)/2].
			  JMP SON			     ; degerin medyana atanmasi icin dallanilir.
ODD:          DEC n                  ; n degeri tekse, ilgili indisi bulmak icin 1 azaltilir.
              MOV SI, n              ; indis olarak kullanilabilmesi icin si'ya atanir.
              MOV AX, SAYILAR[SI]    ; medyan'a atanabilmesi icin medyan degeri ax icine alinir.
SON:          MOV medyan, AX	     ; medyan degeri ax'ten ilgili degiskene atanir.
		      RETF                   ; yordam sonu.
MEDYAN_HESAP  ENDP
cdsg          ENDS
              END               			  
			  