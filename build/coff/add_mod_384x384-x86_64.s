.text	

.def	__add_mod_384x384;	.scl 3;	.type 32;	.endef
.p2align	5
__add_mod_384x384:
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%rsi),%r8
	movq	8(%rsi),%r9
	movq	16(%rsi),%r10
	movq	24(%rsi),%r11
	movq	32(%rsi),%r12
	movq	40(%rsi),%r13
	movq	48(%rsi),%r14

	addq	0(%rdx),%r8
	movq	56(%rsi),%r15
	adcq	8(%rdx),%r9
	movq	64(%rsi),%rax
	adcq	16(%rdx),%r10
	movq	72(%rsi),%rbx
	adcq	24(%rdx),%r11
	movq	80(%rsi),%rbp
	adcq	32(%rdx),%r12
	movq	88(%rsi),%rsi
	adcq	40(%rdx),%r13
	movq	%r8,0(%rdi)
	adcq	48(%rdx),%r14
	movq	%r9,8(%rdi)
	adcq	56(%rdx),%r15
	movq	%r10,16(%rdi)
	adcq	64(%rdx),%rax
	movq	%r12,32(%rdi)
	movq	%r14,%r8
	adcq	72(%rdx),%rbx
	movq	%r11,24(%rdi)
	movq	%r15,%r9
	adcq	80(%rdx),%rbp
	movq	%r13,40(%rdi)
	movq	%rax,%r10
	adcq	88(%rdx),%rsi
	movq	%rbx,%r11
	sbbq	%rdx,%rdx

	subq	0(%rcx),%r14
	sbbq	8(%rcx),%r15
	movq	%rbp,%r12
	sbbq	16(%rcx),%rax
	sbbq	24(%rcx),%rbx
	sbbq	32(%rcx),%rbp
	movq	%rsi,%r13
	sbbq	40(%rcx),%rsi
	sbbq	$0,%rdx

	cmovcq	%r8,%r14
	cmovcq	%r9,%r15
	cmovcq	%r10,%rax
	movq	%r14,48(%rdi)
	cmovcq	%r11,%rbx
	movq	%r15,56(%rdi)
	cmovcq	%r12,%rbp
	movq	%rax,64(%rdi)
	cmovcq	%r13,%rsi
	movq	%rbx,72(%rdi)
	movq	%rbp,80(%rdi)
	movq	%rsi,88(%rdi)

	.byte	0xf3,0xc3


.def	__sub_mod_384x384;	.scl 3;	.type 32;	.endef
.p2align	5
__sub_mod_384x384:
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%rsi),%r8
	movq	8(%rsi),%r9
	movq	16(%rsi),%r10
	movq	24(%rsi),%r11
	movq	32(%rsi),%r12
	movq	40(%rsi),%r13
	movq	48(%rsi),%r14

	subq	0(%rdx),%r8
	movq	56(%rsi),%r15
	sbbq	8(%rdx),%r9
	movq	64(%rsi),%rax
	sbbq	16(%rdx),%r10
	movq	72(%rsi),%rbx
	sbbq	24(%rdx),%r11
	movq	80(%rsi),%rbp
	sbbq	32(%rdx),%r12
	movq	88(%rsi),%rsi
	sbbq	40(%rdx),%r13
	movq	%r8,0(%rdi)
	sbbq	48(%rdx),%r14
	movq	0(%rcx),%r8
	movq	%r9,8(%rdi)
	sbbq	56(%rdx),%r15
	movq	8(%rcx),%r9
	movq	%r10,16(%rdi)
	sbbq	64(%rdx),%rax
	movq	16(%rcx),%r10
	movq	%r11,24(%rdi)
	sbbq	72(%rdx),%rbx
	movq	24(%rcx),%r11
	movq	%r12,32(%rdi)
	sbbq	80(%rdx),%rbp
	movq	32(%rcx),%r12
	movq	%r13,40(%rdi)
	sbbq	88(%rdx),%rsi
	movq	40(%rcx),%r13
	sbbq	%rdx,%rdx

	andq	%rdx,%r8
	andq	%rdx,%r9
	andq	%rdx,%r10
	andq	%rdx,%r11
	andq	%rdx,%r12
	andq	%rdx,%r13

	addq	%r8,%r14
	adcq	%r9,%r15
	movq	%r14,48(%rdi)
	adcq	%r10,%rax
	movq	%r15,56(%rdi)
	adcq	%r11,%rbx
	movq	%rax,64(%rdi)
	adcq	%r12,%rbp
	movq	%rbx,72(%rdi)
	adcq	%r13,%rsi
	movq	%rbp,80(%rdi)
	movq	%rsi,88(%rdi)

	.byte	0xf3,0xc3


.globl	add_mod_384x384

.def	add_mod_384x384;	.scl 2;	.type 32;	.endef
.p2align	5
add_mod_384x384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_add_mod_384x384:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx


	pushq	%rbp

	pushq	%rbx

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

	subq	$8,%rsp

.LSEH_body_add_mod_384x384:


	call	__add_mod_384x384

	movq	8(%rsp),%r15

	movq	16(%rsp),%r14

	movq	24(%rsp),%r13

	movq	32(%rsp),%r12

	movq	40(%rsp),%rbx

	movq	48(%rsp),%rbp

	leaq	56(%rsp),%rsp

.LSEH_epilogue_add_mod_384x384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	.byte	0xf3,0xc3

.LSEH_end_add_mod_384x384:

.globl	sub_mod_384x384

.def	sub_mod_384x384;	.scl 2;	.type 32;	.endef
.p2align	5
sub_mod_384x384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_sub_mod_384x384:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx


	pushq	%rbp

	pushq	%rbx

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

	subq	$8,%rsp

.LSEH_body_sub_mod_384x384:


	call	__sub_mod_384x384

	movq	8(%rsp),%r15

	movq	16(%rsp),%r14

	movq	24(%rsp),%r13

	movq	32(%rsp),%r12

	movq	40(%rsp),%rbx

	movq	48(%rsp),%rbp

	leaq	56(%rsp),%rsp

.LSEH_epilogue_sub_mod_384x384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	.byte	0xf3,0xc3

.LSEH_end_sub_mod_384x384:
.def	__lshift_mod_384x384;	.scl 3;	.type 32;	.endef
.p2align	5
__lshift_mod_384x384:
	.byte	0xf3,0x0f,0x1e,0xfa

	addq	%r8,%r8
	adcq	%r9,%r9
	adcq	%r10,%r10
	adcq	%r11,%r11
	adcq	%r12,%r12
.byte	102,73,15,110,192
	adcq	%r13,%r13
.byte	102,73,15,110,201
	adcq	%r14,%r14
.byte	102,73,15,110,210
	adcq	%r15,%r15
.byte	102,73,15,110,219
	adcq	%rax,%rax
.byte	102,73,15,110,228
	movq	%r14,%r8
	adcq	%rbx,%rbx
.byte	102,73,15,110,237
	movq	%r15,%r9
	adcq	%rcx,%rcx
	adcq	%rbp,%rbp
	movq	%rax,%r10
	sbbq	%rdi,%rdi

	subq	0(%rdx),%r14
	movq	%rbx,%r11
	sbbq	8(%rdx),%r15
	sbbq	16(%rdx),%rax
	movq	%rcx,%r12
	sbbq	24(%rdx),%rbx
	sbbq	32(%rdx),%rcx
	movq	%rbp,%r13
	sbbq	40(%rdx),%rbp
	sbbq	$0,%rdi

	cmovcq	%r8,%r14
.byte	102,73,15,126,192
	cmovcq	%r9,%r15
.byte	102,73,15,126,201
	cmovcq	%r10,%rax
.byte	102,73,15,126,210
	cmovcq	%r11,%rbx
.byte	102,73,15,126,219
	cmovcq	%r12,%rcx
.byte	102,73,15,126,228
	cmovcq	%r13,%rbp
.byte	102,73,15,126,237
	.byte	0xf3,0xc3


.globl	mul_by_5_mod_384x384

.def	mul_by_5_mod_384x384;	.scl 2;	.type 32;	.endef
.p2align	5
mul_by_5_mod_384x384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_mul_by_5_mod_384x384:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx


	pushq	%rbp

	pushq	%rbx

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

	pushq	%rdi

.LSEH_body_mul_by_5_mod_384x384:


	movq	0(%rsi),%r8
	movq	8(%rsi),%r9
	movq	16(%rsi),%r10
	movq	24(%rsi),%r11
	movq	32(%rsi),%r12
	movq	40(%rsi),%r13
	movq	48(%rsi),%r14
	movq	56(%rsi),%r15
	movq	64(%rsi),%rax
	movq	72(%rsi),%rbx
	movq	80(%rsi),%rcx
	movq	88(%rsi),%rbp

	call	__lshift_mod_384x384
	call	__lshift_mod_384x384
	movq	(%rsp),%rdi

	addq	0(%rsi),%r8
	adcq	8(%rsi),%r9
	adcq	16(%rsi),%r10
	adcq	24(%rsi),%r11
	adcq	32(%rsi),%r12
	adcq	40(%rsi),%r13
	movq	%r8,0(%rdi)
	adcq	48(%rsi),%r14
	movq	%r9,8(%rdi)
	adcq	56(%rsi),%r15
	movq	%r10,16(%rdi)
	adcq	64(%rsi),%rax
	movq	%r11,24(%rdi)
	movq	%r14,%r8
	adcq	72(%rsi),%rbx
	movq	%r12,32(%rdi)
	movq	%r15,%r9
	adcq	80(%rsi),%rcx
	movq	%r13,40(%rdi)
	movq	%rax,%r10
	adcq	88(%rsi),%rbp
	sbbq	%rsi,%rsi

	subq	0(%rdx),%r14
	movq	%rbx,%r11
	sbbq	8(%rdx),%r15
	sbbq	16(%rdx),%rax
	movq	%rcx,%r12
	sbbq	24(%rdx),%rbx
	sbbq	32(%rdx),%rcx
	movq	%rbp,%r13
	sbbq	40(%rdx),%rbp
	sbbq	$0,%rsi

	cmovcq	%r8,%r14
	cmovcq	%r9,%r15
	cmovcq	%r10,%rax
	movq	%r14,48(%rdi)
	cmovcq	%r11,%rbx
	movq	%r15,56(%rdi)
	cmovcq	%r12,%rcx
	movq	%rax,64(%rdi)
	cmovcq	%r13,%rbp
	movq	%rbx,72(%rdi)
	movq	%rcx,80(%rdi)
	movq	%rbp,88(%rdi)

	movq	8(%rsp),%r15

	movq	16(%rsp),%r14

	movq	24(%rsp),%r13

	movq	32(%rsp),%r12

	movq	40(%rsp),%rbx

	movq	48(%rsp),%rbp

	leaq	56(%rsp),%rsp

.LSEH_epilogue_mul_by_5_mod_384x384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	.byte	0xf3,0xc3

.LSEH_end_mul_by_5_mod_384x384:

.globl	neg_mod_384x384

.def	neg_mod_384x384;	.scl 2;	.type 32;	.endef
.p2align	5
neg_mod_384x384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_neg_mod_384x384:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx


	pushq	%rbp

	pushq	%rbx

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

	subq	$8,%rsp

.LSEH_body_neg_mod_384x384:


	movq	0(%rsi),%rax
	movq	8(%rsi),%rbx
	movq	16(%rsi),%rcx
	movq	24(%rsi),%rbp
	orq	32(%rsi),%rax
	orq	40(%rsi),%rbx
	orq	48(%rsi),%rcx
	orq	56(%rsi),%rbp
	xorq	%r8,%r8
	orq	64(%rsi),%rax
	xorq	%r9,%r9
	orq	72(%rsi),%rbx
	xorq	%r10,%r10
	orq	80(%rsi),%rcx
	xorq	%r11,%r11
	orq	88(%rsi),%rbp
	xorq	%r12,%r12
	orq	%rax,%rbx
	xorq	%r13,%r13
	orq	%rcx,%rbp
	xorq	%r14,%r14
	movq	$-1,%rax
	orq	%rbx,%rbp
	cmovnzq	%rax,%rbp
	cmovnzq	%rax,%r14

	movq	%rbp,%r15
	movq	%rbp,%rax
	movq	%rbp,%rbx
	movq	%rbp,%rcx
	andq	0(%rdx),%r14
	andq	8(%rdx),%r15
	andq	16(%rdx),%rax
	andq	24(%rdx),%rbx
	andq	32(%rdx),%rcx
	andq	40(%rdx),%rbp

	subq	0(%rsi),%r8
	sbbq	8(%rsi),%r9
	sbbq	16(%rsi),%r10
	sbbq	24(%rsi),%r11
	sbbq	32(%rsi),%r12
	sbbq	40(%rsi),%r13
	movq	%r8,0(%rdi)
	sbbq	48(%rsi),%r14
	movq	%r9,8(%rdi)
	sbbq	56(%rsi),%r15
	movq	%r10,16(%rdi)
	sbbq	64(%rsi),%rax
	movq	%r11,24(%rdi)
	sbbq	72(%rsi),%rbx
	movq	%r12,32(%rdi)
	sbbq	80(%rsi),%rcx
	movq	%r13,40(%rdi)
	sbbq	88(%rsi),%rbp
	movq	%r14,48(%rdi)
	movq	%r15,56(%rdi)
	movq	%rax,64(%rdi)
	movq	%rbx,72(%rdi)
	movq	%rcx,80(%rdi)
	movq	%rbp,88(%rdi)

	movq	8(%rsp),%r15

	movq	16(%rsp),%r14

	movq	24(%rsp),%r13

	movq	32(%rsp),%r12

	movq	40(%rsp),%rbx

	movq	48(%rsp),%rbp

	leaq	56(%rsp),%rsp

.LSEH_epilogue_neg_mod_384x384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	.byte	0xf3,0xc3

.LSEH_end_neg_mod_384x384:
.section	.pdata
.p2align	2
.rva	.LSEH_begin_add_mod_384x384
.rva	.LSEH_body_add_mod_384x384
.rva	.LSEH_info_add_mod_384x384_prologue

.rva	.LSEH_body_add_mod_384x384
.rva	.LSEH_epilogue_add_mod_384x384
.rva	.LSEH_info_add_mod_384x384_body

.rva	.LSEH_epilogue_add_mod_384x384
.rva	.LSEH_end_add_mod_384x384
.rva	.LSEH_info_add_mod_384x384_epilogue

.rva	.LSEH_begin_sub_mod_384x384
.rva	.LSEH_body_sub_mod_384x384
.rva	.LSEH_info_sub_mod_384x384_prologue

.rva	.LSEH_body_sub_mod_384x384
.rva	.LSEH_epilogue_sub_mod_384x384
.rva	.LSEH_info_sub_mod_384x384_body

.rva	.LSEH_epilogue_sub_mod_384x384
.rva	.LSEH_end_sub_mod_384x384
.rva	.LSEH_info_sub_mod_384x384_epilogue

.rva	.LSEH_begin_mul_by_5_mod_384x384
.rva	.LSEH_body_mul_by_5_mod_384x384
.rva	.LSEH_info_mul_by_5_mod_384x384_prologue

.rva	.LSEH_body_mul_by_5_mod_384x384
.rva	.LSEH_epilogue_mul_by_5_mod_384x384
.rva	.LSEH_info_mul_by_5_mod_384x384_body

.rva	.LSEH_epilogue_mul_by_5_mod_384x384
.rva	.LSEH_end_mul_by_5_mod_384x384
.rva	.LSEH_info_mul_by_5_mod_384x384_epilogue

.rva	.LSEH_begin_neg_mod_384x384
.rva	.LSEH_body_neg_mod_384x384
.rva	.LSEH_info_neg_mod_384x384_prologue

.rva	.LSEH_body_neg_mod_384x384
.rva	.LSEH_epilogue_neg_mod_384x384
.rva	.LSEH_info_neg_mod_384x384_body

.rva	.LSEH_epilogue_neg_mod_384x384
.rva	.LSEH_end_neg_mod_384x384
.rva	.LSEH_info_neg_mod_384x384_epilogue

.section	.xdata
.p2align	3
.LSEH_info_add_mod_384x384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0x03
.byte	0,0
.LSEH_info_add_mod_384x384_body:
.byte	1,0,17,0
.byte	0x00,0xf4,0x01,0x00
.byte	0x00,0xe4,0x02,0x00
.byte	0x00,0xd4,0x03,0x00
.byte	0x00,0xc4,0x04,0x00
.byte	0x00,0x34,0x05,0x00
.byte	0x00,0x54,0x06,0x00
.byte	0x00,0x74,0x08,0x00
.byte	0x00,0x64,0x09,0x00
.byte	0x00,0x62
.byte	0x00,0x00
.LSEH_info_add_mod_384x384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_sub_mod_384x384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0x03
.byte	0,0
.LSEH_info_sub_mod_384x384_body:
.byte	1,0,17,0
.byte	0x00,0xf4,0x01,0x00
.byte	0x00,0xe4,0x02,0x00
.byte	0x00,0xd4,0x03,0x00
.byte	0x00,0xc4,0x04,0x00
.byte	0x00,0x34,0x05,0x00
.byte	0x00,0x54,0x06,0x00
.byte	0x00,0x74,0x08,0x00
.byte	0x00,0x64,0x09,0x00
.byte	0x00,0x62
.byte	0x00,0x00
.LSEH_info_sub_mod_384x384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_mul_by_5_mod_384x384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0x03
.byte	0,0
.LSEH_info_mul_by_5_mod_384x384_body:
.byte	1,0,17,0
.byte	0x00,0xf4,0x01,0x00
.byte	0x00,0xe4,0x02,0x00
.byte	0x00,0xd4,0x03,0x00
.byte	0x00,0xc4,0x04,0x00
.byte	0x00,0x34,0x05,0x00
.byte	0x00,0x54,0x06,0x00
.byte	0x00,0x74,0x08,0x00
.byte	0x00,0x64,0x09,0x00
.byte	0x00,0x62
.byte	0x00,0x00
.LSEH_info_mul_by_5_mod_384x384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

.LSEH_info_neg_mod_384x384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0x03
.byte	0,0
.LSEH_info_neg_mod_384x384_body:
.byte	1,0,17,0
.byte	0x00,0xf4,0x01,0x00
.byte	0x00,0xe4,0x02,0x00
.byte	0x00,0xd4,0x03,0x00
.byte	0x00,0xc4,0x04,0x00
.byte	0x00,0x34,0x05,0x00
.byte	0x00,0x54,0x06,0x00
.byte	0x00,0x74,0x08,0x00
.byte	0x00,0x64,0x09,0x00
.byte	0x00,0x62
.byte	0x00,0x00
.LSEH_info_neg_mod_384x384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

