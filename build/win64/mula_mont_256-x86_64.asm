OPTION	DOTNAME
ifdef	__BLST_PORTABLE__
PUBLIC	mul_mont_sparse_256$4
PUBLIC	sqr_mont_sparse_256$4
PUBLIC	from_mont_256$4
PUBLIC	redc_mont_256$4
endif
.text$	SEGMENT ALIGN(256) 'CODE'

PUBLIC	mula_mont_sparse_256


ALIGN	32
mula_mont_sparse_256	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_mula_mont_sparse_256::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
	mov	r8,QWORD PTR[40+rsp]
mul_mont_sparse_256$4::
	sub	rsp,8

$L$SEH_body_mula_mont_sparse_256::


	mov	r10,rdx
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	rdx,QWORD PTR[rdx]
	mov	r22,QWORD PTR[rsi]
	mov	r23,QWORD PTR[8+rsi]
	mov	r24,QWORD PTR[16+rsi]
	mov	r25,QWORD PTR[24+rsi]

	mulx	r20,r16,r22
	call	__mula_mont_sparse_256

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_mula_mont_sparse_256::
	mov	rdi,QWORD PTR[8+rsp]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+rsp]

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif

$L$SEH_end_mula_mont_sparse_256::
mula_mont_sparse_256	ENDP

PUBLIC	sqra_mont_sparse_256


ALIGN	32
sqra_mont_sparse_256	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_sqra_mont_sparse_256::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
sqr_mont_sparse_256$4::
	sub	rsp,8

$L$SEH_body_sqra_mont_sparse_256::


	mov	r10,rsi
	mov	r8,rcx
	mov	rcx,rdx
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	rdx,QWORD PTR[rsi]
	mov	r23,QWORD PTR[8+rsi]
	mov	r24,QWORD PTR[16+rsi]
	mov	r25,QWORD PTR[24+rsi]

	mov	r22,rdx
	mulx	r20,r16,rdx
	call	__mula_mont_sparse_256

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_sqra_mont_sparse_256::
	mov	rdi,QWORD PTR[8+rsp]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+rsp]

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif

$L$SEH_end_sqra_mont_sparse_256::
sqra_mont_sparse_256	ENDP


ALIGN	32
__mula_mont_sparse_256	PROC PRIVATE
	DB	243,15,30,250

	mulx	r21,r17,r23
	mulx	rax,r18,r24
	add	r17,r20
	mulx	r20,r19,r25
	mov	rdx,QWORD PTR[8+r10]
	adc	r18,r21
	mov	r26,QWORD PTR[rcx]
	adc	r19,rax
	mov	r27,QWORD PTR[8+rcx]
	adc	r20,0
	mov	r28,QWORD PTR[16+rcx]
	mov	r29,QWORD PTR[24+rcx]
{nf}	imul	rsi,r16,r8


	xor	r21,r21
	mulx	r11,rax,r22
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r23
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r24
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r25
	mov	rdx,rsi
	adox	r20,rax
	adcx	r11,r21
	adox	r21,r11


	xor	rsi,rsi
	mulx	r11,rax,r26
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,r27
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,r28
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,r29
	mov	rdx,QWORD PTR[((8+8))+r10]
	adcx	r18,rax
	adox	r19,rsi
	adcx	r19,r20
	adcx	r20,r21,rsi
{nf}	imul	rsi,r16,r8


	xor	r21,r21
	mulx	r11,rax,r22
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r23
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r24
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r25
	mov	rdx,rsi
	adox	r20,rax
	adcx	r11,r21
	adox	r21,r11


	xor	rsi,rsi
	mulx	r11,rax,r26
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,r27
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,r28
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,r29
	mov	rdx,QWORD PTR[((16+8))+r10]
	adcx	r18,rax
	adox	r19,rsi
	adcx	r19,r20
	adcx	r20,r21,rsi
{nf}	imul	rsi,r16,r8


	xor	r21,r21
	mulx	r11,rax,r22
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r23
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r24
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r25
	mov	rdx,rsi
	adox	r20,rax
	adcx	r11,r21
	adox	r21,r11


	xor	rsi,rsi
	mulx	r11,rax,r26
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,r27
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,r28
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,r29
{nf}	imul	rdx,r16,r8
	adcx	r18,rax
	adox	r19,rsi
	adcx	r19,r20
	adcx	r20,r21,rsi

	xor	r21,r21
	mulx	r22,rax,r26
	adcx	r16,rax
	adox	r22,r17

	mulx	r23,rax,r27
	adcx	r22,rax
	adox	r23,r18

	mulx	r24,rax,r28
	adcx	r23,rax
	adox	r24,r19

	mulx	r25,rax,r29
	adcx	r24,rax
	adox	r25,r21
	adcx	r25,r20
	adcx	r21,r21




	sub	r16,r22,r26
	sbb	r17,r23,r27
	sbb	r18,r24,r28
	sbb	r19,r25,r29
	sbb	r21,0

	cmovnc	r22,r16
	cmovnc	r23,r17
	cmovnc	r24,r18
	mov	QWORD PTR[rdi],r22
	cmovnc	r25,r19
	mov	QWORD PTR[8+rdi],r23
	mov	QWORD PTR[16+rdi],r24
	mov	QWORD PTR[24+rdi],r25

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif
__mula_mont_sparse_256	ENDP
PUBLIC	froma_mont_256


ALIGN	32
froma_mont_256	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_froma_mont_256::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
from_mont_256$4::
	sub	rsp,8

$L$SEH_body_froma_mont_256::


	mov	r10,rdx
	call	__mula_by_1_mont_256




	sub	r22,r16,r26
	sbb	r23,r17,r27
	sbb	r24,r18,r28
	sbb	r25,r19,r29

	cmovc	r22,r16
	cmovc	r23,r17
	cmovc	r24,r18
	mov	QWORD PTR[rdi],r22
	cmovc	r25,r19
	mov	QWORD PTR[8+rdi],r23
	mov	QWORD PTR[16+rdi],r24
	mov	QWORD PTR[24+rdi],r25

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_froma_mont_256::
	mov	rdi,QWORD PTR[8+rsp]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+rsp]

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif

$L$SEH_end_froma_mont_256::
froma_mont_256	ENDP

PUBLIC	redca_mont_256


ALIGN	32
redca_mont_256	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_redca_mont_256::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
redc_mont_256$4::
	sub	rsp,8

$L$SEH_body_redca_mont_256::


	mov	r10,rdx
	call	__mula_by_1_mont_256

	add	r16,QWORD PTR[32+rsi]
	adc	r17,QWORD PTR[40+rsi]
	adc	r18,QWORD PTR[48+rsi]
	adc	r19,QWORD PTR[56+rsi]
	sbb	rsi,rsi




	sub	r22,r16,r26
	sbb	r23,r17,r27
	sbb	r24,r18,r28
	sbb	r25,r19,r29
	sbb	rsi,0

	cmovc	r22,r16
	cmovc	r23,r17
	cmovc	r24,r18
	mov	QWORD PTR[rdi],r22
	cmovc	r25,r19
	mov	QWORD PTR[8+rdi],r23
	mov	QWORD PTR[16+rdi],r24
	mov	QWORD PTR[24+rdi],r25

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_redca_mont_256::
	mov	rdi,QWORD PTR[8+rsp]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+rsp]

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif

$L$SEH_end_redca_mont_256::
redca_mont_256	ENDP


ALIGN	32
__mula_by_1_mont_256	PROC PRIVATE
	DB	243,15,30,250

ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	r16,QWORD PTR[rsi]
	mov	r26,QWORD PTR[r10]
	mov	r17,QWORD PTR[8+rsi]
	mov	r27,QWORD PTR[8+r10]
	mov	r18,QWORD PTR[16+rsi]
	mov	r28,QWORD PTR[16+r10]
	mov	r19,QWORD PTR[24+rsi]
	mov	r29,QWORD PTR[24+r10]
{nf}	imul	rdx,rcx,r16


	xor	r20,r20
	mulx	r11,rax,r26
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,r27
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,r28
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,r29
	adcx	r18,rax
	adox	r19,r20
	adcx	r19,r20
{nf}	imul	rdx,rcx,r16


	xor	r20,r20
	mulx	r11,rax,r26
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,r27
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,r28
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,r29
	adcx	r18,rax
	adox	r19,r20
	adcx	r19,r20
{nf}	imul	rdx,rcx,r16


	xor	r20,r20
	mulx	r11,rax,r26
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,r27
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,r28
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,r29
	adcx	r18,rax
	adox	r19,r20
	adcx	r19,r20
{nf}	imul	rdx,rcx,r16


	xor	r20,r20
	mulx	r11,rax,r26
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,r27
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,r28
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,r29
	adcx	r18,rax
	adox	r19,r20
	adcx	r19,r20
	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif
__mula_by_1_mont_256	ENDP
.text$	ENDS
.pdata	SEGMENT READONLY ALIGN(4)
ALIGN	4
	DD	imagerel $L$SEH_begin_mula_mont_sparse_256
	DD	imagerel $L$SEH_body_mula_mont_sparse_256
	DD	imagerel $L$SEH_info_mula_mont_sparse_256_prologue

	DD	imagerel $L$SEH_body_mula_mont_sparse_256
	DD	imagerel $L$SEH_epilogue_mula_mont_sparse_256
	DD	imagerel $L$SEH_info_mula_mont_sparse_256_body

	DD	imagerel $L$SEH_epilogue_mula_mont_sparse_256
	DD	imagerel $L$SEH_end_mula_mont_sparse_256
	DD	imagerel $L$SEH_info_mula_mont_sparse_256_epilogue

	DD	imagerel $L$SEH_begin_sqra_mont_sparse_256
	DD	imagerel $L$SEH_body_sqra_mont_sparse_256
	DD	imagerel $L$SEH_info_sqra_mont_sparse_256_prologue

	DD	imagerel $L$SEH_body_sqra_mont_sparse_256
	DD	imagerel $L$SEH_epilogue_sqra_mont_sparse_256
	DD	imagerel $L$SEH_info_sqra_mont_sparse_256_body

	DD	imagerel $L$SEH_epilogue_sqra_mont_sparse_256
	DD	imagerel $L$SEH_end_sqra_mont_sparse_256
	DD	imagerel $L$SEH_info_sqra_mont_sparse_256_epilogue

	DD	imagerel $L$SEH_begin_froma_mont_256
	DD	imagerel $L$SEH_body_froma_mont_256
	DD	imagerel $L$SEH_info_froma_mont_256_prologue

	DD	imagerel $L$SEH_body_froma_mont_256
	DD	imagerel $L$SEH_epilogue_froma_mont_256
	DD	imagerel $L$SEH_info_froma_mont_256_body

	DD	imagerel $L$SEH_epilogue_froma_mont_256
	DD	imagerel $L$SEH_end_froma_mont_256
	DD	imagerel $L$SEH_info_froma_mont_256_epilogue

	DD	imagerel $L$SEH_begin_redca_mont_256
	DD	imagerel $L$SEH_body_redca_mont_256
	DD	imagerel $L$SEH_info_redca_mont_256_prologue

	DD	imagerel $L$SEH_body_redca_mont_256
	DD	imagerel $L$SEH_epilogue_redca_mont_256
	DD	imagerel $L$SEH_info_redca_mont_256_body

	DD	imagerel $L$SEH_epilogue_redca_mont_256
	DD	imagerel $L$SEH_end_redca_mont_256
	DD	imagerel $L$SEH_info_redca_mont_256_epilogue

.pdata	ENDS
.xdata	SEGMENT READONLY ALIGN(8)
ALIGN	8
$L$SEH_info_mula_mont_sparse_256_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_mula_mont_sparse_256_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_mula_mont_sparse_256_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_sqra_mont_sparse_256_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_sqra_mont_sparse_256_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_sqra_mont_sparse_256_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_froma_mont_256_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_froma_mont_256_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_froma_mont_256_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_redca_mont_256_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_redca_mont_256_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_redca_mont_256_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h


.xdata	ENDS
END
