OPTION	DOTNAME
PUBLIC	mul_mont_384x$4
PUBLIC	sqr_mont_384x$4
PUBLIC	mul_382x$4
PUBLIC	sqr_382x$4
PUBLIC	mul_384$4
PUBLIC	sqr_384$4
PUBLIC	redc_mont_384$4
PUBLIC	from_mont_384$4
PUBLIC	sgn0_pty_mont_384$4
PUBLIC	sgn0_pty_mont_384x$4
PUBLIC	mul_mont_384$4
PUBLIC	sqr_mont_384$4
PUBLIC	sqr_n_mul_mont_384$4
PUBLIC	sqr_n_mul_mont_383$4
.text$	SEGMENT ALIGN(256) 'CODE'






ALIGN	32
__suba_mod_384x384	PROC PRIVATE
	DB	243,15,30,250

	mov	r16,QWORD PTR[rsi]
	mov	r17,QWORD PTR[8+rsi]
	mov	r18,QWORD PTR[16+rsi]
	mov	r19,QWORD PTR[24+rsi]
	mov	r20,QWORD PTR[32+rsi]
	mov	r21,QWORD PTR[40+rsi]
	mov	r22,QWORD PTR[48+rsi]

	sub	r16,QWORD PTR[rdx]
	mov	r23,QWORD PTR[56+rsi]
	sbb	r17,QWORD PTR[8+rdx]
	mov	r24,QWORD PTR[64+rsi]
	sbb	r18,QWORD PTR[16+rdx]
	mov	r25,QWORD PTR[72+rsi]
	sbb	r19,QWORD PTR[24+rdx]
	mov	r26,QWORD PTR[80+rsi]
	sbb	r20,QWORD PTR[32+rdx]
	mov	r27,QWORD PTR[88+rsi]
	sbb	r21,QWORD PTR[40+rdx]
	mov	QWORD PTR[rdi],r16
	sbb	r22,QWORD PTR[48+rdx]
	mov	QWORD PTR[8+rdi],r17
	sbb	r23,QWORD PTR[56+rdx]
	mov	QWORD PTR[16+rdi],r18
	sbb	r24,QWORD PTR[64+rdx]
	mov	QWORD PTR[24+rdi],r19
	sbb	r25,QWORD PTR[72+rdx]
	mov	QWORD PTR[32+rdi],r20
	sbb	r26,QWORD PTR[80+rdx]
	mov	QWORD PTR[40+rdi],r21
	sbb	r27,QWORD PTR[88+rdx]
	sbb	rax,rax

{nf}	and	r16,rax,QWORD PTR[rcx]
{nf}	and	r17,rax,QWORD PTR[8+rcx]
{nf}	and	r18,rax,QWORD PTR[16+rcx]
{nf}	and	r19,rax,QWORD PTR[24+rcx]
{nf}	and	r20,rax,QWORD PTR[32+rcx]
{nf}	and	r21,rax,QWORD PTR[40+rcx]

	add	r22,r16
	adc	r23,r17
	mov	QWORD PTR[48+rdi],r22
	adc	r24,r18
	mov	QWORD PTR[56+rdi],r23
	adc	r25,r19
	mov	QWORD PTR[64+rdi],r24
	adc	r26,r20
	mov	QWORD PTR[72+rdi],r25
	adc	r27,r21
	mov	QWORD PTR[80+rdi],r26
	mov	QWORD PTR[88+rdi],r27

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif
__suba_mod_384x384	ENDP

PUBLIC	adda_mod_384


ALIGN	32
adda_mod_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_adda_mod_384::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
	sub	rsp,8

$L$SEH_body_adda_mod_384::


	call	__adda_mod_384

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_adda_mod_384::
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

$L$SEH_end_adda_mod_384::
adda_mod_384	ENDP


ALIGN	32
__adda_mod_384	PROC PRIVATE
	DB	243,15,30,250

ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	r16,QWORD PTR[rsi]
	mov	r17,QWORD PTR[8+rsi]
	mov	r18,QWORD PTR[16+rsi]
	mov	r19,QWORD PTR[24+rsi]
	mov	r20,QWORD PTR[32+rsi]
	mov	r21,QWORD PTR[40+rsi]

	add	r16,QWORD PTR[rdx]
	adc	r17,QWORD PTR[8+rdx]
	adc	r18,QWORD PTR[16+rdx]
	adc	r19,QWORD PTR[24+rdx]
	adc	r20,QWORD PTR[32+rdx]
	adc	r21,QWORD PTR[40+rdx]
	sbb	rax,rax

	sub	r22,r16,QWORD PTR[rcx]
	sbb	r23,r17,QWORD PTR[8+rcx]
	sbb	r24,r18,QWORD PTR[16+rcx]
	sbb	r25,r19,QWORD PTR[24+rcx]
	sbb	r26,r20,QWORD PTR[32+rcx]
	sbb	r27,r21,QWORD PTR[40+rcx]
	sbb	rax,0

	cmovnc	r16,r22
	cmovnc	r17,r23
	cmovnc	r18,r24
	mov	QWORD PTR[rdi],r16
	cmovnc	r19,r25
	mov	QWORD PTR[8+rdi],r17
	cmovnc	r20,r26
	mov	QWORD PTR[16+rdi],r18
	cmovnc	r21,r27
	mov	QWORD PTR[24+rdi],r19
	mov	QWORD PTR[32+rdi],r20
	mov	QWORD PTR[40+rdi],r21

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif
__adda_mod_384	ENDP

PUBLIC	suba_mod_384


ALIGN	32
suba_mod_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_suba_mod_384::



	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
	sub	rsp,8
$L$SEH_body_suba_mod_384::


	call	__suba_mod_384

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_suba_mod_384::
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

$L$SEH_end_suba_mod_384::
suba_mod_384	ENDP


ALIGN	32
__suba_mod_384	PROC PRIVATE
	DB	243,15,30,250

ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	r16,QWORD PTR[rsi]
	mov	r17,QWORD PTR[8+rsi]
	mov	r18,QWORD PTR[16+rsi]
	mov	r19,QWORD PTR[24+rsi]
	mov	r20,QWORD PTR[32+rsi]
	mov	r21,QWORD PTR[40+rsi]

__suba_mod_384_a_is_loaded::
	sub	r16,QWORD PTR[rdx]
	sbb	r17,QWORD PTR[8+rdx]
	sbb	r18,QWORD PTR[16+rdx]
	sbb	r19,QWORD PTR[24+rdx]
	sbb	r20,QWORD PTR[32+rdx]
	sbb	r21,QWORD PTR[40+rdx]
	sbb	rax,rax

{nf}	and	r22,rax,QWORD PTR[rcx]
{nf}	and	r23,rax,QWORD PTR[8+rcx]
{nf}	and	r24,rax,QWORD PTR[16+rcx]
{nf}	and	r25,rax,QWORD PTR[24+rcx]
{nf}	and	r26,rax,QWORD PTR[32+rcx]
{nf}	and	r27,rax,QWORD PTR[40+rcx]

	add	r16,r22
	adc	r17,r23
	mov	QWORD PTR[rdi],r16
	adc	r18,r24
	mov	QWORD PTR[8+rdi],r17
	adc	r19,r25
	mov	QWORD PTR[16+rdi],r18
	adc	r20,r26
	mov	QWORD PTR[24+rdi],r19
	adc	r21,r27
	mov	QWORD PTR[32+rdi],r20
	mov	QWORD PTR[40+rdi],r21

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif
__suba_mod_384	ENDP
PUBLIC	mula_mont_384x


ALIGN	32
mula_mont_384x	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_mula_mont_384x::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
	mov	r8,QWORD PTR[40+rsp]
mul_mont_384x$4::
	sub	rsp,296

$L$SEH_body_mula_mont_384x::


	mov	r10,rdx
	mov	r31,rdi
	mov	r9,rsi




	lea	rdi,QWORD PTR[rsp]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__mula_384


	lea	r10,QWORD PTR[48+r10]
	lea	rsi,QWORD PTR[48+rsi]
	lea	rdi,QWORD PTR[96+rdi]
	call	__mula_384


	lea	rsi,QWORD PTR[r10]
	lea	rdx,QWORD PTR[((-48))+r10]
	lea	rdi,QWORD PTR[((192+48))+rsp]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__adda_mod_384

	lea	rsi,QWORD PTR[r9]
	lea	rdx,QWORD PTR[48+r9]
	lea	rdi,QWORD PTR[((-48))+rdi]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__adda_mod_384

	lea	r10,QWORD PTR[rdi]
	lea	rsi,QWORD PTR[48+rdi]
	call	__mula_384


	lea	rsi,QWORD PTR[rdi]
	lea	rdx,QWORD PTR[rsp]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__suba_mod_384x384

	lea	rsi,QWORD PTR[rdi]
	lea	rdx,QWORD PTR[((-96))+rdi]
	call	__suba_mod_384x384


	lea	rsi,QWORD PTR[rsp]
	lea	rdx,QWORD PTR[96+rsp]
	lea	rdi,QWORD PTR[rsp]
	call	__suba_mod_384x384


	lea	rsi,QWORD PTR[rsp]
	lea	rdi,QWORD PTR[r31]
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384


	lea	rsi,QWORD PTR[192+rsp]
	lea	rdi,QWORD PTR[48+rdi]
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384

	lea	rsp,QWORD PTR[296+rsp]

$L$SEH_epilogue_mula_mont_384x::
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

$L$SEH_end_mula_mont_384x::
mula_mont_384x	ENDP
PUBLIC	sqra_mont_384x


ALIGN	32
sqra_mont_384x	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_sqra_mont_384x::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
sqr_mont_384x$4::
	sub	rsp,104

$L$SEH_body_sqra_mont_384x::


	mov	r8,rcx
	mov	rcx,rdx
	mov	r31,rdi
	mov	r9,rsi


	lea	rdx,QWORD PTR[48+rsi]
	lea	rdi,QWORD PTR[rsp]
	call	__adda_mod_384


	lea	rsi,QWORD PTR[r9]
	lea	rdx,QWORD PTR[48+r9]
	lea	rdi,QWORD PTR[48+rsp]
	call	__suba_mod_384


	lea	r10,QWORD PTR[48+rsi]
	lea	rdi,QWORD PTR[r31]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	rdx,QWORD PTR[48+rsi]
	mov	r25,QWORD PTR[rsi]
	mov	r26,QWORD PTR[8+rsi]
	mov	r27,QWORD PTR[16+rsi]
	mov	r28,QWORD PTR[24+rsi]
	mov	r29,QWORD PTR[32+rsi]
	mov	r30,QWORD PTR[40+rsi]
	lea	rcx,QWORD PTR[((-128))+rcx]

	mulx	r20,r16,r25
	call	__mula_mont_384

	add	rdx,rdx
	adc	r26,r26
	adc	r27,r27
	adc	r28,r28
	adc	r29,r29
	adc	r30,r30
	sbb	rsi,rsi

	sub	r16,rdx,QWORD PTR[rcx]
	sbb	r17,r26,QWORD PTR[8+rcx]
	sbb	r18,r27,QWORD PTR[16+rcx]
	sbb	r19,r28,QWORD PTR[24+rcx]
	sbb	r20,r29,QWORD PTR[32+rcx]
	sbb	r21,r30,QWORD PTR[40+rcx]
	sbb	rsi,0

	cmovnc	rdx,r16
	cmovnc	r26,r17
	cmovnc	r27,r18
	mov	QWORD PTR[48+rdi],rdx
	cmovnc	r28,r19
	mov	QWORD PTR[56+rdi],r26
	cmovnc	r29,r20
	mov	QWORD PTR[64+rdi],r27
	cmovnc	r30,r21
	mov	QWORD PTR[72+rdi],r28
	mov	QWORD PTR[80+rdi],r29
	mov	QWORD PTR[88+rdi],r30


	mov	rdx,QWORD PTR[48+rsp]
	lea	r10,QWORD PTR[48+rsp]
	mov	r25,QWORD PTR[rsp]
	mov	r26,QWORD PTR[8+rsp]
	mov	r27,QWORD PTR[16+rsp]
	mov	r28,QWORD PTR[24+rsp]
	mov	r29,QWORD PTR[32+rsp]
	mov	r30,QWORD PTR[40+rsp]
	lea	rcx,QWORD PTR[((-128))+rcx]

	mulx	r20,r16,r25
	call	__mula_mont_384

	lea	rsp,QWORD PTR[104+rsp]

$L$SEH_epilogue_sqra_mont_384x::
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

$L$SEH_end_sqra_mont_384x::
sqra_mont_384x	ENDP

PUBLIC	mula_382x


ALIGN	32
mula_382x	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_mula_382x::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
mul_382x$4::
	sub	rsp,104

$L$SEH_body_mula_382x::


	mov	r31,rdx
	mov	r9,rsi
	lea	rdi,QWORD PTR[96+rdi]


ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	r16,QWORD PTR[rsi]
	mov	r17,QWORD PTR[8+rsi]
	mov	r18,QWORD PTR[16+rsi]
	mov	r19,QWORD PTR[24+rsi]
	mov	r20,QWORD PTR[32+rsi]
	mov	r21,QWORD PTR[40+rsi]

	add	r16,QWORD PTR[48+rsi]
	adc	r17,QWORD PTR[56+rsi]
	adc	r18,QWORD PTR[64+rsi]
	adc	r19,QWORD PTR[72+rsi]
	adc	r20,QWORD PTR[80+rsi]
	adc	r21,QWORD PTR[88+rsi]

	mov	QWORD PTR[rsp],r16
	mov	QWORD PTR[8+rsp],r17
	mov	QWORD PTR[16+rsp],r18
	mov	QWORD PTR[24+rsp],r19
	mov	QWORD PTR[32+rsp],r20
	mov	QWORD PTR[40+rsp],r21


	mov	r16,QWORD PTR[rdx]
	mov	r17,QWORD PTR[8+rdx]
	mov	r18,QWORD PTR[16+rdx]
	mov	r19,QWORD PTR[24+rdx]
	mov	r20,QWORD PTR[32+rdx]
	mov	r21,QWORD PTR[40+rdx]

	add	r16,QWORD PTR[48+rdx]
	adc	r17,QWORD PTR[56+rdx]
	adc	r18,QWORD PTR[64+rdx]
	adc	r19,QWORD PTR[72+rdx]
	adc	r20,QWORD PTR[80+rdx]
	adc	r21,QWORD PTR[88+rdx]

	mov	QWORD PTR[48+rsp],r16
	mov	QWORD PTR[56+rsp],r17
	mov	QWORD PTR[64+rsp],r18
	mov	QWORD PTR[72+rsp],r19
	mov	QWORD PTR[80+rsp],r20
	mov	QWORD PTR[88+rsp],r21


	lea	r10,QWORD PTR[48+rsp]
	lea	rsi,QWORD PTR[rsp]
	call	__mula_384


	lea	r10,QWORD PTR[r31]
	lea	rsi,QWORD PTR[r9]
	lea	rdi,QWORD PTR[((-96))+rdi]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__mula_384


	lea	r10,QWORD PTR[48+r10]
	lea	rsi,QWORD PTR[48+rsi]
	mov	r31,rdi
	lea	rdi,QWORD PTR[rsp]
	call	__mula_384


	lea	rsi,QWORD PTR[96+r31]
	lea	rdx,QWORD PTR[rsp]
	lea	rdi,QWORD PTR[96+r31]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__suba_mod_384x384


	lea	rsi,QWORD PTR[rdi]
	lea	rdx,QWORD PTR[((-96))+rdi]
	call	__suba_mod_384x384


	lea	rsi,QWORD PTR[((-96))+rdi]
	lea	rdx,QWORD PTR[rsp]
	lea	rdi,QWORD PTR[((-96))+rdi]
	call	__suba_mod_384x384

	lea	rsp,QWORD PTR[104+rsp]

$L$SEH_epilogue_mula_382x::
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

$L$SEH_end_mula_382x::
mula_382x	ENDP
PUBLIC	sqra_382x


ALIGN	32
sqra_382x	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_sqra_382x::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
sqr_382x$4::
	sub	rsp,8

$L$SEH_body_sqra_382x::


	mov	rcx,rdx
	mov	r9,rsi


ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	r16,QWORD PTR[rsi]
	mov	r17,QWORD PTR[8+rsi]
	mov	r18,QWORD PTR[16+rsi]
	mov	r19,QWORD PTR[24+rsi]
	mov	r20,QWORD PTR[32+rsi]
	mov	r21,QWORD PTR[40+rsi]

	add	r22,r16,QWORD PTR[48+rsi]
	adc	r23,r17,QWORD PTR[56+rsi]
	adc	r24,r18,QWORD PTR[64+rsi]
	adc	r25,r19,QWORD PTR[72+rsi]
	adc	r26,r20,QWORD PTR[80+rsi]
	adc	r27,r21,QWORD PTR[88+rsi]

	mov	QWORD PTR[rdi],r22
	mov	QWORD PTR[8+rdi],r23
	mov	QWORD PTR[16+rdi],r24
	mov	QWORD PTR[24+rdi],r25
	mov	QWORD PTR[32+rdi],r26
	mov	QWORD PTR[40+rdi],r27


	lea	rdx,QWORD PTR[48+rsi]
	lea	rdi,QWORD PTR[48+rdi]
	call	__suba_mod_384_a_is_loaded


	lea	rsi,QWORD PTR[rdi]
	lea	r10,QWORD PTR[((-48))+rdi]
	lea	rdi,QWORD PTR[((-48))+rdi]
	call	__mula_384


	lea	rsi,QWORD PTR[r9]
	lea	r10,QWORD PTR[48+r9]
	lea	rdi,QWORD PTR[96+rdi]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__mula_384

	mov	r16,QWORD PTR[rdi]
	mov	r17,QWORD PTR[8+rdi]
	mov	r18,QWORD PTR[16+rdi]
	mov	r19,QWORD PTR[24+rdi]
	mov	r20,QWORD PTR[32+rdi]
	mov	r21,QWORD PTR[40+rdi]
	mov	r22,QWORD PTR[48+rdi]
	mov	r23,QWORD PTR[56+rdi]
	mov	r24,QWORD PTR[64+rdi]
	mov	r25,QWORD PTR[72+rdi]
	mov	r26,QWORD PTR[80+rdi]
	add	r16,r16
	mov	r27,QWORD PTR[88+rdi]
	adc	r17,r17
	mov	QWORD PTR[rdi],r16
	adc	r18,r18
	mov	QWORD PTR[8+rdi],r17
	adc	r19,r19
	mov	QWORD PTR[16+rdi],r18
	adc	r20,r20
	mov	QWORD PTR[24+rdi],r19
	adc	r21,r21
	mov	QWORD PTR[32+rdi],r20
	adc	r22,r22
	mov	QWORD PTR[40+rdi],r21
	adc	r23,r23
	mov	QWORD PTR[48+rdi],r22
	adc	r24,r24
	mov	QWORD PTR[56+rdi],r23
	adc	r25,r25
	mov	QWORD PTR[64+rdi],r24
	adc	r26,r26
	mov	QWORD PTR[72+rdi],r25
	adc	r27,r27
	mov	QWORD PTR[80+rdi],r26
	mov	QWORD PTR[88+rdi],r27

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_sqra_382x::
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

$L$SEH_end_sqra_382x::
sqra_382x	ENDP
PUBLIC	mula_384


ALIGN	32
mula_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_mula_384::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
mul_384$4::
	lea	rsp,QWORD PTR[((-8))+rsp]

$L$SEH_body_mula_384::


	mov	r10,rdx
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__mula_384

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_mula_384::
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

$L$SEH_end_mula_384::
mula_384	ENDP


ALIGN	32
__mula_384	PROC PRIVATE
	DB	243,15,30,250

	mov	rdx,QWORD PTR[r10]
	mov	r25,QWORD PTR[rsi]
	mov	r26,QWORD PTR[8+rsi]
	mov	r27,QWORD PTR[16+rsi]
	mov	r28,QWORD PTR[24+rsi]
	mov	r29,QWORD PTR[32+rsi]
	mov	r30,QWORD PTR[40+rsi]

	mulx	r11,r16,r25
	xor	r23,r23

	mulx	rax,r17,r26
	add	r17,r11
	mov	QWORD PTR[rdi],r16

	mulx	r11,r18,r27
	adc	r18,rax

	mulx	rax,r19,r28
	adc	r19,r11

	mulx	r11,r20,r29
	adc	r20,rax

	mulx	r22,r21,r30
	mov	rdx,QWORD PTR[8+r10]
	adc	r21,r11
	adc	r22,0
ifdef	__CRYPTOLINE__
	cmovc	r22,r22
endif
	xor	r23,r23
	mulx	rax,r16,r25
	adcx	r16,r17
	adox	r18,rax

	mulx	r11,r17,r26
	adcx	r17,r18
	adox	r19,r11
	mov	QWORD PTR[8+rdi],r16

	mulx	rax,r18,r27
	adcx	r18,r19
	adox	r20,rax

	mulx	r11,r19,r28
	adcx	r19,r20
	adox	r21,r11

	mulx	rax,r20,r29
	adcx	r20,r21
	adox	r22,rax

	mulx	r11,r21,r30
	mov	rdx,QWORD PTR[16+r10]
	adcx	r21,r22
	adox	r11,r23
	adcx	r22,r11,r23
ifdef	__CRYPTOLINE__
	cmovo	r22,r22
endif
	xor	r23,r23
	mulx	rax,r16,r25
	adcx	r16,r17
	adox	r18,rax

	mulx	r11,r17,r26
	adcx	r17,r18
	adox	r19,r11
	mov	QWORD PTR[16+rdi],r16

	mulx	rax,r18,r27
	adcx	r18,r19
	adox	r20,rax

	mulx	r11,r19,r28
	adcx	r19,r20
	adox	r21,r11

	mulx	rax,r20,r29
	adcx	r20,r21
	adox	r22,rax

	mulx	r11,r21,r30
	mov	rdx,QWORD PTR[24+r10]
	adcx	r21,r22
	adox	r11,r23
	adcx	r22,r11,r23
ifdef	__CRYPTOLINE__
	cmovo	r22,r22
endif
	xor	r23,r23
	mulx	rax,r16,r25
	adcx	r16,r17
	adox	r18,rax

	mulx	r11,r17,r26
	adcx	r17,r18
	adox	r19,r11
	mov	QWORD PTR[24+rdi],r16

	mulx	rax,r18,r27
	adcx	r18,r19
	adox	r20,rax

	mulx	r11,r19,r28
	adcx	r19,r20
	adox	r21,r11

	mulx	rax,r20,r29
	adcx	r20,r21
	adox	r22,rax

	mulx	r11,r21,r30
	mov	rdx,QWORD PTR[32+r10]
	adcx	r21,r22
	adox	r11,r23
	adcx	r22,r11,r23
ifdef	__CRYPTOLINE__
	cmovo	r22,r22
endif
	xor	r23,r23
	mulx	rax,r16,r25
	adcx	r16,r17
	adox	r18,rax

	mulx	r11,r17,r26
	adcx	r17,r18
	adox	r19,r11
	mov	QWORD PTR[32+rdi],r16

	mulx	rax,r18,r27
	adcx	r18,r19
	adox	r20,rax

	mulx	r11,r19,r28
	adcx	r19,r20
	adox	r21,r11

	mulx	rax,r20,r29
	adcx	r20,r21
	adox	r22,rax

	mulx	r11,r21,r30
	mov	rdx,QWORD PTR[40+r10]
	adcx	r21,r22
	adox	r11,r23
	adcx	r22,r11,r23
ifdef	__CRYPTOLINE__
	cmovo	r22,r22
endif
	xor	r23,r23
	mulx	rax,r16,r25
	adcx	r16,r17
	adox	r18,rax

	mulx	r11,r17,r26
	adcx	r17,r18
	adox	r19,r11
	mov	QWORD PTR[40+rdi],r16

	mulx	rax,r18,r27
	adcx	r18,r19
	adox	r20,rax

	mulx	r11,r19,r28
	adcx	r19,r20
	adox	r21,r11

	mulx	rax,r20,r29
	adcx	r20,r21
	adox	r22,rax

	mulx	r11,r21,r30
	mov	rdx,rax
	adcx	r21,r22
	adox	r11,r23
	adcx	r22,r11,r23
ifdef	__CRYPTOLINE__
	cmovo	r22,r22
endif
	mov	QWORD PTR[48+rdi],r17
	mov	QWORD PTR[56+rdi],r18
	mov	QWORD PTR[64+rdi],r19
	mov	QWORD PTR[72+rdi],r20
	mov	QWORD PTR[80+rdi],r21
	mov	QWORD PTR[88+rdi],r22

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif
__mula_384	ENDP
PUBLIC	sqra_384


ALIGN	32
sqra_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_sqra_384::


	mov	rdi,rcx
	mov	rsi,rdx
sqr_384$4::
	lea	rsp,QWORD PTR[((-8))+rsp]

$L$SEH_body_sqra_384::


ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__sqra_384

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_sqra_384::
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

$L$SEH_end_sqra_384::
sqra_384	ENDP


ALIGN	32
__sqra_384	PROC PRIVATE
	DB	243,15,30,250

	mov	rdx,QWORD PTR[rsi]
	mov	r23,QWORD PTR[8+rsi]
	mov	r24,QWORD PTR[16+rsi]
	mov	r25,QWORD PTR[24+rsi]
	mov	r26,QWORD PTR[32+rsi]


	mulx	rax,r17,r23
	mov	r27,QWORD PTR[40+rsi]
	mulx	r11,r18,r24
	add	r18,rax
	mulx	rax,r19,r25
	adc	r19,r11
	mulx	r11,r20,r26
	adc	r20,rax
	mulx	r22,r21,r27
	mov	rdx,r23
	adc	r21,r11
	adc	r22,0
ifdef	__CRYPTOLINE__
	cmovc	r22,r22
endif


	xor	r23,r23
	mulx	r11,rax,r24
	adcx	r19,rax
	adox	r20,r11

	mulx	r11,rax,r25
	adcx	r20,rax
	adox	r21,r11

	mulx	r11,rax,r26
	adcx	r21,rax
	adox	r22,r11

	mulx	r11,rax,r27
	mov	rdx,r24
	adcx	r22,rax
	adox	r11,r23
	adcx	r23,r11
ifdef	__CRYPTOLINE__
	cmovo	r23,r23
endif


	xor	r24,r24
	mulx	r11,rax,r25
	adcx	r21,rax
	adox	r22,r11

	mulx	r11,rax,r26
	adcx	r22,rax
	adox	r23,r11

	mulx	r11,rax,r27
	mov	rdx,r25
	adcx	r23,rax
	adox	r11,r24
	adcx	r24,r11
ifdef	__CRYPTOLINE__
	cmovo	r24,r24
endif


	xor	r25,r25
	mulx	r11,rax,r26
	adcx	r23,rax
	adox	r24,r11

	mulx	r11,rax,r27
	mov	rdx,r26
	adcx	r24,rax
	adox	r11,r25
	adcx	r25,r11
ifdef	__CRYPTOLINE__
	cmovo	r25,r25
endif


	mulx	r26,rax,r27
	mov	rdx,QWORD PTR[rsi]
	add	r25,rax
	adc	r26,0
ifdef	__CRYPTOLINE__
	cmovc	r26,r26
endif


	xor	r27,r27
	adcx	r17,r17
	adcx	r18,r18
	adcx	r19,r19
	adcx	r20,r20
	adcx	r21,r21
ifdef	__CRYPTOLINE__
	cmovc	r21,r21
endif


	mulx	r11,rdx,rdx
	mov	QWORD PTR[rdi],rdx
	mov	rdx,QWORD PTR[8+rsi]
	adox	r17,r11
	mov	QWORD PTR[8+rdi],r17

	mulx	r11,r17,rdx
	mov	rdx,QWORD PTR[16+rsi]
	adox	r18,r17
	adox	r19,r11
	mov	QWORD PTR[16+rdi],r18
	mov	QWORD PTR[24+rdi],r19

	mulx	r18,r17,rdx
	mov	rdx,QWORD PTR[24+rsi]
	adox	r20,r17
	adox	r21,r18
	adcx	r22,r22
	adcx	r23,r23
	mov	QWORD PTR[32+rdi],r20
	mov	QWORD PTR[40+rdi],r21

	mulx	r18,r17,rdx
	mov	rdx,QWORD PTR[32+rsi]
	adox	r22,r17
	adox	r23,r18
	adcx	r24,r24
	adcx	r25,r25
	mov	QWORD PTR[48+rdi],r22
	mov	QWORD PTR[56+rdi],r23

	mulx	r18,r17,rdx
	mov	rdx,QWORD PTR[40+rsi]
	adox	r24,r17
	adox	r25,r18
	adcx	r26,r26
	adcx	r27,r27
	mov	QWORD PTR[64+rdi],r24
	mov	QWORD PTR[72+rdi],r25

	mulx	r18,r17,rdx
	adox	r26,r17
	adox	r27,r18
ifdef	__CRYPTOLINE__
	cmovo	r27,r27
endif

	mov	QWORD PTR[80+rdi],r26
	mov	QWORD PTR[88+rdi],r27

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif
__sqra_384	ENDP




PUBLIC	redca_mont_384


ALIGN	32
redca_mont_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_redca_mont_384::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
redc_mont_384$4::
	lea	rsp,QWORD PTR[((-8))+rsp]

$L$SEH_body_redca_mont_384::


	mov	r8,rcx
	mov	rcx,rdx
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_redca_mont_384::
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

$L$SEH_end_redca_mont_384::
redca_mont_384	ENDP




PUBLIC	froma_mont_384


ALIGN	32
froma_mont_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_froma_mont_384::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
from_mont_384$4::
	lea	rsp,QWORD PTR[((-8))+rsp]

$L$SEH_body_froma_mont_384::


	mov	r8,rcx
	mov	rcx,rdx
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__mula_by_1_mont_384




	sub	r22,r16,QWORD PTR[rcx]
	sbb	r23,r17,QWORD PTR[8+rcx]
	sbb	r24,r18,QWORD PTR[16+rcx]
	sbb	r25,r19,QWORD PTR[24+rcx]
	sbb	r26,r20,QWORD PTR[32+rcx]
	sbb	r27,r21,QWORD PTR[40+rcx]

	cmovnc	r16,r22
	cmovnc	r17,r23
	cmovnc	r18,r24
	mov	QWORD PTR[rdi],r16
	cmovnc	r19,r25
	mov	QWORD PTR[8+rdi],r17
	cmovnc	r20,r26
	mov	QWORD PTR[16+rdi],r18
	cmovnc	r21,r27
	mov	QWORD PTR[24+rdi],r19
	mov	QWORD PTR[32+rdi],r20
	mov	QWORD PTR[40+rdi],r21

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_froma_mont_384::
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

$L$SEH_end_froma_mont_384::
froma_mont_384	ENDP


ALIGN	32
__mula_by_1_mont_384	PROC PRIVATE
	DB	243,15,30,250

	mov	r16,QWORD PTR[rsi]
	mov	r17,QWORD PTR[8+rsi]
	mov	r18,QWORD PTR[16+rsi]
	mov	r19,QWORD PTR[24+rsi]
	mov	r20,QWORD PTR[32+rsi]
	mov	r21,QWORD PTR[40+rsi]
{nf}	imul	rdx,r8,r16


	xor	r22,r22
	mulx	r11,rax,QWORD PTR[rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[8+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[16+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[24+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[32+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[40+rcx]
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r22
ifdef	__CRYPTOLINE__
	cmovo	r21,r21
endif
{nf}	imul	rdx,r8,r16


	xor	r22,r22
	mulx	r11,rax,QWORD PTR[rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[8+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[16+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[24+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[32+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[40+rcx]
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r22
ifdef	__CRYPTOLINE__
	cmovo	r21,r21
endif
{nf}	imul	rdx,r8,r16


	xor	r22,r22
	mulx	r11,rax,QWORD PTR[rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[8+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[16+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[24+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[32+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[40+rcx]
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r22
ifdef	__CRYPTOLINE__
	cmovo	r21,r21
endif
{nf}	imul	rdx,r8,r16


	xor	r22,r22
	mulx	r11,rax,QWORD PTR[rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[8+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[16+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[24+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[32+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[40+rcx]
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r22
ifdef	__CRYPTOLINE__
	cmovo	r21,r21
endif
{nf}	imul	rdx,r8,r16


	xor	r22,r22
	mulx	r11,rax,QWORD PTR[rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[8+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[16+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[24+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[32+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[40+rcx]
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r22
ifdef	__CRYPTOLINE__
	cmovo	r21,r21
endif
{nf}	imul	rdx,r8,r16


	xor	r22,r22
	mulx	r11,rax,QWORD PTR[rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[8+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[16+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[24+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[32+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[40+rcx]
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r22
ifdef	__CRYPTOLINE__
	cmovo	r21,r21
endif
	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif
__mula_by_1_mont_384	ENDP


ALIGN	32
__reda_tail_mont_384	PROC PRIVATE
	DB	243,15,30,250

	add	r16,QWORD PTR[48+rsi]
	adc	r17,QWORD PTR[56+rsi]
	adc	r18,QWORD PTR[64+rsi]
	adc	r19,QWORD PTR[72+rsi]
	adc	r20,QWORD PTR[80+rsi]
	adc	r21,QWORD PTR[88+rsi]
	sbb	r11,r11




	sub	r22,r16,QWORD PTR[rcx]
	sbb	r23,r17,QWORD PTR[8+rcx]
	sbb	r24,r18,QWORD PTR[16+rcx]
	sbb	r25,r19,QWORD PTR[24+rcx]
	sbb	r26,r20,QWORD PTR[32+rcx]
	sbb	r27,r21,QWORD PTR[40+rcx]
	sbb	r11,0

	cmovnc	r16,r22
	cmovnc	r17,r23
	cmovnc	r18,r24
	mov	QWORD PTR[rdi],r16
	cmovnc	r19,r25
	mov	QWORD PTR[8+rdi],r17
	cmovnc	r20,r26
	mov	QWORD PTR[16+rdi],r18
	cmovnc	r21,r27
	mov	QWORD PTR[24+rdi],r19
	mov	QWORD PTR[32+rdi],r20
	mov	QWORD PTR[40+rdi],r21

	
ifdef	__SGX_LVI_HARDENING__
	pop	rdx
	lfence
	jmp	rdx
	ud2
else
	DB	0F3h,0C3h
endif
__reda_tail_mont_384	ENDP

PUBLIC	sgn0a_pty_mont_384


ALIGN	32
sgn0a_pty_mont_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_sgn0a_pty_mont_384::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
sgn0_pty_mont_384$4::
	lea	rsp,QWORD PTR[((-8))+rsp]

$L$SEH_body_sgn0a_pty_mont_384::


	mov	r8,rdx
	mov	rcx,rsi
	lea	rsi,QWORD PTR[rdi]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__mula_by_1_mont_384

	xor	rax,rax
	mov	r23,r16
	add	r16,r16
	adc	r17,r17
	adc	r18,r18
	adc	r19,r19
	adc	r20,r20
	adc	r21,r21
	adc	rax,0

	sub	r16,QWORD PTR[rcx]
	sbb	r17,QWORD PTR[8+rcx]
	sbb	r18,QWORD PTR[16+rcx]
	sbb	r19,QWORD PTR[24+rcx]
	sbb	r20,QWORD PTR[32+rcx]
	sbb	r21,QWORD PTR[40+rcx]
	sbb	rax,0

	not	rax
	and	r23,1
	and	rax,2
	or	rax,r23

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_sgn0a_pty_mont_384::
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

$L$SEH_end_sgn0a_pty_mont_384::
sgn0a_pty_mont_384	ENDP

PUBLIC	sgn0a_pty_mont_384x


ALIGN	32
sgn0a_pty_mont_384x	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_sgn0a_pty_mont_384x::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
sgn0_pty_mont_384x$4::
	lea	rsp,QWORD PTR[((-8))+rsp]

$L$SEH_body_sgn0a_pty_mont_384x::


	mov	r8,rdx
	mov	rcx,rsi
	lea	rsi,QWORD PTR[48+rdi]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	call	__mula_by_1_mont_384

	mov	r22,r16
	or	r16,r17
	or	r16,r18
	or	r16,r19
	or	r16,r20
	or	r16,r21

	lea	rsi,QWORD PTR[rdi]
	xor	rdi,rdi
	mov	r23,r22
	add	r22,r22
	adc	r17,r17
	adc	r18,r18
	adc	r19,r19
	adc	r20,r20
	adc	r21,r21
	adc	rdi,0

	sub	r22,QWORD PTR[rcx]
	sbb	r17,QWORD PTR[8+rcx]
	sbb	r18,QWORD PTR[16+rcx]
	sbb	r19,QWORD PTR[24+rcx]
	sbb	r20,QWORD PTR[32+rcx]
	sbb	r21,QWORD PTR[40+rcx]
	sbb	rdi,0

	mov	QWORD PTR[rsp],r16
	not	rdi
	and	r23,1
	and	rdi,2
	or	rdi,r23

	call	__mula_by_1_mont_384

	mov	r22,r16
	or	r16,r17
	or	r16,r18
	or	r16,r19
	or	r16,r20
	or	r16,r21

	xor	rax,rax
	mov	r23,r22
	add	r22,r22
	adc	r17,r17
	adc	r18,r18
	adc	r19,r19
	adc	r20,r20
	adc	r21,r21
	adc	rax,0

	sub	r22,QWORD PTR[rcx]
	sbb	r17,QWORD PTR[8+rcx]
	sbb	r18,QWORD PTR[16+rcx]
	sbb	r19,QWORD PTR[24+rcx]
	sbb	r20,QWORD PTR[32+rcx]
	sbb	r21,QWORD PTR[40+rcx]
	sbb	rax,0

	mov	r22,QWORD PTR[rsp]

	not	rax

	test	r16,r16
	cmovz	r23,rdi

	test	r22,r22
	cmovnz	rax,rdi

	and	r23,1
	and	rax,2
	or	rax,r23

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_sgn0a_pty_mont_384x::
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

$L$SEH_end_sgn0a_pty_mont_384x::
sgn0a_pty_mont_384x	ENDP

PUBLIC	mula_mont_384


ALIGN	32
mula_mont_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_mula_mont_384::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
	mov	r8,QWORD PTR[40+rsp]
mul_mont_384$4::
	lea	rsp,QWORD PTR[((-8))+rsp]

$L$SEH_body_mula_mont_384::


	mov	r10,rdx
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	rdx,QWORD PTR[rdx]
	mov	r25,QWORD PTR[rsi]
	mov	r26,QWORD PTR[8+rsi]
	mov	r27,QWORD PTR[16+rsi]
	mov	r28,QWORD PTR[24+rsi]
	mov	r29,QWORD PTR[32+rsi]
	mov	r30,QWORD PTR[40+rsi]
	lea	rcx,QWORD PTR[((-128))+rcx]

	mulx	r20,r16,r25
	call	__mula_mont_384

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_mula_mont_384::
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

$L$SEH_end_mula_mont_384::
mula_mont_384	ENDP


ALIGN	32
__mula_mont_384	PROC PRIVATE
	DB	243,15,30,250


	mulx	r21,r17,r26
	mulx	r22,r18,r27
	add	r17,r20
	mulx	r23,r19,r28
	adc	r18,r21
	mulx	r24,r20,r29
	adc	r19,r22
	mulx	r22,r21,r30
	mov	rdx,QWORD PTR[8+r10]
	adc	r20,r23
	adc	r21,r24
	adc	r22,0
ifdef	__CRYPTOLINE__
	cmovc	r22,r22
endif
	xor	r23,r23
{nf}	imul	rsi,r16,r8


	xor	r24,r24
	mulx	r11,rax,r25
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r26
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r27
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r28
	adox	r20,rax
	adcx	r21,r11

	mulx	r11,rax,r29
	adox	r21,rax
	adcx	r22,r11

	mulx	r11,rax,r30
	mov	rdx,rsi
	adox	r22,rax
	adcx	r11,r24
	adox	r23,r11
	adox	r24,r24
ifdef	__CRYPTOLINE__
	cmovo	r24,r24
endif


	xor	rsi,rsi
	mulx	r11,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[((8+128))+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[((16+128))+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[((24+128))+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[((32+128))+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[((40+128))+rcx]
	mov	rdx,QWORD PTR[((8+8))+r10]
	adcx	r20,rax
	adox	r21,rsi
	adcx	r21,r22
	adcx	r22,r23,rsi
	adcx	r23,r24,rsi
ifdef	__CRYPTOLINE__
	cmovo	r23,r23
endif
{nf}	imul	rsi,r16,r8


	xor	r24,r24
	mulx	r11,rax,r25
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r26
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r27
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r28
	adox	r20,rax
	adcx	r21,r11

	mulx	r11,rax,r29
	adox	r21,rax
	adcx	r22,r11

	mulx	r11,rax,r30
	mov	rdx,rsi
	adox	r22,rax
	adcx	r11,r24
	adox	r23,r11
	adox	r24,r24
ifdef	__CRYPTOLINE__
	cmovo	r24,r24
endif


	xor	rsi,rsi
	mulx	r11,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[((8+128))+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[((16+128))+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[((24+128))+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[((32+128))+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[((40+128))+rcx]
	mov	rdx,QWORD PTR[((16+8))+r10]
	adcx	r20,rax
	adox	r21,rsi
	adcx	r21,r22
	adcx	r22,r23,rsi
	adcx	r23,r24,rsi
ifdef	__CRYPTOLINE__
	cmovo	r23,r23
endif
{nf}	imul	rsi,r16,r8


	xor	r24,r24
	mulx	r11,rax,r25
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r26
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r27
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r28
	adox	r20,rax
	adcx	r21,r11

	mulx	r11,rax,r29
	adox	r21,rax
	adcx	r22,r11

	mulx	r11,rax,r30
	mov	rdx,rsi
	adox	r22,rax
	adcx	r11,r24
	adox	r23,r11
	adox	r24,r24
ifdef	__CRYPTOLINE__
	cmovo	r24,r24
endif


	xor	rsi,rsi
	mulx	r11,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[((8+128))+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[((16+128))+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[((24+128))+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[((32+128))+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[((40+128))+rcx]
	mov	rdx,QWORD PTR[((24+8))+r10]
	adcx	r20,rax
	adox	r21,rsi
	adcx	r21,r22
	adcx	r22,r23,rsi
	adcx	r23,r24,rsi
ifdef	__CRYPTOLINE__
	cmovo	r23,r23
endif
{nf}	imul	rsi,r16,r8


	xor	r24,r24
	mulx	r11,rax,r25
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r26
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r27
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r28
	adox	r20,rax
	adcx	r21,r11

	mulx	r11,rax,r29
	adox	r21,rax
	adcx	r22,r11

	mulx	r11,rax,r30
	mov	rdx,rsi
	adox	r22,rax
	adcx	r11,r24
	adox	r23,r11
	adox	r24,r24
ifdef	__CRYPTOLINE__
	cmovo	r24,r24
endif


	xor	rsi,rsi
	mulx	r11,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[((8+128))+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[((16+128))+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[((24+128))+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[((32+128))+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[((40+128))+rcx]
	mov	rdx,QWORD PTR[((32+8))+r10]
	adcx	r20,rax
	adox	r21,rsi
	adcx	r21,r22
	adcx	r22,r23,rsi
	adcx	r23,r24,rsi
ifdef	__CRYPTOLINE__
	cmovo	r23,r23
endif
{nf}	imul	rsi,r16,r8


	xor	r24,r24
	mulx	r11,rax,r25
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r26
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r27
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r28
	adox	r20,rax
	adcx	r21,r11

	mulx	r11,rax,r29
	adox	r21,rax
	adcx	r22,r11

	mulx	r11,rax,r30
	mov	rdx,rsi
	adox	r22,rax
	adcx	r11,r24
	adox	r23,r11
	adox	r24,r24
ifdef	__CRYPTOLINE__
	cmovo	r24,r24
endif


	xor	rsi,rsi
	mulx	r11,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
ifdef	__CRYPTOLINE__
	cmovp	rax,rax
endif
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[((8+128))+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[((16+128))+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[((24+128))+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[((32+128))+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[((40+128))+rcx]
{nf}	imul	rdx,r16,r8
	adcx	r20,rax
	adox	r21,rsi
	adcx	r21,r22
	adcx	r22,r23,rsi
	adcx	r23,r24,rsi
ifdef	__CRYPTOLINE__
	cmovo	r23,r23
endif

	xor	r24,r24
	mulx	r25,rax,QWORD PTR[((0+128))+rcx]
	adcx	r16,rax
ifdef	__CRYPTOLINE__
	cmovp	r16,r16
endif
	adox	r25,r17

	mulx	r26,rax,QWORD PTR[((8+128))+rcx]
	adcx	r25,rax
	adox	r26,r18

	mulx	r27,rax,QWORD PTR[((16+128))+rcx]
	adcx	r26,rax
	adox	r27,r19

	mulx	r28,rax,QWORD PTR[((24+128))+rcx]
	adcx	r27,rax
	adox	r28,r20

	mulx	r29,rax,QWORD PTR[((32+128))+rcx]
	adcx	r28,rax
	adox	r29,r21

	mulx	r30,rax,QWORD PTR[((40+128))+rcx]
	adcx	r29,rax
	adox	r30,r24
	lea	rcx,QWORD PTR[128+rcx]
	adcx	r30,r22
	adc	r23,0
ifdef	__CRYPTOLINE__
	cmovo	r23,r23
endif




	sub	rdx,r25,QWORD PTR[rcx]
	sbb	r17,r26,QWORD PTR[8+rcx]
	sbb	r18,r27,QWORD PTR[16+rcx]
	sbb	r19,r28,QWORD PTR[24+rcx]
	sbb	r20,r29,QWORD PTR[32+rcx]
	sbb	r21,r30,QWORD PTR[40+rcx]
	sbb	r23,0

	cmovc	rdx,r25
	cmovnc	r26,r17
	cmovnc	r27,r18
	cmovnc	r28,r19
	mov	QWORD PTR[rdi],rdx
	cmovnc	r29,r20
	mov	QWORD PTR[8+rdi],r26
	cmovnc	r30,r21
	mov	QWORD PTR[16+rdi],r27
	mov	QWORD PTR[24+rdi],r28
	mov	QWORD PTR[32+rdi],r29
	mov	QWORD PTR[40+rdi],r30

	
ifdef	__SGX_LVI_HARDENING__
	pop	rsi
	lfence
	jmp	rsi
	ud2
else
	DB	0F3h,0C3h
endif

__mula_mont_384	ENDP

PUBLIC	sqra_mont_384


ALIGN	32
sqra_mont_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_sqra_mont_384::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
sqr_mont_384$4::
	lea	rsp,QWORD PTR[((-8))+rsp]

$L$SEH_body_sqra_mont_384::


	mov	r8,rcx
	lea	rcx,QWORD PTR[((-128))+rdx]
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	rdx,QWORD PTR[rsi]
	mov	r26,QWORD PTR[8+rsi]
	mov	r27,QWORD PTR[16+rsi]
	mov	r28,QWORD PTR[24+rsi]
	mov	r29,QWORD PTR[32+rsi]
	mov	r30,QWORD PTR[40+rsi]

	lea	r10,QWORD PTR[rsi]

	mov	r25,rdx
	mulx	r20,r16,rdx
	call	__mula_mont_384

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_sqra_mont_384::
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

$L$SEH_end_sqra_mont_384::
sqra_mont_384	ENDP

PUBLIC	sqra_n_mul_mont_384


ALIGN	32
sqra_n_mul_mont_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_sqra_n_mul_mont_384::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
	mov	r8,QWORD PTR[40+rsp]
	mov	r9,QWORD PTR[48+rsp]
sqr_n_mul_mont_384$4::
	lea	rsp,QWORD PTR[((-8))+rsp]

$L$SEH_body_sqra_n_mul_mont_384::


	mov	r31,rdx
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	rdx,QWORD PTR[rsi]
	mov	r26,QWORD PTR[8+rsi]
	mov	r27,QWORD PTR[16+rsi]
	mov	r10,rsi
	mov	r28,QWORD PTR[24+rsi]
	mov	r29,QWORD PTR[32+rsi]
	mov	r30,QWORD PTR[40+rsi]

$L$oop_sqra_384::
	lea	rcx,QWORD PTR[((-128))+rcx]

	mov	r25,rdx
	mulx	r20,r16,rdx
	call	__mula_mont_384

	mov	r10,rdi
	dec	r31d
	jnz	$L$oop_sqra_384

	mov	r25,rdx
	mov	rdx,QWORD PTR[r9]
	lea	r10,QWORD PTR[r9]
	lea	rcx,QWORD PTR[((-128))+rcx]

	mulx	r20,r16,r25
	call	__mula_mont_384

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_sqra_n_mul_mont_384::
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

$L$SEH_end_sqra_n_mul_mont_384::
sqra_n_mul_mont_384	ENDP

PUBLIC	sqra_n_mul_mont_383


ALIGN	32
sqra_n_mul_mont_383	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_sqra_n_mul_mont_383::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9
	mov	r8,QWORD PTR[40+rsp]
	mov	r9,QWORD PTR[48+rsp]
sqr_n_mul_mont_383$4::
	lea	rsp,QWORD PTR[((-8))+rsp]

$L$SEH_body_sqra_n_mul_mont_383::


	mov	r31,rdx
ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	rdx,QWORD PTR[rsi]
	mov	r26,QWORD PTR[8+rsi]
	mov	r27,QWORD PTR[16+rsi]
	mov	r28,QWORD PTR[24+rsi]
	mov	r29,QWORD PTR[32+rsi]
	mov	r30,QWORD PTR[40+rsi]
	mov	r25,rdx
	lea	rcx,QWORD PTR[((-128))+rcx]
	jmp	$L$oop_sqra_383

ALIGN	32
$L$oop_sqra_383::


	mulx	r20,r16,rdx
	mulx	r21,r17,r26
	mulx	r22,r18,r27
	add	r17,r20
	mulx	r23,r19,r28
	adc	r18,r21
	mulx	r24,r20,r29
	adc	r19,r22
	mulx	r22,r21,r30
	mov	rdx,r26
	adc	r20,r23
	adc	r21,r24
	adc	r22,0
{nf}	imul	r24,r16,r8


	xor	r23,r23
	mulx	r11,rax,r25
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r26
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r27
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r28
	adox	r20,rax
	adcx	r21,r11

	mulx	r11,rax,r29
	adox	r21,rax
	adcx	r22,r11

	mulx	r11,rax,r30
	mov	rdx,r24
	adox	r22,rax
	adcx	r11,r23
	adox	r23,r11


	xor	r24,r24
	mulx	r11,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[((8+128))+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[((16+128))+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[((24+128))+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[((32+128))+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[((40+128))+rcx]
	mov	rdx,r27
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r24
	adox	r23,r24
	adcx	r22,r23,r24
{nf}	imul	r24,r16,r8


	xor	r23,r23
	mulx	r11,rax,r25
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r26
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r27
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r28
	adox	r20,rax
	adcx	r21,r11

	mulx	r11,rax,r29
	adox	r21,rax
	adcx	r22,r11

	mulx	r11,rax,r30
	mov	rdx,r24
	adox	r22,rax
	adcx	r11,r23
	adox	r23,r11


	xor	r24,r24
	mulx	r11,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[((8+128))+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[((16+128))+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[((24+128))+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[((32+128))+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[((40+128))+rcx]
	mov	rdx,r28
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r24
	adox	r23,r24
	adcx	r22,r23,r24
{nf}	imul	r24,r16,r8


	xor	r23,r23
	mulx	r11,rax,r25
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r26
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r27
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r28
	adox	r20,rax
	adcx	r21,r11

	mulx	r11,rax,r29
	adox	r21,rax
	adcx	r22,r11

	mulx	r11,rax,r30
	mov	rdx,r24
	adox	r22,rax
	adcx	r11,r23
	adox	r23,r11


	xor	r24,r24
	mulx	r11,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[((8+128))+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[((16+128))+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[((24+128))+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[((32+128))+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[((40+128))+rcx]
	mov	rdx,r29
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r24
	adox	r23,r24
	adcx	r22,r23,r24
{nf}	imul	r24,r16,r8


	xor	r23,r23
	mulx	r11,rax,r25
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r26
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r27
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r28
	adox	r20,rax
	adcx	r21,r11

	mulx	r11,rax,r29
	adox	r21,rax
	adcx	r22,r11

	mulx	r11,rax,r30
	mov	rdx,r24
	adox	r22,rax
	adcx	r11,r23
	adox	r23,r11


	xor	r24,r24
	mulx	r11,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[((8+128))+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[((16+128))+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[((24+128))+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[((32+128))+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[((40+128))+rcx]
	mov	rdx,r30
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r24
	adox	r23,r24
	adcx	r22,r23,r24
{nf}	imul	r24,r16,r8


	xor	r23,r23
	mulx	r11,rax,r25
	adox	r17,rax
	adcx	r18,r11

	mulx	r11,rax,r26
	adox	r18,rax
	adcx	r19,r11

	mulx	r11,rax,r27
	adox	r19,rax
	adcx	r20,r11

	mulx	r11,rax,r28
	adox	r20,rax
	adcx	r21,r11

	mulx	r11,rax,r29
	adox	r21,rax
	adcx	r22,r11

	mulx	r11,rax,r30
	mov	rdx,r24
	adox	r22,rax
	adcx	r11,r23
	adox	r23,r11


	xor	r24,r24
	mulx	r11,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
	adox	r16,r17,r11

	mulx	r17,rax,QWORD PTR[((8+128))+rcx]
	adcx	r16,rax
	adox	r17,r18

	mulx	r18,rax,QWORD PTR[((16+128))+rcx]
	adcx	r17,rax
	adox	r18,r19

	mulx	r19,rax,QWORD PTR[((24+128))+rcx]
	adcx	r18,rax
	adox	r19,r20

	mulx	r20,rax,QWORD PTR[((32+128))+rcx]
	adcx	r19,rax
	adox	r20,r21

	mulx	r21,rax,QWORD PTR[((40+128))+rcx]
{nf}	imul	rdx,r16,r8
	adcx	r20,rax
	adox	r21,r22
	adcx	r21,r24
	adox	r23,r24
	adcx	r22,r23,r24

	xor	r24,r24
	mulx	r25,rax,QWORD PTR[((0+128))+rcx]
	adcx	rax,r16
	adox	r25,r17

	mulx	r26,rax,QWORD PTR[((8+128))+rcx]
	adcx	r25,rax
	adox	r26,r18

	mulx	r27,rax,QWORD PTR[((16+128))+rcx]
	adcx	r26,rax
	adox	r27,r19

	mulx	r28,rax,QWORD PTR[((24+128))+rcx]
	adcx	r27,rax
	adox	r28,r20

	mulx	r29,rax,QWORD PTR[((32+128))+rcx]
	adcx	r28,rax
	adox	r29,r21

	mulx	r30,rax,QWORD PTR[((40+128))+rcx]
	mov	rdx,r25
	adcx	r29,rax
	adox	r30,r22
	adc	r30,0

	dec	r31d
	jnz	$L$oop_sqra_383

	mov	rdx,QWORD PTR[r9]
	lea	r10,QWORD PTR[r9]

	mulx	r20,r16,r25
	call	__mula_mont_384

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_sqra_n_mul_mont_383::
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

$L$SEH_end_sqra_n_mul_mont_383::
sqra_n_mul_mont_383	ENDP
PUBLIC	mula_by_1_plus_i_mod_384x


ALIGN	32
mula_by_1_plus_i_mod_384x	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_mula_by_1_plus_i_mod_384x::


	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	sub	rsp,8

$L$SEH_body_mula_by_1_plus_i_mod_384x::


ifdef	__SGX_LVI_HARDENING__
	lfence
endif
	mov	r22,QWORD PTR[rsi]
	mov	r23,QWORD PTR[8+rsi]
	mov	r24,QWORD PTR[16+rsi]
	mov	r25,QWORD PTR[24+rsi]
	mov	r26,QWORD PTR[32+rsi]
	mov	r27,QWORD PTR[40+rsi]

	sub	r16,r22,QWORD PTR[48+rsi]
	sbb	r17,r23,QWORD PTR[56+rsi]
	sbb	r18,r24,QWORD PTR[64+rsi]
	sbb	r19,r25,QWORD PTR[72+rsi]
	sbb	r20,r26,QWORD PTR[80+rsi]
	sbb	r21,r27,QWORD PTR[88+rsi]
	sbb	rax,rax

	add	r22,QWORD PTR[48+rsi]
	adc	r23,QWORD PTR[56+rsi]
	adc	r24,QWORD PTR[64+rsi]
	adc	r25,QWORD PTR[72+rsi]
	adc	r26,QWORD PTR[80+rsi]
	adc	r27,QWORD PTR[88+rsi]
	sbb	r11,r11

{nf}	and	r28,rax,QWORD PTR[rdx]
{nf}	and	r29,rax,QWORD PTR[8+rdx]
{nf}	and	r30,rax,QWORD PTR[16+rdx]
{nf}	and	r31,rax,QWORD PTR[24+rdx]
{nf}	and	r8,rax,QWORD PTR[32+rdx]
{nf}	and	r9,rax,QWORD PTR[40+rdx]

	add	r16,r28
	adc	r17,r29
	adc	r18,r30
	adc	r19,r31
	adc	r20,r8
	adc	r21,r9

	sub	r28,r22,QWORD PTR[rdx]
	sbb	r29,r23,QWORD PTR[8+rdx]
	sbb	r30,r24,QWORD PTR[16+rdx]
	sbb	r31,r25,QWORD PTR[24+rdx]
	sbb	r8,r26,QWORD PTR[32+rdx]
	sbb	r9,r27,QWORD PTR[40+rdx]
	sbb	r11,0

	mov	QWORD PTR[rdi],r16
	mov	QWORD PTR[8+rdi],r17
	mov	QWORD PTR[16+rdi],r18
	mov	QWORD PTR[24+rdi],r19
	mov	QWORD PTR[32+rdi],r20
	mov	QWORD PTR[40+rdi],r21

	cmovnc	r22,r28
	cmovnc	r23,r29
	cmovnc	r24,r30
	cmovnc	r25,r31
	cmovnc	r26,r8
	cmovnc	r27,r9

	mov	QWORD PTR[48+rdi],r22
	mov	QWORD PTR[56+rdi],r23
	mov	QWORD PTR[64+rdi],r24
	mov	QWORD PTR[72+rdi],r25
	mov	QWORD PTR[80+rdi],r26
	mov	QWORD PTR[88+rdi],r27

	lea	rsp,QWORD PTR[8+rsp]

$L$SEH_epilogue_mula_by_1_plus_i_mod_384x::
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

$L$SEH_end_mula_by_1_plus_i_mod_384x::
mula_by_1_plus_i_mod_384x	ENDP
.text$	ENDS
.pdata	SEGMENT READONLY ALIGN(4)
ALIGN	4
	DD	imagerel $L$SEH_begin_adda_mod_384
	DD	imagerel $L$SEH_body_adda_mod_384
	DD	imagerel $L$SEH_info_adda_mod_384_prologue

	DD	imagerel $L$SEH_body_adda_mod_384
	DD	imagerel $L$SEH_epilogue_adda_mod_384
	DD	imagerel $L$SEH_info_adda_mod_384_body

	DD	imagerel $L$SEH_epilogue_adda_mod_384
	DD	imagerel $L$SEH_end_adda_mod_384
	DD	imagerel $L$SEH_info_adda_mod_384_epilogue

	DD	imagerel $L$SEH_begin_suba_mod_384
	DD	imagerel $L$SEH_body_suba_mod_384
	DD	imagerel $L$SEH_info_suba_mod_384_prologue

	DD	imagerel $L$SEH_body_suba_mod_384
	DD	imagerel $L$SEH_epilogue_suba_mod_384
	DD	imagerel $L$SEH_info_suba_mod_384_body

	DD	imagerel $L$SEH_epilogue_suba_mod_384
	DD	imagerel $L$SEH_end_suba_mod_384
	DD	imagerel $L$SEH_info_suba_mod_384_epilogue

	DD	imagerel $L$SEH_begin_mula_mont_384x
	DD	imagerel $L$SEH_body_mula_mont_384x
	DD	imagerel $L$SEH_info_mula_mont_384x_prologue

	DD	imagerel $L$SEH_body_mula_mont_384x
	DD	imagerel $L$SEH_epilogue_mula_mont_384x
	DD	imagerel $L$SEH_info_mula_mont_384x_body

	DD	imagerel $L$SEH_epilogue_mula_mont_384x
	DD	imagerel $L$SEH_end_mula_mont_384x
	DD	imagerel $L$SEH_info_mula_mont_384x_epilogue

	DD	imagerel $L$SEH_begin_sqra_mont_384x
	DD	imagerel $L$SEH_body_sqra_mont_384x
	DD	imagerel $L$SEH_info_sqra_mont_384x_prologue

	DD	imagerel $L$SEH_body_sqra_mont_384x
	DD	imagerel $L$SEH_epilogue_sqra_mont_384x
	DD	imagerel $L$SEH_info_sqra_mont_384x_body

	DD	imagerel $L$SEH_epilogue_sqra_mont_384x
	DD	imagerel $L$SEH_end_sqra_mont_384x
	DD	imagerel $L$SEH_info_sqra_mont_384x_epilogue

	DD	imagerel $L$SEH_begin_mula_382x
	DD	imagerel $L$SEH_body_mula_382x
	DD	imagerel $L$SEH_info_mula_382x_prologue

	DD	imagerel $L$SEH_body_mula_382x
	DD	imagerel $L$SEH_epilogue_mula_382x
	DD	imagerel $L$SEH_info_mula_382x_body

	DD	imagerel $L$SEH_epilogue_mula_382x
	DD	imagerel $L$SEH_end_mula_382x
	DD	imagerel $L$SEH_info_mula_382x_epilogue

	DD	imagerel $L$SEH_begin_sqra_382x
	DD	imagerel $L$SEH_body_sqra_382x
	DD	imagerel $L$SEH_info_sqra_382x_prologue

	DD	imagerel $L$SEH_body_sqra_382x
	DD	imagerel $L$SEH_epilogue_sqra_382x
	DD	imagerel $L$SEH_info_sqra_382x_body

	DD	imagerel $L$SEH_epilogue_sqra_382x
	DD	imagerel $L$SEH_end_sqra_382x
	DD	imagerel $L$SEH_info_sqra_382x_epilogue

	DD	imagerel $L$SEH_begin_mula_384
	DD	imagerel $L$SEH_body_mula_384
	DD	imagerel $L$SEH_info_mula_384_prologue

	DD	imagerel $L$SEH_body_mula_384
	DD	imagerel $L$SEH_epilogue_mula_384
	DD	imagerel $L$SEH_info_mula_384_body

	DD	imagerel $L$SEH_epilogue_mula_384
	DD	imagerel $L$SEH_end_mula_384
	DD	imagerel $L$SEH_info_mula_384_epilogue

	DD	imagerel $L$SEH_begin_sqra_384
	DD	imagerel $L$SEH_body_sqra_384
	DD	imagerel $L$SEH_info_sqra_384_prologue

	DD	imagerel $L$SEH_body_sqra_384
	DD	imagerel $L$SEH_epilogue_sqra_384
	DD	imagerel $L$SEH_info_sqra_384_body

	DD	imagerel $L$SEH_epilogue_sqra_384
	DD	imagerel $L$SEH_end_sqra_384
	DD	imagerel $L$SEH_info_sqra_384_epilogue

	DD	imagerel $L$SEH_begin_redca_mont_384
	DD	imagerel $L$SEH_body_redca_mont_384
	DD	imagerel $L$SEH_info_redca_mont_384_prologue

	DD	imagerel $L$SEH_body_redca_mont_384
	DD	imagerel $L$SEH_epilogue_redca_mont_384
	DD	imagerel $L$SEH_info_redca_mont_384_body

	DD	imagerel $L$SEH_epilogue_redca_mont_384
	DD	imagerel $L$SEH_end_redca_mont_384
	DD	imagerel $L$SEH_info_redca_mont_384_epilogue

	DD	imagerel $L$SEH_begin_froma_mont_384
	DD	imagerel $L$SEH_body_froma_mont_384
	DD	imagerel $L$SEH_info_froma_mont_384_prologue

	DD	imagerel $L$SEH_body_froma_mont_384
	DD	imagerel $L$SEH_epilogue_froma_mont_384
	DD	imagerel $L$SEH_info_froma_mont_384_body

	DD	imagerel $L$SEH_epilogue_froma_mont_384
	DD	imagerel $L$SEH_end_froma_mont_384
	DD	imagerel $L$SEH_info_froma_mont_384_epilogue

	DD	imagerel $L$SEH_begin_sgn0a_pty_mont_384
	DD	imagerel $L$SEH_body_sgn0a_pty_mont_384
	DD	imagerel $L$SEH_info_sgn0a_pty_mont_384_prologue

	DD	imagerel $L$SEH_body_sgn0a_pty_mont_384
	DD	imagerel $L$SEH_epilogue_sgn0a_pty_mont_384
	DD	imagerel $L$SEH_info_sgn0a_pty_mont_384_body

	DD	imagerel $L$SEH_epilogue_sgn0a_pty_mont_384
	DD	imagerel $L$SEH_end_sgn0a_pty_mont_384
	DD	imagerel $L$SEH_info_sgn0a_pty_mont_384_epilogue

	DD	imagerel $L$SEH_begin_sgn0a_pty_mont_384x
	DD	imagerel $L$SEH_body_sgn0a_pty_mont_384x
	DD	imagerel $L$SEH_info_sgn0a_pty_mont_384x_prologue

	DD	imagerel $L$SEH_body_sgn0a_pty_mont_384x
	DD	imagerel $L$SEH_epilogue_sgn0a_pty_mont_384x
	DD	imagerel $L$SEH_info_sgn0a_pty_mont_384x_body

	DD	imagerel $L$SEH_epilogue_sgn0a_pty_mont_384x
	DD	imagerel $L$SEH_end_sgn0a_pty_mont_384x
	DD	imagerel $L$SEH_info_sgn0a_pty_mont_384x_epilogue

	DD	imagerel $L$SEH_begin_mula_mont_384
	DD	imagerel $L$SEH_body_mula_mont_384
	DD	imagerel $L$SEH_info_mula_mont_384_prologue

	DD	imagerel $L$SEH_body_mula_mont_384
	DD	imagerel $L$SEH_epilogue_mula_mont_384
	DD	imagerel $L$SEH_info_mula_mont_384_body

	DD	imagerel $L$SEH_epilogue_mula_mont_384
	DD	imagerel $L$SEH_end_mula_mont_384
	DD	imagerel $L$SEH_info_mula_mont_384_epilogue

	DD	imagerel $L$SEH_begin_sqra_mont_384
	DD	imagerel $L$SEH_body_sqra_mont_384
	DD	imagerel $L$SEH_info_sqra_mont_384_prologue

	DD	imagerel $L$SEH_body_sqra_mont_384
	DD	imagerel $L$SEH_epilogue_sqra_mont_384
	DD	imagerel $L$SEH_info_sqra_mont_384_body

	DD	imagerel $L$SEH_epilogue_sqra_mont_384
	DD	imagerel $L$SEH_end_sqra_mont_384
	DD	imagerel $L$SEH_info_sqra_mont_384_epilogue

	DD	imagerel $L$SEH_begin_sqra_n_mul_mont_384
	DD	imagerel $L$SEH_body_sqra_n_mul_mont_384
	DD	imagerel $L$SEH_info_sqra_n_mul_mont_384_prologue

	DD	imagerel $L$SEH_body_sqra_n_mul_mont_384
	DD	imagerel $L$SEH_epilogue_sqra_n_mul_mont_384
	DD	imagerel $L$SEH_info_sqra_n_mul_mont_384_body

	DD	imagerel $L$SEH_epilogue_sqra_n_mul_mont_384
	DD	imagerel $L$SEH_end_sqra_n_mul_mont_384
	DD	imagerel $L$SEH_info_sqra_n_mul_mont_384_epilogue

	DD	imagerel $L$SEH_begin_sqra_n_mul_mont_383
	DD	imagerel $L$SEH_body_sqra_n_mul_mont_383
	DD	imagerel $L$SEH_info_sqra_n_mul_mont_383_prologue

	DD	imagerel $L$SEH_body_sqra_n_mul_mont_383
	DD	imagerel $L$SEH_epilogue_sqra_n_mul_mont_383
	DD	imagerel $L$SEH_info_sqra_n_mul_mont_383_body

	DD	imagerel $L$SEH_epilogue_sqra_n_mul_mont_383
	DD	imagerel $L$SEH_end_sqra_n_mul_mont_383
	DD	imagerel $L$SEH_info_sqra_n_mul_mont_383_epilogue

	DD	imagerel $L$SEH_begin_mula_by_1_plus_i_mod_384x
	DD	imagerel $L$SEH_body_mula_by_1_plus_i_mod_384x
	DD	imagerel $L$SEH_info_mula_by_1_plus_i_mod_384x_prologue

	DD	imagerel $L$SEH_body_mula_by_1_plus_i_mod_384x
	DD	imagerel $L$SEH_epilogue_mula_by_1_plus_i_mod_384x
	DD	imagerel $L$SEH_info_mula_by_1_plus_i_mod_384x_body

	DD	imagerel $L$SEH_epilogue_mula_by_1_plus_i_mod_384x
	DD	imagerel $L$SEH_end_mula_by_1_plus_i_mod_384x
	DD	imagerel $L$SEH_info_mula_by_1_plus_i_mod_384x_epilogue

.pdata	ENDS
.xdata	SEGMENT READONLY ALIGN(8)
ALIGN	8
$L$SEH_info_adda_mod_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_adda_mod_384_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_adda_mod_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_suba_mod_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_suba_mod_384_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_suba_mod_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_mula_mont_384x_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_mula_mont_384x_body::
DB	1,0,6,0
DB	000h,074h,026h,000h
DB	000h,064h,027h,000h
DB	000h,001h,025h,000h
DB	000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_mula_mont_384x_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_sqra_mont_384x_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_sqra_mont_384x_body::
DB	1,0,5,0
DB	000h,074h,00eh,000h
DB	000h,064h,00fh,000h
DB	000h,0c2h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_sqra_mont_384x_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_mula_382x_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_mula_382x_body::
DB	1,0,5,0
DB	000h,074h,00eh,000h
DB	000h,064h,00fh,000h
DB	000h,0c2h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_mula_382x_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_sqra_382x_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_sqra_382x_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_sqra_382x_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_mula_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_mula_384_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_mula_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_sqra_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_sqra_384_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_sqra_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_redca_mont_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_redca_mont_384_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_redca_mont_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_froma_mont_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_froma_mont_384_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_froma_mont_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_sgn0a_pty_mont_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_sgn0a_pty_mont_384_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_sgn0a_pty_mont_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_sgn0a_pty_mont_384x_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_sgn0a_pty_mont_384x_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_sgn0a_pty_mont_384x_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_mula_mont_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_mula_mont_384_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_mula_mont_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_sqra_mont_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_sqra_mont_384_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_sqra_mont_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_sqra_n_mul_mont_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_sqra_n_mul_mont_384_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_sqra_n_mul_mont_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_sqra_n_mul_mont_383_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_sqra_n_mul_mont_383_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_sqra_n_mul_mont_383_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_mula_by_1_plus_i_mod_384x_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,0b3h
DB	0,0
	DD	0,0
$L$SEH_info_mula_by_1_plus_i_mod_384x_body::
DB	1,0,5,0
DB	000h,074h,002h,000h
DB	000h,064h,003h,000h
DB	000h,002h
DB	000h,000h,000h,000h,000h,000h
DB	000h,000h,000h,000h
$L$SEH_info_mula_by_1_plus_i_mod_384x_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h


.xdata	ENDS
END
