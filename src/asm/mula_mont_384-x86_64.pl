#!/usr/bin/env perl
#
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

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

$code.=<<___ if ($flavour =~ /masm/);
.globl	mul_mont_384x\$4
.globl	sqr_mont_384x\$4
.globl	mul_382x\$4
.globl	sqr_382x\$4
.globl	mul_384\$4
.globl	sqr_384\$4
.globl	redc_mont_384\$4
.globl	from_mont_384\$4
.globl	sgn0_pty_mont_384\$4
.globl	sgn0_pty_mont_384x\$4
.globl	mul_mont_384\$4
.globl	sqr_mont_384\$4
.globl	sqr_n_mul_mont_384\$4
.globl	sqr_n_mul_mont_383\$4
___

# common argument layout
($r_ptr,$a_ptr,$b_org,$n_ptr,$n0) = ("%rdi","%rsi","%rdx","%rcx","%r8");
$b_ptr = "%r10";

# common accumulator layout
@acc = map("%r$_",(16..27));
@a = (@acc[9..11], map("%r$_",(28..30)));
($lo, $hi) = ("%rax", "%r11");

########################################################################
$code.=<<___;
.text

########################################################################
# Double-width subtraction modulo n<<384, as opposite to naively
# expected modulo n*n. It works because n<<384 is the actual
# input boundary condition for Montgomery reduction, not n*n.
.type	__suba_mod_384x384,\@abi-omnipotent
.align	32
__suba_mod_384x384:
	mov	8*0($a_ptr), @acc[0]
	mov	8*1($a_ptr), @acc[1]
	mov	8*2($a_ptr), @acc[2]
	mov	8*3($a_ptr), @acc[3]
	mov	8*4($a_ptr), @acc[4]
	mov	8*5($a_ptr), @acc[5]
	mov	8*6($a_ptr), @acc[6]

	sub	8*0($b_org), @acc[0]
	mov	8*7($a_ptr), @acc[7]
	sbb	8*1($b_org), @acc[1]
	mov	8*8($a_ptr), @acc[8]
	sbb	8*2($b_org), @acc[2]
	mov	8*9($a_ptr), @acc[9]
	sbb	8*3($b_org), @acc[3]
	mov	8*10($a_ptr), @acc[10]
	sbb	8*4($b_org), @acc[4]
	mov	8*11($a_ptr), @acc[11]
	sbb	8*5($b_org), @acc[5]
	 mov	@acc[0], 8*0($r_ptr)
	sbb	8*6($b_org), @acc[6]
	 mov	@acc[1], 8*1($r_ptr)
	sbb	8*7($b_org), @acc[7]
	 mov	@acc[2], 8*2($r_ptr)
	sbb	8*8($b_org), @acc[8]
	 mov	@acc[3], 8*3($r_ptr)
	sbb	8*9($b_org), @acc[9]
	 mov	@acc[4], 8*4($r_ptr)
	sbb	8*10($b_org), @acc[10]
	 mov	@acc[5], 8*5($r_ptr)
	sbb	8*11($b_org), @acc[11]
	sbb	$lo, $lo

{nf}	and	8*0($n_ptr), $lo, @acc[0]
{nf}	and	8*1($n_ptr), $lo, @acc[1]
{nf}	and	8*2($n_ptr), $lo, @acc[2]
{nf}	and	8*3($n_ptr), $lo, @acc[3]
{nf}	and	8*4($n_ptr), $lo, @acc[4]
{nf}	and	8*5($n_ptr), $lo, @acc[5]

	add	@acc[0], @acc[6]
	adc	@acc[1], @acc[7]
	mov	@acc[6], 8*6($r_ptr)
	adc	@acc[2], @acc[8]
	mov	@acc[7], 8*7($r_ptr)
	adc	@acc[3], @acc[9]
	mov	@acc[8], 8*8($r_ptr)
	adc	@acc[4], @acc[10]
	mov	@acc[9], 8*9($r_ptr)
	adc	@acc[5], @acc[11]
	mov	@acc[10], 8*10($r_ptr)
	mov	@acc[11], 8*11($r_ptr)

	ret
.size	__suba_mod_384x384,.-__suba_mod_384x384

.globl	adda_mod_384
.hidden	adda_mod_384
.type	adda_mod_384,\@function,4,"unwind"
.align	32
adda_mod_384:
.cfi_startproc
	sub	\$8, %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	call	__adda_mod_384

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	adda_mod_384,.-adda_mod_384

.type	__adda_mod_384,\@abi-omnipotent
.align	32
__adda_mod_384:
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($a_ptr), @acc[0]
	mov	8*1($a_ptr), @acc[1]
	mov	8*2($a_ptr), @acc[2]
	mov	8*3($a_ptr), @acc[3]
	mov	8*4($a_ptr), @acc[4]
	mov	8*5($a_ptr), @acc[5]

	add	8*0($b_org), @acc[0]
	adc	8*1($b_org), @acc[1]
	adc	8*2($b_org), @acc[2]
	adc	8*3($b_org), @acc[3]
	adc	8*4($b_org), @acc[4]
	adc	8*5($b_org), @acc[5]
	sbb	$lo, $lo

	sub	8*0($n_ptr), @acc[0], @acc[6]
	sbb	8*1($n_ptr), @acc[1], @acc[7]
	sbb	8*2($n_ptr), @acc[2], @acc[8]
	sbb	8*3($n_ptr), @acc[3], @acc[9]
	sbb	8*4($n_ptr), @acc[4], @acc[10]
	sbb	8*5($n_ptr), @acc[5], @acc[11]
	sbb	\$0, $lo

	cmovnc	@acc[6], @acc[0]
	cmovnc	@acc[7], @acc[1]
	cmovnc	@acc[8], @acc[2]
	mov	@acc[0], 8*0($r_ptr)
	cmovnc	@acc[9], @acc[3]
	mov	@acc[1], 8*1($r_ptr)
	cmovnc	@acc[10], @acc[4]
	mov	@acc[2], 8*2($r_ptr)
	cmovnc	@acc[11], @acc[5]
	mov	@acc[3], 8*3($r_ptr)
	mov	@acc[4], 8*4($r_ptr)
	mov	@acc[5], 8*5($r_ptr)

	ret
.size	__adda_mod_384,.-__adda_mod_384

.globl	suba_mod_384
.hidden	suba_mod_384
.type	suba_mod_384,\@function,4,"unwind"
.align	32
suba_mod_384:
.cfi_startproc
.cfi_adjust_cfa_offset	8
	sub	\$8, %rsp
.cfi_end_prologue

	call	__suba_mod_384

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	suba_mod_384,.-suba_mod_384

.type	__suba_mod_384,\@abi-omnipotent
.align	32
__suba_mod_384:
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($a_ptr), @acc[0]
	mov	8*1($a_ptr), @acc[1]
	mov	8*2($a_ptr), @acc[2]
	mov	8*3($a_ptr), @acc[3]
	mov	8*4($a_ptr), @acc[4]
	mov	8*5($a_ptr), @acc[5]

__suba_mod_384_a_is_loaded:
	sub	8*0($b_org), @acc[0]
	sbb	8*1($b_org), @acc[1]
	sbb	8*2($b_org), @acc[2]
	sbb	8*3($b_org), @acc[3]
	sbb	8*4($b_org), @acc[4]
	sbb	8*5($b_org), @acc[5]
	sbb	$lo, $lo

{nf}	and	8*0($n_ptr), $lo, @acc[6]
{nf}	and	8*1($n_ptr), $lo, @acc[7]
{nf}	and	8*2($n_ptr), $lo, @acc[8]
{nf}	and	8*3($n_ptr), $lo, @acc[9]
{nf}	and	8*4($n_ptr), $lo, @acc[10]
{nf}	and	8*5($n_ptr), $lo, @acc[11]

	add	@acc[6], @acc[0]
	adc	@acc[7], @acc[1]
	mov	@acc[0], 8*0($r_ptr)
	adc	@acc[8], @acc[2]
	mov	@acc[1], 8*1($r_ptr)
	adc	@acc[9], @acc[3]
	mov	@acc[2], 8*2($r_ptr)
	adc	@acc[10], @acc[4]
	mov	@acc[3], 8*3($r_ptr)
	adc	@acc[11], @acc[5]
	mov	@acc[4], 8*4($r_ptr)
	mov	@acc[5], 8*5($r_ptr)

	ret
.size	__suba_mod_384,.-__suba_mod_384
___

########################################################################
# "Complex" multiplication and squaring. Use vanilla multiplication when
# possible to fold reductions. I.e. instead of mul_mont, mul_mont
# followed by add/sub_mod, it calls mul, mul, double-width add/sub_mod
# followed by *common* reduction... For single multiplication disjoint
# reduction is bad for performance for given vector length, yet overall
# it's a win here, because it's one reduction less.
{ my $frame = 3*768/8 +	# place for 3 768-bit temporary vectors
              8;	# align
$code.=<<___;
.globl	mula_mont_384x
.hidden	mula_mont_384x
.type	mula_mont_384x,\@function,5,"unwind"
.align	32
mula_mont_384x:
.cfi_startproc
mul_mont_384x\$4:
	sub	\$$frame, %rsp
.cfi_adjust_cfa_offset	$frame
.cfi_end_prologue

	mov	$b_org, $b_ptr
	mov	$r_ptr, %r31		# put aside the arguments
	mov	$a_ptr, %r9

	################################# mul_384(t0, a->re, b->re);
	#lea	0($b_btr), $b_ptr	# b->re
	#lea	0($a_ptr), $a_ptr	# a->re
	lea	0(%rsp), $r_ptr		# t0
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384

	################################# mul_384(t1, a->im, b->im);
	lea	48($b_ptr), $b_ptr	# b->im
	lea	48($a_ptr), $a_ptr	# a->im
	lea	96($r_ptr), $r_ptr	# t1
	call	__mula_384

	################################# mul_384(t2, a->re+a->im, b->re+b->im);
	lea	($b_ptr), $a_ptr	# b->re
	lea	-48($b_ptr), $b_org	# b->im
	lea	192+48(%rsp), $r_ptr
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__adda_mod_384

	lea	(%r9), $a_ptr		# a->re
	lea	48(%r9), $b_org		# a->im
	lea	-48($r_ptr), $r_ptr
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__adda_mod_384

	lea	($r_ptr),$b_ptr
	lea	48($r_ptr),$a_ptr
	call	__mula_384

	################################# t2=t2-t0-t1
	lea	($r_ptr), $a_ptr	# t2
	lea	0(%rsp), $b_org		# t0
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__suba_mod_384x384	# t2-t0

	lea	($r_ptr), $a_ptr	# t2
	lea	-96($r_ptr), $b_org	# t1
	call	__suba_mod_384x384	# t2-t0-t1

	################################# t0=t0-t1
	lea	0(%rsp), $a_ptr
	lea	96(%rsp), $b_org
	lea	0(%rsp), $r_ptr
	call	__suba_mod_384x384	# t0-t1

	################################# redc_mont_384(ret->re, t0, mod, n0);
	lea	0(%rsp), $a_ptr		# t0
	lea	0(%r31), $r_ptr		# ret->re
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384

	################################# redc_mont_384(ret->im, t2, mod, n0);
	lea	192(%rsp), $a_ptr	# t2
	lea	48($r_ptr), $r_ptr	# ret->im
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384

	lea	$frame(%rsp), %rsp
.cfi_adjust_cfa_offset	-$frame
.cfi_epilogue
	ret
.cfi_endproc
.size	mula_mont_384x,.-mula_mont_384x
___
}
{ my $frame = 2*384/8 +	# place for 2 384-bit temporary vectors
	      8;	# alignment
$code.=<<___;
.globl	sqra_mont_384x
.hidden	sqra_mont_384x
.type	sqra_mont_384x,\@function,4,"unwind"
.align	32
sqra_mont_384x:
.cfi_startproc
sqr_mont_384x\$4:
	sub	\$$frame, %rsp
.cfi_adjust_cfa_offset	$frame
.cfi_end_prologue

	mov	$n_ptr, $n0		# n0
	mov	$b_org, $n_ptr		# n_ptr
	mov	$r_ptr, %r31
	mov	$a_ptr, %r9

	################################# add_mod_384(t0, a->re, a->im);
	lea	48($a_ptr), $b_org	# a->im
	lea	0(%rsp), $r_ptr		# t0
	call	__adda_mod_384

	################################# sub_mod_384(t1, a->re, a->im);
	lea	(%r9), $a_ptr		# a->re
	lea	48(%r9), $b_org		# a->im
	lea	48(%rsp), $r_ptr	# t1
	call	__suba_mod_384

	################################# mul_mont_384(ret->im, a->re, a->im, mod, n0);
	lea	48($a_ptr), $b_ptr	# a->im
	lea	(%r31), $r_ptr
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	48($a_ptr), %rdx
	mov	8*0($a_ptr), @a[0]
	mov	8*1($a_ptr), @a[1]
	mov	8*2($a_ptr), @a[2]
	mov	8*3($a_ptr), @a[3]
	mov	8*4($a_ptr), @a[4]
	mov	8*5($a_ptr), @a[5]
	lea	-128($n_ptr), $n_ptr	# control u-op density

	mulx	@a[0], @acc[0], @acc[4]
	call	__mula_mont_384

	add	%rdx, %rdx		# add with itself
	adc	@a[1], @a[1]
	adc	@a[2], @a[2]
	adc	@a[3], @a[3]
	adc	@a[4], @a[4]
	adc	@a[5], @a[5]
	sbb	$a_ptr, $a_ptr

	sub	8*0($n_ptr), %rdx,  @acc[0]
	sbb	8*1($n_ptr), @a[1], @acc[1]
	sbb	8*2($n_ptr), @a[2], @acc[2]
	sbb	8*3($n_ptr), @a[3], @acc[3]
	sbb	8*4($n_ptr), @a[4], @acc[4]
	sbb	8*5($n_ptr), @a[5], @acc[5]
	sbb	\$0, $a_ptr

	cmovnc	@acc[0], %rdx
	cmovnc	@acc[1], @a[1]
	cmovnc	@acc[2], @a[2]
	mov	%rdx,    8*6($r_ptr)	# ret->im
	cmovnc	@acc[3], @a[3]
	mov	@a[1],   8*7($r_ptr)
	cmovnc	@acc[4], @a[4]
	mov	@a[2],   8*8($r_ptr)
	cmovnc	@acc[5], @a[5]
	mov	@a[3],   8*9($r_ptr)
	mov	@a[4],   8*10($r_ptr)
	mov	@a[5],   8*11($r_ptr)

	################################# mul_mont_384(ret->re, t0, t1, mod, n0);
	mov	48(%rsp), %rdx		# t1[0]
	lea	48(%rsp), $b_ptr	# t1
	mov	8*0(%rsp), @a[0]
	mov	8*1(%rsp), @a[1]
	mov	8*2(%rsp), @a[2]
	mov	8*3(%rsp), @a[3]
	mov	8*4(%rsp), @a[4]
	mov	8*5(%rsp), @a[5]
	lea	-128($n_ptr), $n_ptr	# control u-op density

	mulx	@a[0], @acc[0], @acc[4]
	call	__mula_mont_384

	lea	$frame(%rsp), %rsp	# size optimization
.cfi_adjust_cfa_offset	-$frame
.cfi_epilogue
	ret
.cfi_endproc
.size	sqra_mont_384x,.-sqra_mont_384x

.globl	mula_382x
.hidden	mula_382x
.type	mula_382x,\@function,4,"unwind"
.align	32
mula_382x:
.cfi_startproc
mul_382x\$4:
	sub	\$$frame, %rsp
.cfi_adjust_cfa_offset	$frame
.cfi_end_prologue

	mov	$b_org, %r31
	mov	$a_ptr, %r9
	lea	96($r_ptr), $r_ptr	# ret->im

	################################# t0 = a->re + a->im
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($a_ptr), @acc[0]
	mov	8*1($a_ptr), @acc[1]
	mov	8*2($a_ptr), @acc[2]
	mov	8*3($a_ptr), @acc[3]
	mov	8*4($a_ptr), @acc[4]
	mov	8*5($a_ptr), @acc[5]

	add	8*6($a_ptr), @acc[0]
	adc	8*7($a_ptr), @acc[1]
	adc	8*8($a_ptr), @acc[2]
	adc	8*9($a_ptr), @acc[3]
	adc	8*10($a_ptr), @acc[4]
	adc	8*11($a_ptr), @acc[5]

	mov	@acc[0], 8*0(%rsp)
	mov	@acc[1], 8*1(%rsp)
	mov	@acc[2], 8*2(%rsp)
	mov	@acc[3], 8*3(%rsp)
	mov	@acc[4], 8*4(%rsp)
	mov	@acc[5], 8*5(%rsp)

	################################# t1 = b->re + b->im
	mov	8*0($b_org), @acc[0]
	mov	8*1($b_org), @acc[1]
	mov	8*2($b_org), @acc[2]
	mov	8*3($b_org), @acc[3]
	mov	8*4($b_org), @acc[4]
	mov	8*5($b_org), @acc[5]

	add	8*6($b_org), @acc[0]
	adc	8*7($b_org), @acc[1]
	adc	8*8($b_org), @acc[2]
	adc	8*9($b_org), @acc[3]
	adc	8*10($b_org), @acc[4]
	adc	8*11($b_org), @acc[5]

	mov	@acc[0], 8*6(%rsp)
	mov	@acc[1], 8*7(%rsp)
	mov	@acc[2], 8*8(%rsp)
	mov	@acc[3], 8*9(%rsp)
	mov	@acc[4], 8*10(%rsp)
	mov	@acc[5], 8*11(%rsp)

	################################# mul_384(ret->im, t0, t1);
	lea	8*6(%rsp), $b_ptr	# t1
	lea	8*0(%rsp), $a_ptr	# t0
	call	__mula_384

	################################# mul_384(ret->re, a->re, b->re);
	lea	(%r31), $b_ptr
	lea	(%r9), $a_ptr
	lea	-96($r_ptr), $r_ptr	# ret->re
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384

	################################# mul_384(tx, a->im, b->im);
	lea	48($b_ptr), $b_ptr
	lea	48($a_ptr), $a_ptr
	mov	$r_ptr, %r31
	lea	0(%rsp), $r_ptr
	call	__mula_384

	################################# ret->im -= tx
	lea	96(%r31), $a_ptr	# ret->im
	lea	0(%rsp), $b_org
	lea	96(%r31), $r_ptr
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__suba_mod_384x384

	################################# ret->im -= ret->re
	lea	0($r_ptr), $a_ptr
	lea	-96($r_ptr), $b_org
	call	__suba_mod_384x384

	################################# ret->re -= tx
	lea	-96($r_ptr), $a_ptr
	lea	0(%rsp), $b_org
	lea	-96($r_ptr), $r_ptr
	call	__suba_mod_384x384

	lea	$frame(%rsp), %rsp	# size optimization
.cfi_adjust_cfa_offset	-$frame
.cfi_epilogue
	ret
.cfi_endproc
.size	mula_382x,.-mula_382x
___
}
{
$code.=<<___;
.globl	sqra_382x
.hidden	sqra_382x
.type	sqra_382x,\@function,3,"unwind"
.align	32
sqra_382x:
.cfi_startproc
sqr_382x\$4:
	sub	\$8, %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$b_org, $n_ptr
	mov	$a_ptr, %r9

	################################# t0 = a->re + a->im
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($a_ptr), @acc[0]
	mov	8*1($a_ptr), @acc[1]
	mov	8*2($a_ptr), @acc[2]
	mov	8*3($a_ptr), @acc[3]
	mov	8*4($a_ptr), @acc[4]
	mov	8*5($a_ptr), @acc[5]

	add	8*6($a_ptr), @acc[0], @acc[6]
	adc	8*7($a_ptr), @acc[1], @acc[7]
	adc	8*8($a_ptr), @acc[2], @acc[8]
	adc	8*9($a_ptr), @acc[3], @acc[9]
	adc	8*10($a_ptr), @acc[4], @acc[10]
	adc	8*11($a_ptr), @acc[5], @acc[11]

	mov	@acc[6], 8*0($r_ptr)
	mov	@acc[7], 8*1($r_ptr)
	mov	@acc[8], 8*2($r_ptr)
	mov	@acc[9], 8*3($r_ptr)
	mov	@acc[10], 8*4($r_ptr)
	mov	@acc[11], 8*5($r_ptr)

	################################# t1 = a->re - a->im
	lea	48($a_ptr), $b_org
	lea	48($r_ptr), $r_ptr
	call	__suba_mod_384_a_is_loaded

	################################# mul_384(ret->re, t0, t1);
	lea	($r_ptr), $a_ptr
	lea	-48($r_ptr), $b_ptr
	lea	-48($r_ptr), $r_ptr
	call	__mula_384

	################################# mul_384(ret->im, a->re, a->im);
	lea	(%r9), $a_ptr
	lea	48(%r9), $b_ptr
	lea	96($r_ptr), $r_ptr
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384

	mov	8*0($r_ptr), @acc[0]	# double ret->im
	mov	8*1($r_ptr), @acc[1]
	mov	8*2($r_ptr), @acc[2]
	mov	8*3($r_ptr), @acc[3]
	mov	8*4($r_ptr), @acc[4]
	mov	8*5($r_ptr), @acc[5]
	mov	8*6($r_ptr), @acc[6]
	mov	8*7($r_ptr), @acc[7]
	mov	8*8($r_ptr), @acc[8]
	mov	8*9($r_ptr), @acc[9]
	mov	8*10($r_ptr), @acc[10]
	add	@acc[0], @acc[0]
	mov	8*11($r_ptr), @acc[11]
	adc	@acc[1], @acc[1]
	mov	@acc[0], 8*0($r_ptr)
	adc	@acc[2], @acc[2]
	mov	@acc[1], 8*1($r_ptr)
	adc	@acc[3], @acc[3]
	mov	@acc[2], 8*2($r_ptr)
	adc	@acc[4], @acc[4]
	mov	@acc[3], 8*3($r_ptr)
	adc	@acc[5], @acc[5]
	mov	@acc[4], 8*4($r_ptr)
	adc	@acc[6], @acc[6]
	mov	@acc[5], 8*5($r_ptr)
	adc	@acc[7], @acc[7]
	mov	@acc[6], 8*6($r_ptr)
	adc	@acc[8], @acc[8]
	mov	@acc[7], 8*7($r_ptr)
	adc	@acc[9], @acc[9]
	mov	@acc[8], 8*8($r_ptr)
	adc	@acc[10], @acc[10]
	mov	@acc[9], 8*9($r_ptr)
	adc	@acc[11], @acc[11]
	mov	@acc[10], 8*10($r_ptr)
	mov	@acc[11], 8*11($r_ptr)

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	sqra_382x,.-sqra_382x
___
}
{ ########################################################## 384-bit mulx
my $zr = @acc[7];
my @acc = @acc[0..6];

$code.=<<___;
.globl	mula_384
.hidden	mula_384
.type	mula_384,\@function,3,"unwind"
.align	32
mula_384:
.cfi_startproc
mul_384\$4:
	lea	-8(%rsp),%rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$b_org, $b_ptr		# evacuate from %rdx
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_384

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	mula_384,.-mula_384

.type	__mula_384,\@abi-omnipotent
.align	32
__mula_384:
	mov	8*0($b_ptr), %rdx
	mov	8*0($a_ptr), @a[0]
	mov	8*1($a_ptr), @a[1]
	mov	8*2($a_ptr), @a[2]
	mov	8*3($a_ptr), @a[3]
	mov	8*4($a_ptr), @a[4]
	mov	8*5($a_ptr), @a[5]

	mulx	@a[0], @acc[0], $hi
	xor	$zr, $zr

	mulx	@a[1], @acc[1], $lo
	add	$hi,   @acc[1]
	mov	@acc[0], 8*0($r_ptr)

	mulx	@a[2], @acc[2], $hi
	adc	$lo,   @acc[2]

	mulx	@a[3], @acc[3], $lo
	adc	$hi,   @acc[3]

	mulx	@a[4], @acc[4], $hi
	adc	$lo,   @acc[4]

	mulx	@a[5], @acc[5], @acc[6]
	 mov	8*1($b_ptr), %rdx
	adc	$hi, @acc[5]
	adc	\$0, @acc[6]
___
for(my $i=1; $i<6; $i++) {
my $b_next = $i<5 ? 8*($i+1)."($b_ptr)" : "%rax";
$code.=<<___;
	xor	$zr, $zr			# cf=0, of=0
	mulx	@a[0],   @acc[0], $lo
	adcx	@acc[1], @acc[0]
	adox	$lo,     @acc[2]

	mulx	@a[1],   @acc[1], $hi
	adcx	@acc[2], $acc[1]
	adox	$hi,     @acc[3]
	mov	@acc[0], 8*$i($r_ptr)

	mulx	@a[2],   @acc[2], $lo
	adcx	@acc[3], @acc[2]
	adox	$lo,     @acc[4]

	mulx	@a[3],   @acc[3], $hi
	adcx	@acc[4], @acc[3]
	adox	$hi,     @acc[5]

	mulx	@a[4],   @acc[4], $lo
	adcx	@acc[5], @acc[4]
	adox	$lo,     @acc[6]

	mulx	@a[5],   @acc[5], $hi
	 mov	$b_next, %rdx
	adcx	@acc[6], @acc[5]
	adox	$zr, $hi
	adcx	$zr, $hi, @acc[6]
___
}
$code.=<<___;
	mov	@acc[1], 8*6($r_ptr)
	mov	@acc[2], 8*7($r_ptr)
	mov	@acc[3], 8*8($r_ptr)
	mov	@acc[4], 8*9($r_ptr)
	mov	@acc[5], 8*10($r_ptr)
	mov	@acc[6], 8*11($r_ptr)

	ret
.size	__mula_384,.-__mula_384
___
}
{ ########################################################## 384-bit sqrx
$code.=<<___;
.globl	sqra_384
.hidden	sqra_384
.type	sqra_384,\@function,2,"unwind"
.align	32
sqra_384:
.cfi_startproc
sqr_384\$4:
	lea	-8(%rsp), %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__sqra_384

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	sqra_384,.-sqra_384

.type	__sqra_384,\@abi-omnipotent
.align	32
__sqra_384:
	mov	8*0($a_ptr), %rdx
	mov	8*1($a_ptr), @acc[7]
	mov	8*2($a_ptr), @acc[8]
	mov	8*3($a_ptr), @acc[9]
	mov	8*4($a_ptr), @acc[10]

	#########################################
	mulx	@acc[7], @acc[1], $lo		# a[1]*a[0]
	 mov	8*5($a_ptr), @acc[11]
	mulx	@acc[8], @acc[2], $hi		# a[2]*a[0]
	add	$lo, @acc[2]
	mulx	@acc[9], @acc[3], $lo		# a[3]*a[0]
	adc	$hi, @acc[3]
	mulx	@acc[10], @acc[4], $hi		# a[4]*a[0]
	adc	$lo, @acc[4]
	mulx	@acc[11], @acc[5], @acc[6]	# a[5]*a[0]
	 mov	@acc[7], %rdx
	adc	$hi, @acc[5]
	adc	\$0, @acc[6]

	#########################################
	xor	@acc[7], @acc[7]
	mulx	@acc[8], $lo, $hi		# a[2]*a[1]
	adcx	$lo, @acc[3]
	adox	$hi, @acc[4]

	mulx	@acc[9], $lo, $hi		# a[3]*a[1]
	adcx	$lo, @acc[4]
	adox	$hi, @acc[5]

	mulx	@acc[10], $lo, $hi		# a[4]*a[1]
	adcx	$lo, @acc[5]
	adox	$hi, @acc[6]

	mulx	@acc[11], $lo, $hi		# a[5]*a[1]
	 mov	@acc[8], %rdx
	adcx	$lo, @acc[6]
	adox	@acc[7], $hi
	adcx	$hi, @acc[7]

	#########################################
	xor	@acc[8], @acc[8]
	mulx	@acc[9], $lo, $hi		# a[3]*a[2]
	adcx	$lo, @acc[5]
	adox	$hi, @acc[6]

	mulx	@acc[10], $lo, $hi		# a[4]*a[2]
	adcx	$lo, @acc[6]
	adox	$hi, @acc[7]

	mulx	@acc[11], $lo, $hi		# a[5]*a[2]
	 mov	@acc[9], %rdx
	adcx	$lo, @acc[7]
	adox	@acc[8], $hi
	adcx	$hi, @acc[8]

	#########################################
	xor	@acc[9], @acc[9]
	mulx	@acc[10], $lo, $hi		# a[4]*a[3]
	adcx	$lo, @acc[7]
	adox	$hi, @acc[8]

	mulx	@acc[11], $lo, $hi		# a[5]*a[3]
	 mov	@acc[10], %rdx
	adcx	$lo, @acc[8]
	adox	@acc[9], $hi
	adcx	$hi, @acc[9]

	#########################################
	mulx	@acc[11], $lo, @acc[10]		# a[5]*a[4]
	 mov	8*0($a_ptr), %rdx
	add	$lo, @acc[9]
	adc	\$0, @acc[10]

	######################################### double acc[1:10]
	xor	@acc[11], @acc[11]
	adcx	@acc[1], @acc[1]
	adcx	@acc[2], @acc[2]
	adcx	@acc[3], @acc[3]
	adcx	@acc[4], @acc[4]
	adcx	@acc[5], @acc[5]

	######################################### accumulate a[i]*a[i]
	mulx	%rdx, %rdx, $hi 		# a[0]*a[0]
	mov	%rdx, 8*0($r_ptr)
	mov	8*1($a_ptr), %rdx
	adox	$hi, @acc[1]
	mov	@acc[1], 8*1($r_ptr)

	mulx	%rdx, @acc[1], $hi		# a[1]*a[1]
	mov	8*2($a_ptr), %rdx
	adox	@acc[1], @acc[2]
	adox	$hi,     @acc[3]
	mov	@acc[2], 8*2($r_ptr)
	mov	@acc[3], 8*3($r_ptr)

	mulx	%rdx, @acc[1], @acc[2]		# a[2]*a[2]
	mov	8*3($a_ptr), %rdx
	adox	@acc[1], @acc[4]
	adox	@acc[2], @acc[5]
	adcx	@acc[6], @acc[6]
	adcx	@acc[7], @acc[7]
	mov	@acc[4], 8*4($r_ptr)
	mov	@acc[5], 8*5($r_ptr)

	mulx	%rdx, @acc[1], @acc[2]		# a[3]*a[3]
	mov	8*4($a_ptr), %rdx
	adox	@acc[1], @acc[6]
	adox	@acc[2], @acc[7]
	adcx	@acc[8], @acc[8]
	adcx	@acc[9], @acc[9]
	mov	@acc[6], 8*6($r_ptr)
	mov	@acc[7], 8*7($r_ptr)

	mulx	%rdx, @acc[1], @acc[2]		# a[4]*a[4]
	mov	8*5($a_ptr), %rdx
	adox	@acc[1], @acc[8]
	adox	@acc[2], @acc[9]
	adcx	@acc[10], @acc[10]
	adcx	@acc[11], @acc[11]
	mov	@acc[8], 8*8($r_ptr)
	mov	@acc[9], 8*9($r_ptr)

	mulx	%rdx, @acc[1], @acc[2]		# a[5]*a[5]
	adox	@acc[1], @acc[10]
	adox	@acc[2], @acc[11]

	mov	@acc[10], 8*10($r_ptr)
	mov	@acc[11], 8*11($r_ptr)

	ret
.size	__sqra_384,.-__sqra_384

########################################################################
# void redca_mont_384(uint64_t ret[6], const uint64_t a[12],
#                     uint64_t m[6], uint64_t n0);
.globl	redca_mont_384
.hidden	redca_mont_384
.type	redca_mont_384,\@function,4,"unwind"
.align	32
redca_mont_384:
.cfi_startproc
redc_mont_384\$4:
	lea	-8(%rsp), %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$n_ptr, $n0
	mov	$b_org, $n_ptr
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384
	call	__reda_tail_mont_384

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	redca_mont_384,.-redca_mont_384

########################################################################
# void froma_mont_384(uint64_t ret[6], const uint64_t a[6],
#                     uint64_t m[6], uint64_t n0);
.globl	froma_mont_384
.hidden	froma_mont_384
.type	froma_mont_384,\@function,4,"unwind"
.align	32
froma_mont_384:
.cfi_startproc
from_mont_384\$4:
	lea	-8(%rsp), %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$n_ptr, $n0
	mov	$b_org, $n_ptr
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384

	#################################
	# Branch-less conditional acc[0:6] - modulus

	sub	8*0($n_ptr), @acc[0], @acc[6]
	sbb	8*1($n_ptr), @acc[1], @acc[7]
	sbb	8*2($n_ptr), @acc[2], @acc[8]
	sbb	8*3($n_ptr), @acc[3], @acc[9]
	sbb	8*4($n_ptr), @acc[4], @acc[10]
	sbb	8*5($n_ptr), @acc[5], @acc[11]

	cmovnc	@acc[6], @acc[0]
	cmovnc	@acc[7], @acc[1]
	cmovnc	@acc[8], @acc[2]
	mov	@acc[0], 8*0($r_ptr)
	cmovnc	@acc[9], @acc[3]
	mov	@acc[1], 8*1($r_ptr)
	cmovnc	@acc[10], @acc[4]
	mov	@acc[2], 8*2($r_ptr)
	cmovnc	@acc[11], @acc[5]
	mov	@acc[3], 8*3($r_ptr)
	mov	@acc[4], 8*4($r_ptr)
	mov	@acc[5], 8*5($r_ptr)

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	froma_mont_384,.-froma_mont_384

.type	__mula_by_1_mont_384,\@abi-omnipotent
.align	32
__mula_by_1_mont_384:
	mov	8*0($a_ptr), @acc[0]
	mov	8*1($a_ptr), @acc[1]
	mov	8*2($a_ptr), @acc[2]
	mov	8*3($a_ptr), @acc[3]
	mov	8*4($a_ptr), @acc[4]
	mov	8*5($a_ptr), @acc[5]
___
for (my $i=0; $i<6; $i++) {
$code.=<<___;
{nf}	imulq	@acc[0], $n0, %rdx

	################################# reduction $i
	xor	@acc[6], @acc[6]	# @acc[6]=0, cf=0, of=0
	mulx	8*0($n_ptr), $lo, $hi
	adcx	@acc[0], $lo		# guaranteed to be zero
	adox	$hi, @acc[1], @acc[0]

	mulx	8*1($n_ptr), $lo, @acc[1]
	adcx	$lo, @acc[0]
	adox	@acc[2], @acc[1]

	mulx	8*2($n_ptr), $lo, @acc[2]
	adcx	$lo, @acc[1]
	adox	@acc[3], @acc[2]

	mulx	8*3($n_ptr), $lo, @acc[3]
	adcx	$lo, @acc[2]
	adox	@acc[4], @acc[3]

	mulx	8*4($n_ptr), $lo, @acc[4]
	adcx	$lo, @acc[3]
	adox	@acc[5], @acc[4]

	mulx	8*5($n_ptr), $lo, @acc[5]
	adcx	$lo, @acc[4]
	adox	@acc[6], @acc[5]	# of=0
	adcx	@acc[6], @acc[5]	# cf=0
___
}
$code.=<<___;
	ret
.size	__mula_by_1_mont_384,.-__mula_by_1_mont_384

.type	__reda_tail_mont_384,\@abi-omnipotent
.align	32
__reda_tail_mont_384:
	add	8*6($a_ptr), @acc[0]	# accumulate upper half
	adc	8*7($a_ptr), @acc[1]
	adc	8*8($a_ptr), @acc[2]
	adc	8*9($a_ptr), @acc[3]
	adc	8*10($a_ptr), @acc[4]
	adc	8*11($a_ptr), @acc[5]
	sbb	$hi, $hi

	#################################
	# Branch-less conditional acc[0:6] - modulus

	sub	8*0($n_ptr), @acc[0], @acc[6]
	sbb	8*1($n_ptr), @acc[1], @acc[7]
	sbb	8*2($n_ptr), @acc[2], @acc[8]
	sbb	8*3($n_ptr), @acc[3], @acc[9]
	sbb	8*4($n_ptr), @acc[4], @acc[10]
	sbb	8*5($n_ptr), @acc[5], @acc[11]
	sbb	\$0, $hi

	cmovnc	@acc[6], @acc[0]
	cmovnc	@acc[7], @acc[1]
	cmovnc	@acc[8], @acc[2]
	mov	@acc[0], 8*0($r_ptr)
	cmovnc	@acc[9], @acc[3]
	mov	@acc[1], 8*1($r_ptr)
	cmovnc	@acc[10], @acc[4]
	mov	@acc[2], 8*2($r_ptr)
	cmovnc	@acc[11], @acc[5]
	mov	@acc[3], 8*3($r_ptr)
	mov	@acc[4], 8*4($r_ptr)
	mov	@acc[5], 8*5($r_ptr)

	ret
.size	__reda_tail_mont_384,.-__reda_tail_mont_384

.globl	sgn0a_pty_mont_384
.hidden	sgn0a_pty_mont_384
.type	sgn0a_pty_mont_384,\@function,3,"unwind"
.align	32
sgn0a_pty_mont_384:
.cfi_startproc
sgn0_pty_mont_384\$4:
	lea	-8(%rsp), %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$b_org, $n0
	mov	$a_ptr, $n_ptr
	lea	0($r_ptr), $a_ptr
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384

	xor	%rax, %rax
	mov	@acc[0], @acc[7]
	add	@acc[0], @acc[0]
	adc	@acc[1], @acc[1]
	adc	@acc[2], @acc[2]
	adc	@acc[3], @acc[3]
	adc	@acc[4], @acc[4]
	adc	@acc[5], @acc[5]
	adc	\$0, %rax

	sub	8*0($n_ptr), @acc[0]
	sbb	8*1($n_ptr), @acc[1]
	sbb	8*2($n_ptr), @acc[2]
	sbb	8*3($n_ptr), @acc[3]
	sbb	8*4($n_ptr), @acc[4]
	sbb	8*5($n_ptr), @acc[5]
	sbb	\$0, %rax

	not	%rax			# 2*x > p, which means "negative"
	and	\$1, @acc[7]
	and	\$2, %rax
	or	@acc[7], %rax		# pack sign and parity

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	sgn0a_pty_mont_384,.-sgn0a_pty_mont_384

.globl	sgn0a_pty_mont_384x
.hidden	sgn0a_pty_mont_384x
.type	sgn0a_pty_mont_384x,\@function,3,"unwind"
.align	32
sgn0a_pty_mont_384x:
.cfi_startproc
sgn0_pty_mont_384x\$4:
	lea	-8(%rsp), %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$b_org, $n0
	mov	$a_ptr, $n_ptr
	lea	48($r_ptr), $a_ptr	# sgn0(a->im)
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	call	__mula_by_1_mont_384

	mov	@acc[0], @acc[6]
	or	@acc[1], @acc[0]
	or	@acc[2], @acc[0]
	or	@acc[3], @acc[0]
	or	@acc[4], @acc[0]
	or	@acc[5], @acc[0]

	lea	0($r_ptr), $a_ptr	# sgn0(a->re)
	xor	$r_ptr, $r_ptr
	mov	@acc[6], @acc[7]
	add	@acc[6], @acc[6]
	adc	@acc[1], @acc[1]
	adc	@acc[2], @acc[2]
	adc	@acc[3], @acc[3]
	adc	@acc[4], @acc[4]
	adc	@acc[5], @acc[5]
	adc	\$0, $r_ptr

	sub	8*0($n_ptr), @acc[6]
	sbb	8*1($n_ptr), @acc[1]
	sbb	8*2($n_ptr), @acc[2]
	sbb	8*3($n_ptr), @acc[3]
	sbb	8*4($n_ptr), @acc[4]
	sbb	8*5($n_ptr), @acc[5]
	sbb	\$0, $r_ptr

	mov	@acc[0], 0(%rsp)	# a->im is zero or not
	not	$r_ptr			# 2*x > p, which means "negative"
	and	\$1, @acc[7]
	and	\$2, $r_ptr
	or	@acc[7], $r_ptr		# pack sign and parity

	call	__mula_by_1_mont_384

	mov	@acc[0], @acc[6]
	or	@acc[1], @acc[0]
	or	@acc[2], @acc[0]
	or	@acc[3], @acc[0]
	or	@acc[4], @acc[0]
	or	@acc[5], @acc[0]

	xor	%rax, %rax
	mov	@acc[6], @acc[7]
	add	@acc[6], @acc[6]
	adc	@acc[1], @acc[1]
	adc	@acc[2], @acc[2]
	adc	@acc[3], @acc[3]
	adc	@acc[4], @acc[4]
	adc	@acc[5], @acc[5]
	adc	\$0, %rax

	sub	8*0($n_ptr), @acc[6]
	sbb	8*1($n_ptr), @acc[1]
	sbb	8*2($n_ptr), @acc[2]
	sbb	8*3($n_ptr), @acc[3]
	sbb	8*4($n_ptr), @acc[4]
	sbb	8*5($n_ptr), @acc[5]
	sbb	\$0, %rax

	mov	0(%rsp), @acc[6]

	not	%rax			# 2*x > p, which means "negative"

	test	@acc[0], @acc[0]
	cmovz	$r_ptr, @acc[7]		# a->re==0? prty(a->im) : prty(a->re)

	test	@acc[6], @acc[6]
	cmovnz	$r_ptr, %rax		# a->im!=0? sgn0(a->im) : sgn0(a->re)

	and	\$1, @acc[7]
	and	\$2, %rax
	or	@acc[7], %rax		# pack sign and parity

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	sgn0a_pty_mont_384x,.-sgn0a_pty_mont_384x

.globl	mula_mont_384
.hidden	mula_mont_384
.type	mula_mont_384,\@function,5,"unwind"
.align	32
mula_mont_384:
.cfi_startproc
mul_mont_384\$4:
	lea	-8(%rsp), %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$b_org, $b_ptr		# evacuate from %rdx
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($b_org), %rdx
	mov	8*0($a_ptr), @a[0]
	mov	8*1($a_ptr), @a[1]
	mov	8*2($a_ptr), @a[2]
	mov	8*3($a_ptr), @a[3]
	mov	8*4($a_ptr), @a[4]
	mov	8*5($a_ptr), @a[5]
	lea	-128($n_ptr), $n_ptr	# control u-op density

	mulx	@a[0],@acc[0],@acc[4]	# a[0]*b[0]
	call	__mula_mont_384

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	mula_mont_384,.-mula_mont_384

.type	__mula_mont_384,\@abi-omnipotent
.align	32
__mula_mont_384:
.cfi_startproc
	mulx	@a[1], @acc[1], @acc[5]
	mulx	@a[2], @acc[2], @acc[6]
	add	@acc[4], @acc[1]
	mulx	@a[3], @acc[3], @acc[7]
	adc	@acc[5], @acc[2]
	mulx	@a[4], @acc[4], @acc[8]
	adc	@acc[6], @acc[3]
	mulx	@a[5], @acc[5], @acc[6]
	 mov	8($b_ptr), %rdx
	adc	@acc[7], @acc[4]
	adc	@acc[8], @acc[5]
	adc	\$0, @acc[6]
	xor	@acc[7], @acc[7]
___
for (my $i=1; $i<6; $i++) {
my $next_rdx = $i<5 ? "mov		8*$i+8($b_ptr), %rdx"
                    : "{nf} imulq	$n0, @acc[0], %rdx";
$code.=<<___;
{nf}	 imulq	$n0, @acc[0], $a_ptr

	################################# Multiply by b[$i]
	xor	@acc[8], @acc[8]	# @acc[8]=0, cf=0, of=0
	mulx	@a[0], $lo, $hi
	adox	$lo, @acc[1]
	adcx	$hi, @acc[2]

	mulx	@a[1], $lo, $hi
	adox	$lo, @acc[2]
	adcx	$hi, @acc[3]

	mulx	@a[2], $lo, $hi
	adox	$lo, @acc[3]
	adcx	$hi, @acc[4]

	mulx	@a[3], $lo, $hi
	adox	$lo, @acc[4]
	adcx	$hi, @acc[5]

	mulx	@a[4], $lo, $hi
	adox	$lo, @acc[5]
	adcx	$hi, @acc[6]

	mulx	@a[5], $lo, $hi
	 mov	$a_ptr, %rdx
	adox	$lo, @acc[6]
	adcx	@acc[8], $hi		# cf=0
	adox	$hi, @acc[7]
	adox	@acc[8], @acc[8]

	################################# reduction
	xor	$a_ptr, $a_ptr		# $a_ptr=0, cf=0, of=0
	mulx	8*0+128($n_ptr), $lo, $hi
	adcx	@acc[0], $lo		# guaranteed to be zero
	adox	$hi, @acc[1], @acc[0]

	mulx	8*1+128($n_ptr), $lo, @acc[1]
	adcx	$lo, @acc[0]
	adox	@acc[2], @acc[1]

	mulx	8*2+128($n_ptr), $lo, @acc[2]
	adcx	$lo, @acc[1]
	adox	@acc[3], @acc[2]

	mulx	8*3+128($n_ptr), $lo, @acc[3]
	adcx	$lo, @acc[2]
	adox	@acc[4], @acc[3]

	mulx	8*4+128($n_ptr), $lo, @acc[4]
	adcx	$lo, @acc[3]
	adox	@acc[5], @acc[4]

	mulx	8*5+128($n_ptr), $lo, @acc[5]
	 $next_rdx
	adcx	$lo, @acc[4]
	adox	$a_ptr, @acc[5]		# of = 0
	adcx	@acc[6], @acc[5]
	adcx	$a_ptr, @acc[7], @acc[6]
	adcx	$a_ptr, @acc[8], @acc[7]
___
}
$code.=<<___;
	################################# last reduction
	xor	@acc[8], @acc[8]	# @acc[8]=0, cf=0, of=0
	mulx	8*0+128($n_ptr), $lo, @a[0]
	adcx	$lo, @acc[0]		# guaranteed to be zero
	adox	@acc[1], @a[0]

	mulx	8*1+128($n_ptr), $lo, @a[1]
	adcx	$lo, @a[0]
	adox	@acc[2], @a[1]

	mulx	8*2+128($n_ptr), $lo, @a[2]
	adcx	$lo, @a[1]
	adox	@acc[3], @a[2]

	mulx	8*3+128($n_ptr), $lo, @a[3]
	adcx	$lo, @a[2]
	adox	@acc[4], @a[3]

	mulx	8*4+128($n_ptr), $lo, @a[4]
	adcx	$lo, @a[3]
	adox	@acc[5], @a[4]

	mulx	8*5+128($n_ptr), $lo, @a[5]
	adcx	$lo, @a[4]
	adox	@acc[8], @a[5]		# of=0
	 lea	128($n_ptr), $n_ptr
	adcx	@acc[6], @a[5]
	adc	\$0, @acc[7]

	#################################
	# Branch-less conditional a[0:6] - modulus

	sub	8*0($n_ptr), @a[0], %rdx
	sbb	8*1($n_ptr), @a[1], @acc[1]
	sbb	8*2($n_ptr), @a[2], @acc[2]
	sbb	8*3($n_ptr), @a[3], @acc[3]
	sbb	8*4($n_ptr), @a[4], @acc[4]
	sbb	8*5($n_ptr), @a[5], @acc[5]
	sbb	\$0, @acc[7]

	cmovc	@a[0], %rdx
	cmovnc	@acc[1], @a[1]
	cmovnc	@acc[2], @a[2]
	cmovnc	@acc[3], @a[3]
	mov	%rdx, 8*0($r_ptr)
	cmovnc	@acc[4], @a[4]
	mov	@a[1], 8*1($r_ptr)
	cmovnc	@acc[5], @a[5]
	mov	@a[2], 8*2($r_ptr)
	mov	@a[3], 8*3($r_ptr)
	mov	@a[4], 8*4($r_ptr)
	mov	@a[5], 8*5($r_ptr)

	ret	# __SGX_LVI_HARDENING_CLOBBER__=%rsi
.cfi_endproc
.size	__mula_mont_384,.-__mula_mont_384

.globl	sqra_mont_384
.hidden	sqra_mont_384
.type	sqra_mont_384,\@function,4,"unwind"
.align	32
sqra_mont_384:
.cfi_startproc
sqr_mont_384\$4:
	lea	-8(%rsp), %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$n_ptr, $n0		# n0
	lea	-128($b_org), $n_ptr	# control u-op density
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($a_ptr), %rdx
	mov	8*1($a_ptr), @a[1]
	mov	8*2($a_ptr), @a[2]
	mov	8*3($a_ptr), @a[3]
	mov	8*4($a_ptr), @a[4]
	mov	8*5($a_ptr), @a[5]

	lea	($a_ptr), $b_ptr

	mov	%rdx, @a[0]
	mulx	%rdx, @acc[0], @acc[4]	# a[0]*a[0]
	call	__mula_mont_384		# as fast as dedicated squaring

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	sqra_mont_384,.-sqra_mont_384

.globl	sqra_n_mul_mont_384
.hidden	sqra_n_mul_mont_384
.type	sqra_n_mul_mont_384,\@function,6,"unwind"
.align	32
sqra_n_mul_mont_384:
.cfi_startproc
sqr_n_mul_mont_384\$4:
	lea	-8(%rsp), %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$b_org, %r31		# loop counter
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($a_ptr), %rdx
	mov	8*1($a_ptr), @a[1]
	mov	8*2($a_ptr), @a[2]
	mov	$a_ptr, $b_ptr
	mov	8*3($a_ptr), @a[3]
	mov	8*4($a_ptr), @a[4]
	mov	8*5($a_ptr), @a[5]

.Loop_sqra_384:
	lea	-128($n_ptr), $n_ptr	# control u-op density

	mov	%rdx, @a[0]
	mulx	%rdx, @acc[0], @acc[4]	# a[0]*a[0]
	call	__mula_mont_384

	mov	$r_ptr, $b_ptr
	dec	%r31d
	jnz	.Loop_sqra_384

	mov	%rdx, @a[0]
	mov	(%r9), %rdx		# b[0]
	lea	(%r9), $b_ptr		# 6th, multiplicand argument
	lea	-128($n_ptr), $n_ptr	# control u-op density

	mulx	@a[0],@acc[0],@acc[4]	# a[0]*b[0]
	call	__mula_mont_384

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	sqra_n_mul_mont_384,.-sqra_n_mul_mont_384

.globl	sqra_n_mul_mont_383
.hidden	sqra_n_mul_mont_383
.type	sqra_n_mul_mont_383,\@function,6,"unwind"
.align	32
sqra_n_mul_mont_383:
.cfi_startproc
sqr_n_mul_mont_383\$4:
	lea	-8(%rsp), %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$b_org, %r31		# loop counter
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($a_ptr), %rdx
	mov	8*1($a_ptr), @a[1]
	mov	8*2($a_ptr), @a[2]
	mov	8*3($a_ptr), @a[3]
	mov	8*4($a_ptr), @a[4]
	mov	8*5($a_ptr), @a[5]
	mov	%rdx, @a[0]
	lea	-128($n_ptr), $n_ptr	# control u-op density
	jmp	.Loop_sqra_383

.align	32
.Loop_sqra_383:
	# omitting full reduction gives ~15% in addition-chains

	mulx	%rdx,  @acc[0], @acc[4]	# a[0]*a[0]
	mulx	@a[1], @acc[1], @acc[5]
	mulx	@a[2], @acc[2], @acc[6]
	add	@acc[4], @acc[1]
	mulx	@a[3], @acc[3], @acc[7]
	adc	@acc[5], @acc[2]
	mulx	@a[4], @acc[4], @acc[8]
	adc	@acc[6], @acc[3]
	mulx	@a[5], @acc[5], @acc[6]
	 mov	@a[1], %rdx
	adc	@acc[7], @acc[4]
	adc	@acc[8], @acc[5]
	adc	\$0, @acc[6]
___
for (my $i=1; $i<6; $i++) {
my $next_rdx = $i<5 ? "mov		@a[$i+1], %rdx"
                    : "{nf} imulq	$n0, @acc[0], %rdx";
$code.=<<___;
{nf}	 imulq	$n0, @acc[0], @acc[8]

	################################# Multiply by b[$i]
	xor	@acc[7], @acc[7]	# @acc[7]=0, cf=0, of=0
	mulx	@a[0], $lo, $hi
	adox	$lo, @acc[1]
	adcx	$hi, @acc[2]

	mulx	@a[1], $lo, $hi
	adox	$lo, @acc[2]
	adcx	$hi, @acc[3]

	mulx	@a[2], $lo, $hi
	adox	$lo, @acc[3]
	adcx	$hi, @acc[4]

	mulx	@a[3], $lo, $hi
	adox	$lo, @acc[4]
	adcx	$hi, @acc[5]

	mulx	@a[4], $lo, $hi
	adox	$lo, @acc[5]
	adcx	$hi, @acc[6]

	mulx	@a[5], $lo, $hi
	 mov	@acc[8], %rdx
	adox	$lo, @acc[6]
	adcx	@acc[7], $hi
	adox	$hi, @acc[7]

	################################# reduction
	xor	@acc[8], @acc[8]	# @acc[8]=0, cf=0, of=0
	mulx	8*0+128($n_ptr), $lo, $hi
	adcx	@acc[0], $lo		# guaranteed to be zero
	adox	$hi, @acc[1], @acc[0]

	mulx	8*1+128($n_ptr), $lo, @acc[1]
	adcx	$lo, @acc[0]
	adox	@acc[2], @acc[1]

	mulx	8*2+128($n_ptr), $lo, @acc[2]
	adcx	$lo, @acc[1]
	adox	@acc[3], @acc[2]

	mulx	8*3+128($n_ptr), $lo, @acc[3]
	adcx	$lo, @acc[2]
	adox	@acc[4], @acc[3]

	mulx	8*4+128($n_ptr), $lo, @acc[4]
	adcx	$lo, @acc[3]
	adox	@acc[5], @acc[4]

	mulx	8*5+128($n_ptr), $lo, @acc[5]
	 $next_rdx
	adcx	$lo, @acc[4]
	adox	@acc[6], @acc[5]
	adcx	@acc[8], @acc[5]
	adox	@acc[8], @acc[7]
	adcx	@acc[8], @acc[7], @acc[6]
___
}
$code.=<<___;
	################################# last reduction
	xor	@acc[8], @acc[8]	# @acc[8]=0, cf=0, of=0
	mulx	8*0+128($n_ptr), $lo, @a[0]
	adcx	@acc[0], $lo		# guaranteed to be zero
	adox	@acc[1], @a[0]

	mulx	8*1+128($n_ptr), $lo, @a[1]
	adcx	$lo, @a[0]
	adox	@acc[2], @a[1]

	mulx	8*2+128($n_ptr), $lo, @a[2]
	adcx	$lo, @a[1]
	adox	@acc[3], @a[2]

	mulx	8*3+128($n_ptr), $lo, @a[3]
	adcx	$lo, @a[2]
	adox	@acc[4], @a[3]

	mulx	8*4+128($n_ptr), $lo, @a[4]
	adcx	$lo, @a[3]
	adox	@acc[5], @a[4]

	mulx	8*5+128($n_ptr), $lo, @a[5]
	 mov	@a[0], %rdx
	adcx	$lo, @a[4]
	adox	@acc[6], @a[5]
	adc	\$0, @a[5]

	dec	%r31d
	jnz	.Loop_sqra_383

	mov	(%r9), %rdx		# b[0]
	lea	(%r9), $b_ptr		# 6th, multiplicand argument

	mulx	@a[0], @acc[0], @acc[4]	# a[0]*b[0]
	call	__mula_mont_384

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	sqra_n_mul_mont_383,.-sqra_n_mul_mont_383
___
}
{
my $n_ptr = $b_org;
my @tmp = map("%r$_", (28..31,8,9));

$code.=<<___;
.globl	mula_by_1_plus_i_mod_384x
.hidden	mula_by_1_plus_i_mod_384x
.type	mula_by_1_plus_i_mod_384x,\@function,3,"unwind"
.align	32
mula_by_1_plus_i_mod_384x:
.cfi_startproc
	sub	\$8, %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($a_ptr), @acc[6]
	mov	8*1($a_ptr), @acc[7]
	mov	8*2($a_ptr), @acc[8]
	mov	8*3($a_ptr), @acc[9]
	mov	8*4($a_ptr), @acc[10]
	mov	8*5($a_ptr), @acc[11]

	sub	8*6($a_ptr), @acc[6], @acc[0]	# a->re - a->im
	sbb	8*7($a_ptr), @acc[7], @acc[1]
	sbb	8*8($a_ptr), @acc[8], @acc[2]
	sbb	8*9($a_ptr), @acc[9], @acc[3]
	sbb	8*10($a_ptr), @acc[10], @acc[4]
	sbb	8*11($a_ptr), @acc[11], @acc[5]
	sbb	$lo, $lo

	add	8*6($a_ptr), @acc[6]		# a->re + a->im
	adc	8*7($a_ptr), @acc[7]
	adc	8*8($a_ptr), @acc[8]
	adc	8*9($a_ptr), @acc[9]
	adc	8*10($a_ptr), @acc[10]
	adc	8*11($a_ptr), @acc[11]
	sbb	$hi, $hi

{nf}	and	8*0($n_ptr), $lo, @tmp[0]
{nf}	and	8*1($n_ptr), $lo, @tmp[1]
{nf}	and	8*2($n_ptr), $lo, @tmp[2]
{nf}	and	8*3($n_ptr), $lo, @tmp[3]
{nf}	and	8*4($n_ptr), $lo, @tmp[4]
{nf}	and	8*5($n_ptr), $lo, @tmp[5]

	add	@tmp[0], @acc[0]
	adc	@tmp[1], @acc[1]
	adc	@tmp[2], @acc[2]
	adc	@tmp[3], @acc[3]
	adc	@tmp[4], @acc[4]
	adc	@tmp[5], @acc[5]

	sub	8*0($n_ptr), @acc[6], @tmp[0]
	sbb	8*1($n_ptr), @acc[7], @tmp[1]
	sbb	8*2($n_ptr), @acc[8], @tmp[2]
	sbb	8*3($n_ptr), @acc[9], @tmp[3]
	sbb	8*4($n_ptr), @acc[10], @tmp[4]
	sbb	8*5($n_ptr), @acc[11], @tmp[5]
	sbb	\$0, $hi

	mov	@acc[0], 8*0($r_ptr)
	mov	@acc[1], 8*1($r_ptr)
	mov	@acc[2], 8*2($r_ptr)
	mov	@acc[3], 8*3($r_ptr)
	mov	@acc[4], 8*4($r_ptr)
	mov	@acc[5], 8*5($r_ptr)

	cmovnc	@tmp[0], @acc[6]
	cmovnc	@tmp[1], @acc[7]
	cmovnc	@tmp[2], @acc[8]
	cmovnc	@tmp[3], @acc[9]
	cmovnc	@tmp[4], @acc[10]
	cmovnc	@tmp[5], @acc[11]

	mov	@acc[6], 8*6($r_ptr)
	mov	@acc[7], 8*7($r_ptr)
	mov	@acc[8], 8*8($r_ptr)
	mov	@acc[9], 8*9($r_ptr)
	mov	@acc[10], 8*10($r_ptr)
	mov	@acc[11], 8*11($r_ptr)

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	mula_by_1_plus_i_mod_384x,.-mula_by_1_plus_i_mod_384x
___
}

print $code;
close STDOUT;
