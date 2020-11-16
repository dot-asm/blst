.text	

.globl	mont_inverse_mod_384

.def	mont_inverse_mod_384;	.scl 2;	.type 32;	.endef
.p2align	5
mont_inverse_mod_384:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_mont_inverse_mod_384:
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

	subq	$536,%rsp

.LSEH_body_mont_inverse_mod_384:


	movq	0(%rsi),%rax
	movq	8(%rsi),%r9
	movq	16(%rsi),%r10
	movq	24(%rsi),%r11
	movq	32(%rsi),%r12
	movq	40(%rsi),%r13

	movq	%rax,%r8
	orq	%r9,%rax
	orq	%r10,%rax
	orq	%r11,%rax
	orq	%r12,%rax
	orq	%r13,%rax
	jz	.Labort

	movq	%rdi,0(%rsp)
	movq	%rdx,8(%rsp)

	leaq	16+255(%rsp),%rsi
	andq	$-256,%rsi
	leaq	128(%rsi),%rcx

	movq	0(%rdx),%r14
	movq	8(%rdx),%r15
	movq	16(%rdx),%rax
	movq	24(%rdx),%rbx
	movq	32(%rdx),%rbp
	movq	40(%rdx),%rdi

	xorq	%rdx,%rdx

	movq	%r8,0(%rsi)
	movq	%r9,8(%rsi)
	movq	%r10,16(%rsi)
	movq	%r11,24(%rsi)
	movq	%r12,32(%rsi)
	movq	%r13,40(%rsi)

	movq	%rdx,48(%rsi)
	movq	%rdx,56(%rsi)
	movq	%rdx,64(%rsi)
	movq	%rdx,72(%rsi)
	movq	%rdx,80(%rsi)
	movq	%rdx,88(%rsi)

	movq	%r14,0(%rcx)
	movq	%r15,8(%rcx)
	movq	%rax,16(%rcx)
	movq	%rbx,24(%rcx)
	movq	%rbp,32(%rcx)
	movq	%rdi,40(%rcx)

	movq	$1,48(%rcx)
	movq	%rdx,56(%rcx)
	movq	%rdx,64(%rcx)
	movq	%rdx,72(%rcx)
	movq	%rdx,80(%rcx)
	movq	%rdx,88(%rcx)



.p2align	5
.Loop_inv_384:


	call	__shift_powers_of_2

	movq	$128,%rcx
	xorq	%rsi,%rcx

	subq	0(%rcx),%r8
	sbbq	8(%rcx),%r9
	sbbq	16(%rcx),%r10
	sbbq	24(%rcx),%r11
	sbbq	32(%rcx),%r12
	sbbq	40(%rcx),%r13
	jae	.Lv_greater_than_u_384

	xchgq	%rcx,%rsi

	notq	%r8
	notq	%r9
	notq	%r10
	notq	%r11
	notq	%r12
	notq	%r13

	addq	$1,%r8
	adcq	$0,%r9
	adcq	$0,%r10
	adcq	$0,%r11
	adcq	$0,%r12
	adcq	$0,%r13

.Lv_greater_than_u_384:
	shrdq	$1,%r9,%r8
	shrdq	$1,%r10,%r9
	shrdq	$1,%r11,%r10
	shrdq	$1,%r12,%r11
	shrdq	$1,%r13,%r12
	movq	48(%rsi),%r14
	shrq	$1,%r13
	movq	56(%rsi),%r15
	movq	64(%rsi),%rax
	movq	72(%rsi),%rbx
	movq	80(%rsi),%rbp
	movq	88(%rsi),%rdi

	movq	%r8,0(%rsi)
	movq	%r9,8(%rsi)
	movq	%r10,16(%rsi)
	movq	%r11,24(%rsi)
	movq	%r12,32(%rsi)
	movq	%r13,40(%rsi)

	orq	40(%rcx),%r13
	jz	.Loop_inv_320_entry

	call	__update_rs

	jmp	.Loop_inv_384

.p2align	5
.Loop_inv_320:


	call	__shift_powers_of_2

	movq	$128,%rcx
	xorq	%rsi,%rcx

	subq	0(%rcx),%r8
	sbbq	8(%rcx),%r9
	sbbq	16(%rcx),%r10
	sbbq	24(%rcx),%r11
	sbbq	32(%rcx),%r12
	jae	.Lv_greater_than_u_320

	xchgq	%rcx,%rsi

	notq	%r8
	notq	%r9
	notq	%r10
	notq	%r11
	notq	%r12

	addq	$1,%r8
	adcq	$0,%r9
	adcq	$0,%r10
	adcq	$0,%r11
	adcq	$0,%r12

.Lv_greater_than_u_320:
	shrdq	$1,%r9,%r8
	shrdq	$1,%r10,%r9
	shrdq	$1,%r11,%r10
	shrdq	$1,%r12,%r11
	movq	48(%rsi),%r14
	shrq	$1,%r12
	movq	56(%rsi),%r15
	movq	64(%rsi),%rax
	movq	72(%rsi),%rbx
	movq	80(%rsi),%rbp
	movq	88(%rsi),%rdi

	movq	%r8,0(%rsi)
	movq	%r9,8(%rsi)
	movq	%r10,16(%rsi)
	movq	%r11,24(%rsi)
	movq	%r12,32(%rsi)

	orq	32(%rcx),%r12
	jz	.Loop_inv_256_entry
.Loop_inv_320_entry:
	call	__update_rs

	jmp	.Loop_inv_320

.p2align	5
.Loop_inv_256:


	call	__shift_powers_of_2

	movq	$128,%rcx
	xorq	%rsi,%rcx

	subq	0(%rcx),%r8
	sbbq	8(%rcx),%r9
	sbbq	16(%rcx),%r10
	sbbq	24(%rcx),%r11
	jae	.Lv_greater_than_u_256

	xchgq	%rcx,%rsi

	notq	%r8
	notq	%r9
	notq	%r10
	notq	%r11

	addq	$1,%r8
	adcq	$0,%r9
	adcq	$0,%r10
	adcq	$0,%r11

.Lv_greater_than_u_256:
	shrdq	$1,%r9,%r8
	shrdq	$1,%r10,%r9
	shrdq	$1,%r11,%r10
	movq	48(%rsi),%r14
	shrq	$1,%r11
	movq	56(%rsi),%r15
	movq	64(%rsi),%rax
	movq	72(%rsi),%rbx
	movq	80(%rsi),%rbp
	movq	88(%rsi),%rdi

	movq	%r8,0(%rsi)
	movq	%r9,8(%rsi)
	movq	%r10,16(%rsi)
	movq	%r11,24(%rsi)

	orq	24(%rcx),%r11
	jz	.Loop_inv_192_entry
.Loop_inv_256_entry:
	call	__update_rs

	jmp	.Loop_inv_256

.p2align	5
.Loop_inv_192:



	movq	0(%rsi),%r8
	movq	8(%rsi),%r9
	movq	16(%rsi),%r10
	testq	$1,%r8
	jnz	.Loop_inv_192_v_is_odd

.Loop_inv_192_make_v_odd:
	bsfq	%r8,%rcx
	movl	$63,%eax
	cmovzl	%eax,%ecx

	movq	88(%rsi),%rdi
	movq	80(%rsi),%rbp
	movq	72(%rsi),%rbx
	movq	64(%rsi),%rax
	movq	56(%rsi),%r15
	movq	48(%rsi),%r14

	addl	%ecx,%edx

	shrdq	%cl,%r9,%r8
	shrdq	%cl,%r10,%r9
	shrq	%cl,%r10

	movq	%r8,0(%rsi)
	movq	%r9,8(%rsi)
	movq	%r10,16(%rsi)

	shldq	%cl,%rbp,%rdi
	shldq	%cl,%rbx,%rbp
	shldq	%cl,%rax,%rbx
	shldq	%cl,%r15,%rax
	shldq	%cl,%r14,%r15
	shlq	%cl,%r14

	movq	$128,%rcx
	movq	%rdi,88(%rsi)
	xorq	%rsi,%rcx
	movq	%rbp,80(%rsi)
	movq	%rbx,72(%rsi)
	movq	%rax,64(%rsi)
	movq	%r15,56(%rsi)
	movq	%r14,48(%rsi)

	testq	$1,%r8
.byte	0x2e
	jz	.Loop_inv_192_make_v_odd

.Loop_inv_192_v_is_odd:

	subq	0(%rcx),%r8
	sbbq	8(%rcx),%r9
	sbbq	16(%rcx),%r10
	jae	.Lv_greater_than_u_192

	xchgq	%rcx,%rsi

	notq	%r8
	notq	%r9
	notq	%r10

	addq	$1,%r8
	adcq	$0,%r9
	adcq	$0,%r10

.Lv_greater_than_u_192:
	shrdq	$1,%r9,%r8
	shrdq	$1,%r10,%r9
	movq	48(%rsi),%r14
	shrq	$1,%r10
	movq	56(%rsi),%r15
	movq	64(%rsi),%rax
	movq	72(%rsi),%rbx
	movq	80(%rsi),%rbp
	movq	88(%rsi),%rdi

	movq	%r8,0(%rsi)
	movq	%r9,8(%rsi)
	movq	%r10,16(%rsi)

	orq	16(%rcx),%r10
	jz	.Loop_inv_128_entry
.Loop_inv_192_entry:
	call	__update_rs

	jmp	.Loop_inv_192

.p2align	5
.Loop_inv_128:



	movq	0(%rsi),%r8
	movq	8(%rsi),%r9
	testq	$1,%r8
	jnz	.Loop_inv_128_v_is_odd

.Loop_inv_128_make_v_odd:
	bsfq	%r8,%rcx
	movl	$63,%eax
	cmovzl	%eax,%ecx

	movq	88(%rsi),%rdi
	movq	80(%rsi),%rbp
	movq	72(%rsi),%rbx
	movq	64(%rsi),%rax
	movq	56(%rsi),%r15
	movq	48(%rsi),%r14

	addl	%ecx,%edx

	shrdq	%cl,%r9,%r8
	shrq	%cl,%r9

	movq	%r8,0(%rsi)
	movq	%r9,8(%rsi)

	shldq	%cl,%rbp,%rdi
	shldq	%cl,%rbx,%rbp
	shldq	%cl,%rax,%rbx
	shldq	%cl,%r15,%rax
	shldq	%cl,%r14,%r15
	shlq	%cl,%r14

	movq	$128,%rcx
	movq	%rdi,88(%rsi)
	xorq	%rsi,%rcx
	movq	%rbp,80(%rsi)
	movq	%rbx,72(%rsi)
	movq	%rax,64(%rsi)
	movq	%r15,56(%rsi)
	movq	%r14,48(%rsi)

	testq	$1,%r8
.byte	0x2e
	jz	.Loop_inv_128_make_v_odd

.Loop_inv_128_v_is_odd:

	movq	0(%rcx),%r14
	movq	8(%rcx),%r15
	subq	%r8,%r14
	sbbq	%r9,%r15

	subq	0(%rcx),%r8
	sbbq	8(%rcx),%r9
	sbbq	%r10,%r10

	cmovcq	%r14,%r8
	cmovcq	%r15,%r9

	andq	$128,%r10
	xorq	%r10,%rsi
	xorq	%r10,%rcx

	shrdq	$1,%r9,%r8
	movq	48(%rsi),%r14
	shrq	$1,%r9
	movq	56(%rsi),%r15
	movq	64(%rsi),%rax
	movq	72(%rsi),%rbx
	movq	80(%rsi),%rbp
	movq	88(%rsi),%rdi

	movq	%r8,0(%rsi)
	movq	%r9,8(%rsi)

.Loop_inv_128_entry:
	call	__update_rs

	movq	0(%rsi),%r8
	orq	8(%rsi),%r8
	jnz	.Loop_inv_128

	movq	8(%rsp),%rcx

	movq	48(%rsi),%r8
	movq	56(%rsi),%r9
	movq	64(%rsi),%r10
	movq	72(%rsi),%r11
	movq	80(%rsi),%r12
	movq	88(%rsi),%r13

	movq	%r8,%r14
	subq	0(%rcx),%r8
	movq	%r9,%r15
	sbbq	8(%rcx),%r9
	movq	%r10,%rax
	sbbq	16(%rcx),%r10
	movq	%r11,%rbx
	sbbq	24(%rcx),%r11
	movq	%r12,%rbp
	sbbq	32(%rcx),%r12
	movq	%r13,%rdi
	sbbq	40(%rcx),%r13

	cmovncq	%r8,%r14
	movq	0(%rcx),%r8
	cmovncq	%r9,%r15
	movq	8(%rcx),%r9
	cmovncq	%r10,%rax
	movq	16(%rcx),%r10
	cmovncq	%r11,%rbx
	movq	24(%rcx),%r11
	cmovncq	%r12,%rbp
	movq	32(%rcx),%r12
	cmovncq	%r13,%rdi
	movq	40(%rcx),%r13

	subq	%r14,%r8
	sbbq	%r15,%r9
	sbbq	%rax,%r10
	sbbq	%rbx,%r11
	sbbq	%rbp,%r12
	sbbq	%rdi,%r13

	movq	0(%rsp),%rdi
	movq	%rdx,%rax
.Labort:
	movq	%r8,0(%rdi)
	movq	%r9,8(%rdi)
	movq	%r10,16(%rdi)
	movq	%r11,24(%rdi)
	movq	%r12,32(%rdi)
	movq	%r13,40(%rdi)

	leaq	536(%rsp),%r8
	movq	0(%r8),%r15

	movq	8(%r8),%r14

	movq	16(%r8),%r13

	movq	24(%r8),%r12

	movq	32(%r8),%rbx

	movq	40(%r8),%rbp

	leaq	48(%r8),%rsp

.LSEH_epilogue_mont_inverse_mod_384:
	mov	8(%rsp),%rdi
	mov	16(%rsp),%rsi

	.byte	0xf3,0xc3

.LSEH_end_mont_inverse_mod_384:

.def	__shift_powers_of_2;	.scl 3;	.type 32;	.endef
.p2align	5
__shift_powers_of_2:
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%rsi),%r8
	movq	8(%rsi),%r9
	movq	16(%rsi),%r10
	movq	24(%rsi),%r11
	movq	32(%rsi),%r12
	movq	40(%rsi),%r13
	testq	$1,%r8
	jnz	.Loop_of_2_done

.Loop_of_2:
	bsfq	%r8,%rcx
	movl	$63,%eax
	cmovzl	%eax,%ecx

	addl	%ecx,%edx

	shrdq	%cl,%r9,%r8
	movq	88(%rsi),%rdi
	shrdq	%cl,%r10,%r9
	movq	80(%rsi),%rbp
	shrdq	%cl,%r11,%r10
	movq	72(%rsi),%rbx
	shrdq	%cl,%r12,%r11
	movq	64(%rsi),%rax
	shrdq	%cl,%r13,%r12
	movq	56(%rsi),%r15
	shrq	%cl,%r13
	movq	48(%rsi),%r14

	movq	%r8,0(%rsi)
	movq	%r9,8(%rsi)
	movq	%r10,16(%rsi)
	movq	%r11,24(%rsi)
	movq	%r12,32(%rsi)
	movq	%r13,40(%rsi)

	shldq	%cl,%rbp,%rdi
	shldq	%cl,%rbx,%rbp
	shldq	%cl,%rax,%rbx
	shldq	%cl,%r15,%rax
	shldq	%cl,%r14,%r15
	shlq	%cl,%r14

	movq	%rdi,88(%rsi)
	movq	%rbp,80(%rsi)
	movq	%rbx,72(%rsi)
	movq	%rax,64(%rsi)
	movq	%r15,56(%rsi)
	movq	%r14,48(%rsi)

	testq	$1,%r8
.byte	0x2e
	jz	.Loop_of_2

.Loop_of_2_done:
	.byte	0xf3,0xc3


.def	__update_rs;	.scl 3;	.type 32;	.endef
.p2align	5
__update_rs:
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	%r14,%r8
	addq	48(%rcx),%r14
	movq	%r15,%r9
	adcq	56(%rcx),%r15
	movq	%rax,%r10
	adcq	64(%rcx),%rax
	movq	%rbx,%r11
	adcq	72(%rcx),%rbx
	movq	%rbp,%r12
	adcq	80(%rcx),%rbp
	movq	%rdi,%r13
	adcq	88(%rcx),%rdi

	movq	%r14,48(%rcx)
	movq	%r15,56(%rcx)
	movq	%rax,64(%rcx)
	movq	%rbx,72(%rcx)
	movq	%rbp,80(%rcx)

	addq	%r8,%r8
	movq	%rdi,88(%rcx)
	adcq	%r9,%r9
	movq	%r8,48(%rsi)
	adcq	%r10,%r10
	movq	%r9,56(%rsi)
	adcq	%r11,%r11
	movq	%r10,64(%rsi)
	adcq	%r12,%r12
	movq	%r11,72(%rsi)
	adcq	%r13,%r13
	movq	%r12,80(%rsi)
	leaq	1(%rdx),%rdx
	movq	%r13,88(%rsi)

	.byte	0xf3,0xc3

.section	.pdata
.p2align	2
.rva	.LSEH_begin_mont_inverse_mod_384
.rva	.LSEH_body_mont_inverse_mod_384
.rva	.LSEH_info_mont_inverse_mod_384_prologue

.rva	.LSEH_body_mont_inverse_mod_384
.rva	.LSEH_epilogue_mont_inverse_mod_384
.rva	.LSEH_info_mont_inverse_mod_384_body

.rva	.LSEH_epilogue_mont_inverse_mod_384
.rva	.LSEH_end_mont_inverse_mod_384
.rva	.LSEH_info_mont_inverse_mod_384_epilogue

.section	.xdata
.p2align	3
.LSEH_info_mont_inverse_mod_384_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0x03
.byte	0,0
.LSEH_info_mont_inverse_mod_384_body:
.byte	1,0,18,0
.byte	0x00,0xf4,0x43,0x00
.byte	0x00,0xe4,0x44,0x00
.byte	0x00,0xd4,0x45,0x00
.byte	0x00,0xc4,0x46,0x00
.byte	0x00,0x34,0x47,0x00
.byte	0x00,0x54,0x48,0x00
.byte	0x00,0x74,0x4a,0x00
.byte	0x00,0x64,0x4b,0x00
.byte	0x00,0x01,0x49,0x00
.LSEH_info_mont_inverse_mod_384_epilogue:
.byte	1,0,4,0
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x00,0x00,0x00

