.586
.model flat, c
.stack 100h
.data
.code


selsortasm PROC NEAR  ;; gerekli stack atma islemlerinin yapilmasi.
           PUSH EBP
           PUSH ECX
           PUSH EDI
           PUSH ESI
           PUSH EAX
           PUSH EBX
           PUSH EDX
           MOV EBP, ESP
           MOV ECX, [EBP+36]    ;; num_people degeri ecx'te.
		   DEC ECX
		   XOR EBX, EBX
		   JMP dis_don


subtract:  MOV EAX, [EBP+40]
           CMP EAX, 1d    ;; siralama yapilmasi sonrasi yer degistirme islemlerinin
		   JE strchng     ;; dogru yapilabilmesi icin ilgili struct dizininin basina
		   CMP EAX, 3d    ;; donme islemi yapilmasi.
		   JE numberc
	       SUB EDI, 16d
		   SUB ESI, 16d
		   JMP strchng
numberc:   SUB EDI, 32d	
           SUB ESI, 32d
strchng:   XOR EDX, EDX
		   PUSH ESI
		   PUSH EDI
		   JMP change

addition:  CMP EAX, 1d          ;; karsilatirma yapilacak deger icin ilgili struct
		   JE strloop           ;; dizinine gidilmesi. (ornegin number ise people[0].number degeri edi icine atiliyor)
		   CMP EAX, 3d
		   JE number
	       ADD EDI, 16d
		   JMP strloop
number:    ADD EDI, 32d
           JMP strloop

nextchar:  PUSH ESI       ;; iki karakter birbirine esitse, kac karakter birbirine esit bilgisi ax'te tutuluyor
           PUSH EDI       ;; ax'in degerine gore de karakterleri kaydirarak karsilastirma islemini surduruyoruz.
           INC EAX        ;; edi ve esi degerlerini kaybetmemek icin stack icine pushlaniyor ve direkt 
           PUSH ECX       ;; karsilatirmaya donuyoruz.
		   MOV ECX, EAX
next:	   INC ESI
		   MOV DH, [ESI]
		   INC EDI
		   MOV DL, [EDI]
		   LOOP next
		   POP ECX
		   POP EDI
		   POP ESI
		   JMP karsilas

		   

		                            ; selection sort ile siralama yapildi. alt satir dis dongu
dis_don:   MOV EAX, [EBP+40]      ; ax icerisine option degerinin alinmasi.
           MOV EDI, [EBP+32]      ; edi'nin icine struct'in ilk degerinin atilmasi.
DEVAM:     MOV EBX, ECX		   
		   JMP addition
strloop:   MOV ESI, EDI          
           MOV DL, [EDI]
		   XOR EAX, EAX
ic_don:	   ADD ESI, 42d          ; ic dongu selection sort. karakter karakter karsilastirma yapilacak.
           MOV DH, [ESI]
karsilas:  CMP DH, DL
		   JB ATLA
		   JE nextchar
		   MOV EDI, ESI
		   MOV DL, [EDI]
ATLA:	   DEC EBX
		   JNZ ic_don
		   JMP subtract
change:	   CMP EDX, 2d        ; degistirme islemleri (soyad icin)
           JE lend
           MOV AL, [ESI]
		   MOV AH, [EDI]
		   MOV [ESI], AH
		   MOV [EDI], AL
		   CMP AL, 0
		   JNE L2
		   INC EDX
L2:		   CMP AH, 0
		   JNE L1
		   INC EDX
L1:		   INC ESI
		   INC EDI
		   JMP change
lend:	   POP EDI
		   POP ESI
		   ADD ESI, 16d
		   ADD EDI, 16d
           PUSH ESI
		   PUSH EDI
           XOR EDX, EDX
change2:   CMP EDX, 2d     ; degistirme islemleri (isim icin)
           JE lend2
           MOV AL, [ESI]
		   MOV AH, [EDI]
		   MOV [ESI], AH
		   MOV [EDI], AL
		   CMP AL, 0
		   JNE Ln
		   INC EDX
Ln:		   CMP AH, 0
		   JNE Lm
		   INC EDX
Lm:		   INC ESI
		   INC EDI
		   JMP change2
lend2:	   POP EDI                ; degistirme islemleri (numara icin)
		   POP ESI
           MOV EDX, [ESI+16d]
		   XCHG EDX, [EDI+16d]
		   MOV [ESI+16d], EDX
           LOOP dis_don
		   
		   POP EDX
           POP EBX
           POP EAX
           POP ESI
           POP EDI
           POP ECX
           POP EBP
           RET
selsortasm ENDP
           END
