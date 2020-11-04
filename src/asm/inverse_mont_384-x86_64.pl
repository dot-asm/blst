#!/usr/bin/env perl
#
# Copyright Supranational LLC
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# The subroutine is "Phase I" algorithm from "The Montgomery Modular
# Inverse - Revisited" by Savaş and Koç, originally by Kaliski, with
# a number of twists utilizing "hidden" properties like modulus being
# odd, one of the terms in u/v pair remainng odd in each iteration,
# "smooth" shortening of the u/v terms...
# Caveat lector! Benchmarking results can be deceptive, as timings vary
# wildly from input to input. This depends both on set bits' relative
# positions in input and modulus, and ability of branch prediction logic
# to adapt for a specific workflow. Right thing to do is to benchmark
# with series of random inputs.
#
# int mont_inverse_mod_384(vec384 ret, const vec384 inp, const vec384 mod);

$flavour = shift;
$output  = shift;
if ($flavour =~ /\./) { $output = $flavour; undef $flavour; }

$win64=0; $win64=1 if ($flavour =~ /[nm]asm|mingw64/ || $output =~ /\.asm$/);

$0 =~ m/(.*[\/\\])[^\/\\]+$/; $dir=$1;
( $xlate="${dir}x86_64-xlate.pl" and -f $xlate ) or
( $xlate="${dir}../../perlasm/x86_64-xlate.pl" and -f $xlate) or
die "can't locate x86_64-xlate.pl";

open STDOUT,"| \"$^X\" \"$xlate\" $flavour \"$output\""
    or die "can't call $xlate: $!";

($r_ptr, $a_ptr, $n_ptr) = ("%rdi","%rsi","%rdx");
@acc=(map("%r$_",(8..15)),"%rax","%rbx","%rbp",$r_ptr);
($vr_ptr, $us_ptr) = ($a_ptr, "%rcx");
$k = $n_ptr;

$frame=8*3+256+2*128;

$code.=<<___;
.text

.globl	mont_inverse_mod_384
.hidden	mont_inverse_mod_384
.type	mont_inverse_mod_384,\@function,4,"unwind"
.align	32
mont_inverse_mod_384:
.cfi_startproc
	push	%rbp
.cfi_push	%rbp
	push	%rbx
.cfi_push	%rbx
	push	%r12
.cfi_push	%r12
	push	%r13
.cfi_push	%r13
	push	%r14
.cfi_push	%r14
	push	%r15
.cfi_push	%r15
	sub	\$$frame, %rsp
.cfi_adjust_cfa_offset	$frame
.cfi_end_prologue

	mov	8*0($a_ptr), %rax	# load |inp|
	mov	8*1($a_ptr), @acc[1]
	mov	8*2($a_ptr), @acc[2]
	mov	8*3($a_ptr), @acc[3]
	mov	8*4($a_ptr), @acc[4]
	mov	8*5($a_ptr), @acc[5]

	mov	%rax, @acc[0]
	or	@acc[1], %rax
	or	@acc[2], %rax
	or	@acc[3], %rax
	or	@acc[4], %rax
	or	@acc[5], %rax
	jz	.Labort			# abort if |inp|==0

	mov	$r_ptr, 8*0(%rsp)
	mov	$n_ptr, 8*1(%rsp)

	lea	8*2+255(%rsp), $vr_ptr	# find closest 256-byte-aligned spot
	and	\$-256, $vr_ptr		# in the frame...
	lea	128($vr_ptr), $us_ptr

	mov	8*0($n_ptr), @acc[6]	# load |mod|
	mov	8*1($n_ptr), @acc[7]
	mov	8*2($n_ptr), @acc[8]
	mov	8*3($n_ptr), @acc[9]
	mov	8*4($n_ptr), @acc[10]
	mov	8*5($n_ptr), @acc[11]

	xor	$k, $k			# k=0

	mov	@acc[0], 8*0($vr_ptr)	# copy |inp| to V
	mov	@acc[1], 8*1($vr_ptr)
	mov	@acc[2], 8*2($vr_ptr)
	mov	@acc[3], 8*3($vr_ptr)
	mov	@acc[4], 8*4($vr_ptr)
	mov	@acc[5], 8*5($vr_ptr)

	mov	$k, 8*6($vr_ptr)	# clear R
	mov	$k, 8*7($vr_ptr)
	mov	$k, 8*8($vr_ptr)
	mov	$k, 8*9($vr_ptr)
	mov	$k, 8*10($vr_ptr)
	mov	$k, 8*11($vr_ptr)

	mov	@acc[6], 8*0($us_ptr)	# copy |mod| to U
	mov	@acc[7], 8*1($us_ptr)
	mov	@acc[8], 8*2($us_ptr)
	mov	@acc[9], 8*3($us_ptr)
	mov	@acc[10], 8*4($us_ptr)
	mov	@acc[11], 8*5($us_ptr)

	movq	\$1, 8*6($us_ptr)	# set S to 1
	mov	$k, 8*7($us_ptr)
	mov	$k, 8*8($us_ptr)
	mov	$k, 8*9($us_ptr)
	mov	$k, 8*10($us_ptr)
	mov	$k, 8*11($us_ptr)

	#jmp	.Loop_inv_384

.align	32
.Loop_inv_384:
	####### *$us_ptr is always odd at this point, no need to check...

	call	__shift_powers_of_2	# $vr_ptr is input argument

	mov	\$128, $us_ptr
	xor	$vr_ptr, $us_ptr	# recover $us_ptr

	sub	8*0($us_ptr), @acc[0]	# V-U
	sbb	8*1($us_ptr), @acc[1]
	sbb	8*2($us_ptr), @acc[2]
	sbb	8*3($us_ptr), @acc[3]
	sbb	8*4($us_ptr), @acc[4]
	sbb	8*5($us_ptr), @acc[5]
	jae	.Lv_greater_than_u_384	# conditional pointers' swap
					# doesn't help [performance
	xchg	$us_ptr, $vr_ptr	# with random inputs]

	not	@acc[0]			# V-U => U-V
	not	@acc[1]
	not	@acc[2]
	not	@acc[3]
	not	@acc[4]
	not	@acc[5]

	add	\$1, @acc[0]
	adc	\$0, @acc[1]
	adc	\$0, @acc[2]
	adc	\$0, @acc[3]
	adc	\$0, @acc[4]
	adc	\$0, @acc[5]

.Lv_greater_than_u_384:
	shrd	\$1, @acc[1], @acc[0]	# (V-U)/2	# [alt. (U-V)/2]
	shrd	\$1, @acc[2], @acc[1]
	shrd	\$1, @acc[3], @acc[2]
	shrd	\$1, @acc[4], @acc[3]
	shrd	\$1, @acc[5], @acc[4]
	 mov	8*6($vr_ptr), @acc[6]	# load R	# [alt. load S]
	shr	\$1, @acc[5]
	 mov	8*7($vr_ptr), @acc[7]
	 mov	8*8($vr_ptr), @acc[8]
	 mov	8*9($vr_ptr), @acc[9]
	 mov	8*10($vr_ptr), @acc[10]
	 mov	8*11($vr_ptr), @acc[11]

	mov	@acc[0], 8*0($vr_ptr)	# save (V-U)/2	# [alt. save (U-V)/2]
	mov	@acc[1], 8*1($vr_ptr)
	mov	@acc[2], 8*2($vr_ptr)
	mov	@acc[3], 8*3($vr_ptr)
	mov	@acc[4], 8*4($vr_ptr)
	mov	@acc[5], 8*5($vr_ptr)

	or	8*5($us_ptr), @acc[5]
	jz	.Loop_inv_320_entry	# most significant limbs are zero

	call	__update_rs

	jmp	.Loop_inv_384		# V!=0?		# [alt. U can't be 0]

.align	32
.Loop_inv_320:
	####### *$us_ptr is always odd at this point, no need to check...

	call	__shift_powers_of_2	# $vr_ptr is input argument

	mov	\$128, $us_ptr
	xor	$vr_ptr, $us_ptr	# recover $us_ptr

	sub	8*0($us_ptr), @acc[0]	# V-U
	sbb	8*1($us_ptr), @acc[1]
	sbb	8*2($us_ptr), @acc[2]
	sbb	8*3($us_ptr), @acc[3]
	sbb	8*4($us_ptr), @acc[4]
	jae	.Lv_greater_than_u_320	# conditional pointers' swap
					# doesn't help [performance
	xchg	$us_ptr, $vr_ptr	# with random inputs]

	not	@acc[0]			# V-U => U-V
	not	@acc[1]
	not	@acc[2]
	not	@acc[3]
	not	@acc[4]

	add	\$1, @acc[0]
	adc	\$0, @acc[1]
	adc	\$0, @acc[2]
	adc	\$0, @acc[3]
	adc	\$0, @acc[4]

.Lv_greater_than_u_320:
	shrd	\$1, @acc[1], @acc[0]	# (V-U)/2	# [alt. (U-V)/2]
	shrd	\$1, @acc[2], @acc[1]
	shrd	\$1, @acc[3], @acc[2]
	shrd	\$1, @acc[4], @acc[3]
	 mov	8*6($vr_ptr), @acc[6]	# load R	# [alt. load S]
	shr	\$1, @acc[4]
	 mov	8*7($vr_ptr), @acc[7]
	 mov	8*8($vr_ptr), @acc[8]
	 mov	8*9($vr_ptr), @acc[9]
	 mov	8*10($vr_ptr), @acc[10]
	 mov	8*11($vr_ptr), @acc[11]

	mov	@acc[0], 8*0($vr_ptr)	# save (V-U)/2	# [alt. save (U-V)/2]
	mov	@acc[1], 8*1($vr_ptr)
	mov	@acc[2], 8*2($vr_ptr)
	mov	@acc[3], 8*3($vr_ptr)
	mov	@acc[4], 8*4($vr_ptr)

	or	8*4($us_ptr), @acc[4]
	jz	.Loop_inv_256_entry	# most significant limbs are zero
.Loop_inv_320_entry:
	call	__update_rs

	jmp	.Loop_inv_320		# V!=0?		# [alt. U can't be 0]

.align	32
.Loop_inv_256:
	####### *$us_ptr is always odd at this point, no need to check...

	call	__shift_powers_of_2	# $vr_ptr is input argument

	mov	\$128, $us_ptr
	xor	$vr_ptr, $us_ptr	# recover $us_ptr

	sub	8*0($us_ptr), @acc[0]	# V-U
	sbb	8*1($us_ptr), @acc[1]
	sbb	8*2($us_ptr), @acc[2]
	sbb	8*3($us_ptr), @acc[3]
	jae	.Lv_greater_than_u_256	# conditional pointers' swap
					# doesn't help [performance
	xchg	$us_ptr, $vr_ptr	# with random inputs]

	not	@acc[0]			# V-U => U-V
	not	@acc[1]
	not	@acc[2]
	not	@acc[3]

	add	\$1, @acc[0]
	adc	\$0, @acc[1]
	adc	\$0, @acc[2]
	adc	\$0, @acc[3]

.Lv_greater_than_u_256:
	shrd	\$1, @acc[1], @acc[0]	# (V-U)/2	# [alt. (U-V)/2]
	shrd	\$1, @acc[2], @acc[1]
	shrd	\$1, @acc[3], @acc[2]
	 mov	8*6($vr_ptr), @acc[6]	# load R	# [alt. load S]
	shr	\$1, @acc[3]
	 mov	8*7($vr_ptr), @acc[7]
	 mov	8*8($vr_ptr), @acc[8]
	 mov	8*9($vr_ptr), @acc[9]
	 mov	8*10($vr_ptr), @acc[10]
	 mov	8*11($vr_ptr), @acc[11]

	mov	@acc[0], 8*0($vr_ptr)	# save (V-U)/2	# [alt. save (U-V)/2]
	mov	@acc[1], 8*1($vr_ptr)
	mov	@acc[2], 8*2($vr_ptr)
	mov	@acc[3], 8*3($vr_ptr)

	or	8*3($us_ptr), @acc[3]
	jz	.Loop_inv_192_entry	# most significant limbs are zero
.Loop_inv_256_entry:
	call	__update_rs

	jmp	.Loop_inv_256		# V!=0?		# [alt. U can't be 0]

.align	32
.Loop_inv_192:
	####### *$us_ptr is always odd at this point, no need to check...

	#call	__shift_powers_of_2	# $vr_ptr is input argument
	mov	8*0($vr_ptr), @acc[0]
	mov	8*1($vr_ptr), @acc[1]
	mov	8*2($vr_ptr), @acc[2]
	test	\$1, @acc[0]
	jnz	.Loop_inv_192_v_is_odd

.Loop_inv_192_make_v_odd:
	bsf	@acc[0], %rcx
	mov	\$63, %eax
	cmovz	%eax, %ecx		# unlikely in real life

	mov	8*11($vr_ptr), @acc[11]
	mov	8*10($vr_ptr), @acc[10]
	mov	8*9($vr_ptr), @acc[9]
	mov	8*8($vr_ptr), @acc[8]
	mov	8*7($vr_ptr), @acc[7]
	mov	8*6($vr_ptr), @acc[6]

	add	%ecx, %edx		# increment k

	shrdq	%cl, @acc[1], @acc[0]
	shrdq	%cl, @acc[2], @acc[1]
	shrq	%cl, @acc[2]

	mov	@acc[0], 8*0($vr_ptr)
	mov	@acc[1], 8*1($vr_ptr)
	mov	@acc[2], 8*2($vr_ptr)

	shldq	%cl, @acc[10], @acc[11]
	shldq	%cl, @acc[9], @acc[10]
	shldq	%cl, @acc[8], @acc[9]
	shldq	%cl, @acc[7], @acc[8]
	shldq	%cl, @acc[6], @acc[7]
	shlq	%cl, @acc[6]

	mov	\$128, $us_ptr
	mov	@acc[11], 8*11($vr_ptr)
	xor	$vr_ptr, $us_ptr	# recover $us_ptr
	mov	@acc[10], 8*10($vr_ptr)
	mov	@acc[9], 8*9($vr_ptr)
	mov	@acc[8], 8*8($vr_ptr)
	mov	@acc[7], 8*7($vr_ptr)
	mov	@acc[6], 8*6($vr_ptr)

	test	\$1, $acc[0]
	.byte	0x2e			# predict non-taken
	jz	.Loop_inv_192_make_v_odd

.Loop_inv_192_v_is_odd:

	sub	8*0($us_ptr), @acc[0]	# V-U
	sbb	8*1($us_ptr), @acc[1]
	sbb	8*2($us_ptr), @acc[2]
	jae	.Lv_greater_than_u_192	# conditional pointers' swap
					# doesn't help [performance
	xchg	$us_ptr, $vr_ptr	# with random inputs]

	not	@acc[0]			# V-U => U-V
	not	@acc[1]
	not	@acc[2]

	add	\$1, @acc[0]
	adc	\$0, @acc[1]
	adc	\$0, @acc[2]

.Lv_greater_than_u_192:
	shrd	\$1, @acc[1], @acc[0]	# (V-U)/2	# [alt. (U-V)/2]
	shrd	\$1, @acc[2], @acc[1]
	 mov	8*6($vr_ptr), @acc[6]	# load R	# [alt. load S]
	shr	\$1, @acc[2]
	 mov	8*7($vr_ptr), @acc[7]
	 mov	8*8($vr_ptr), @acc[8]
	 mov	8*9($vr_ptr), @acc[9]
	 mov	8*10($vr_ptr), @acc[10]
	 mov	8*11($vr_ptr), @acc[11]

	mov	@acc[0], 8*0($vr_ptr)	# save (V-U)/2	# [alt. save (U-V)/2]
	mov	@acc[1], 8*1($vr_ptr)
	mov	@acc[2], 8*2($vr_ptr)

	or	8*2($us_ptr), @acc[2]
	jz	.Loop_inv_128_entry	# most significant limbs are zero
.Loop_inv_192_entry:
	call	__update_rs

	jmp	.Loop_inv_192		# V!=0?		# [alt. U can't be 0]

.align	32
.Loop_inv_128:
	####### *$us_ptr is always odd at this point, no need to check...

	#call	__shift_powers_of_2	# $vr_ptr is input argument
	mov	8*0($vr_ptr), @acc[0]
	mov	8*1($vr_ptr), @acc[1]
	test	\$1, @acc[0]
	jnz	.Loop_inv_128_v_is_odd

.Loop_inv_128_make_v_odd:
	bsf	@acc[0], %rcx
	mov	\$63, %eax
	cmovz	%eax, %ecx		# unlikely in real life

	mov	8*11($vr_ptr), @acc[11]
	mov	8*10($vr_ptr), @acc[10]
	mov	8*9($vr_ptr), @acc[9]
	mov	8*8($vr_ptr), @acc[8]
	mov	8*7($vr_ptr), @acc[7]
	mov	8*6($vr_ptr), @acc[6]

	add	%ecx, %edx		# increment k

	shrdq	%cl, @acc[1], @acc[0]
	shrq	%cl, @acc[1]

	mov	@acc[0], 8*0($vr_ptr)
	mov	@acc[1], 8*1($vr_ptr)

	shldq	%cl, @acc[10], @acc[11]
	shldq	%cl, @acc[9], @acc[10]
	shldq	%cl, @acc[8], @acc[9]
	shldq	%cl, @acc[7], @acc[8]
	shldq	%cl, @acc[6], @acc[7]
	shlq	%cl, @acc[6]

	mov	\$128, $us_ptr
	mov	@acc[11], 8*11($vr_ptr)
	xor	$vr_ptr, $us_ptr	# recover $us_ptr
	mov	@acc[10], 8*10($vr_ptr)
	mov	@acc[9], 8*9($vr_ptr)
	mov	@acc[8], 8*8($vr_ptr)
	mov	@acc[7], 8*7($vr_ptr)
	mov	@acc[6], 8*6($vr_ptr)

	test	\$1, $acc[0]
	.byte	0x2e			# predict non-taken
	jz	.Loop_inv_128_make_v_odd

.Loop_inv_128_v_is_odd:

	mov	8*0($us_ptr), @acc[6]
	mov	8*1($us_ptr), @acc[7]
	sub	@acc[0], @acc[6]
	sbb	@acc[1], @acc[7]

	sub	8*0($us_ptr), @acc[0]	# V-U
	sbb	8*1($us_ptr), @acc[1]
	sbb	@acc[2], @acc[2]	# borrow flag -> mask

	cmovc	@acc[6], @acc[0]	# V-U => U-V
	cmovc	@acc[7], @acc[1]

	and	\$128, @acc[2]
	xor	@acc[2], $vr_ptr	# xchg	$vr_ptr, $us_ptr
	xor	@acc[2], $us_ptr

	shrd	\$1, @acc[1], @acc[0]	# (V-U)/2	# [alt. (U-V)/2]
	 mov	8*6($vr_ptr), @acc[6]	# load R	# [alt. load S]
	shr	\$1, @acc[1]
	 mov	8*7($vr_ptr), @acc[7]
	 mov	8*8($vr_ptr), @acc[8]
	 mov	8*9($vr_ptr), @acc[9]
	 mov	8*10($vr_ptr), @acc[10]
	 mov	8*11($vr_ptr), @acc[11]

	mov	@acc[0], 8*0($vr_ptr)	# save (V-U)/2	# [alt. save (U-V)/2]
	mov	@acc[1], 8*1($vr_ptr)

.Loop_inv_128_entry:
	call	__update_rs

	mov	8*0($vr_ptr), @acc[0]
	or	8*1($vr_ptr), @acc[0]
	jnz	.Loop_inv_128		# V!=0?		# [alt. U can't be 0]

	mov	8*1(%rsp), $us_ptr	# n_ptr

	mov	8*6($vr_ptr), @acc[0]	# return R
	mov	8*7($vr_ptr), @acc[1]
	mov	8*8($vr_ptr), @acc[2]
	mov	8*9($vr_ptr), @acc[3]
	mov	8*10($vr_ptr), @acc[4]
	mov	8*11($vr_ptr), @acc[5]

	mov	@acc[0], @acc[6]	# if (r >= mod) r -= mod
	sub	8*0($us_ptr), @acc[0]
	mov	@acc[1], @acc[7]
	sbb	8*1($us_ptr), @acc[1]
	mov	@acc[2], @acc[8]
	sbb	8*2($us_ptr), @acc[2]
	mov	@acc[3], @acc[9]
	sbb	8*3($us_ptr), @acc[3]
	mov	@acc[4], @acc[10]
	sbb	8*4($us_ptr), @acc[4]
	mov	@acc[5], @acc[11]
	sbb	8*5($us_ptr), @acc[5]

	cmovnc	@acc[0], @acc[6]
	mov	8*0($us_ptr), @acc[0]
	cmovnc	@acc[1], @acc[7]
	mov	8*1($us_ptr), @acc[1]
	cmovnc	@acc[2], @acc[8]
	mov	8*2($us_ptr), @acc[2]
	cmovnc	@acc[3], @acc[9]
	mov	8*3($us_ptr), @acc[3]
	cmovnc	@acc[4], @acc[10]
	mov	8*4($us_ptr), @acc[4]
	cmovnc	@acc[5], @acc[11]
	mov	8*5($us_ptr), @acc[5]

	sub	@acc[6], @acc[0]	# mod - r
	sbb	@acc[7], @acc[1]
	sbb	@acc[8], @acc[2]
	sbb	@acc[9], @acc[3]
	sbb	@acc[10], @acc[4]
	sbb	@acc[11], @acc[5]

	mov	8*0(%rsp), $r_ptr
	mov	$k, %rax		# return value
.Labort:
	mov	@acc[0], 8*0($r_ptr)
	mov	@acc[1], 8*1($r_ptr)
	mov	@acc[2], 8*2($r_ptr)
	mov	@acc[3], 8*3($r_ptr)
	mov	@acc[4], 8*4($r_ptr)
	mov	@acc[5], 8*5($r_ptr)

	lea	$frame(%rsp), %r8	# size optimization
	mov	8*0(%r8),%r15
.cfi_restore	%r15
	mov	8*1(%r8),%r14
.cfi_restore	%r14
	mov	8*2(%r8),%r13
.cfi_restore	%r13
	mov	8*3(%r8),%r12
.cfi_restore	%r12
	mov	8*4(%r8),%rbx
.cfi_restore	%rbx
	mov	8*5(%r8),%rbp
.cfi_restore	%rbp
	lea	8*6(%r8),%rsp
.cfi_adjust_cfa_offset	-$frame-8*6
.cfi_epilogue
	ret
.cfi_endproc
.size	mont_inverse_mod_384,.-mont_inverse_mod_384

.type	__shift_powers_of_2,\@abi-omnipotent
.align	32
__shift_powers_of_2:
	mov	8*0($vr_ptr), @acc[0]
	mov	8*1($vr_ptr), @acc[1]
	mov	8*2($vr_ptr), @acc[2]
	mov	8*3($vr_ptr), @acc[3]
	mov	8*4($vr_ptr), @acc[4]
	mov	8*5($vr_ptr), @acc[5]
	test	\$1, @acc[0]
	jnz	.Loop_of_2_done

.Loop_of_2:
	bsf	@acc[0], %rcx
	mov	\$63, %eax
	cmovz	%eax, %ecx		# unlikely in real life

	add	%ecx, %edx		# increment k

	shrdq	%cl, @acc[1], @acc[0]
	 mov	8*11($vr_ptr), @acc[11]
	shrdq	%cl, @acc[2], @acc[1]
	 mov	8*10($vr_ptr), @acc[10]
	shrdq	%cl, @acc[3], @acc[2]
	 mov	8*9($vr_ptr), @acc[9]
	shrdq	%cl, @acc[4], @acc[3]
	 mov	8*8($vr_ptr), @acc[8]
	shrdq	%cl, @acc[5], @acc[4]
	 mov	8*7($vr_ptr), @acc[7]
	shrq	%cl, @acc[5]
	 mov	8*6($vr_ptr), @acc[6]

	mov	@acc[0], 8*0($vr_ptr)
	mov	@acc[1], 8*1($vr_ptr)
	mov	@acc[2], 8*2($vr_ptr)
	mov	@acc[3], 8*3($vr_ptr)
	mov	@acc[4], 8*4($vr_ptr)
	mov	@acc[5], 8*5($vr_ptr)

	shldq	%cl, @acc[10], @acc[11]
	shldq	%cl, @acc[9], @acc[10]
	shldq	%cl, @acc[8], @acc[9]
	shldq	%cl, @acc[7], @acc[8]
	shldq	%cl, @acc[6], @acc[7]
	shlq	%cl, @acc[6]

	mov	@acc[11], 8*11($vr_ptr)
	mov	@acc[10], 8*10($vr_ptr)
	mov	@acc[9], 8*9($vr_ptr)
	mov	@acc[8], 8*8($vr_ptr)
	mov	@acc[7], 8*7($vr_ptr)
	mov	@acc[6], 8*6($vr_ptr)

	test	\$1, $acc[0]
	.byte	0x2e			# predict non-taken
	jz	.Loop_of_2

.Loop_of_2_done:
	ret
.size	__shift_powers_of_2,.-__shift_powers_of_2

.type	__update_rs,\@abi-omnipotent
.align	32
__update_rs:
	mov	@acc[6], @acc[0]
	add	8*6($us_ptr), @acc[6]	# R+S		# [alt. S+R]
	mov	@acc[7], @acc[1]
	adc	8*7($us_ptr), @acc[7]
	mov	@acc[8], @acc[2]
	adc	8*8($us_ptr), @acc[8]
	mov	@acc[9], @acc[3]
	adc	8*9($us_ptr), @acc[9]
	mov	@acc[10], @acc[4]
	adc	8*10($us_ptr), @acc[10]
	mov	@acc[11], @acc[5]
	adc	8*11($us_ptr), @acc[11]

	mov	@acc[6], 8*6($us_ptr)	# save R+S	# [alt. save S+R]
	mov	@acc[7], 8*7($us_ptr)
	mov	@acc[8], 8*8($us_ptr)
	mov	@acc[9], 8*9($us_ptr)
	mov	@acc[10], 8*10($us_ptr)

	add	@acc[0], @acc[0]	# R<<1		# [alt. S<<1]
	 mov	@acc[11], 8*11($us_ptr)
	adc	@acc[1], @acc[1]
	mov	@acc[0], 8*6($vr_ptr)
	adc	@acc[2], @acc[2]
	mov	@acc[1], 8*7($vr_ptr)
	adc	@acc[3], @acc[3]
	mov	@acc[2], 8*8($vr_ptr)
	adc	@acc[4], @acc[4]
	mov	@acc[3], 8*9($vr_ptr)
	adc	@acc[5], @acc[5]
	mov	@acc[4], 8*10($vr_ptr)
	lea	1($k), $k		# increment k
	mov	@acc[5], 8*11($vr_ptr)

	ret
.size	__update_rs,.-__update_rs
___

print $code;
close STDOUT;
