#!/usr/bin/env perl
#
# Copyright Supranational LLC
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# "Sparse" in subroutine names refers to most significant limb of the
# modulus. Though "sparse" is a bit of misnomer, because limitation is
# just not-all-ones. Or in other words not larger than 2^256-2^192-1.
# In general Montgomery multiplication algorithm can handle one of the
# inputs being non-reduced and capped by 1<<radix_width, 1<<256 in this
# case, rather than the modulus. mul_mont_sparse_256, being a *tailored*
# implementation of the algorithm, can handle such input only as second
# input, the third function argument.
# Just in case, why limitation at all and not general-purpose 256-bit
# subroutines? Unlike the 384-bit case, accounting for additional carry
# has disproportionate impact on performance, especially in adcx/adox
# implementation.

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
#ifdef	__BLST_PORTABLE__
.globl	mul_mont_sparse_256\$4
.globl	sqr_mont_sparse_256\$4
.globl	from_mont_256\$4
.globl	redc_mont_256\$4
#endif
___

# common argument layout
($r_ptr,$a_ptr,$b_org,$n_ptr,$n0) = ("%rdi","%rsi","%rdx","%rcx","%r8");
$b_ptr = "%r10";

@acc = map("%r$_",(16..21));
@a = map("%r$_",(22..25));
@n = map("%r$_",(26..29));
($lo, $hi) = ("%rax", "%r11");

{ ############################################################## mulq
$code.=<<___;
.text

.globl	mula_mont_sparse_256
.hidden	mula_mont_sparse_256
.type	mula_mont_sparse_256,\@function,5,"unwind"
.align	32
mula_mont_sparse_256:
.cfi_startproc
mul_mont_sparse_256\$4:
	sub	\$8,%rsp
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

	mulx	@a[0], @acc[0], @acc[4]	# a[0]*b[0]
	call	__mula_mont_sparse_256

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	mula_mont_sparse_256,.-mula_mont_sparse_256

.globl	sqra_mont_sparse_256
.hidden	sqra_mont_sparse_256
.type	sqra_mont_sparse_256,\@function,4,"unwind"
.align	32
sqra_mont_sparse_256:
.cfi_startproc
sqr_mont_sparse_256\$4:
	sub	\$8,%rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$a_ptr, $b_ptr
	mov	$n_ptr, $n0
	mov	$b_org, $n_ptr
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($a_ptr), %rdx
	mov	8*1($a_ptr), @a[1]
	mov	8*2($a_ptr), @a[2]
	mov	8*3($a_ptr), @a[3]

	mov	%rdx, @a[0]
	mulx	%rdx, @acc[0], @acc[4]	# a[0]*a[0]
	call	__mula_mont_sparse_256

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	sqra_mont_sparse_256,.-sqra_mont_sparse_256

.type	__mula_mont_sparse_256,\@abi-omnipotent
.align	32
__mula_mont_sparse_256:
	mulx	@a[1], @acc[1], @acc[5]
	mulx	@a[2], @acc[2], $lo
	add	@acc[4], @acc[1]
	mulx	@a[3], @acc[3], @acc[4]
	 mov	8($b_ptr), %rdx
	adc	@acc[5], @acc[2]
	mov	8*0($n_ptr), @n[0]
	adc	$lo, @acc[3]
	mov	8*1($n_ptr), @n[1]
	adc	\$0, @acc[4]
	mov	8*2($n_ptr), @n[2]
	mov	8*3($n_ptr), @n[3]
___
for (my $i=1; $i<4; $i++) {
my $next_rdx = $i<3 ? "mov		8*$i+8($b_ptr), %rdx"
                    : "{nf} imulq	$n0, @acc[0], %rdx";
$code.=<<___;
{nf}	 imulq	$n0, @acc[0], $a_ptr

	################################# Multiply by b[$i]
	xor	@acc[5], @acc[5]	# @acc[5]=0, cf=0, of=0
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
	 mov	$a_ptr, %rdx
	adox	$lo, @acc[4]
	adcx	@acc[5], $hi 		# cf=0
	adox	$hi, @acc[5]		# of=0

	################################# reduction
	xor	$a_ptr, $a_ptr		# $a_ptr=0, cf=0, of=0
	mulx	@n[0], $lo, $hi
	adcx	@acc[0], $lo		# guaranteed to be zero
	adox	$hi, @acc[1], @acc[0]

	mulx	@n[1], $lo, @acc[1]
	adcx	$lo, @acc[0]
	adox	@acc[2], @acc[1]

	mulx	@n[2], $lo, @acc[2]
	adcx	$lo, @acc[1]
	adox	@acc[3], @acc[2]

	mulx	@n[3], $lo, @acc[3]
	 $next_rdx
	adcx	$lo, @acc[2]
	adox	$a_ptr, @acc[3]		# of=0
	adcx	@acc[4], @acc[3]
	adcx	$a_ptr, @acc[5], @acc[4]# cf=0
___
}
$code.=<<___;
	################################# last reduction
	xor	@acc[5], @acc[5]	# cf=0, of=0
	mulx	@n[0], $lo, @a[0]
	adcx	$lo, @acc[0]		# guaranteed to be zero
	adox	@acc[1], @a[0]

	mulx	@n[1], $lo, @a[1]
	adcx	$lo, @a[0]
	adox	@acc[2], @a[1]

	mulx	@n[2], $lo, @a[2]
	adcx	$lo, @a[1]
	adox	@acc[3], @a[2]

	mulx	@n[3], $lo, @a[3]
	adcx	$lo, @a[2]
	adox	@acc[5], @a[3]		# of=0
	adcx	@acc[4], @a[3]
	adcx	@acc[5], @acc[5]	# cf=0

	#################################
	# Branch-less conditional a[0:5] - modulus

	sub	@n[0], @a[0], @acc[0]
	sbb	@n[1], @a[1], @acc[1]
	sbb	@n[2], @a[2], @acc[2]
	sbb	@n[3], @a[3], @acc[3]
	sbb	\$0, @acc[5]

	cmovnc	@acc[0], @a[0]
	cmovnc	@acc[1], @a[1]
	cmovnc	@acc[2], @a[2]
	mov	@a[0], 8*0($r_ptr)
	cmovnc	@acc[3], @a[3]
	mov	@a[1], 8*1($r_ptr)
	mov	@a[2], 8*2($r_ptr)
	mov	@a[3], 8*3($r_ptr)

	ret
.size	__mula_mont_sparse_256,.-__mula_mont_sparse_256
___
}
{ my ($n_ptr, $n0)=($b_ptr, $n_ptr);	# arguments are "shifted"

$code.=<<___;
.globl	froma_mont_256
.hidden	froma_mont_256
.type	froma_mont_256,\@function,4,"unwind"
.align	32
froma_mont_256:
.cfi_startproc
from_mont_256\$4:
	sub	\$8, %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$b_org, $n_ptr
	call	__mula_by_1_mont_256

	#################################
	# Branch-less conditional acc[0:3] - modulus

	sub	@n[0], @acc[0], @a[0]
	sbb	@n[1], @acc[1], @a[1]
	sbb	@n[2], @acc[2], @a[2]
	sbb	@n[3], @acc[3], @a[3]

	cmovc	@acc[0], @a[0]
	cmovc	@acc[1], @a[1]
	cmovc	@acc[2], @a[2]
	mov	@a[0], 8*0($r_ptr)
	cmovc	@acc[3], @a[3]
	mov	@a[1], 8*1($r_ptr)
	mov	@a[2], 8*2($r_ptr)
	mov	@a[3], 8*3($r_ptr)

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	froma_mont_256,.-froma_mont_256

.globl	redca_mont_256
.hidden	redca_mont_256
.type	redca_mont_256,\@function,4,"unwind"
.align	32
redca_mont_256:
.cfi_startproc
redc_mont_256\$4:
	sub	\$8, %rsp
.cfi_adjust_cfa_offset	8
.cfi_end_prologue

	mov	$b_org, $n_ptr
	call	__mula_by_1_mont_256

	add	8*4($a_ptr), @acc[0]	# accumulate upper half
	adc	8*5($a_ptr), @acc[1]
	adc	8*6($a_ptr), @acc[2]
	adc	8*7($a_ptr), @acc[3]
	sbb	$a_ptr, $a_ptr

	#################################
	# Branch-less conditional acc[0:4] - modulus

	sub	@n[0], @acc[0], @a[0]
	sbb	@n[1], @acc[1], @a[1]
	sbb	@n[2], @acc[2], @a[2]
	sbb	@n[3], @acc[3], @a[3]
	sbb	\$0, $a_ptr

	cmovc	@acc[0], @a[0]
	cmovc	@acc[1], @a[1]
	cmovc	@acc[2], @a[2]
	mov	@a[0], 8*0($r_ptr)
	cmovc	@acc[3], @a[3]
	mov	@a[1], 8*1($r_ptr)
	mov	@a[2], 8*2($r_ptr)
	mov	@a[3], 8*3($r_ptr)

	lea	8(%rsp),%rsp
.cfi_adjust_cfa_offset	-8
.cfi_epilogue
	ret
.cfi_endproc
.size	redca_mont_256,.-redca_mont_256

.type	__mula_by_1_mont_256,\@abi-omnipotent
.align	32
__mula_by_1_mont_256:
#ifdef	__SGX_LVI_HARDENING__
	lfence
#endif
	mov	8*0($a_ptr), @acc[0]
	mov	8*0($n_ptr), @n[0]
	mov	8*1($a_ptr), @acc[1]
	mov	8*1($n_ptr), @n[1]
	mov	8*2($a_ptr), @acc[2]
	mov	8*2($n_ptr), @n[2]
	mov	8*3($a_ptr), @acc[3]
	mov	8*3($n_ptr), @n[3]
___
for (my $i=0; $i<4; $i++) {
$code.=<<___;
{nf}	imulq	@acc[0], $n0, %rdx

	################################# reduction $i
	xor	@acc[4], @acc[4]	# @acc[4]=0, cf=0, of=0
	mulx	@n[0], $lo, $hi
	adcx	@acc[0], $lo		# guaranteed to be zero
	adox	$hi, @acc[1], @acc[0]

	mulx	@n[1], $lo, @acc[1]
	adcx	$lo, @acc[0]
	adox	@acc[2], @acc[1]

	mulx	@n[2], $lo, @acc[2]
	adcx	$lo, @acc[1]
	adox	@acc[3], @acc[2]

	mulx	@n[3], $lo, @acc[3]
	adcx	$lo, @acc[2]
	adox	@acc[4], @acc[3]	# of=0
	adcx	@acc[4], @acc[3]	# cf=0
___
}
$code.=<<___;
	ret
.size	__mula_by_1_mont_256,.-__mula_by_1_mont_256
___
}

print $code;
close STDOUT;
