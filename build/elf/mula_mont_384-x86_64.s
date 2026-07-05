.text	





.type	__suba_mod_384x384,@function
.align	32
__suba_mod_384x384:
.cfi_startproc
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

	andq	0(%rcx),%rdx,%r16
	andq	8(%rcx),%rdx,%r17
	andq	16(%rcx),%rdx,%r18
	andq	24(%rcx),%rdx,%r19
	andq	32(%rcx),%rdx,%r20
	andq	40(%rcx),%rdx,%r21

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
.cfi_endproc
.size	__suba_mod_384x384,.-__suba_mod_384x384

.type	__adda_mod_384,@function
.align	32
__adda_mod_384:
.cfi_startproc
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
.cfi_endproc
.size	__adda_mod_384,.-__adda_mod_384

.type	__suba_mod_384,@function
.align	32
__suba_mod_384:
.cfi_startproc
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

	andq	0(%rcx),%rdx,%r22
	andq	8(%rcx),%rdx,%r23
	andq	16(%rcx),%rdx,%r24
	andq	24(%rcx),%rdx,%r25
	andq	32(%rcx),%rdx,%r26
	andq	40(%rcx),%rdx,%r27

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
.cfi_endproc
.size	__suba_mod_384,.-__suba_mod_384
.globl	mula_mont_384x
.hidden	mula_mont_384x
.type	mula_mont_384x,@function
.align	32
mula_mont_384x:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


mul_mont_384x$4:
	subq	$296,%rsp
.cfi_adjust_cfa_offset	296


	movq	%rdx,%r10
	movq	%rdi,%r28
	movq	%rsi,%r29




	leaq	0(%rsp),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384


	leaq	48(%r10),%r10
	leaq	128+48(%rsi),%rsi
	leaq	96(%rdi),%rdi
	call	__mula_384


	leaq	(%r10),%rsi
	leaq	-48(%r10),%rdx
	leaq	192+48(%rsp),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__adda_mod_384

	leaq	(%r29),%rsi
	leaq	48(%r29),%rdx
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
	leaq	0(%r28),%rdi
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384


	leaq	192(%rsp),%rsi
	leaq	48(%rdi),%rdi
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384

	leaq	296(%rsp),%rsp
.cfi_adjust_cfa_offset	-296

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	mula_mont_384x,.-mula_mont_384x
.globl	sqra_mont_384x
.hidden	sqra_mont_384x
.type	sqra_mont_384x,@function
.align	32
sqra_mont_384x:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


sqr_mont_384x$4:
	subq	$104,%rsp
.cfi_adjust_cfa_offset	104


	movq	%rcx,%r8
	movq	%rdx,%rcx
	movq	%rdi,%r28
	movq	%rsi,%r29


	leaq	48(%rsi),%rdx
	leaq	0(%rsp),%rdi
	call	__adda_mod_384


	leaq	(%r29),%rsi
	leaq	48(%r29),%rdx
	leaq	48(%rsp),%rdi
	call	__suba_mod_384


	leaq	48(%rsi),%r10
	leaq	(%r28),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	48(%rsi),%rdx
	movq	0(%rsi),%r22
	movq	8(%rsi),%r23
	movq	16(%rsi),%r24
	movq	24(%rsi),%r25
	movq	32(%rsi),%r26
	movq	40(%rsi),%r27
	leaq	-128(%rsi),%rsi
	leaq	-128(%rcx),%rcx

	mulxq	%r22,%r16,%r17
	call	__mula_mont_384
	addq	%rdx,%rdx
	adcq	%r23,%r23
	adcq	%r24,%r24
	adcq	%r25,%r25
	adcq	%r26,%r26
	adcq	%r27,%r27
	sbbq	%rsi,%rsi

	subq	0(%rcx),%rdx,%r16
	sbbq	8(%rcx),%r23,%r17
	sbbq	16(%rcx),%r24,%r18
	sbbq	24(%rcx),%r25,%r19
	sbbq	32(%rcx),%r26,%r20
	sbbq	40(%rcx),%r27,%r21
	sbbq	$0,%rsi

	cmovncq	%r16,%rdx
	cmovncq	%r17,%r23
	cmovncq	%r18,%r24
	movq	%rdx,48(%rdi)
	cmovncq	%r19,%r25
	movq	%r23,56(%rdi)
	cmovncq	%r20,%r26
	movq	%r24,64(%rdi)
	cmovncq	%r21,%r27
	movq	%r25,72(%rdi)
	movq	%r26,80(%rdi)
	movq	%r27,88(%rdi)

	leaq	0(%rsp),%rsi
	leaq	48(%rsp),%r10

	movq	48(%rsp),%rdx
	movq	0(%rsp),%r22
	movq	8(%rsp),%r23
	movq	16(%rsp),%r24
	movq	24(%rsp),%r25
	movq	32(%rsp),%r26
	movq	40(%rsp),%r27
	leaq	-128(%rsi),%rsi
	leaq	-128(%rcx),%rcx

	mulxq	%r22,%r16,%r17
	call	__mula_mont_384

	leaq	104(%rsp),%rsp
.cfi_adjust_cfa_offset	-104

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	sqra_mont_384x,.-sqra_mont_384x

.globl	mula_382x
.hidden	mula_382x
.type	mula_382x,@function
.align	32
mula_382x:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


mul_382x$4:
	subq	$104,%rsp
.cfi_adjust_cfa_offset	104


	movq	%rdi,%r28
	movq	%rsi,%r29
	movq	%rdx,%r30
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


	leaq	0(%rsp),%rsi
	leaq	48(%rsp),%r10
	call	__mula_384


	leaq	(%r29),%rsi
	leaq	(%r30),%r10
	leaq	-96(%rdi),%rdi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384


	leaq	48+128(%rsi),%rsi
	leaq	48(%r10),%r10
	leaq	0(%rsp),%rdi
	call	__mula_384


	leaq	96(%r28),%rsi
	leaq	0(%rsp),%rdx
	leaq	96(%r28),%rdi
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
.cfi_adjust_cfa_offset	-104

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	mula_382x,.-mula_382x
.globl	sqra_382x
.hidden	sqra_382x
.type	sqra_382x,@function
.align	32
sqra_382x:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


sqr_382x$4:
	subq	$8,%rsp
.cfi_adjust_cfa_offset	8


	movq	%rdx,%rcx
	movq	%rsi,%r28


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


	leaq	(%r28),%rsi
	leaq	48(%rsi),%r10
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
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	sqra_382x,.-sqra_382x
.globl	mula_384
.hidden	mula_384
.type	mula_384,@function
.align	32
mula_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


mul_384$4:
	leaq	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8


	movq	%rdx,%r10
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384

	leaq	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	mula_384,.-mula_384

.type	__mula_384,@function
.align	32
__mula_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%r10),%rdx
	movq	0(%rsi),%r22
	movq	8(%rsi),%r23
	movq	16(%rsi),%r18
	movq	24(%rsi),%r19
	movq	32(%rsi),%r20
	movq	40(%rsi),%r21
	leaq	-128(%rsi),%rsi

	mulxq	%r22,%r17,%r25
	xorq	%r26,%r26

	mulxq	%r23,%r16,%r24
	adcxq	%r25,%r16
	movq	%r17,0(%rdi)

	mulxq	%r18,%r17,%r25
	adcxq	%r24,%r17

	mulxq	%r19,%r18,%r24
	adcxq	%r25,%r18

	mulxq	%r20,%r19,%r25
	adcxq	%r24,%r19

	mulxq	%r21,%r20,%r21
	movq	8(%r10),%rdx
	adcxq	%r25,%r20
	adcxq	%r26,%r21
	mulxq	%r22,%r24,%r25
	adcxq	%r16,%r24
	adoxq	%r25,%r17
	movq	%r24,8(%rdi)

	mulxq	%r23,%r16,%r25
	adcxq	%r17,%r16
	adoxq	%r25,%r18

	mulxq	128+16(%rsi),%r17,%r24
	adcxq	%r18,%r17
	adoxq	%r24,%r19

	mulxq	128+24(%rsi),%r18,%r25
	adcxq	%r19,%r18
	adoxq	%r25,%r20

	mulxq	128+32(%rsi),%r19,%r24
	adcxq	%r20,%r19
	adoxq	%r21,%r24

	mulxq	128+40(%rsi),%r20,%r21
	movq	16(%r10),%rdx
	adcxq	%r24,%r20
	adoxq	%r26,%r21
	adcxq	%r26,%r21
	mulxq	%r22,%r24,%r25
	adcxq	%r16,%r24
	adoxq	%r25,%r17
	movq	%r24,16(%rdi)

	mulxq	%r23,%r16,%r25
	adcxq	%r17,%r16
	adoxq	%r25,%r18

	mulxq	128+16(%rsi),%r17,%r24
	adcxq	%r18,%r17
	adoxq	%r24,%r19

	mulxq	128+24(%rsi),%r18,%r25
	adcxq	%r19,%r18
	adoxq	%r25,%r20

	mulxq	128+32(%rsi),%r19,%r24
	adcxq	%r20,%r19
	adoxq	%r21,%r24

	mulxq	128+40(%rsi),%r20,%r21
	movq	24(%r10),%rdx
	adcxq	%r24,%r20
	adoxq	%r26,%r21
	adcxq	%r26,%r21
	mulxq	%r22,%r24,%r25
	adcxq	%r16,%r24
	adoxq	%r25,%r17
	movq	%r24,24(%rdi)

	mulxq	%r23,%r16,%r25
	adcxq	%r17,%r16
	adoxq	%r25,%r18

	mulxq	128+16(%rsi),%r17,%r24
	adcxq	%r18,%r17
	adoxq	%r24,%r19

	mulxq	128+24(%rsi),%r18,%r25
	adcxq	%r19,%r18
	adoxq	%r25,%r20

	mulxq	128+32(%rsi),%r19,%r24
	adcxq	%r20,%r19
	adoxq	%r21,%r24

	mulxq	128+40(%rsi),%r20,%r21
	movq	32(%r10),%rdx
	adcxq	%r24,%r20
	adoxq	%r26,%r21
	adcxq	%r26,%r21
	mulxq	%r22,%r24,%r25
	adcxq	%r16,%r24
	adoxq	%r25,%r17
	movq	%r24,32(%rdi)

	mulxq	%r23,%r16,%r25
	adcxq	%r17,%r16
	adoxq	%r25,%r18

	mulxq	128+16(%rsi),%r17,%r24
	adcxq	%r18,%r17
	adoxq	%r24,%r19

	mulxq	128+24(%rsi),%r18,%r25
	adcxq	%r19,%r18
	adoxq	%r25,%r20

	mulxq	128+32(%rsi),%r19,%r24
	adcxq	%r20,%r19
	adoxq	%r21,%r24

	mulxq	128+40(%rsi),%r20,%r21
	movq	40(%r10),%rdx
	adcxq	%r24,%r20
	adoxq	%r26,%r21
	adcxq	%r26,%r21
	mulxq	%r22,%r24,%r25
	adcxq	%r16,%r24
	adoxq	%r25,%r17
	movq	%r24,40(%rdi)

	mulxq	%r23,%r16,%r25
	adcxq	%r17,%r16
	adoxq	%r25,%r18

	mulxq	128+16(%rsi),%r17,%r24
	adcxq	%r18,%r17
	adoxq	%r24,%r19

	mulxq	128+24(%rsi),%r18,%r25
	adcxq	%r19,%r18
	adoxq	%r25,%r20

	mulxq	128+32(%rsi),%r19,%r24
	adcxq	%r20,%r19
	adoxq	%r21,%r24

	mulxq	128+40(%rsi),%r20,%r21
	movq	%rax,%rdx
	adcxq	%r24,%r20
	adoxq	%r26,%r21
	adcxq	%r26,%r21
	movq	%r16,48(%rdi)
	movq	%r17,56(%rdi)
	movq	%r18,64(%rdi)
	movq	%r19,72(%rdi)
	movq	%r20,80(%rdi)
	movq	%r21,88(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc
.size	__mula_384,.-__mula_384
.globl	sqra_384
.hidden	sqra_384
.type	sqra_384,@function
.align	32
sqra_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


sqr_384$4:
	leaq	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8


#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__sqra_384

	leaq	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	sqra_384,.-sqra_384
.type	__sqra_384,@function
.align	32
__sqra_384:
.cfi_startproc
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
.cfi_endproc
.size	__sqra_384,.-__sqra_384



.globl	redca_mont_384
.hidden	redca_mont_384
.type	redca_mont_384,@function
.align	32
redca_mont_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


redc_mont_384$4:
	leaq	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8


	movq	%rcx,%r8
	movq	%rdx,%rcx
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384

	leaq	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	redca_mont_384,.-redca_mont_384




.globl	froma_mont_384
.hidden	froma_mont_384
.type	froma_mont_384,@function
.align	32
froma_mont_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


from_mont_384$4:
	leaq	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8


	movq	%rcx,%r8
	movq	%rdx,%rcx
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384




	subq	0(%rcx),%r22,%r16
	sbbq	8(%rcx),%r23,%r17
	sbbq	16(%rcx),%r24,%r18
	sbbq	24(%rcx),%r25,%r19
	sbbq	32(%rcx),%r26,%r20
	sbbq	40(%rcx),%r27,%rsi

	cmovncq	%r16,%r22
	cmovncq	%r17,%r23
	cmovncq	%r18,%r24
	movq	%r22,0(%rdi)
	cmovncq	%r19,%r25
	movq	%r23,8(%rdi)
	cmovncq	%r20,%r26
	movq	%r24,16(%rdi)
	cmovncq	%rsi,%r27
	movq	%r25,24(%rdi)
	movq	%r26,32(%rdi)
	movq	%r27,40(%rdi)

	leaq	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	froma_mont_384,.-froma_mont_384
.type	__mula_by_1_mont_384,@function
.align	32
__mula_by_1_mont_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%rsi),%r16
	movq	8(%rsi),%r17
	movq	16(%rsi),%r18
	movq	24(%rsi),%r19
	movq	32(%rsi),%r20
	movq	40(%rsi),%r21
{nf}	imulq	%r16, %r8, %rdx


	xorq	%r22,%r22
	mulxq	0(%rcx),%rax,%r11
	adcxq	%rax,%r16
	adoxq	%r11,%r17

	mulxq	8(%rcx),%rax,%r11
	adcxq	%rax,%r17
	adoxq	%r11,%r18

	mulxq	16(%rcx),%rax,%r11
	adcxq	%rax,%r18
	adoxq	%r11,%r19

	mulxq	24(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	32(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	40(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r22,%r11
	adcxq	%r11,%r22
{nf}	imulq	%r17, %r8, %rdx


	xorq	%r23,%r23
	mulxq	0(%rcx),%rax,%r11
	adcxq	%rax,%r17
	adoxq	%r11,%r18

	mulxq	8(%rcx),%rax,%r11
	adcxq	%rax,%r18
	adoxq	%r11,%r19

	mulxq	16(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	24(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	32(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	40(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r23,%r11
	adcxq	%r11,%r23
{nf}	imulq	%r18, %r8, %rdx


	xorq	%r24,%r24
	mulxq	0(%rcx),%rax,%r11
	adcxq	%rax,%r18
	adoxq	%r11,%r19

	mulxq	8(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	16(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	24(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	32(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	40(%rcx),%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r24,%r11
	adcxq	%r11,%r24
{nf}	imulq	%r19, %r8, %rdx


	xorq	%r25,%r25
	mulxq	0(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	8(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	16(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	24(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	32(%rcx),%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r11,%r24

	mulxq	40(%rcx),%rax,%r11
	adcxq	%rax,%r24
	adoxq	%r25,%r11
	adcxq	%r11,%r25
{nf}	imulq	%r20, %r8, %rdx


	xorq	%r26,%r26
	mulxq	0(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	8(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	16(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	24(%rcx),%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r11,%r24

	mulxq	32(%rcx),%rax,%r11
	adcxq	%rax,%r24
	adoxq	%r11,%r25

	mulxq	40(%rcx),%rax,%r11
	adcxq	%rax,%r25
	adoxq	%r26,%r11
	adcxq	%r11,%r26
{nf}	imulq	%r21, %r8, %rdx


	xorq	%r27,%r27
	mulxq	0(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	8(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	16(%rcx),%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r11,%r24

	mulxq	24(%rcx),%rax,%r11
	adcxq	%rax,%r24
	adoxq	%r11,%r25

	mulxq	32(%rcx),%rax,%r11
	adcxq	%rax,%r25
	adoxq	%r11,%r26

	mulxq	40(%rcx),%rax,%r11
	adcxq	%rax,%r26
	adoxq	%r27,%r11
	adcxq	%r11,%r27
	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc
.size	__mula_by_1_mont_384,.-__mula_by_1_mont_384

.type	__reda_tail_mont_384,@function
.align	32
__reda_tail_mont_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa

	addq	48(%rsi),%r22
	adcq	56(%rsi),%r23
	adcq	64(%rsi),%r24
	adcq	72(%rsi),%r25
	adcq	80(%rsi),%r26
	adcq	88(%rsi),%r27
	sbbq	%r16,%r16




	subq	0(%rcx),%r22,%r17
	sbbq	8(%rcx),%r23,%r18
	sbbq	16(%rcx),%r24,%r19
	sbbq	24(%rcx),%r25,%r20
	sbbq	32(%rcx),%r26,%r21
	sbbq	40(%rcx),%r27,%rsi
	sbbq	$0,%r16

	cmovncq	%r17,%r22
	cmovncq	%r18,%r23
	cmovncq	%r19,%r24
	movq	%r22,0(%rdi)
	cmovncq	%r20,%r25
	movq	%r23,8(%rdi)
	cmovncq	%r21,%r26
	movq	%r24,16(%rdi)
	cmovncq	%rsi,%r27
	movq	%r25,24(%rdi)
	movq	%r26,32(%rdi)
	movq	%r27,40(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc
.size	__reda_tail_mont_384,.-__reda_tail_mont_384

.globl	sgn0a_pty_mont_384
.hidden	sgn0a_pty_mont_384
.type	sgn0a_pty_mont_384,@function
.align	32
sgn0a_pty_mont_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


sgn0_pty_mont_384$4:
	leaq	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8


	movq	%rdx,%r8
	movq	%rsi,%rcx
	leaq	0(%rdi),%rsi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384

	xorq	%rax,%rax
	movq	%r22,%r17
	addq	%r22,%r22
	adcq	%r23,%r23
	adcq	%r24,%r24
	adcq	%r25,%r25
	adcq	%r26,%r26
	adcq	%r27,%r27
	adcq	$0,%rax

	subq	0(%rcx),%r22
	sbbq	8(%rcx),%r23
	sbbq	16(%rcx),%r24
	sbbq	24(%rcx),%r25
	sbbq	32(%rcx),%r26
	sbbq	40(%rcx),%r27
	sbbq	$0,%rax

	notq	%rax
	andq	$1,%r17
	andq	$2,%rax
	orq	%r17,%rax

	leaq	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	sgn0a_pty_mont_384,.-sgn0a_pty_mont_384

.globl	sgn0a_pty_mont_384x
.hidden	sgn0a_pty_mont_384x
.type	sgn0a_pty_mont_384x,@function
.align	32
sgn0a_pty_mont_384x:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


sgn0_pty_mont_384x$4:
	leaq	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8


	movq	%rdx,%r8
	movq	%rsi,%rcx
	leaq	48(%rdi),%rsi
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384

	movq	%r22,%r16
	orq	%r23,%r22
	orq	%r24,%r22
	orq	%r25,%r22
	orq	%r26,%r22
	orq	%r27,%r22

	leaq	0(%rdi),%rsi
	xorq	%rdi,%rdi
	movq	%r16,%r17
	addq	%r16,%r16
	adcq	%r23,%r23
	adcq	%r24,%r24
	adcq	%r25,%r25
	adcq	%r26,%r26
	adcq	%r27,%r27
	adcq	$0,%rdi

	subq	0(%rcx),%r16
	sbbq	8(%rcx),%r23
	sbbq	16(%rcx),%r24
	sbbq	24(%rcx),%r25
	sbbq	32(%rcx),%r26
	sbbq	40(%rcx),%r27
	sbbq	$0,%rdi

	movq	%r22,0(%rsp)
	notq	%rdi
	andq	$1,%r17
	andq	$2,%rdi
	orq	%r17,%rdi

	call	__mula_by_1_mont_384

	movq	%r22,%r16
	orq	%r23,%r22
	orq	%r24,%r22
	orq	%r25,%r22
	orq	%r26,%r22
	orq	%r27,%r22

	xorq	%rax,%rax
	movq	%r16,%r17
	addq	%r16,%r16
	adcq	%r23,%r23
	adcq	%r24,%r24
	adcq	%r25,%r25
	adcq	%r26,%r26
	adcq	%r27,%r27
	adcq	$0,%rax

	subq	0(%rcx),%r16
	sbbq	8(%rcx),%r23
	sbbq	16(%rcx),%r24
	sbbq	24(%rcx),%r25
	sbbq	32(%rcx),%r26
	sbbq	40(%rcx),%r27
	sbbq	$0,%rax

	movq	0(%rsp),%r16

	notq	%rax

	testq	%r22,%r22
	cmovzq	%rdi,%r17

	testq	%r16,%r16
	cmovnzq	%rdi,%rax

	andq	$1,%r17
	andq	$2,%rax
	orq	%r17,%rax

	leaq	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	sgn0a_pty_mont_384x,.-sgn0a_pty_mont_384x
.globl	mula_mont_384
.hidden	mula_mont_384
.type	mula_mont_384,@function
.align	32
mula_mont_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


mul_mont_384$4:
	leaq	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8


	movq	%rdx,%r10
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rdx),%rdx
	movq	0(%rsi),%r22
	movq	8(%rsi),%r23
	movq	16(%rsi),%r24
	movq	24(%rsi),%r25
	movq	32(%rsi),%r26
	movq	40(%rsi),%r27
	leaq	-128(%rsi),%rsi
	leaq	-128(%rcx),%rcx

	mulxq	%r22,%r16,%r17
	call	__mula_mont_384

	leaq	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	mula_mont_384,.-mula_mont_384
.type	__mula_mont_384,@function
.align	32
__mula_mont_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


	mulxq	%r23,%r22,%r18
	mulxq	%r24,%r23,%r19
	addq	%r22,%r17
	mulxq	%r25,%r24,%r20
	adcq	%r23,%r18
	mulxq	%r26,%rax,%r21
	adcq	%r24,%r19
	mulxq	%r27,%r11,%r22
	movq	8(%r10),%rdx
	adcq	%rax,%r20
	adcq	%r11,%r21
	adcq	$0,%r22
	xorq	%r23,%r23


	xorq	%r24,%r24
	mulxq	0+128(%rsi),%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	8+128(%rsi),%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	16+128(%rsi),%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	24+128(%rsi),%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	32+128(%rsi),%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	40+128(%rsi),%rax,%r11
	adoxq	%rax,%r22
	adcxq	%r11,%r23
{nf}	 imulq	%r8, %r16, %rdx
	adoxq	%r24,%r23
	adoxq	%r24,%r24


	xorq	%r25,%r25
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r16
	adoxq	%r11,%r17

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r17
	adoxq	%r11,%r18

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r18
	adoxq	%r11,%r19

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	40+128(%rcx),%rax,%r11
	movq	16(%r10),%rdx
	adcxq	%rax,%r21
	adoxq	%r11,%r22
	adcxq	%r16,%r22
	adoxq	%r16,%r23
	adcxq	%r16,%r23
	adoxq	%r16,%r24
	adcxq	%r16,%r24

	xorq	%r25,%r25
	mulxq	0+128(%rsi),%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	8+128(%rsi),%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	16+128(%rsi),%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	24+128(%rsi),%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	32+128(%rsi),%rax,%r11
	adoxq	%rax,%r22
	adcxq	%r11,%r23

	mulxq	40+128(%rsi),%rax,%r11
	adoxq	%rax,%r23
	adcxq	%r11,%r24
{nf}	 imulq	%r8, %r17, %rdx
	adoxq	%r25,%r24
	adoxq	%r25,%r25


	xorq	%r26,%r26
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r17
	adoxq	%r11,%r18

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r18
	adoxq	%r11,%r19

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	40+128(%rcx),%rax,%r11
	movq	24(%r10),%rdx
	adcxq	%rax,%r22
	adoxq	%r11,%r23
	adcxq	%r17,%r23
	adoxq	%r17,%r24
	adcxq	%r17,%r24
	adoxq	%r17,%r25
	adcxq	%r17,%r25

	xorq	%r26,%r26
	mulxq	0+128(%rsi),%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	8+128(%rsi),%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	16+128(%rsi),%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	24+128(%rsi),%rax,%r11
	adoxq	%rax,%r22
	adcxq	%r11,%r23

	mulxq	32+128(%rsi),%rax,%r11
	adoxq	%rax,%r23
	adcxq	%r11,%r24

	mulxq	40+128(%rsi),%rax,%r11
	adoxq	%rax,%r24
	adcxq	%r11,%r25
{nf}	 imulq	%r8, %r18, %rdx
	adoxq	%r26,%r25
	adoxq	%r26,%r26


	xorq	%r27,%r27
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r18
	adoxq	%r11,%r19

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	40+128(%rcx),%rax,%r11
	movq	32(%r10),%rdx
	adcxq	%rax,%r23
	adoxq	%r11,%r24
	adcxq	%r18,%r24
	adoxq	%r18,%r25
	adcxq	%r18,%r25
	adoxq	%r18,%r26
	adcxq	%r18,%r26

	xorq	%r27,%r27
	mulxq	0+128(%rsi),%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	8+128(%rsi),%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	16+128(%rsi),%rax,%r11
	adoxq	%rax,%r22
	adcxq	%r11,%r23

	mulxq	24+128(%rsi),%rax,%r11
	adoxq	%rax,%r23
	adcxq	%r11,%r24

	mulxq	32+128(%rsi),%rax,%r11
	adoxq	%rax,%r24
	adcxq	%r11,%r25

	mulxq	40+128(%rsi),%rax,%r11
	adoxq	%rax,%r25
	adcxq	%r11,%r26
{nf}	 imulq	%r8, %r19, %rdx
	adoxq	%r27,%r26
	adoxq	%r27,%r27


	xorq	%r16,%r16
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r11,%r24

	mulxq	40+128(%rcx),%rax,%r11
	movq	40(%r10),%rdx
	adcxq	%rax,%r24
	adoxq	%r11,%r25
	adcxq	%r19,%r25
	adoxq	%r19,%r26
	adcxq	%r19,%r26
	adoxq	%r19,%r27
	adcxq	%r19,%r27

	xorq	%r16,%r16
	mulxq	0+128(%rsi),%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	8+128(%rsi),%rax,%r11
	adoxq	%rax,%r22
	adcxq	%r11,%r23

	mulxq	16+128(%rsi),%rax,%r11
	adoxq	%rax,%r23
	adcxq	%r11,%r24

	mulxq	24+128(%rsi),%rax,%r11
	adoxq	%rax,%r24
	adcxq	%r11,%r25

	mulxq	32+128(%rsi),%rax,%r11
	adoxq	%rax,%r25
	adcxq	%r11,%r26

	mulxq	40+128(%rsi),%rax,%r11
	adoxq	%rax,%r26
	adcxq	%r11,%r27
{nf}	 imulq	%r8, %r20, %rdx
	adoxq	%r16,%r27
	adoxq	%r16,%r16


	xorq	%r17,%r17
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r11,%r24

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r24
	adoxq	%r11,%r25

	mulxq	40+128(%rcx),%rax,%r11
	movq	%r21,%rdx
	adcxq	%rax,%r25
	adoxq	%r11,%r26
	adcxq	%r20,%r26
	adoxq	%r20,%r27
	adcxq	%r20,%r27
	adoxq	%r20,%r16
	adcxq	%r20,%r16
{nf}	imulq	%r8, %rdx


	xorq	%r17,%r17
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r11,%r24

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r24
	adoxq	%r11,%r25

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r25
	adoxq	%r11,%r26

	mulxq	40+128(%rcx),%rax,%r11
	adcxq	%rax,%r26
	adoxq	%r11,%r27
	adcxq	%r17,%r27
	adoxq	%r17,%r16
	leaq	128(%rcx),%rcx
	adcq	$0,%r16




	subq	0(%rcx),%r22,%rdx
	sbbq	8(%rcx),%r23,%r17
	sbbq	16(%rcx),%r24,%r18
	sbbq	24(%rcx),%r25,%r19
	sbbq	32(%rcx),%r26,%rax
	sbbq	40(%rcx),%r27,%r11
	sbbq	$0,%r16

	cmovcq	%r22,%rdx
	cmovncq	%r17,%r23
	cmovncq	%r18,%r24
	cmovncq	%r19,%r25
	movq	%rdx,0(%rdi)
	cmovncq	%rax,%r26
	movq	%r23,8(%rdi)
	cmovncq	%r11,%r27
	movq	%r24,16(%rdi)
	movq	%r25,24(%rdi)
	movq	%r26,32(%rdi)
	movq	%r27,40(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rsi
	lfence
	jmpq	*%rsi
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	__mula_mont_384,.-__mula_mont_384
.globl	sqra_mont_384
.hidden	sqra_mont_384
.type	sqra_mont_384,@function
.align	32
sqra_mont_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


sqr_mont_384$4:
	leaq	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8


	movq	%rcx,%r8
	leaq	-128(%rdx),%rcx
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%rdx
	movq	8(%rsi),%r23
	movq	16(%rsi),%r24
	movq	24(%rsi),%r25
	movq	32(%rsi),%r26
	movq	40(%rsi),%r27

	leaq	(%rsi),%r10
	leaq	-128(%rsi),%rsi

	mulxq	%rdx,%r16,%r17
	call	__mula_mont_384

	leaq	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	sqra_mont_384,.-sqra_mont_384

.globl	sqra_n_mul_mont_384
.hidden	sqra_n_mul_mont_384
.type	sqra_n_mul_mont_384,@function
.align	32
sqra_n_mul_mont_384:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


sqr_n_mul_mont_384$4:
	leaq	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8


	movq	%rdx,%r28
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%rdx
	movq	8(%rsi),%r23
	movq	16(%rsi),%r24
	movq	%rsi,%r10
	movq	24(%rsi),%r25
	movq	32(%rsi),%r26
	movq	40(%rsi),%r27
	movq	(%r9),%r29

.Loop_sqra_384:
	leaq	-128(%r10),%rsi
	leaq	-128(%rcx),%rcx

	mulxq	%rdx,%r16,%r17
	call	__mula_mont_384

	decl	%r28d
	jnz	.Loop_sqra_384

	movq	%rdx,%r22
	movq	%r29,%rdx
	leaq	-128(%r10),%rsi
	leaq	-128(%rcx),%rcx
	movq	%r9,%r10

	mulxq	%r22,%r16,%r17
	call	__mula_mont_384

	leaq	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	sqra_n_mul_mont_384,.-sqra_n_mul_mont_384

.globl	sqra_n_mul_mont_383
.hidden	sqra_n_mul_mont_383
.type	sqra_n_mul_mont_383,@function
.align	32
sqra_n_mul_mont_383:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


sqr_n_mul_mont_383$4:
	leaq	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8


	movq	%rdx,%r28
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%rdx
	movq	8(%rsi),%r23
	movq	16(%rsi),%r24
	movq	%rsi,%r10
	movq	24(%rsi),%r25
	movq	32(%rsi),%r26
	movq	40(%rsi),%r27
	leaq	-128(%rcx),%rcx
	movq	(%r9),%r29

.Loop_sqra_383:
	leaq	-128(%r10),%rsi

	mulxq	%rdx,%r16,%r17
	call	__mula_mont_383_nonred

	movq	%rdi,%r10
	decl	%r28d
	jnz	.Loop_sqra_383

	movq	%rdx,%r22
	movq	%r29,%rdx
	leaq	-128(%r10),%rsi
	leaq	(%r9),%r10

	mulxq	%r22,%r16,%r17
	call	__mula_mont_384

	leaq	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	sqra_n_mul_mont_383,.-sqra_n_mul_mont_383
.type	__mula_mont_383_nonred,@function
.align	32
__mula_mont_383_nonred:
.cfi_startproc
	.byte	0xf3,0x0f,0x1e,0xfa


	mulxq	%r23,%r22,%r18
	mulxq	%r24,%r23,%r19
	addq	%r22,%r17
	mulxq	%r25,%r24,%r20
	adcq	%r23,%r18
	mulxq	%r26,%rax,%r21
	adcq	%r24,%r19
	mulxq	%r27,%r11,%r22
	movq	8(%r10),%rdx
	adcq	%rax,%r20
	adcq	%r11,%r21
	adcq	$0,%r22
{nf}	imulq	%r8, %r16, %r24


	xorq	%r23,%r23
	mulxq	0+128(%rsi),%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	8+128(%rsi),%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	16+128(%rsi),%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	24+128(%rsi),%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	32+128(%rsi),%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	40+128(%rsi),%rax,%r11
	movq	%r24,%rdx
	adoxq	%rax,%r22
	adcxq	%r23,%r11
	adoxq	%r11,%r23


	xorq	%r24,%r24
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r16
	adoxq	%r11,%r17

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r17
	adoxq	%r11,%r18

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r18
	adoxq	%r11,%r19

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	40+128(%rcx),%rax,%r11
	movq	16(%r10),%rdx
	adcxq	%rax,%r21
	adoxq	%r11,%r22
	adcxq	%r16,%r22
	adoxq	%r16,%r23
	adcxq	%r16,%r23
{nf}	imulq	%r8, %r17, %r25


	xorq	%r24,%r24
	mulxq	0+128(%rsi),%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	8+128(%rsi),%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	16+128(%rsi),%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	24+128(%rsi),%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	32+128(%rsi),%rax,%r11
	adoxq	%rax,%r22
	adcxq	%r11,%r23

	mulxq	40+128(%rsi),%rax,%r11
	movq	%r25,%rdx
	adoxq	%rax,%r23
	adcxq	%r24,%r11
	adoxq	%r11,%r24


	xorq	%r25,%r25
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r17
	adoxq	%r11,%r18

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r18
	adoxq	%r11,%r19

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	40+128(%rcx),%rax,%r11
	movq	24(%r10),%rdx
	adcxq	%rax,%r22
	adoxq	%r11,%r23
	adcxq	%r17,%r23
	adoxq	%r17,%r24
	adcxq	%r17,%r24
{nf}	imulq	%r8, %r18, %r26


	xorq	%r25,%r25
	mulxq	0+128(%rsi),%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	8+128(%rsi),%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	16+128(%rsi),%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	24+128(%rsi),%rax,%r11
	adoxq	%rax,%r22
	adcxq	%r11,%r23

	mulxq	32+128(%rsi),%rax,%r11
	adoxq	%rax,%r23
	adcxq	%r11,%r24

	mulxq	40+128(%rsi),%rax,%r11
	movq	%r26,%rdx
	adoxq	%rax,%r24
	adcxq	%r25,%r11
	adoxq	%r11,%r25


	xorq	%r26,%r26
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r18
	adoxq	%r11,%r19

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	40+128(%rcx),%rax,%r11
	movq	32(%r10),%rdx
	adcxq	%rax,%r23
	adoxq	%r11,%r24
	adcxq	%r18,%r24
	adoxq	%r18,%r25
	adcxq	%r18,%r25
{nf}	imulq	%r8, %r19, %r27


	xorq	%r26,%r26
	mulxq	0+128(%rsi),%rax,%r11
	adoxq	%rax,%r20
	adcxq	%r11,%r21

	mulxq	8+128(%rsi),%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	16+128(%rsi),%rax,%r11
	adoxq	%rax,%r22
	adcxq	%r11,%r23

	mulxq	24+128(%rsi),%rax,%r11
	adoxq	%rax,%r23
	adcxq	%r11,%r24

	mulxq	32+128(%rsi),%rax,%r11
	adoxq	%rax,%r24
	adcxq	%r11,%r25

	mulxq	40+128(%rsi),%rax,%r11
	movq	%r27,%rdx
	adoxq	%rax,%r25
	adcxq	%r26,%r11
	adoxq	%r11,%r26


	xorq	%r27,%r27
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r19
	adoxq	%r11,%r20

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r11,%r24

	mulxq	40+128(%rcx),%rax,%r11
	movq	40(%r10),%rdx
	adcxq	%rax,%r24
	adoxq	%r11,%r25
	adcxq	%r19,%r25
	adoxq	%r19,%r26
	adcxq	%r19,%r26
{nf}	imulq	%r8, %r20, %r16


	xorq	%r27,%r27
	mulxq	0+128(%rsi),%rax,%r11
	adoxq	%rax,%r21
	adcxq	%r11,%r22

	mulxq	8+128(%rsi),%rax,%r11
	adoxq	%rax,%r22
	adcxq	%r11,%r23

	mulxq	16+128(%rsi),%rax,%r11
	adoxq	%rax,%r23
	adcxq	%r11,%r24

	mulxq	24+128(%rsi),%rax,%r11
	adoxq	%rax,%r24
	adcxq	%r11,%r25

	mulxq	32+128(%rsi),%rax,%r11
	adoxq	%rax,%r25
	adcxq	%r11,%r26

	mulxq	40+128(%rsi),%rax,%r11
	movq	%r16,%rdx
	adoxq	%rax,%r26
	adcxq	%r27,%r11
	adoxq	%r11,%r27


	xorq	%r16,%r16
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r20
	adoxq	%r11,%r21

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r11,%r24

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r24
	adoxq	%r11,%r25

	mulxq	40+128(%rcx),%rax,%r11
	movq	%r21,%rdx
	adcxq	%rax,%r25
	adoxq	%r11,%r26
	adcxq	%r20,%r26
	adoxq	%r20,%r27
	adcxq	%r20,%r27
{nf}	imulq	%r8, %rdx


	xorq	%r17,%r17
	mulxq	0+128(%rcx),%rax,%r11
	adcxq	%rax,%r21
	adoxq	%r11,%r22

	mulxq	8+128(%rcx),%rax,%r11
	adcxq	%rax,%r22
	adoxq	%r11,%r23

	mulxq	16+128(%rcx),%rax,%r11
	adcxq	%rax,%r23
	adoxq	%r11,%r24

	mulxq	24+128(%rcx),%rax,%r11
	adcxq	%rax,%r24
	adoxq	%r11,%r25

	mulxq	32+128(%rcx),%rax,%r11
	adcxq	%rax,%r25
	adoxq	%r11,%r26

	mulxq	40+128(%rcx),%rax,%r11
	adcxq	%rax,%r26
	adoxq	%r11,%r27
	adcq	$0,%r27

	movq	%r22,0(%rdi)
	movq	%r22,%rdx
	movq	%r23,8(%rdi)
	movq	%r24,16(%rdi)
	movq	%r25,24(%rdi)
	movq	%r26,32(%rdi)
	movq	%r27,40(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rsi
	lfence
	jmpq	*%rsi
	ud2
#else
	.byte	0xf3,0xc3
#endif
.cfi_endproc	
.size	__mula_mont_383_nonred,.-__mula_mont_383_nonred

.section	.note.GNU-stack,"",@progbits
#ifndef	__SGX_LVI_HARDENING__
.section	.note.gnu.property,"a",@note
	.long	4,2f-1f,5
	.byte	0x47,0x4E,0x55,0
1:	.long	0xc0000002,4,3
.align	8
2:
#endif
