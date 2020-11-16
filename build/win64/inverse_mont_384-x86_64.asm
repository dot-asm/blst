OPTION	DOTNAME
.text$	SEGMENT ALIGN(256) 'CODE'

PUBLIC	mont_inverse_mod_384


ALIGN	32
mont_inverse_mod_384	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_mont_inverse_mod_384::
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

	sub	rsp,536

$L$SEH_body_mont_inverse_mod_384::


	mov	rax,QWORD PTR[rsi]
	mov	r9,QWORD PTR[8+rsi]
	mov	r10,QWORD PTR[16+rsi]
	mov	r11,QWORD PTR[24+rsi]
	mov	r12,QWORD PTR[32+rsi]
	mov	r13,QWORD PTR[40+rsi]

	mov	r8,rax
	or	rax,r9
	or	rax,r10
	or	rax,r11
	or	rax,r12
	or	rax,r13
	jz	$L$abort

	mov	QWORD PTR[rsp],rdi
	mov	QWORD PTR[8+rsp],rdx

	lea	rsi,QWORD PTR[((16+255))+rsp]
	and	rsi,-256
	lea	rcx,QWORD PTR[128+rsi]

	mov	r14,QWORD PTR[rdx]
	mov	r15,QWORD PTR[8+rdx]
	mov	rax,QWORD PTR[16+rdx]
	mov	rbx,QWORD PTR[24+rdx]
	mov	rbp,QWORD PTR[32+rdx]
	mov	rdi,QWORD PTR[40+rdx]

	xor	rdx,rdx

	mov	QWORD PTR[rsi],r8
	mov	QWORD PTR[8+rsi],r9
	mov	QWORD PTR[16+rsi],r10
	mov	QWORD PTR[24+rsi],r11
	mov	QWORD PTR[32+rsi],r12
	mov	QWORD PTR[40+rsi],r13

	mov	QWORD PTR[48+rsi],rdx
	mov	QWORD PTR[56+rsi],rdx
	mov	QWORD PTR[64+rsi],rdx
	mov	QWORD PTR[72+rsi],rdx
	mov	QWORD PTR[80+rsi],rdx
	mov	QWORD PTR[88+rsi],rdx

	mov	QWORD PTR[rcx],r14
	mov	QWORD PTR[8+rcx],r15
	mov	QWORD PTR[16+rcx],rax
	mov	QWORD PTR[24+rcx],rbx
	mov	QWORD PTR[32+rcx],rbp
	mov	QWORD PTR[40+rcx],rdi

	mov	QWORD PTR[48+rcx],1
	mov	QWORD PTR[56+rcx],rdx
	mov	QWORD PTR[64+rcx],rdx
	mov	QWORD PTR[72+rcx],rdx
	mov	QWORD PTR[80+rcx],rdx
	mov	QWORD PTR[88+rcx],rdx



ALIGN	32
$L$oop_inv_384::


	call	__shift_powers_of_2

	mov	rcx,128
	xor	rcx,rsi

	sub	r8,QWORD PTR[rcx]
	sbb	r9,QWORD PTR[8+rcx]
	sbb	r10,QWORD PTR[16+rcx]
	sbb	r11,QWORD PTR[24+rcx]
	sbb	r12,QWORD PTR[32+rcx]
	sbb	r13,QWORD PTR[40+rcx]
	jae	$L$v_greater_than_u_384

	xchg	rsi,rcx

	not	r8
	not	r9
	not	r10
	not	r11
	not	r12
	not	r13

	add	r8,1
	adc	r9,0
	adc	r10,0
	adc	r11,0
	adc	r12,0
	adc	r13,0

$L$v_greater_than_u_384::
	shrd	r8,r9,1
	shrd	r9,r10,1
	shrd	r10,r11,1
	shrd	r11,r12,1
	shrd	r12,r13,1
	mov	r14,QWORD PTR[48+rsi]
	shr	r13,1
	mov	r15,QWORD PTR[56+rsi]
	mov	rax,QWORD PTR[64+rsi]
	mov	rbx,QWORD PTR[72+rsi]
	mov	rbp,QWORD PTR[80+rsi]
	mov	rdi,QWORD PTR[88+rsi]

	mov	QWORD PTR[rsi],r8
	mov	QWORD PTR[8+rsi],r9
	mov	QWORD PTR[16+rsi],r10
	mov	QWORD PTR[24+rsi],r11
	mov	QWORD PTR[32+rsi],r12
	mov	QWORD PTR[40+rsi],r13

	or	r13,QWORD PTR[40+rcx]
	jz	$L$oop_inv_320_entry

	call	__update_rs

	jmp	$L$oop_inv_384

ALIGN	32
$L$oop_inv_320::


	call	__shift_powers_of_2

	mov	rcx,128
	xor	rcx,rsi

	sub	r8,QWORD PTR[rcx]
	sbb	r9,QWORD PTR[8+rcx]
	sbb	r10,QWORD PTR[16+rcx]
	sbb	r11,QWORD PTR[24+rcx]
	sbb	r12,QWORD PTR[32+rcx]
	jae	$L$v_greater_than_u_320

	xchg	rsi,rcx

	not	r8
	not	r9
	not	r10
	not	r11
	not	r12

	add	r8,1
	adc	r9,0
	adc	r10,0
	adc	r11,0
	adc	r12,0

$L$v_greater_than_u_320::
	shrd	r8,r9,1
	shrd	r9,r10,1
	shrd	r10,r11,1
	shrd	r11,r12,1
	mov	r14,QWORD PTR[48+rsi]
	shr	r12,1
	mov	r15,QWORD PTR[56+rsi]
	mov	rax,QWORD PTR[64+rsi]
	mov	rbx,QWORD PTR[72+rsi]
	mov	rbp,QWORD PTR[80+rsi]
	mov	rdi,QWORD PTR[88+rsi]

	mov	QWORD PTR[rsi],r8
	mov	QWORD PTR[8+rsi],r9
	mov	QWORD PTR[16+rsi],r10
	mov	QWORD PTR[24+rsi],r11
	mov	QWORD PTR[32+rsi],r12

	or	r12,QWORD PTR[32+rcx]
	jz	$L$oop_inv_256_entry
$L$oop_inv_320_entry::
	call	__update_rs

	jmp	$L$oop_inv_320

ALIGN	32
$L$oop_inv_256::


	call	__shift_powers_of_2

	mov	rcx,128
	xor	rcx,rsi

	sub	r8,QWORD PTR[rcx]
	sbb	r9,QWORD PTR[8+rcx]
	sbb	r10,QWORD PTR[16+rcx]
	sbb	r11,QWORD PTR[24+rcx]
	jae	$L$v_greater_than_u_256

	xchg	rsi,rcx

	not	r8
	not	r9
	not	r10
	not	r11

	add	r8,1
	adc	r9,0
	adc	r10,0
	adc	r11,0

$L$v_greater_than_u_256::
	shrd	r8,r9,1
	shrd	r9,r10,1
	shrd	r10,r11,1
	mov	r14,QWORD PTR[48+rsi]
	shr	r11,1
	mov	r15,QWORD PTR[56+rsi]
	mov	rax,QWORD PTR[64+rsi]
	mov	rbx,QWORD PTR[72+rsi]
	mov	rbp,QWORD PTR[80+rsi]
	mov	rdi,QWORD PTR[88+rsi]

	mov	QWORD PTR[rsi],r8
	mov	QWORD PTR[8+rsi],r9
	mov	QWORD PTR[16+rsi],r10
	mov	QWORD PTR[24+rsi],r11

	or	r11,QWORD PTR[24+rcx]
	jz	$L$oop_inv_192_entry
$L$oop_inv_256_entry::
	call	__update_rs

	jmp	$L$oop_inv_256

ALIGN	32
$L$oop_inv_192::



	mov	r8,QWORD PTR[rsi]
	mov	r9,QWORD PTR[8+rsi]
	mov	r10,QWORD PTR[16+rsi]
	test	r8,1
	jnz	$L$oop_inv_192_v_is_odd

$L$oop_inv_192_make_v_odd::
	bsf	rcx,r8
	mov	eax,63
	cmovz	ecx,eax

	mov	rdi,QWORD PTR[88+rsi]
	mov	rbp,QWORD PTR[80+rsi]
	mov	rbx,QWORD PTR[72+rsi]
	mov	rax,QWORD PTR[64+rsi]
	mov	r15,QWORD PTR[56+rsi]
	mov	r14,QWORD PTR[48+rsi]

	add	edx,ecx

	shrd	r8,r9,cl
	shrd	r9,r10,cl
	shr	r10,cl

	mov	QWORD PTR[rsi],r8
	mov	QWORD PTR[8+rsi],r9
	mov	QWORD PTR[16+rsi],r10

	shld	rdi,rbp,cl
	shld	rbp,rbx,cl
	shld	rbx,rax,cl
	shld	rax,r15,cl
	shld	r15,r14,cl
	shl	r14,cl

	mov	rcx,128
	mov	QWORD PTR[88+rsi],rdi
	xor	rcx,rsi
	mov	QWORD PTR[80+rsi],rbp
	mov	QWORD PTR[72+rsi],rbx
	mov	QWORD PTR[64+rsi],rax
	mov	QWORD PTR[56+rsi],r15
	mov	QWORD PTR[48+rsi],r14

	test	r8,1
DB	02eh
	jz	$L$oop_inv_192_make_v_odd

$L$oop_inv_192_v_is_odd::

	sub	r8,QWORD PTR[rcx]
	sbb	r9,QWORD PTR[8+rcx]
	sbb	r10,QWORD PTR[16+rcx]
	jae	$L$v_greater_than_u_192

	xchg	rsi,rcx

	not	r8
	not	r9
	not	r10

	add	r8,1
	adc	r9,0
	adc	r10,0

$L$v_greater_than_u_192::
	shrd	r8,r9,1
	shrd	r9,r10,1
	mov	r14,QWORD PTR[48+rsi]
	shr	r10,1
	mov	r15,QWORD PTR[56+rsi]
	mov	rax,QWORD PTR[64+rsi]
	mov	rbx,QWORD PTR[72+rsi]
	mov	rbp,QWORD PTR[80+rsi]
	mov	rdi,QWORD PTR[88+rsi]

	mov	QWORD PTR[rsi],r8
	mov	QWORD PTR[8+rsi],r9
	mov	QWORD PTR[16+rsi],r10

	or	r10,QWORD PTR[16+rcx]
	jz	$L$oop_inv_128_entry
$L$oop_inv_192_entry::
	call	__update_rs

	jmp	$L$oop_inv_192

ALIGN	32
$L$oop_inv_128::



	mov	r8,QWORD PTR[rsi]
	mov	r9,QWORD PTR[8+rsi]
	test	r8,1
	jnz	$L$oop_inv_128_v_is_odd

$L$oop_inv_128_make_v_odd::
	bsf	rcx,r8
	mov	eax,63
	cmovz	ecx,eax

	mov	rdi,QWORD PTR[88+rsi]
	mov	rbp,QWORD PTR[80+rsi]
	mov	rbx,QWORD PTR[72+rsi]
	mov	rax,QWORD PTR[64+rsi]
	mov	r15,QWORD PTR[56+rsi]
	mov	r14,QWORD PTR[48+rsi]

	add	edx,ecx

	shrd	r8,r9,cl
	shr	r9,cl

	mov	QWORD PTR[rsi],r8
	mov	QWORD PTR[8+rsi],r9

	shld	rdi,rbp,cl
	shld	rbp,rbx,cl
	shld	rbx,rax,cl
	shld	rax,r15,cl
	shld	r15,r14,cl
	shl	r14,cl

	mov	rcx,128
	mov	QWORD PTR[88+rsi],rdi
	xor	rcx,rsi
	mov	QWORD PTR[80+rsi],rbp
	mov	QWORD PTR[72+rsi],rbx
	mov	QWORD PTR[64+rsi],rax
	mov	QWORD PTR[56+rsi],r15
	mov	QWORD PTR[48+rsi],r14

	test	r8,1
DB	02eh
	jz	$L$oop_inv_128_make_v_odd

$L$oop_inv_128_v_is_odd::

	mov	r14,QWORD PTR[rcx]
	mov	r15,QWORD PTR[8+rcx]
	sub	r14,r8
	sbb	r15,r9

	sub	r8,QWORD PTR[rcx]
	sbb	r9,QWORD PTR[8+rcx]
	sbb	r10,r10

	cmovc	r8,r14
	cmovc	r9,r15

	and	r10,128
	xor	rsi,r10
	xor	rcx,r10

	shrd	r8,r9,1
	mov	r14,QWORD PTR[48+rsi]
	shr	r9,1
	mov	r15,QWORD PTR[56+rsi]
	mov	rax,QWORD PTR[64+rsi]
	mov	rbx,QWORD PTR[72+rsi]
	mov	rbp,QWORD PTR[80+rsi]
	mov	rdi,QWORD PTR[88+rsi]

	mov	QWORD PTR[rsi],r8
	mov	QWORD PTR[8+rsi],r9

$L$oop_inv_128_entry::
	call	__update_rs

	mov	r8,QWORD PTR[rsi]
	or	r8,QWORD PTR[8+rsi]
	jnz	$L$oop_inv_128

	mov	rcx,QWORD PTR[8+rsp]

	mov	r8,QWORD PTR[48+rsi]
	mov	r9,QWORD PTR[56+rsi]
	mov	r10,QWORD PTR[64+rsi]
	mov	r11,QWORD PTR[72+rsi]
	mov	r12,QWORD PTR[80+rsi]
	mov	r13,QWORD PTR[88+rsi]

	mov	r14,r8
	sub	r8,QWORD PTR[rcx]
	mov	r15,r9
	sbb	r9,QWORD PTR[8+rcx]
	mov	rax,r10
	sbb	r10,QWORD PTR[16+rcx]
	mov	rbx,r11
	sbb	r11,QWORD PTR[24+rcx]
	mov	rbp,r12
	sbb	r12,QWORD PTR[32+rcx]
	mov	rdi,r13
	sbb	r13,QWORD PTR[40+rcx]

	cmovnc	r14,r8
	mov	r8,QWORD PTR[rcx]
	cmovnc	r15,r9
	mov	r9,QWORD PTR[8+rcx]
	cmovnc	rax,r10
	mov	r10,QWORD PTR[16+rcx]
	cmovnc	rbx,r11
	mov	r11,QWORD PTR[24+rcx]
	cmovnc	rbp,r12
	mov	r12,QWORD PTR[32+rcx]
	cmovnc	rdi,r13
	mov	r13,QWORD PTR[40+rcx]

	sub	r8,r14
	sbb	r9,r15
	sbb	r10,rax
	sbb	r11,rbx
	sbb	r12,rbp
	sbb	r13,rdi

	mov	rdi,QWORD PTR[rsp]
	mov	rax,rdx
$L$abort::
	mov	QWORD PTR[rdi],r8
	mov	QWORD PTR[8+rdi],r9
	mov	QWORD PTR[16+rdi],r10
	mov	QWORD PTR[24+rdi],r11
	mov	QWORD PTR[32+rdi],r12
	mov	QWORD PTR[40+rdi],r13

	lea	r8,QWORD PTR[536+rsp]
	mov	r15,QWORD PTR[r8]

	mov	r14,QWORD PTR[8+r8]

	mov	r13,QWORD PTR[16+r8]

	mov	r12,QWORD PTR[24+r8]

	mov	rbx,QWORD PTR[32+r8]

	mov	rbp,QWORD PTR[40+r8]

	lea	rsp,QWORD PTR[48+r8]

$L$SEH_epilogue_mont_inverse_mod_384::
	mov	rdi,QWORD PTR[8+rsp]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+rsp]

	DB	0F3h,0C3h		;repret

$L$SEH_end_mont_inverse_mod_384::
mont_inverse_mod_384	ENDP


ALIGN	32
__shift_powers_of_2	PROC PRIVATE
	DB	243,15,30,250
	mov	r8,QWORD PTR[rsi]
	mov	r9,QWORD PTR[8+rsi]
	mov	r10,QWORD PTR[16+rsi]
	mov	r11,QWORD PTR[24+rsi]
	mov	r12,QWORD PTR[32+rsi]
	mov	r13,QWORD PTR[40+rsi]
	test	r8,1
	jnz	$L$oop_of_2_done

$L$oop_of_2::
	bsf	rcx,r8
	mov	eax,63
	cmovz	ecx,eax

	add	edx,ecx

	shrd	r8,r9,cl
	mov	rdi,QWORD PTR[88+rsi]
	shrd	r9,r10,cl
	mov	rbp,QWORD PTR[80+rsi]
	shrd	r10,r11,cl
	mov	rbx,QWORD PTR[72+rsi]
	shrd	r11,r12,cl
	mov	rax,QWORD PTR[64+rsi]
	shrd	r12,r13,cl
	mov	r15,QWORD PTR[56+rsi]
	shr	r13,cl
	mov	r14,QWORD PTR[48+rsi]

	mov	QWORD PTR[rsi],r8
	mov	QWORD PTR[8+rsi],r9
	mov	QWORD PTR[16+rsi],r10
	mov	QWORD PTR[24+rsi],r11
	mov	QWORD PTR[32+rsi],r12
	mov	QWORD PTR[40+rsi],r13

	shld	rdi,rbp,cl
	shld	rbp,rbx,cl
	shld	rbx,rax,cl
	shld	rax,r15,cl
	shld	r15,r14,cl
	shl	r14,cl

	mov	QWORD PTR[88+rsi],rdi
	mov	QWORD PTR[80+rsi],rbp
	mov	QWORD PTR[72+rsi],rbx
	mov	QWORD PTR[64+rsi],rax
	mov	QWORD PTR[56+rsi],r15
	mov	QWORD PTR[48+rsi],r14

	test	r8,1
DB	02eh
	jz	$L$oop_of_2

$L$oop_of_2_done::
	DB	0F3h,0C3h		;repret
__shift_powers_of_2	ENDP


ALIGN	32
__update_rs	PROC PRIVATE
	DB	243,15,30,250
	mov	r8,r14
	add	r14,QWORD PTR[48+rcx]
	mov	r9,r15
	adc	r15,QWORD PTR[56+rcx]
	mov	r10,rax
	adc	rax,QWORD PTR[64+rcx]
	mov	r11,rbx
	adc	rbx,QWORD PTR[72+rcx]
	mov	r12,rbp
	adc	rbp,QWORD PTR[80+rcx]
	mov	r13,rdi
	adc	rdi,QWORD PTR[88+rcx]

	mov	QWORD PTR[48+rcx],r14
	mov	QWORD PTR[56+rcx],r15
	mov	QWORD PTR[64+rcx],rax
	mov	QWORD PTR[72+rcx],rbx
	mov	QWORD PTR[80+rcx],rbp

	add	r8,r8
	mov	QWORD PTR[88+rcx],rdi
	adc	r9,r9
	mov	QWORD PTR[48+rsi],r8
	adc	r10,r10
	mov	QWORD PTR[56+rsi],r9
	adc	r11,r11
	mov	QWORD PTR[64+rsi],r10
	adc	r12,r12
	mov	QWORD PTR[72+rsi],r11
	adc	r13,r13
	mov	QWORD PTR[80+rsi],r12
	lea	rdx,QWORD PTR[1+rdx]
	mov	QWORD PTR[88+rsi],r13

	DB	0F3h,0C3h		;repret
__update_rs	ENDP
.text$	ENDS
.pdata	SEGMENT READONLY ALIGN(4)
ALIGN	4
	DD	imagerel $L$SEH_begin_mont_inverse_mod_384
	DD	imagerel $L$SEH_body_mont_inverse_mod_384
	DD	imagerel $L$SEH_info_mont_inverse_mod_384_prologue

	DD	imagerel $L$SEH_body_mont_inverse_mod_384
	DD	imagerel $L$SEH_epilogue_mont_inverse_mod_384
	DD	imagerel $L$SEH_info_mont_inverse_mod_384_body

	DD	imagerel $L$SEH_epilogue_mont_inverse_mod_384
	DD	imagerel $L$SEH_end_mont_inverse_mod_384
	DD	imagerel $L$SEH_info_mont_inverse_mod_384_epilogue

.pdata	ENDS
.xdata	SEGMENT READONLY ALIGN(8)
ALIGN	8
$L$SEH_info_mont_inverse_mod_384_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,003h
DB	0,0
$L$SEH_info_mont_inverse_mod_384_body::
DB	1,0,18,0
DB	000h,0f4h,043h,000h
DB	000h,0e4h,044h,000h
DB	000h,0d4h,045h,000h
DB	000h,0c4h,046h,000h
DB	000h,034h,047h,000h
DB	000h,054h,048h,000h
DB	000h,074h,04ah,000h
DB	000h,064h,04bh,000h
DB	000h,001h,049h,000h
$L$SEH_info_mont_inverse_mod_384_epilogue::
DB	1,0,4,0
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,000h,000h,000h


.xdata	ENDS
END
