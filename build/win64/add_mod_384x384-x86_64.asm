OPTION	DOTNAME
.text$	SEGMENT ALIGN(256) 'CODE'


ALIGN	32
__add_mod_384x384	PROC PRIVATE
	DB	243,15,30,250
	mov	r8,QWORD PTR[rsi]
	mov	r9,QWORD PTR[8+rsi]
	mov	r10,QWORD PTR[16+rsi]
	mov	r11,QWORD PTR[24+rsi]
	mov	r12,QWORD PTR[32+rsi]
	mov	r13,QWORD PTR[40+rsi]
	mov	r14,QWORD PTR[48+rsi]

	add	r8,QWORD PTR[rdx]
	mov	r15,QWORD PTR[56+rsi]
	adc	r9,QWORD PTR[8+rdx]
	mov	rax,QWORD PTR[64+rsi]
	adc	r10,QWORD PTR[16+rdx]
	mov	rbx,QWORD PTR[72+rsi]
	adc	r11,QWORD PTR[24+rdx]
	mov	rbp,QWORD PTR[80+rsi]
	adc	r12,QWORD PTR[32+rdx]
	mov	rsi,QWORD PTR[88+rsi]
	adc	r13,QWORD PTR[40+rdx]
	mov	QWORD PTR[rdi],r8
	adc	r14,QWORD PTR[48+rdx]
	mov	QWORD PTR[8+rdi],r9
	adc	r15,QWORD PTR[56+rdx]
	mov	QWORD PTR[16+rdi],r10
	adc	rax,QWORD PTR[64+rdx]
	mov	QWORD PTR[32+rdi],r12
	mov	r8,r14
	adc	rbx,QWORD PTR[72+rdx]
	mov	QWORD PTR[24+rdi],r11
	mov	r9,r15
	adc	rbp,QWORD PTR[80+rdx]
	mov	QWORD PTR[40+rdi],r13
	mov	r10,rax
	adc	rsi,QWORD PTR[88+rdx]
	mov	r11,rbx
	sbb	rdx,rdx

	sub	r14,QWORD PTR[rcx]
	sbb	r15,QWORD PTR[8+rcx]
	mov	r12,rbp
	sbb	rax,QWORD PTR[16+rcx]
	sbb	rbx,QWORD PTR[24+rcx]
	sbb	rbp,QWORD PTR[32+rcx]
	mov	r13,rsi
	sbb	rsi,QWORD PTR[40+rcx]
	sbb	rdx,0

	cmovc	r14,r8
	cmovc	r15,r9
	cmovc	rax,r10
	mov	QWORD PTR[48+rdi],r14
	cmovc	rbx,r11
	mov	QWORD PTR[56+rdi],r15
	cmovc	rbp,r12
	mov	QWORD PTR[64+rdi],rax
	cmovc	rsi,r13
	mov	QWORD PTR[72+rdi],rbx
	mov	QWORD PTR[80+rdi],rbp
	mov	QWORD PTR[88+rdi],rsi

	DB	0F3h,0C3h		;repret
__add_mod_384x384	ENDP


ALIGN	32
__sub_mod_384x384	PROC PRIVATE
	DB	243,15,30,250
	mov	r8,QWORD PTR[rsi]
	mov	r9,QWORD PTR[8+rsi]
	mov	r10,QWORD PTR[16+rsi]
	mov	r11,QWORD PTR[24+rsi]
	mov	r12,QWORD PTR[32+rsi]
	mov	r13,QWORD PTR[40+rsi]
	mov	r14,QWORD PTR[48+rsi]

	sub	r8,QWORD PTR[rdx]
	mov	r15,QWORD PTR[56+rsi]
	sbb	r9,QWORD PTR[8+rdx]
	mov	rax,QWORD PTR[64+rsi]
	sbb	r10,QWORD PTR[16+rdx]
	mov	rbx,QWORD PTR[72+rsi]
	sbb	r11,QWORD PTR[24+rdx]
	mov	rbp,QWORD PTR[80+rsi]
	sbb	r12,QWORD PTR[32+rdx]
	mov	rsi,QWORD PTR[88+rsi]
	sbb	r13,QWORD PTR[40+rdx]
	mov	QWORD PTR[rdi],r8
	sbb	r14,QWORD PTR[48+rdx]
	mov	r8,QWORD PTR[rcx]
	mov	QWORD PTR[8+rdi],r9
	sbb	r15,QWORD PTR[56+rdx]
	mov	r9,QWORD PTR[8+rcx]
	mov	QWORD PTR[16+rdi],r10
	sbb	rax,QWORD PTR[64+rdx]
	mov	r10,QWORD PTR[16+rcx]
	mov	QWORD PTR[24+rdi],r11
	sbb	rbx,QWORD PTR[72+rdx]
	mov	r11,QWORD PTR[24+rcx]
	mov	QWORD PTR[32+rdi],r12
	sbb	rbp,QWORD PTR[80+rdx]
	mov	r12,QWORD PTR[32+rcx]
	mov	QWORD PTR[40+rdi],r13
	sbb	rsi,QWORD PTR[88+rdx]
	mov	r13,QWORD PTR[40+rcx]
	sbb	rdx,rdx

	and	r8,rdx
	and	r9,rdx
	and	r10,rdx
	and	r11,rdx
	and	r12,rdx
	and	r13,rdx

	add	r14,r8
	adc	r15,r9
	mov	QWORD PTR[48+rdi],r14
	adc	rax,r10
	mov	QWORD PTR[56+rdi],r15
	adc	rbx,r11
	mov	QWORD PTR[64+rdi],rax
	adc	rbp,r12
	mov	QWORD PTR[72+rdi],rbx
	adc	rsi,r13
	mov	QWORD PTR[80+rdi],rbp
	mov	QWORD PTR[88+rdi],rsi

	DB	0F3h,0C3h		;repret
__sub_mod_384x384	ENDP

PUBLIC	add_mod_384x384


ALIGN	32
add_mod_384x384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_add_mod_384x384::
	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9



	push	rbp

	push	rbx

	push	r12

	push	r13

	push	r14

	push	r15

	sub	rsp,8

$L$SEH_body_add_mod_384x384::


	call	__add_mod_384x384

	mov	r15,QWORD PTR[8+rsp]

	mov	r14,QWORD PTR[16+rsp]

	mov	r13,QWORD PTR[24+rsp]

	mov	r12,QWORD PTR[32+rsp]

	mov	rbx,QWORD PTR[40+rsp]

	mov	rbp,QWORD PTR[48+rsp]

	lea	rsp,QWORD PTR[56+rsp]

$L$SEH_epilogue_add_mod_384x384::
	mov	rdi,QWORD PTR[8+rsp]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+rsp]

	DB	0F3h,0C3h		;repret

$L$SEH_end_add_mod_384x384::
add_mod_384x384	ENDP

PUBLIC	sub_mod_384x384


ALIGN	32
sub_mod_384x384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_sub_mod_384x384::
	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8
	mov	rcx,r9



	push	rbp

	push	rbx

	push	r12

	push	r13

	push	r14

	push	r15

	sub	rsp,8

$L$SEH_body_sub_mod_384x384::


	call	__sub_mod_384x384

	mov	r15,QWORD PTR[8+rsp]

	mov	r14,QWORD PTR[16+rsp]

	mov	r13,QWORD PTR[24+rsp]

	mov	r12,QWORD PTR[32+rsp]

	mov	rbx,QWORD PTR[40+rsp]

	mov	rbp,QWORD PTR[48+rsp]

	lea	rsp,QWORD PTR[56+rsp]

$L$SEH_epilogue_sub_mod_384x384::
	mov	rdi,QWORD PTR[8+rsp]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+rsp]

	DB	0F3h,0C3h		;repret

$L$SEH_end_sub_mod_384x384::
sub_mod_384x384	ENDP

ALIGN	32
__lshift_mod_384x384	PROC PRIVATE
	DB	243,15,30,250
	add	r8,r8
	adc	r9,r9
	adc	r10,r10
	adc	r11,r11
	adc	r12,r12
DB	102,73,15,110,192
	adc	r13,r13
DB	102,73,15,110,201
	adc	r14,r14
DB	102,73,15,110,210
	adc	r15,r15
DB	102,73,15,110,219
	adc	rax,rax
DB	102,73,15,110,228
	mov	r8,r14
	adc	rbx,rbx
DB	102,73,15,110,237
	mov	r9,r15
	adc	rcx,rcx
	adc	rbp,rbp
	mov	r10,rax
	sbb	rdi,rdi

	sub	r14,QWORD PTR[rdx]
	mov	r11,rbx
	sbb	r15,QWORD PTR[8+rdx]
	sbb	rax,QWORD PTR[16+rdx]
	mov	r12,rcx
	sbb	rbx,QWORD PTR[24+rdx]
	sbb	rcx,QWORD PTR[32+rdx]
	mov	r13,rbp
	sbb	rbp,QWORD PTR[40+rdx]
	sbb	rdi,0

	cmovc	r14,r8
DB	102,73,15,126,192
	cmovc	r15,r9
DB	102,73,15,126,201
	cmovc	rax,r10
DB	102,73,15,126,210
	cmovc	rbx,r11
DB	102,73,15,126,219
	cmovc	rcx,r12
DB	102,73,15,126,228
	cmovc	rbp,r13
DB	102,73,15,126,237
	DB	0F3h,0C3h		;repret
__lshift_mod_384x384	ENDP

PUBLIC	mul_by_5_mod_384x384


ALIGN	32
mul_by_5_mod_384x384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_mul_by_5_mod_384x384::
	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8



	push	rbp

	push	rbx

	push	r12

	push	r13

	push	r14

	push	r15

	push	rdi

$L$SEH_body_mul_by_5_mod_384x384::


	mov	r8,QWORD PTR[rsi]
	mov	r9,QWORD PTR[8+rsi]
	mov	r10,QWORD PTR[16+rsi]
	mov	r11,QWORD PTR[24+rsi]
	mov	r12,QWORD PTR[32+rsi]
	mov	r13,QWORD PTR[40+rsi]
	mov	r14,QWORD PTR[48+rsi]
	mov	r15,QWORD PTR[56+rsi]
	mov	rax,QWORD PTR[64+rsi]
	mov	rbx,QWORD PTR[72+rsi]
	mov	rcx,QWORD PTR[80+rsi]
	mov	rbp,QWORD PTR[88+rsi]

	call	__lshift_mod_384x384
	call	__lshift_mod_384x384
	mov	rdi,QWORD PTR[rsp]

	add	r8,QWORD PTR[rsi]
	adc	r9,QWORD PTR[8+rsi]
	adc	r10,QWORD PTR[16+rsi]
	adc	r11,QWORD PTR[24+rsi]
	adc	r12,QWORD PTR[32+rsi]
	adc	r13,QWORD PTR[40+rsi]
	mov	QWORD PTR[rdi],r8
	adc	r14,QWORD PTR[48+rsi]
	mov	QWORD PTR[8+rdi],r9
	adc	r15,QWORD PTR[56+rsi]
	mov	QWORD PTR[16+rdi],r10
	adc	rax,QWORD PTR[64+rsi]
	mov	QWORD PTR[24+rdi],r11
	mov	r8,r14
	adc	rbx,QWORD PTR[72+rsi]
	mov	QWORD PTR[32+rdi],r12
	mov	r9,r15
	adc	rcx,QWORD PTR[80+rsi]
	mov	QWORD PTR[40+rdi],r13
	mov	r10,rax
	adc	rbp,QWORD PTR[88+rsi]
	sbb	rsi,rsi

	sub	r14,QWORD PTR[rdx]
	mov	r11,rbx
	sbb	r15,QWORD PTR[8+rdx]
	sbb	rax,QWORD PTR[16+rdx]
	mov	r12,rcx
	sbb	rbx,QWORD PTR[24+rdx]
	sbb	rcx,QWORD PTR[32+rdx]
	mov	r13,rbp
	sbb	rbp,QWORD PTR[40+rdx]
	sbb	rsi,0

	cmovc	r14,r8
	cmovc	r15,r9
	cmovc	rax,r10
	mov	QWORD PTR[48+rdi],r14
	cmovc	rbx,r11
	mov	QWORD PTR[56+rdi],r15
	cmovc	rcx,r12
	mov	QWORD PTR[64+rdi],rax
	cmovc	rbp,r13
	mov	QWORD PTR[72+rdi],rbx
	mov	QWORD PTR[80+rdi],rcx
	mov	QWORD PTR[88+rdi],rbp

	mov	r15,QWORD PTR[8+rsp]

	mov	r14,QWORD PTR[16+rsp]

	mov	r13,QWORD PTR[24+rsp]

	mov	r12,QWORD PTR[32+rsp]

	mov	rbx,QWORD PTR[40+rsp]

	mov	rbp,QWORD PTR[48+rsp]

	lea	rsp,QWORD PTR[56+rsp]

$L$SEH_epilogue_mul_by_5_mod_384x384::
	mov	rdi,QWORD PTR[8+rsp]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+rsp]

	DB	0F3h,0C3h		;repret

$L$SEH_end_mul_by_5_mod_384x384::
mul_by_5_mod_384x384	ENDP

PUBLIC	neg_mod_384x384


ALIGN	32
neg_mod_384x384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_neg_mod_384x384::
	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8



	push	rbp

	push	rbx

	push	r12

	push	r13

	push	r14

	push	r15

	sub	rsp,8

$L$SEH_body_neg_mod_384x384::


	mov	rax,QWORD PTR[rsi]
	mov	rbx,QWORD PTR[8+rsi]
	mov	rcx,QWORD PTR[16+rsi]
	mov	rbp,QWORD PTR[24+rsi]
	or	rax,QWORD PTR[32+rsi]
	or	rbx,QWORD PTR[40+rsi]
	or	rcx,QWORD PTR[48+rsi]
	or	rbp,QWORD PTR[56+rsi]
	xor	r8,r8
	or	rax,QWORD PTR[64+rsi]
	xor	r9,r9
	or	rbx,QWORD PTR[72+rsi]
	xor	r10,r10
	or	rcx,QWORD PTR[80+rsi]
	xor	r11,r11
	or	rbp,QWORD PTR[88+rsi]
	xor	r12,r12
	or	rbx,rax
	xor	r13,r13
	or	rbp,rcx
	xor	r14,r14
	mov	rax,-1
	or	rbp,rbx
	cmovnz	rbp,rax
	cmovnz	r14,rax

	mov	r15,rbp
	mov	rax,rbp
	mov	rbx,rbp
	mov	rcx,rbp
	and	r14,QWORD PTR[rdx]
	and	r15,QWORD PTR[8+rdx]
	and	rax,QWORD PTR[16+rdx]
	and	rbx,QWORD PTR[24+rdx]
	and	rcx,QWORD PTR[32+rdx]
	and	rbp,QWORD PTR[40+rdx]

	sub	r8,QWORD PTR[rsi]
	sbb	r9,QWORD PTR[8+rsi]
	sbb	r10,QWORD PTR[16+rsi]
	sbb	r11,QWORD PTR[24+rsi]
	sbb	r12,QWORD PTR[32+rsi]
	sbb	r13,QWORD PTR[40+rsi]
	mov	QWORD PTR[rdi],r8
	sbb	r14,QWORD PTR[48+rsi]
	mov	QWORD PTR[8+rdi],r9
	sbb	r15,QWORD PTR[56+rsi]
	mov	QWORD PTR[16+rdi],r10
	sbb	rax,QWORD PTR[64+rsi]
	mov	QWORD PTR[24+rdi],r11
	sbb	rbx,QWORD PTR[72+rsi]
	mov	QWORD PTR[32+rdi],r12
	sbb	rcx,QWORD PTR[80+rsi]
	mov	QWORD PTR[40+rdi],r13
	sbb	rbp,QWORD PTR[88+rsi]
	mov	QWORD PTR[48+rdi],r14
	mov	QWORD PTR[56+rdi],r15
	mov	QWORD PTR[64+rdi],rax
	mov	QWORD PTR[72+rdi],rbx
	mov	QWORD PTR[80+rdi],rcx
	mov	QWORD PTR[88+rdi],rbp

	mov	r15,QWORD PTR[8+rsp]

	mov	r14,QWORD PTR[16+rsp]

	mov	r13,QWORD PTR[24+rsp]

	mov	r12,QWORD PTR[32+rsp]

	mov	rbx,QWORD PTR[40+rsp]

	mov	rbp,QWORD PTR[48+rsp]

	lea	rsp,QWORD PTR[56+rsp]

$L$SEH_epilogue_neg_mod_384x384::
	mov	rdi,QWORD PTR[8+rsp]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+rsp]

	DB	0F3h,0C3h		;repret

$L$SEH_end_neg_mod_384x384::
neg_mod_384x384	ENDP
.text$	ENDS
.pdata	SEGMENT READONLY ALIGN(4)
ALIGN	4
	DD	imagerel $L$SEH_begin_add_mod_384x384
	DD	imagerel $L$SEH_body_add_mod_384x384
	DD	imagerel $L$SEH_info_add_mod_384x384_prologue

	DD	imagerel $L$SEH_body_add_mod_384x384
	DD	imagerel $L$SEH_epilogue_add_mod_384x384
	DD	imagerel $L$SEH_info_add_mod_384x384_body

	DD	imagerel $L$SEH_epilogue_add_mod_384x384
	DD	imagerel $L$SEH_end_add_mod_384x384
	DD	imagerel $L$SEH_info_add_mod_384x384_epilogue

	DD	imagerel $L$SEH_begin_sub_mod_384x384
	DD	imagerel $L$SEH_body_sub_mod_384x384
	DD	imagerel $L$SEH_info_sub_mod_384x384_prologue

	DD	imagerel $L$SEH_body_sub_mod_384x384
	DD	imagerel $L$SEH_epilogue_sub_mod_384x384
	DD	imagerel $L$SEH_info_sub_mod_384x384_body

	DD	imagerel $L$SEH_epilogue_sub_mod_384x384
	DD	imagerel $L$SEH_end_sub_mod_384x384
	DD	imagerel $L$SEH_info_sub_mod_384x384_epilogue

	DD	imagerel $L$SEH_begin_mul_by_5_mod_384x384
	DD	imagerel $L$SEH_body_mul_by_5_mod_384x384
	DD	imagerel $L$SEH_info_mul_by_5_mod_384x384_prologue

	DD	imagerel $L$SEH_body_mul_by_5_mod_384x384
	DD	imagerel $L$SEH_epilogue_mul_by_5_mod_384x384
	DD	imagerel $L$SEH_info_mul_by_5_mod_384x384_body

	DD	imagerel $L$SEH_epilogue_mul_by_5_mod_384x384
	DD	imagerel $L$SEH_end_mul_by_5_mod_384x384
	DD	imagerel $L$SEH_info_mul_by_5_mod_384x384_epilogue

	DD	imagerel $L$SEH_begin_neg_mod_384x384
	DD	imagerel $L$SEH_body_neg_mod_384x384
	DD	imagerel $L$SEH_info_neg_mod_384x384_prologue

	DD	imagerel $L$SEH_body_neg_mod_384x384
	DD	imagerel $L$SEH_epilogue_neg_mod_384x384
	DD	imagerel $L$SEH_info_neg_mod_384x384_body

	DD	imagerel $L$SEH_epilogue_neg_mod_384x384
	DD	imagerel $L$SEH_end_neg_mod_384x384
	DD	imagerel $L$SEH_info_neg_mod_384x384_epilogue

.pdata	ENDS
.xdata	SEGMENT READONLY ALIGN(8)
ALIGN	8
$L$SEH_info_add_mod_384x384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,003h
DB	0,0
$L$SEH_info_add_mod_384x384_body::
DB	1,0,17,0
DB	000h,0f4h,001h,000h
DB	000h,0e4h,002h,000h
DB	000h,0d4h,003h,000h
DB	000h,0c4h,004h,000h
DB	000h,034h,005h,000h
DB	000h,054h,006h,000h
DB	000h,074h,008h,000h
DB	000h,064h,009h,000h
DB	000h,062h
DB	000h,000h
$L$SEH_info_add_mod_384x384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_sub_mod_384x384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,003h
DB	0,0
$L$SEH_info_sub_mod_384x384_body::
DB	1,0,17,0
DB	000h,0f4h,001h,000h
DB	000h,0e4h,002h,000h
DB	000h,0d4h,003h,000h
DB	000h,0c4h,004h,000h
DB	000h,034h,005h,000h
DB	000h,054h,006h,000h
DB	000h,074h,008h,000h
DB	000h,064h,009h,000h
DB	000h,062h
DB	000h,000h
$L$SEH_info_sub_mod_384x384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_mul_by_5_mod_384x384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,003h
DB	0,0
$L$SEH_info_mul_by_5_mod_384x384_body::
DB	1,0,17,0
DB	000h,0f4h,001h,000h
DB	000h,0e4h,002h,000h
DB	000h,0d4h,003h,000h
DB	000h,0c4h,004h,000h
DB	000h,034h,005h,000h
DB	000h,054h,006h,000h
DB	000h,074h,008h,000h
DB	000h,064h,009h,000h
DB	000h,062h
DB	000h,000h
$L$SEH_info_mul_by_5_mod_384x384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h

$L$SEH_info_neg_mod_384x384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,003h
DB	0,0
$L$SEH_info_neg_mod_384x384_body::
DB	1,0,17,0
DB	000h,0f4h,001h,000h
DB	000h,0e4h,002h,000h
DB	000h,0d4h,003h,000h
DB	000h,0c4h,004h,000h
DB	000h,034h,005h,000h
DB	000h,054h,006h,000h
DB	000h,074h,008h,000h
DB	000h,064h,009h,000h
DB	000h,062h
DB	000h,000h
$L$SEH_info_neg_mod_384x384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h


.xdata	ENDS
END
