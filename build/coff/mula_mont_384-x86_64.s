.text	





.def	__suba_mod_384x384;	.scl 3;	.type 32;	.endef
.p2align	5
__suba_mod_384x384:
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%rsi),%r16
	movq	8(%rsi),%r17
	movq	16(%rsi),%r18
	movq	24(%rsi),%r19
	movq	32(%rsi),%r20
	movq	40(%rsi),%r21
	movq	48(%rsi),%r22

	subq	0(%rdx),%r16
	movq	56(%rsi),%r23
	sbbq	8(%rdx),%r17
	movq	64(%rsi),%r24
	sbbq	16(%rdx),%r18
	movq	72(%rsi),%r25
	sbbq	24(%rdx),%r19
	movq	80(%rsi),%r26
	sbbq	32(%rdx),%r20
	movq	88(%rsi),%r27
	sbbq	40(%rdx),%r21
	movq	%r16,0(%rdi)
	sbbq	48(%rdx),%r22
	movq	%r17,8(%rdi)
	sbbq	56(%rdx),%r23
	movq	%r18,16(%rdi)
	sbbq	64(%rdx),%r24
	movq	%r19,24(%rdi)
	sbbq	72(%rdx),%r25
	movq	%r20,32(%rdi)
	sbbq	80(%rdx),%r26
	movq	%r21,40(%rdi)
	sbbq	88(%rdx),%r27
	sbbq	%rdx,%rdx

{nf}	andq	0(%rcx),%rdx,%r16
{nf}	andq	8(%rcx),%rdx,%r17
{nf}	andq	16(%rcx),%rdx,%r18
{nf}	andq	24(%rcx),%rdx,%r19
{nf}	andq	32(%rcx),%rdx,%r20
{nf}	andq	40(%rcx),%rdx,%r21

	addq	%r16,%r22
	adcq	%r17,%r23
	movq	%r22,48(%rdi)
	adcq	%r18,%r24
	movq	%r23,56(%rdi)
	adcq	%r19,%r25
	movq	%r24,64(%rdi)
	adcq	%r20,%r26
	movq	%r25,72(%rdi)
	adcq	%r21,%r27
	movq	%r26,80(%rdi)
	movq	%r27,88(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif


.def	__adda_mod_384;	.scl 3;	.type 32;	.endef
.p2align	5
__adda_mod_384:
	.byte	0xf3,0x0f,0x1e,0xfa

#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%r16
	movq	8(%rsi),%r17
	movq	16(%rsi),%r18
	movq	24(%rsi),%r19
	movq	32(%rsi),%r20
	movq	40(%rsi),%r21

	addq	0(%rdx),%r16
	adcq	8(%rdx),%r17
	adcq	16(%rdx),%r18
	adcq	24(%rdx),%r19
	adcq	32(%rdx),%r20
	adcq	40(%rdx),%r21
	sbbq	%rdx,%rdx

	subq	0(%rcx),%r16,%r22
	sbbq	8(%rcx),%r17,%r23
	sbbq	16(%rcx),%r18,%r24
	sbbq	24(%rcx),%r19,%r25
	sbbq	32(%rcx),%r20,%r26
	sbbq	40(%rcx),%r21,%r27
	sbbq	$0,%rdx

	cmovncq	%r22,%r16
	cmovncq	%r23,%r17
	cmovncq	%r24,%r18
	movq	%r16,0(%rdi)
	cmovncq	%r25,%r19
	movq	%r17,8(%rdi)
	cmovncq	%r26,%r20
	movq	%r18,16(%rdi)
	cmovncq	%r27,%r21
	movq	%r19,24(%rdi)
	movq	%r20,32(%rdi)
	movq	%r21,40(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif


.def	__suba_mod_384;	.scl 3;	.type 32;	.endef
.p2align	5
__suba_mod_384:
	.byte	0xf3,0x0f,0x1e,0xfa

#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%r16
	movq	8(%rsi),%r17
	movq	16(%rsi),%r18
	movq	24(%rsi),%r19
	movq	32(%rsi),%r20
	movq	40(%rsi),%r21

__suba_mod_384_a_is_loaded:
	subq	0(%rdx),%r16
	sbbq	8(%rdx),%r17
	sbbq	16(%rdx),%r18
	sbbq	24(%rdx),%r19
	sbbq	32(%rdx),%r20
	sbbq	40(%rdx),%r21
	sbbq	%rdx,%rdx

{nf}	andq	0(%rcx),%rdx,%r22
{nf}	andq	8(%rcx),%rdx,%r23
{nf}	andq	16(%rcx),%rdx,%r24
{nf}	andq	24(%rcx),%rdx,%r25
{nf}	andq	32(%rcx),%rdx,%r26
{nf}	andq	40(%rcx),%rdx,%r27

	addq	%r22,%r16
	adcq	%r23,%r17
	movq	%r16,0(%rdi)
	adcq	%r24,%r18
	movq	%r17,8(%rdi)
	adcq	%r25,%r19
	movq	%r18,16(%rdi)
	adcq	%r26,%r20
	movq	%r19,24(%rdi)
	adcq	%r27,%r21
	movq	%r20,32(%rdi)
	movq	%r21,40(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.globl	mula_mont_384x

.def	mula_mont_384x;	.scl 2;	.type 32;	.endef
.p2align	5
mula_mont_384x:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_mula_mont_384x:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
	movq	40(%rsp),%r8
mul_mont_384x$4:
	subq	$296,%rsp

.LSEH_body_mula_mont_384x:


	movq	%rdx,%r10
	movq	%rdi,%r31
	movq	%rsi,%r9




	leaq	0(%rsp),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384


	leaq	48(%r10),%r10
	leaq	48(%rsi),%rsi
	leaq	96(%rdi),%rdi
	call	__mula_384


	leaq	(%r10),%rsi
	leaq	-48(%r10),%rdx
	leaq	192+48(%rsp),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__adda_mod_384

	leaq	(%r9),%rsi
	leaq	48(%r9),%rdx
	leaq	-48(%rdi),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__adda_mod_384

	leaq	(%rdi),%r10
	leaq	48(%rdi),%rsi
	call	__mula_384


	leaq	(%rdi),%rsi
	leaq	0(%rsp),%rdx
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__suba_mod_384x384

	leaq	(%rdi),%rsi
	leaq	-96(%rdi),%rdx
	call	__suba_mod_384x384


	leaq	0(%rsp),%rsi
	leaq	96(%rsp),%rdx
	leaq	0(%rsp),%rdi
	call	__suba_mod_384x384


	leaq	0(%rsp),%rsi
	leaq	0(%r31),%rdi
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384


	leaq	192(%rsp),%rsi
	leaq	48(%rdi),%rdi
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384

	leaq	296(%rsp),%rsp

.LSEH_epilogue_mula_mont_384x:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_mula_mont_384x:
.globl	sqra_mont_384x

.def	sqra_mont_384x;	.scl 2;	.type 32;	.endef
.p2align	5
sqra_mont_384x:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_sqra_mont_384x:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
sqr_mont_384x$4:
	subq	$104,%rsp

.LSEH_body_sqra_mont_384x:


	movq	%rcx,%r8
	movq	%rdx,%rcx
	movq	%rdi,%r31
	movq	%rsi,%r9


	leaq	48(%rsi),%rdx
	leaq	0(%rsp),%rdi
	call	__adda_mod_384


	leaq	(%r9),%rsi
	leaq	48(%r9),%rdx
	leaq	48(%rsp),%rdi
	call	__suba_mod_384


	leaq	48(%rsi),%r10
	leaq	(%r31),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	48(%rsi),%rdx
	movq	0(%rsi),%r25
	movq	8(%rsi),%r26
	movq	16(%rsi),%r27
	movq	24(%rsi),%r28
	movq	32(%rsi),%r29
	movq	40(%rsi),%r30
	leaq	-128(%rcx),%rcx

	mulxq	%r25,%r16,%r20
	call	__mula_mont_384

	addq	%rdx,%rdx
	adcq	%r26,%r26
	adcq	%r27,%r27
	adcq	%r28,%r28
	adcq	%r29,%r29
	adcq	%r30,%r30
	sbbq	%rsi,%rsi

	subq	0(%rcx),%rdx,%r16
	sbbq	8(%rcx),%r26,%r17
	sbbq	16(%rcx),%r27,%r18
	sbbq	24(%rcx),%r28,%r19
	sbbq	32(%rcx),%r29,%r20
	sbbq	40(%rcx),%r30,%r21
	sbbq	$0,%rsi

	cmovncq	%r16,%rdx
	cmovncq	%r17,%r26
	cmovncq	%r18,%r27
	movq	%rdx,48(%rdi)
	cmovncq	%r19,%r28
	movq	%r26,56(%rdi)
	cmovncq	%r20,%r29
	movq	%r27,64(%rdi)
	cmovncq	%r21,%r30
	movq	%r28,72(%rdi)
	movq	%r29,80(%rdi)
	movq	%r30,88(%rdi)


	movq	48(%rsp),%rdx
	leaq	48(%rsp),%r10
	movq	0(%rsp),%r25
	movq	8(%rsp),%r26
	movq	16(%rsp),%r27
	movq	24(%rsp),%r28
	movq	32(%rsp),%r29
	movq	40(%rsp),%r30
	leaq	-128(%rcx),%rcx

	mulxq	%r25,%r16,%r20
	call	__mula_mont_384

	leaq	104(%rsp),%rsp

.LSEH_epilogue_sqra_mont_384x:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_sqra_mont_384x:

.globl	mula_382x

.def	mula_382x;	.scl 2;	.type 32;	.endef
.p2align	5
mula_382x:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_mula_382x:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
mul_382x$4:
	subq	$104,%rsp

.LSEH_body_mula_382x:


	movq	%rdx,%r31
	movq	%rsi,%r9
	leaq	96(%rdi),%rdi


#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%r16
	movq	8(%rsi),%r17
	movq	16(%rsi),%r18
	movq	24(%rsi),%r19
	movq	32(%rsi),%r20
	movq	40(%rsi),%r21

	addq	48(%rsi),%r16
	adcq	56(%rsi),%r17
	adcq	64(%rsi),%r18
	adcq	72(%rsi),%r19
	adcq	80(%rsi),%r20
	adcq	88(%rsi),%r21

	movq	%r16,0(%rsp)
	movq	%r17,8(%rsp)
	movq	%r18,16(%rsp)
	movq	%r19,24(%rsp)
	movq	%r20,32(%rsp)
	movq	%r21,40(%rsp)


	movq	0(%rdx),%r16
	movq	8(%rdx),%r17
	movq	16(%rdx),%r18
	movq	24(%rdx),%r19
	movq	32(%rdx),%r20
	movq	40(%rdx),%r21

	addq	48(%rdx),%r16
	adcq	56(%rdx),%r17
	adcq	64(%rdx),%r18
	adcq	72(%rdx),%r19
	adcq	80(%rdx),%r20
	adcq	88(%rdx),%r21

	movq	%r16,48(%rsp)
	movq	%r17,56(%rsp)
	movq	%r18,64(%rsp)
	movq	%r19,72(%rsp)
	movq	%r20,80(%rsp)
	movq	%r21,88(%rsp)


	leaq	48(%rsp),%r10
	leaq	0(%rsp),%rsi
	call	__mula_384


	leaq	(%r31),%r10
	leaq	(%r9),%rsi
	leaq	-96(%rdi),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384


	leaq	48(%r10),%r10
	leaq	48(%rsi),%rsi
	movq	%rdi,%r31
	leaq	0(%rsp),%rdi
	call	__mula_384


	leaq	96(%r31),%rsi
	leaq	0(%rsp),%rdx
	leaq	96(%r31),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__suba_mod_384x384


	leaq	0(%rdi),%rsi
	leaq	-96(%rdi),%rdx
	call	__suba_mod_384x384


	leaq	-96(%rdi),%rsi
	leaq	0(%rsp),%rdx
	leaq	-96(%rdi),%rdi
	call	__suba_mod_384x384

	leaq	104(%rsp),%rsp

.LSEH_epilogue_mula_382x:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_mula_382x:
.globl	sqra_382x

.def	sqra_382x;	.scl 2;	.type 32;	.endef
.p2align	5
sqra_382x:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_sqra_382x:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
sqr_382x$4:
	subq	$8,%rsp

.LSEH_body_sqra_382x:


	movq	%rdx,%rcx
	movq	%rsi,%r9


#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%r16
	movq	8(%rsi),%r17
	movq	16(%rsi),%r18
	movq	24(%rsi),%r19
	movq	32(%rsi),%r20
	movq	40(%rsi),%r21

	addq	48(%rsi),%r16,%r22
	adcq	56(%rsi),%r17,%r23
	adcq	64(%rsi),%r18,%r24
	adcq	72(%rsi),%r19,%r25
	adcq	80(%rsi),%r20,%r26
	adcq	88(%rsi),%r21,%r27

	movq	%r22,0(%rdi)
	movq	%r23,8(%rdi)
	movq	%r24,16(%rdi)
	movq	%r25,24(%rdi)
	movq	%r26,32(%rdi)
	movq	%r27,40(%rdi)


	leaq	48(%rsi),%rdx
	leaq	48(%rdi),%rdi
	call	__suba_mod_384_a_is_loaded


	leaq	(%rdi),%rsi
	leaq	-48(%rdi),%r10
	leaq	-48(%rdi),%rdi
	call	__mula_384


	leaq	(%r9),%rsi
	leaq	48(%r9),%r10
	leaq	96(%rdi),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384

	movq	0(%rdi),%r16
	movq	8(%rdi),%r17
	movq	16(%rdi),%r18
	movq	24(%rdi),%r19
	movq	32(%rdi),%r20
	movq	40(%rdi),%r21
	movq	48(%rdi),%r22
	movq	56(%rdi),%r23
	movq	64(%rdi),%r24
	movq	72(%rdi),%r25
	movq	80(%rdi),%r26
	addq	%r16,%r16
	movq	88(%rdi),%r27
	adcq	%r17,%r17
	movq	%r16,0(%rdi)
	adcq	%r18,%r18
	movq	%r17,8(%rdi)
	adcq	%r19,%r19
	movq	%r18,16(%rdi)
	adcq	%r20,%r20
	movq	%r19,24(%rdi)
	adcq	%r21,%r21
	movq	%r20,32(%rdi)
	adcq	%r22,%r22
	movq	%r21,40(%rdi)
	adcq	%r23,%r23
	movq	%r22,48(%rdi)
	adcq	%r24,%r24
	movq	%r23,56(%rdi)
	adcq	%r25,%r25
	movq	%r24,64(%rdi)
	adcq	%r26,%r26
	movq	%r25,72(%rdi)
	adcq	%r27,%r27
	movq	%r26,80(%rdi)
	movq	%r27,88(%rdi)

	leaq	8(%rsp),%rsp

.LSEH_epilogue_sqra_382x:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_sqra_382x:
.globl	mula_384

.def	mula_384;	.scl 2;	.type 32;	.endef
.p2align	5
mula_384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_mula_384:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
mul_384$4:
	leaq	-8(%rsp),%rsp

.LSEH_body_mula_384:


	movq	%rdx,%r10
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384

	leaq	8(%rsp),%rsp

.LSEH_epilogue_mula_384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_mula_384:

.def	__mula_384;	.scl 3;	.type 32;	.endef
.p2align	5
__mula_384:
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%r10),%rdx
	movq	0(%rsi),%r25
	movq	8(%rsi),%r26
	movq	16(%rsi),%r27
	movq	24(%rsi),%r28
	movq	32(%rsi),%r29
	movq	40(%rsi),%r30

	mulxq	%r25,%r16,%r11
	xorq	%r23,%r23

	mulxq	%r26,%r17,%rax
	addq	%r11,%r17
	movq	%r16,0(%rdi)

	mulxq	%r27,%r18,%r11
	adcq	%rax,%r18

	mulxq	%r28,%r19,%rax
	adcq	%r11,%r19

	mulxq	%r29,%r20,%r11
	adcq	%rax,%r20

	mulxq	%r30,%r21,%r22
	movq	8(%r10),%rdx
	adcq	%r11,%r21
	adcq	$0,%r22
	xorq	%r23,%r23
	mulxq	%r25,%r16,%rax
	adcxq	%r17,%r16
	adoxq	%rax,%r18

	mulxq	%r26,%r17,%r11
	adcxq	%r18,%r17
	adoxq	%r11,%r19
	movq	%r16,8(%rdi)

	mulxq	%r27,%r18,%rax
	adcxq	%r19,%r18
	adoxq	%rax,%r20

	mulxq	%r28,%r19,%r11
	adcxq	%r20,%r19
	adoxq	%r11,%r21

	mulxq	%r29,%r20,%rax
	adcxq	%r21,%r20
	adoxq	%rax,%r22

	mulxq	%r30,%r21,%r11
	movq	16(%r10),%rdx
	adcxq	%r22,%r21
	adoxq	%r23,%r11
	adcxq	%r23,%r11,%r22
	xorq	%r23,%r23
	mulxq	%r25,%r16,%rax
	adcxq	%r17,%r16
	adoxq	%rax,%r18

	mulxq	%r26,%r17,%r11
	adcxq	%r18,%r17
	adoxq	%r11,%r19
	movq	%r16,16(%rdi)

	mulxq	%r27,%r18,%rax
	adcxq	%r19,%r18
	adoxq	%rax,%r20

	mulxq	%r28,%r19,%r11
	adcxq	%r20,%r19
	adoxq	%r11,%r21

	mulxq	%r29,%r20,%rax
	adcxq	%r21,%r20
	adoxq	%rax,%r22

	mulxq	%r30,%r21,%r11
	movq	24(%r10),%rdx
	adcxq	%r22,%r21
	adoxq	%r23,%r11
	adcxq	%r23,%r11,%r22
	xorq	%r23,%r23
	mulxq	%r25,%r16,%rax
	adcxq	%r17,%r16
	adoxq	%rax,%r18

	mulxq	%r26,%r17,%r11
	adcxq	%r18,%r17
	adoxq	%r11,%r19
	movq	%r16,24(%rdi)

	mulxq	%r27,%r18,%rax
	adcxq	%r19,%r18
	adoxq	%rax,%r20

	mulxq	%r28,%r19,%r11
	adcxq	%r20,%r19
	adoxq	%r11,%r21

	mulxq	%r29,%r20,%rax
	adcxq	%r21,%r20
	adoxq	%rax,%r22

	mulxq	%r30,%r21,%r11
	movq	32(%r10),%rdx
	adcxq	%r22,%r21
	adoxq	%r23,%r11
	adcxq	%r23,%r11,%r22
	xorq	%r23,%r23
	mulxq	%r25,%r16,%rax
	adcxq	%r17,%r16
	adoxq	%rax,%r18

	mulxq	%r26,%r17,%r11
	adcxq	%r18,%r17
	adoxq	%r11,%r19
	movq	%r16,32(%rdi)

	mulxq	%r27,%r18,%rax
	adcxq	%r19,%r18
	adoxq	%rax,%r20

	mulxq	%r28,%r19,%r11
	adcxq	%r20,%r19
	adoxq	%r11,%r21

	mulxq	%r29,%r20,%rax
	adcxq	%r21,%r20
	adoxq	%rax,%r22

	mulxq	%r30,%r21,%r11
	movq	40(%r10),%rdx
	adcxq	%r22,%r21
	adoxq	%r23,%r11
	adcxq	%r23,%r11,%r22
	xorq	%r23,%r23
	mulxq	%r25,%r16,%rax
	adcxq	%r17,%r16
	adoxq	%rax,%r18

	mulxq	%r26,%r17,%r11
	adcxq	%r18,%r17
	adoxq	%r11,%r19
	movq	%r16,40(%rdi)

	mulxq	%r27,%r18,%rax
	adcxq	%r19,%r18
	adoxq	%rax,%r20

	mulxq	%r28,%r19,%r11
	adcxq	%r20,%r19
	adoxq	%r11,%r21

	mulxq	%r29,%r20,%rax
	adcxq	%r21,%r20
	adoxq	%rax,%r22

	mulxq	%r30,%r21,%r11
	movq	%rax,%rdx
	adcxq	%r22,%r21
	adoxq	%r23,%r11
	adcxq	%r23,%r11,%r22
	movq	%r17,48(%rdi)
	movq	%r18,56(%rdi)
	movq	%r19,64(%rdi)
	movq	%r20,72(%rdi)
	movq	%r21,80(%rdi)
	movq	%r22,88(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.globl	sqra_384

.def	sqra_384;	.scl 2;	.type 32;	.endef
.p2align	5
sqra_384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_sqra_384:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
sqr_384$4:
	leaq	-8(%rsp),%rsp

.LSEH_body_sqra_384:


#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__sqra_384

	leaq	8(%rsp),%rsp

.LSEH_epilogue_sqra_384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_sqra_384:

.def	__sqra_384;	.scl 3;	.type 32;	.endef
.p2align	5
__sqra_384:
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%rsi),%rdx
	movq	8(%rsi),%r23
	movq	16(%rsi),%r24
	movq	24(%rsi),%r25
	movq	32(%rsi),%r26


	mulxq	%r23,%r17,%rax
	movq	40(%rsi),%r27
	mulxq	%r24,%r18,%r11
	addq	%rax,%r18
	mulxq	%r25,%r19,%rax
	adcq	%r11,%r19
	mulxq	%r26,%r20,%r11
	adcq	%rax,%r20
	mulxq	%r27,%r21,%r22
	movq	%r23,%rdx
	adcq	%r11,%r21
	adcq	$0,%r22


	xorq	%r23,%r23
	mulxq	%r24,%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	%r25,%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	%r26,%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	%r27,%rax,%r11
	movq	%r24,%rdx
	adcxq	%rax,%r22
	adoxq	%r23,%r11
	adcxq	%r11,%r23


	xorq	%r24,%r24
	mulxq	%r25,%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	%r26,%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	%r27,%rax,%r11
	movq	%r25,%rdx
	adcxq	%rax,%r23
	adoxq	%r24,%r11
	adcxq	%r11,%r24


	xorq	%r25,%r25
	mulxq	%r26,%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r11,%r24

	mulxq	%r27,%rax,%r11
	movq	%r26,%rdx
	adcxq	%rax,%r24
	adoxq	%r25,%r11
	adcxq	%r11,%r25


	mulxq	%r27,%rax,%r26
	movq	0(%rsi),%rdx
	addq	%rax,%r25
	adcq	$0,%r26


	xorq	%r27,%r27
	adcxq	%r17,%r17
	adcxq	%r18,%r18
	adcxq	%r19,%r19
	adcxq	%r20,%r20
	adcxq	%r21,%r21


	mulxq	%rdx,%rdx,%r11
	movq	%rdx,0(%rdi)
	movq	8(%rsi),%rdx
	adoxq	%r11,%r17
	movq	%r17,8(%rdi)

	mulxq	%rdx,%r17,%r11
	movq	16(%rsi),%rdx
	adoxq	%r17,%r18
	adoxq	%r11,%r19
	movq	%r18,16(%rdi)
	movq	%r19,24(%rdi)

	mulxq	%rdx,%r17,%r18
	movq	24(%rsi),%rdx
	adoxq	%r17,%r20
	adoxq	%r18,%r21
	adcxq	%r22,%r22
	adcxq	%r23,%r23
	movq	%r20,32(%rdi)
	movq	%r21,40(%rdi)

	mulxq	%rdx,%r17,%r18
	movq	32(%rsi),%rdx
	adoxq	%r17,%r22
	adoxq	%r18,%r23
	adcxq	%r24,%r24
	adcxq	%r25,%r25
	movq	%r22,48(%rdi)
	movq	%r23,56(%rdi)

	mulxq	%rdx,%r17,%r18
	movq	40(%rsi),%rdx
	adoxq	%r17,%r24
	adoxq	%r18,%r25
	adcxq	%r26,%r26
	adcxq	%r27,%r27
	movq	%r24,64(%rdi)
	movq	%r25,72(%rdi)

	mulxq	%rdx,%r17,%r18
	adoxq	%r17,%r26
	adoxq	%r18,%r27

	movq	%r26,80(%rdi)
	movq	%r27,88(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif





.globl	redca_mont_384

.def	redca_mont_384;	.scl 2;	.type 32;	.endef
.p2align	5
redca_mont_384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_redca_mont_384:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
redc_mont_384$4:
	leaq	-8(%rsp),%rsp

.LSEH_body_redca_mont_384:


	movq	%rcx,%r8
	movq	%rdx,%rcx
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384

	leaq	8(%rsp),%rsp

.LSEH_epilogue_redca_mont_384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_redca_mont_384:




.globl	froma_mont_384

.def	froma_mont_384;	.scl 2;	.type 32;	.endef
.p2align	5
froma_mont_384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_froma_mont_384:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
from_mont_384$4:
	leaq	-8(%rsp),%rsp

.LSEH_body_froma_mont_384:


	movq	%rcx,%r8
	movq	%rdx,%rcx
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384




	subq	0(%rcx),%r16,%r22
	sbbq	8(%rcx),%r17,%r23
	sbbq	16(%rcx),%r18,%r24
	sbbq	24(%rcx),%r19,%r25
	sbbq	32(%rcx),%r20,%r26
	sbbq	40(%rcx),%r21,%r27

	cmovncq	%r22,%r16
	cmovncq	%r23,%r17
	cmovncq	%r24,%r18
	movq	%r16,0(%rdi)
	cmovncq	%r25,%r19
	movq	%r17,8(%rdi)
	cmovncq	%r26,%r20
	movq	%r18,16(%rdi)
	cmovncq	%r27,%r21
	movq	%r19,24(%rdi)
	movq	%r20,32(%rdi)
	movq	%r21,40(%rdi)

	leaq	8(%rsp),%rsp

.LSEH_epilogue_froma_mont_384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_froma_mont_384:

.def	__mula_by_1_mont_384;	.scl 3;	.type 32;	.endef
.p2align	5
__mula_by_1_mont_384:
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%rsi),%r16
	movq	8(%rsi),%r17
	movq	16(%rsi),%r18
	movq	24(%rsi),%r19
	movq	32(%rsi),%r20
	movq	40(%rsi),%r21
{nf}	imulq	%r16,%r8,%rdx


	xorq	%r22,%r22
	mulxq	0(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40(%rcx),%rax,%r21
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r22,%r21
{nf}	imulq	%r16,%r8,%rdx


	xorq	%r22,%r22
	mulxq	0(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40(%rcx),%rax,%r21
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r22,%r21
{nf}	imulq	%r16,%r8,%rdx


	xorq	%r22,%r22
	mulxq	0(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40(%rcx),%rax,%r21
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r22,%r21
{nf}	imulq	%r16,%r8,%rdx


	xorq	%r22,%r22
	mulxq	0(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40(%rcx),%rax,%r21
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r22,%r21
{nf}	imulq	%r16,%r8,%rdx


	xorq	%r22,%r22
	mulxq	0(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40(%rcx),%rax,%r21
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r22,%r21
{nf}	imulq	%r16,%r8,%rdx


	xorq	%r22,%r22
	mulxq	0(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40(%rcx),%rax,%r21
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r22,%r21
	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif


.def	__reda_tail_mont_384;	.scl 3;	.type 32;	.endef
.p2align	5
__reda_tail_mont_384:
	.byte	0xf3,0x0f,0x1e,0xfa

	addq	48(%rsi),%r16
	adcq	56(%rsi),%r17
	adcq	64(%rsi),%r18
	adcq	72(%rsi),%r19
	adcq	80(%rsi),%r20
	adcq	88(%rsi),%r21
	sbbq	%r11,%r11




	subq	0(%rcx),%r16,%r22
	sbbq	8(%rcx),%r17,%r23
	sbbq	16(%rcx),%r18,%r24
	sbbq	24(%rcx),%r19,%r25
	sbbq	32(%rcx),%r20,%r26
	sbbq	40(%rcx),%r21,%r27
	sbbq	$0,%r11

	cmovncq	%r22,%r16
	cmovncq	%r23,%r17
	cmovncq	%r24,%r18
	movq	%r16,0(%rdi)
	cmovncq	%r25,%r19
	movq	%r17,8(%rdi)
	cmovncq	%r26,%r20
	movq	%r18,16(%rdi)
	cmovncq	%r27,%r21
	movq	%r19,24(%rdi)
	movq	%r20,32(%rdi)
	movq	%r21,40(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif


.globl	sgn0a_pty_mont_384

.def	sgn0a_pty_mont_384;	.scl 2;	.type 32;	.endef
.p2align	5
sgn0a_pty_mont_384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_sgn0a_pty_mont_384:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
sgn0_pty_mont_384$4:
	leaq	-8(%rsp),%rsp

.LSEH_body_sgn0a_pty_mont_384:


	movq	%rdx,%r8
	movq	%rsi,%rcx
	leaq	0(%rdi),%rsi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384

	xorq	%rax,%rax
	movq	%r16,%r23
	addq	%r16,%r16
	adcq	%r17,%r17
	adcq	%r18,%r18
	adcq	%r19,%r19
	adcq	%r20,%r20
	adcq	%r21,%r21
	adcq	$0,%rax

	subq	0(%rcx),%r16
	sbbq	8(%rcx),%r17
	sbbq	16(%rcx),%r18
	sbbq	24(%rcx),%r19
	sbbq	32(%rcx),%r20
	sbbq	40(%rcx),%r21
	sbbq	$0,%rax

	notq	%rax
	andq	$1,%r23
	andq	$2,%rax
	orq	%r23,%rax

	leaq	8(%rsp),%rsp

.LSEH_epilogue_sgn0a_pty_mont_384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_sgn0a_pty_mont_384:

.globl	sgn0a_pty_mont_384x

.def	sgn0a_pty_mont_384x;	.scl 2;	.type 32;	.endef
.p2align	5
sgn0a_pty_mont_384x:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_sgn0a_pty_mont_384x:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
sgn0_pty_mont_384x$4:
	leaq	-8(%rsp),%rsp

.LSEH_body_sgn0a_pty_mont_384x:


	movq	%rdx,%r8
	movq	%rsi,%rcx
	leaq	48(%rdi),%rsi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384

	movq	%r16,%r22
	orq	%r17,%r16
	orq	%r18,%r16
	orq	%r19,%r16
	orq	%r20,%r16
	orq	%r21,%r16

	leaq	0(%rdi),%rsi
	xorq	%rdi,%rdi
	movq	%r22,%r23
	addq	%r22,%r22
	adcq	%r17,%r17
	adcq	%r18,%r18
	adcq	%r19,%r19
	adcq	%r20,%r20
	adcq	%r21,%r21
	adcq	$0,%rdi

	subq	0(%rcx),%r22
	sbbq	8(%rcx),%r17
	sbbq	16(%rcx),%r18
	sbbq	24(%rcx),%r19
	sbbq	32(%rcx),%r20
	sbbq	40(%rcx),%r21
	sbbq	$0,%rdi

	movq	%r16,0(%rsp)
	notq	%rdi
	andq	$1,%r23
	andq	$2,%rdi
	orq	%r23,%rdi

	call	__mula_by_1_mont_384

	movq	%r16,%r22
	orq	%r17,%r16
	orq	%r18,%r16
	orq	%r19,%r16
	orq	%r20,%r16
	orq	%r21,%r16

	xorq	%rax,%rax
	movq	%r22,%r23
	addq	%r22,%r22
	adcq	%r17,%r17
	adcq	%r18,%r18
	adcq	%r19,%r19
	adcq	%r20,%r20
	adcq	%r21,%r21
	adcq	$0,%rax

	subq	0(%rcx),%r22
	sbbq	8(%rcx),%r17
	sbbq	16(%rcx),%r18
	sbbq	24(%rcx),%r19
	sbbq	32(%rcx),%r20
	sbbq	40(%rcx),%r21
	sbbq	$0,%rax

	movq	0(%rsp),%r22

	notq	%rax

	testq	%r16,%r16
	cmovzq	%rdi,%r23

	testq	%r22,%r22
	cmovnzq	%rdi,%rax

	andq	$1,%r23
	andq	$2,%rax
	orq	%r23,%rax

	leaq	8(%rsp),%rsp

.LSEH_epilogue_sgn0a_pty_mont_384x:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_sgn0a_pty_mont_384x:

.globl	mula_mont_384

.def	mula_mont_384;	.scl 2;	.type 32;	.endef
.p2align	5
mula_mont_384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_mula_mont_384:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
	movq	40(%rsp),%r8
mul_mont_384$4:
	leaq	-8(%rsp),%rsp

.LSEH_body_mula_mont_384:


	movq	%rdx,%r10
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rdx),%rdx
	movq	0(%rsi),%r25
	movq	8(%rsi),%r26
	movq	16(%rsi),%r27
	movq	24(%rsi),%r28
	movq	32(%rsi),%r29
	movq	40(%rsi),%r30
	leaq	-128(%rcx),%rcx

	mulxq	%r25,%r16,%r20
	call	__mula_mont_384

	leaq	8(%rsp),%rsp

.LSEH_epilogue_mula_mont_384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_mula_mont_384:

.def	__mula_mont_384;	.scl 3;	.type 32;	.endef
.p2align	5
__mula_mont_384:
	.byte	0xf3,0x0f,0x1e,0xfa


	mulxq	%r26,%r17,%r21
	mulxq	%r27,%r18,%r22
	addq	%r20,%r17
	mulxq	%r28,%r19,%r23
	adcq	%r21,%r18
	mulxq	%r29,%r20,%r24
	adcq	%r22,%r19
	mulxq	%r30,%r21,%r22
	movq	8(%r10),%rdx
	adcq	%r23,%r20
	adcq	%r24,%r21
	adcq	$0,%r22
	xorq	%r23,%r23

{nf}	imulq	%r8,%r16,%rsi


	xorq	%r24,%r24
	mulxq	%r25,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r26,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r27,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r28,%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	%r29,%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	%r30,%rax,%r11
	movq	%rsi,%rdx
	adoxq	%rax,%r22
	adcxq	%r24,%r11
	adoxq	%r11,%r23
	adoxq	%r24,%r24


	xorq	%rsi,%rsi
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8+128(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16+128(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24+128(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32+128(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40+128(%rcx),%rax,%r21
	movq	8+8(%r10),%rdx
	adcxq	%rax,%r20
	adoxq	%rsi,%r21
	adcxq	%r22,%r21
	adcxq	%rsi,%r23,%r22
	adcxq	%rsi,%r24,%r23
{nf}	imulq	%r8,%r16,%rsi


	xorq	%r24,%r24
	mulxq	%r25,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r26,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r27,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r28,%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	%r29,%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	%r30,%rax,%r11
	movq	%rsi,%rdx
	adoxq	%rax,%r22
	adcxq	%r24,%r11
	adoxq	%r11,%r23
	adoxq	%r24,%r24


	xorq	%rsi,%rsi
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8+128(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16+128(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24+128(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32+128(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40+128(%rcx),%rax,%r21
	movq	16+8(%r10),%rdx
	adcxq	%rax,%r20
	adoxq	%rsi,%r21
	adcxq	%r22,%r21
	adcxq	%rsi,%r23,%r22
	adcxq	%rsi,%r24,%r23
{nf}	imulq	%r8,%r16,%rsi


	xorq	%r24,%r24
	mulxq	%r25,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r26,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r27,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r28,%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	%r29,%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	%r30,%rax,%r11
	movq	%rsi,%rdx
	adoxq	%rax,%r22
	adcxq	%r24,%r11
	adoxq	%r11,%r23
	adoxq	%r24,%r24


	xorq	%rsi,%rsi
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8+128(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16+128(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24+128(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32+128(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40+128(%rcx),%rax,%r21
	movq	24+8(%r10),%rdx
	adcxq	%rax,%r20
	adoxq	%rsi,%r21
	adcxq	%r22,%r21
	adcxq	%rsi,%r23,%r22
	adcxq	%rsi,%r24,%r23
{nf}	imulq	%r8,%r16,%rsi


	xorq	%r24,%r24
	mulxq	%r25,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r26,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r27,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r28,%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	%r29,%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	%r30,%rax,%r11
	movq	%rsi,%rdx
	adoxq	%rax,%r22
	adcxq	%r24,%r11
	adoxq	%r11,%r23
	adoxq	%r24,%r24


	xorq	%rsi,%rsi
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8+128(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16+128(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24+128(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32+128(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40+128(%rcx),%rax,%r21
	movq	32+8(%r10),%rdx
	adcxq	%rax,%r20
	adoxq	%rsi,%r21
	adcxq	%r22,%r21
	adcxq	%rsi,%r23,%r22
	adcxq	%rsi,%r24,%r23
{nf}	imulq	%r8,%r16,%rsi


	xorq	%r24,%r24
	mulxq	%r25,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r26,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r27,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r28,%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	%r29,%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	%r30,%rax,%r11
	movq	%rsi,%rdx
	adoxq	%rax,%r22
	adcxq	%r24,%r11
	adoxq	%r11,%r23
	adoxq	%r24,%r24


	xorq	%rsi,%rsi
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8+128(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16+128(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24+128(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32+128(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40+128(%rcx),%rax,%r21
{nf}	imulq	%r8,%r16,%rdx
	adcxq	%rax,%r20
	adoxq	%rsi,%r21
	adcxq	%r22,%r21
	adcxq	%rsi,%r23,%r22
	adcxq	%rsi,%r24,%r23

	xorq	%r24,%r24
	mulxq	0+128(%rcx),%rax,%r25
	adcxq	%rax,%r16
	adoxq	%r17,%r25

	mulxq	8+128(%rcx),%rax,%r26
	adcxq	%rax,%r25
	adoxq	%r18,%r26

	mulxq	16+128(%rcx),%rax,%r27
	adcxq	%rax,%r26
	adoxq	%r19,%r27

	mulxq	24+128(%rcx),%rax,%r28
	adcxq	%rax,%r27
	adoxq	%r20,%r28

	mulxq	32+128(%rcx),%rax,%r29
	adcxq	%rax,%r28
	adoxq	%r21,%r29

	mulxq	40+128(%rcx),%rax,%r30
	adcxq	%rax,%r29
	adoxq	%r24,%r30
	leaq	128(%rcx),%rcx
	adcxq	%r22,%r30
	adcq	$0,%r23




	subq	0(%rcx),%r25,%rdx
	sbbq	8(%rcx),%r26,%r17
	sbbq	16(%rcx),%r27,%r18
	sbbq	24(%rcx),%r28,%r19
	sbbq	32(%rcx),%r29,%r20
	sbbq	40(%rcx),%r30,%r21
	sbbq	$0,%r23

	cmovcq	%r25,%rdx
	cmovncq	%r17,%r26
	cmovncq	%r18,%r27
	cmovncq	%r19,%r28
	movq	%rdx,0(%rdi)
	cmovncq	%r20,%r29
	movq	%r26,8(%rdi)
	cmovncq	%r21,%r30
	movq	%r27,16(%rdi)
	movq	%r28,24(%rdi)
	movq	%r29,32(%rdi)
	movq	%r30,40(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rsi
	lfence
	jmpq	*%rsi
	ud2
#else
	.byte	0xf3,0xc3
#endif



.globl	sqra_mont_384

.def	sqra_mont_384;	.scl 2;	.type 32;	.endef
.p2align	5
sqra_mont_384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_sqra_mont_384:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
sqr_mont_384$4:
	leaq	-8(%rsp),%rsp

.LSEH_body_sqra_mont_384:


	movq	%rcx,%r8
	leaq	-128(%rdx),%rcx
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%rdx
	movq	8(%rsi),%r26
	movq	16(%rsi),%r27
	movq	24(%rsi),%r28
	movq	32(%rsi),%r29
	movq	40(%rsi),%r30

	leaq	(%rsi),%r10

	movq	%rdx,%r25
	mulxq	%rdx,%r16,%r20
	call	__mula_mont_384

	leaq	8(%rsp),%rsp

.LSEH_epilogue_sqra_mont_384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_sqra_mont_384:

.globl	sqra_n_mul_mont_384

.def	sqra_n_mul_mont_384;	.scl 2;	.type 32;	.endef
.p2align	5
sqra_n_mul_mont_384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_sqra_n_mul_mont_384:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
	movq	40(%rsp),%r8
	movq	48(%rsp),%r9
sqr_n_mul_mont_384$4:
	leaq	-8(%rsp),%rsp

.LSEH_body_sqra_n_mul_mont_384:


	movq	%rdx,%r31
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%rdx
	movq	8(%rsi),%r26
	movq	16(%rsi),%r27
	movq	%rsi,%r10
	movq	24(%rsi),%r28
	movq	32(%rsi),%r29
	movq	40(%rsi),%r30

.Loop_sqra_384:
	leaq	-128(%rcx),%rcx

	movq	%rdx,%r25
	mulxq	%rdx,%r16,%r20
	call	__mula_mont_384

	movq	%rdi,%r10
	decl	%r31d
	jnz	.Loop_sqra_384

	movq	%rdx,%r25
	movq	(%r9),%rdx
	leaq	(%r9),%r10
	leaq	-128(%rcx),%rcx

	mulxq	%r25,%r16,%r20
	call	__mula_mont_384

	leaq	8(%rsp),%rsp

.LSEH_epilogue_sqra_n_mul_mont_384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_sqra_n_mul_mont_384:

.globl	sqra_n_mul_mont_383

.def	sqra_n_mul_mont_383;	.scl 2;	.type 32;	.endef
.p2align	5
sqra_n_mul_mont_383:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_sqra_n_mul_mont_383:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
	movq	40(%rsp),%r8
	movq	48(%rsp),%r9
sqr_n_mul_mont_383$4:
	leaq	-8(%rsp),%rsp

.LSEH_body_sqra_n_mul_mont_383:


	movq	%rdx,%r31
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%rdx
	movq	8(%rsi),%r26
	movq	16(%rsi),%r27
	movq	24(%rsi),%r28
	movq	32(%rsi),%r29
	movq	40(%rsi),%r30
	movq	%rdx,%r25
	leaq	-128(%rcx),%rcx
	jmp	.Loop_sqra_383

.p2align	5
.Loop_sqra_383:


	mulxq	%rdx,%r16,%r20
	mulxq	%r26,%r17,%r21
	mulxq	%r27,%r18,%r22
	addq	%r20,%r17
	mulxq	%r28,%r19,%r23
	adcq	%r21,%r18
	mulxq	%r29,%r20,%r24
	adcq	%r22,%r19
	mulxq	%r30,%r21,%r22
	movq	%r26,%rdx
	adcq	%r23,%r20
	adcq	%r24,%r21
	adcq	$0,%r22
{nf}	imulq	%r8,%r16,%r24


	xorq	%r23,%r23
	mulxq	%r25,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r26,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r27,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r28,%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	%r29,%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	%r30,%rax,%r11
	movq	%r24,%rdx
	adoxq	%rax,%r22
	adcxq	%r23,%r11
	adoxq	%r11,%r23


	xorq	%r24,%r24
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8+128(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16+128(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24+128(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32+128(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40+128(%rcx),%rax,%r21
	movq	%r27,%rdx
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r24,%r21
	adoxq	%r24,%r23
	adcxq	%r24,%r23,%r22
{nf}	imulq	%r8,%r16,%r24


	xorq	%r23,%r23
	mulxq	%r25,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r26,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r27,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r28,%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	%r29,%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	%r30,%rax,%r11
	movq	%r24,%rdx
	adoxq	%rax,%r22
	adcxq	%r23,%r11
	adoxq	%r11,%r23


	xorq	%r24,%r24
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8+128(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16+128(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24+128(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32+128(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40+128(%rcx),%rax,%r21
	movq	%r28,%rdx
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r24,%r21
	adoxq	%r24,%r23
	adcxq	%r24,%r23,%r22
{nf}	imulq	%r8,%r16,%r24


	xorq	%r23,%r23
	mulxq	%r25,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r26,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r27,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r28,%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	%r29,%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	%r30,%rax,%r11
	movq	%r24,%rdx
	adoxq	%rax,%r22
	adcxq	%r23,%r11
	adoxq	%r11,%r23


	xorq	%r24,%r24
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8+128(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16+128(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24+128(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32+128(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40+128(%rcx),%rax,%r21
	movq	%r29,%rdx
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r24,%r21
	adoxq	%r24,%r23
	adcxq	%r24,%r23,%r22
{nf}	imulq	%r8,%r16,%r24


	xorq	%r23,%r23
	mulxq	%r25,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r26,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r27,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r28,%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	%r29,%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	%r30,%rax,%r11
	movq	%r24,%rdx
	adoxq	%rax,%r22
	adcxq	%r23,%r11
	adoxq	%r11,%r23


	xorq	%r24,%r24
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8+128(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16+128(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24+128(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32+128(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40+128(%rcx),%rax,%r21
	movq	%r30,%rdx
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r24,%r21
	adoxq	%r24,%r23
	adcxq	%r24,%r23,%r22
{nf}	imulq	%r8,%r16,%r24


	xorq	%r23,%r23
	mulxq	%r25,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r26,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r27,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r28,%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	%r29,%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	%r30,%rax,%r11
	movq	%r24,%rdx
	adoxq	%rax,%r22
	adcxq	%r23,%r11
	adoxq	%r11,%r23


	xorq	%r24,%r24
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	8+128(%rcx),%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	16+128(%rcx),%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	24+128(%rcx),%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19

	mulxq	32+128(%rcx),%rax,%r20
	adcxq	%rax,%r19
	adoxq	%r21,%r20

	mulxq	40+128(%rcx),%rax,%r21
{nf}	imulq	%r8,%r16,%rdx
	adcxq	%rax,%r20
	adoxq	%r22,%r21
	adcxq	%r24,%r21
	adoxq	%r24,%r23
	adcxq	%r24,%r23,%r22

	xorq	%r24,%r24
	mulxq	0+128(%rcx),%rax,%r25
	adcxq	%r16,%rax
	adoxq	%r17,%r25

	mulxq	8+128(%rcx),%rax,%r26
	adcxq	%rax,%r25
	adoxq	%r18,%r26

	mulxq	16+128(%rcx),%rax,%r27
	adcxq	%rax,%r26
	adoxq	%r19,%r27

	mulxq	24+128(%rcx),%rax,%r28
	adcxq	%rax,%r27
	adoxq	%r20,%r28

	mulxq	32+128(%rcx),%rax,%r29
	adcxq	%rax,%r28
	adoxq	%r21,%r29

	mulxq	40+128(%rcx),%rax,%r30
	movq	%r25,%rdx
	adcxq	%rax,%r29
	adoxq	%r22,%r30
	adcq	$0,%r30

	decl	%r31d
	jnz	.Loop_sqra_383

	movq	(%r9),%rdx
	leaq	(%r9),%r10

	mulxq	%r25,%r16,%r20
	call	__mula_mont_384

	leaq	8(%rsp),%rsp

.LSEH_epilogue_sqra_n_mul_mont_383:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.LSEH_end_sqra_n_mul_mont_383:
.section	.pdata
.p2align	2
.rva	.LSEH_begin_mula_mont_384x
.rva	.LSEH_body_mula_mont_384x
.rva	.LSEH_info_mula_mont_384x_prologue

.rva	.LSEH_body_mula_mont_384x
.rva	.LSEH_epilogue_mula_mont_384x
.rva	.LSEH_info_mula_mont_384x_body

.rva	.LSEH_epilogue_mula_mont_384x
.rva	.LSEH_end_mula_mont_384x
.rva	.LSEH_info_mula_mont_384x_epilogue

.rva	.LSEH_begin_sqra_mont_384x
.rva	.LSEH_body_sqra_mont_384x
.rva	.LSEH_info_sqra_mont_384x_prologue

.rva	.LSEH_body_sqra_mont_384x
.rva	.LSEH_epilogue_sqra_mont_384x
.rva	.LSEH_info_sqra_mont_384x_body

.rva	.LSEH_epilogue_sqra_mont_384x
.rva	.LSEH_end_sqra_mont_384x
.rva	.LSEH_info_sqra_mont_384x_epilogue

.rva	.LSEH_begin_mula_382x
.rva	.LSEH_body_mula_382x
.rva	.LSEH_info_mula_382x_prologue

.rva	.LSEH_body_mula_382x
.rva	.LSEH_epilogue_mula_382x
.rva	.LSEH_info_mula_382x_body

.rva	.LSEH_epilogue_mula_382x
.rva	.LSEH_end_mula_382x
.rva	.LSEH_info_mula_382x_epilogue

.rva	.LSEH_begin_sqra_382x
.rva	.LSEH_body_sqra_382x
.rva	.LSEH_info_sqra_382x_prologue

.rva	.LSEH_body_sqra_382x
.rva	.LSEH_epilogue_sqra_382x
.rva	.LSEH_info_sqra_382x_body

.rva	.LSEH_epilogue_sqra_382x
.rva	.LSEH_end_sqra_382x
.rva	.LSEH_info_sqra_382x_epilogue

.rva	.LSEH_begin_mula_384
.rva	.LSEH_body_mula_384
.rva	.LSEH_info_mula_384_prologue

.rva	.LSEH_body_mula_384
.rva	.LSEH_epilogue_mula_384
.rva	.LSEH_info_mula_384_body

.rva	.LSEH_epilogue_mula_384
.rva	.LSEH_end_mula_384
.rva	.LSEH_info_mula_384_epilogue

.rva	.LSEH_begin_sqra_384
.rva	.LSEH_body_sqra_384
.rva	.LSEH_info_sqra_384_prologue

.rva	.LSEH_body_sqra_384
.rva	.LSEH_epilogue_sqra_384
.rva	.LSEH_info_sqra_384_body

.rva	.LSEH_epilogue_sqra_384
.rva	.LSEH_end_sqra_384
.rva	.LSEH_info_sqra_384_epilogue

.rva	.LSEH_begin_redca_mont_384
.rva	.LSEH_body_redca_mont_384
.rva	.LSEH_info_redca_mont_384_prologue

.rva	.LSEH_body_redca_mont_384
.rva	.LSEH_epilogue_redca_mont_384
.rva	.LSEH_info_redca_mont_384_body

.rva	.LSEH_epilogue_redca_mont_384
.rva	.LSEH_end_redca_mont_384
.rva	.LSEH_info_redca_mont_384_epilogue

.rva	.LSEH_begin_froma_mont_384
.rva	.LSEH_body_froma_mont_384
.rva	.LSEH_info_froma_mont_384_prologue

.rva	.LSEH_body_froma_mont_384
.rva	.LSEH_epilogue_froma_mont_384
.rva	.LSEH_info_froma_mont_384_body

.rva	.LSEH_epilogue_froma_mont_384
.rva	.LSEH_end_froma_mont_384
.rva	.LSEH_info_froma_mont_384_epilogue

.rva	.LSEH_begin_sgn0a_pty_mont_384
.rva	.LSEH_body_sgn0a_pty_mont_384
.rva	.LSEH_info_sgn0a_pty_mont_384_prologue

.rva	.LSEH_body_sgn0a_pty_mont_384
.rva	.LSEH_epilogue_sgn0a_pty_mont_384
.rva	.LSEH_info_sgn0a_pty_mont_384_body

.rva	.LSEH_epilogue_sgn0a_pty_mont_384
.rva	.LSEH_end_sgn0a_pty_mont_384
.rva	.LSEH_info_sgn0a_pty_mont_384_epilogue

.rva	.LSEH_begin_sgn0a_pty_mont_384x
.rva	.LSEH_body_sgn0a_pty_mont_384x
.rva	.LSEH_info_sgn0a_pty_mont_384x_prologue

.rva	.LSEH_body_sgn0a_pty_mont_384x
.rva	.LSEH_epilogue_sgn0a_pty_mont_384x
.rva	.LSEH_info_sgn0a_pty_mont_384x_body

.rva	.LSEH_epilogue_sgn0a_pty_mont_384x
.rva	.LSEH_end_sgn0a_pty_mont_384x
.rva	.LSEH_info_sgn0a_pty_mont_384x_epilogue

.rva	.LSEH_begin_mula_mont_384
.rva	.LSEH_body_mula_mont_384
.rva	.LSEH_info_mula_mont_384_prologue

.rva	.LSEH_body_mula_mont_384
.rva	.LSEH_epilogue_mula_mont_384
.rva	.LSEH_info_mula_mont_384_body

.rva	.LSEH_epilogue_mula_mont_384
.rva	.LSEH_end_mula_mont_384
.rva	.LSEH_info_mula_mont_384_epilogue

.rva	.LSEH_begin_sqra_mont_384
.rva	.LSEH_body_sqra_mont_384
.rva	.LSEH_info_sqra_mont_384_prologue

.rva	.LSEH_body_sqra_mont_384
.rva	.LSEH_epilogue_sqra_mont_384
.rva	.LSEH_info_sqra_mont_384_body

.rva	.LSEH_epilogue_sqra_mont_384
.rva	.LSEH_end_sqra_mont_384
.rva	.LSEH_info_sqra_mont_384_epilogue

.rva	.LSEH_begin_sqra_n_mul_mont_384
.rva	.LSEH_body_sqra_n_mul_mont_384
.rva	.LSEH_info_sqra_n_mul_mont_384_prologue

.rva	.LSEH_body_sqra_n_mul_mont_384
.rva	.LSEH_epilogue_sqra_n_mul_mont_384
.rva	.LSEH_info_sqra_n_mul_mont_384_body

.rva	.LSEH_epilogue_sqra_n_mul_mont_384
.rva	.LSEH_end_sqra_n_mul_mont_384
.rva	.LSEH_info_sqra_n_mul_mont_384_epilogue

.rva	.LSEH_begin_sqra_n_mul_mont_383
.rva	.LSEH_body_sqra_n_mul_mont_383
.rva	.LSEH_info_sqra_n_mul_mont_383_prologue

.rva	.LSEH_body_sqra_n_mul_mont_383
.rva	.LSEH_epilogue_sqra_n_mul_mont_383
.rva	.LSEH_info_sqra_n_mul_mont_383_body

.rva	.LSEH_epilogue_sqra_n_mul_mont_383
.rva	.LSEH_end_sqra_n_mul_mont_383
.rva	.LSEH_info_sqra_n_mul_mont_383_epilogue

.section	.xdata
.p2align	3
.LSEH_info_mula_mont_384x_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_mula_mont_384x_body:
.byte	1,0,6,0
.byte	0x00,0x74,0x26,0x00
.byte	0x00,0x64,0x27,0x00
.byte	0x00,0x01,0x25,0x00
.byte	0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_mula_mont_384x_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_sqra_mont_384x_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_sqra_mont_384x_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x0e,0x00
.byte	0x00,0x64,0x0f,0x00
.byte	0x00,0xc2
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_sqra_mont_384x_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_mula_382x_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_mula_382x_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x0e,0x00
.byte	0x00,0x64,0x0f,0x00
.byte	0x00,0xc2
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_mula_382x_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_sqra_382x_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_sqra_382x_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_sqra_382x_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_mula_384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_mula_384_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_mula_384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_sqra_384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_sqra_384_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_sqra_384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_redca_mont_384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_redca_mont_384_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_redca_mont_384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_froma_mont_384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_froma_mont_384_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_froma_mont_384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_sgn0a_pty_mont_384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_sgn0a_pty_mont_384_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_sgn0a_pty_mont_384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_sgn0a_pty_mont_384x_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_sgn0a_pty_mont_384x_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_sgn0a_pty_mont_384x_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_mula_mont_384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_mula_mont_384_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_mula_mont_384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_sqra_mont_384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_sqra_mont_384_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_sqra_mont_384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_sqra_n_mul_mont_384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_sqra_n_mul_mont_384_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_sqra_n_mul_mont_384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_sqra_n_mul_mont_383_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_sqra_n_mul_mont_383_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_sqra_n_mul_mont_383_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

