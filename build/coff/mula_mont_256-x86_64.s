.text	

.globl	mula_mont_sparse_256

.def	mula_mont_sparse_256;	.scl 2;	.type 32;	.endef
.p2align	5
mula_mont_sparse_256:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_mula_mont_sparse_256:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
	movq	40(%rsp),%r8
mul_mont_sparse_256$4:
	subq	$8,%rsp

.LSEH_body_mula_mont_sparse_256:


	movq	%rdx,%r10
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rdx),%rdx
	movq	0(%rsi),%r22
	movq	8(%rsi),%r23
	movq	16(%rsi),%r24
	movq	24(%rsi),%r25

	mulxq	%r22,%r16,%r20
	call	__mula_mont_sparse_256

	leaq	8(%rsp),%rsp

.LSEH_epilogue_mula_mont_sparse_256:
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

.LSEH_end_mula_mont_sparse_256:

.globl	sqra_mont_sparse_256

.def	sqra_mont_sparse_256;	.scl 2;	.type 32;	.endef
.p2align	5
sqra_mont_sparse_256:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_sqra_mont_sparse_256:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
sqr_mont_sparse_256$4:
	subq	$8,%rsp

.LSEH_body_sqra_mont_sparse_256:


	movq	%rsi,%r10
	movq	%rcx,%r8
	movq	%rdx,%rcx
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%rdx
	movq	8(%rsi),%r23
	movq	16(%rsi),%r24
	movq	24(%rsi),%r25

	movq	%rdx,%r22
	mulxq	%rdx,%r16,%r20
	call	__mula_mont_sparse_256

	leaq	8(%rsp),%rsp

.LSEH_epilogue_sqra_mont_sparse_256:
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

.LSEH_end_sqra_mont_sparse_256:

.def	__mula_mont_sparse_256;	.scl 3;	.type 32;	.endef
.p2align	5
__mula_mont_sparse_256:
	.byte	0xf3,0x0f,0x1e,0xfa

	mulxq	%r23,%r17,%r21
	mulxq	%r24,%r18,%rax
	addq	%r20,%r17
	mulxq	%r25,%r19,%r20
	movq	8(%r10),%rdx
	adcq	%r21,%r18
	movq	0(%rcx),%r26
	adcq	%rax,%r19
	movq	8(%rcx),%r27
	adcq	$0,%r20
	movq	16(%rcx),%r28
	movq	24(%rcx),%r29
{nf}	imulq	%r8,%r16,%rsi


	xorq	%r21,%r21
	mulxq	%r22,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r23,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r24,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r25,%rax,%r11
	movq	%rsi,%rdx
	adoxq	%rax,%r20
	adcxq	%r21,%r11
	adoxq	%r11,%r21


	xorq	%rsi,%rsi
	mulxq	%r26,%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	%r27,%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	%r28,%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	%r29,%rax,%r19
	movq	8+8(%r10),%rdx
	adcxq	%rax,%r18
	adoxq	%rsi,%r19
	adcxq	%r20,%r19
	adcxq	%rsi,%r21,%r20
{nf}	imulq	%r8,%r16,%rsi


	xorq	%r21,%r21
	mulxq	%r22,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r23,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r24,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r25,%rax,%r11
	movq	%rsi,%rdx
	adoxq	%rax,%r20
	adcxq	%r21,%r11
	adoxq	%r11,%r21


	xorq	%rsi,%rsi
	mulxq	%r26,%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	%r27,%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	%r28,%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	%r29,%rax,%r19
	movq	16+8(%r10),%rdx
	adcxq	%rax,%r18
	adoxq	%rsi,%r19
	adcxq	%r20,%r19
	adcxq	%rsi,%r21,%r20
{nf}	imulq	%r8,%r16,%rsi


	xorq	%r21,%r21
	mulxq	%r22,%rax,%r11
	adoxq	%rax,%r17
	adcxq	%r11,%r18

	mulxq	%r23,%rax,%r11
	adoxq	%rax,%r18
	adcxq	%r11,%r19

	mulxq	%r24,%rax,%r11
	adoxq	%rax,%r19
	adcxq	%r11,%r20

	mulxq	%r25,%rax,%r11
	movq	%rsi,%rdx
	adoxq	%rax,%r20
	adcxq	%r21,%r11
	adoxq	%r11,%r21


	xorq	%rsi,%rsi
	mulxq	%r26,%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	%r27,%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	%r28,%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	%r29,%rax,%r19
{nf}	imulq	%r8,%r16,%rdx
	adcxq	%rax,%r18
	adoxq	%rsi,%r19
	adcxq	%r20,%r19
	adcxq	%rsi,%r21,%r20

	xorq	%r21,%r21
	mulxq	%r26,%rax,%r22
	adcxq	%rax,%r16
	adoxq	%r17,%r22

	mulxq	%r27,%rax,%r23
	adcxq	%rax,%r22
	adoxq	%r18,%r23

	mulxq	%r28,%rax,%r24
	adcxq	%rax,%r23
	adoxq	%r19,%r24

	mulxq	%r29,%rax,%r25
	adcxq	%rax,%r24
	adoxq	%r21,%r25
	adcxq	%r20,%r25
	adcxq	%r21,%r21




	subq	%r26,%r22,%r16
	sbbq	%r27,%r23,%r17
	sbbq	%r28,%r24,%r18
	sbbq	%r29,%r25,%r19
	sbbq	$0,%r21

	cmovncq	%r16,%r22
	cmovncq	%r17,%r23
	cmovncq	%r18,%r24
	movq	%r22,0(%rdi)
	cmovncq	%r19,%r25
	movq	%r23,8(%rdi)
	movq	%r24,16(%rdi)
	movq	%r25,24(%rdi)

	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.globl	froma_mont_256

.def	froma_mont_256;	.scl 2;	.type 32;	.endef
.p2align	5
froma_mont_256:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_froma_mont_256:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
from_mont_256$4:
	subq	$8,%rsp

.LSEH_body_froma_mont_256:


	movq	%rdx,%r10
	call	__mula_by_1_mont_256




	subq	%r26,%r16,%r22
	sbbq	%r27,%r17,%r23
	sbbq	%r28,%r18,%r24
	sbbq	%r29,%r19,%r25

	cmovcq	%r16,%r22
	cmovcq	%r17,%r23
	cmovcq	%r18,%r24
	movq	%r22,0(%rdi)
	cmovcq	%r19,%r25
	movq	%r23,8(%rdi)
	movq	%r24,16(%rdi)
	movq	%r25,24(%rdi)

	leaq	8(%rsp),%rsp

.LSEH_epilogue_froma_mont_256:
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

.LSEH_end_froma_mont_256:

.globl	redca_mont_256

.def	redca_mont_256;	.scl 2;	.type 32;	.endef
.p2align	5
redca_mont_256:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_redca_mont_256:


	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx
redc_mont_256$4:
	subq	$8,%rsp

.LSEH_body_redca_mont_256:


	movq	%rdx,%r10
	call	__mula_by_1_mont_256

	addq	32(%rsi),%r16
	adcq	40(%rsi),%r17
	adcq	48(%rsi),%r18
	adcq	56(%rsi),%r19
	sbbq	%rsi,%rsi




	subq	%r26,%r16,%r22
	sbbq	%r27,%r17,%r23
	sbbq	%r28,%r18,%r24
	sbbq	%r29,%r19,%r25
	sbbq	$0,%rsi

	cmovcq	%r16,%r22
	cmovcq	%r17,%r23
	cmovcq	%r18,%r24
	movq	%r22,0(%rdi)
	cmovcq	%r19,%r25
	movq	%r23,8(%rdi)
	movq	%r24,16(%rdi)
	movq	%r25,24(%rdi)

	leaq	8(%rsp),%rsp

.LSEH_epilogue_redca_mont_256:
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

.LSEH_end_redca_mont_256:

.def	__mula_by_1_mont_256;	.scl 3;	.type 32;	.endef
.p2align	5
__mula_by_1_mont_256:
	.byte	0xf3,0x0f,0x1e,0xfa

#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	movq	0(%rsi),%r16
	movq	0(%r10),%r26
	movq	8(%rsi),%r17
	movq	8(%r10),%r27
	movq	16(%rsi),%r18
	movq	16(%r10),%r28
	movq	24(%rsi),%r19
	movq	24(%r10),%r29
{nf}	imulq	%r16,%rcx,%rdx


	xorq	%r20,%r20
	mulxq	%r26,%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	%r27,%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	%r28,%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	%r29,%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19
	adcxq	%r20,%r19
{nf}	imulq	%r16,%rcx,%rdx


	xorq	%r20,%r20
	mulxq	%r26,%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	%r27,%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	%r28,%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	%r29,%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19
	adcxq	%r20,%r19
{nf}	imulq	%r16,%rcx,%rdx


	xorq	%r20,%r20
	mulxq	%r26,%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	%r27,%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	%r28,%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	%r29,%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19
	adcxq	%r20,%r19
{nf}	imulq	%r16,%rcx,%rdx


	xorq	%r20,%r20
	mulxq	%r26,%rax,%r11
	adcxq	%r16,%rax
	adoxq	%r11,%r17,%r16

	mulxq	%r27,%rax,%r17
	adcxq	%rax,%r16
	adoxq	%r18,%r17

	mulxq	%r28,%rax,%r18
	adcxq	%rax,%r17
	adoxq	%r19,%r18

	mulxq	%r29,%rax,%r19
	adcxq	%rax,%r18
	adoxq	%r20,%r19
	adcxq	%r20,%r19
	
#ifdef	__SGX_LVI_HARDENING__
	popq	%rdx
	lfence
	jmpq	*%rdx
	ud2
#else
	.byte	0xf3,0xc3
#endif

.section	.pdata
.p2align	2
.rva	.LSEH_begin_mula_mont_sparse_256
.rva	.LSEH_body_mula_mont_sparse_256
.rva	.LSEH_info_mula_mont_sparse_256_prologue

.rva	.LSEH_body_mula_mont_sparse_256
.rva	.LSEH_epilogue_mula_mont_sparse_256
.rva	.LSEH_info_mula_mont_sparse_256_body

.rva	.LSEH_epilogue_mula_mont_sparse_256
.rva	.LSEH_end_mula_mont_sparse_256
.rva	.LSEH_info_mula_mont_sparse_256_epilogue

.rva	.LSEH_begin_sqra_mont_sparse_256
.rva	.LSEH_body_sqra_mont_sparse_256
.rva	.LSEH_info_sqra_mont_sparse_256_prologue

.rva	.LSEH_body_sqra_mont_sparse_256
.rva	.LSEH_epilogue_sqra_mont_sparse_256
.rva	.LSEH_info_sqra_mont_sparse_256_body

.rva	.LSEH_epilogue_sqra_mont_sparse_256
.rva	.LSEH_end_sqra_mont_sparse_256
.rva	.LSEH_info_sqra_mont_sparse_256_epilogue

.rva	.LSEH_begin_froma_mont_256
.rva	.LSEH_body_froma_mont_256
.rva	.LSEH_info_froma_mont_256_prologue

.rva	.LSEH_body_froma_mont_256
.rva	.LSEH_epilogue_froma_mont_256
.rva	.LSEH_info_froma_mont_256_body

.rva	.LSEH_epilogue_froma_mont_256
.rva	.LSEH_end_froma_mont_256
.rva	.LSEH_info_froma_mont_256_epilogue

.rva	.LSEH_begin_redca_mont_256
.rva	.LSEH_body_redca_mont_256
.rva	.LSEH_info_redca_mont_256_prologue

.rva	.LSEH_body_redca_mont_256
.rva	.LSEH_epilogue_redca_mont_256
.rva	.LSEH_info_redca_mont_256_body

.rva	.LSEH_epilogue_redca_mont_256
.rva	.LSEH_end_redca_mont_256
.rva	.LSEH_info_redca_mont_256_epilogue

.section	.xdata
.p2align	3
.LSEH_info_mula_mont_sparse_256_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_mula_mont_sparse_256_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_mula_mont_sparse_256_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_sqra_mont_sparse_256_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_sqra_mont_sparse_256_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_sqra_mont_sparse_256_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_froma_mont_256_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_froma_mont_256_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_froma_mont_256_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_redca_mont_256_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0xb3
.byte	0,0
.long	0,0
.LSEH_info_redca_mont_256_body:
.byte	1,0,5,0
.byte	0x00,0x74,0x02,0x00
.byte	0x00,0x64,0x03,0x00
.byte	0x00,0x02
.byte	0x00,0x00,0x00,0x00,0x00,0x00
.byte	0x00,0x00,0x00,0x00
.LSEH_info_redca_mont_256_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

