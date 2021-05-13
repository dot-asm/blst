#!/usr/bin/env perl
#
# Approximate %clock counts for single-warp operations with hot caches.
#
#		GTX 1650(i)	Tesla P100	Tegra X1	Tesla K80
#		CUDA 11.2	CUDA 11.2	CUDA 10.2	CUDA 11.2
#
# add_fp	290		510		760		830
# sub_fp	310		880		720		880
# lshift_fp(1)	250		670		550		700
# rshift_fp(1)	230		600		500		630
# lshift_fp(2)	350		860		800		1100
# rshift_fp(2)	320		750		650		860
# mul_fp	2700		4700		4700		8700
# sqr_fp	1800		8900(ii)	7000(ii)	7000
# mul_384	1500		2500		2600		4600
# sqr_384	610		1800		1700		2500
# redc_fp	1400		2900		3000		4900
#
# (i)	TU117, considered representative of Tesla A100, V100, T4;
# (ii)	Maxwell and Pascal expressions of the algorithm are largest
#	and apparently thrash the code cache; 

$0 =~ m/mul_([a-z]+)\-ptx(32)?\./;
my $sfx = $1;
my $ptr = $2 ? 32 : 64;

sub AUTOLOAD()
{ my $opcode = $AUTOLOAD; $opcode =~ s/.*:://; $opcode =~ s/_/\./g;
    $ptx .= "\t$opcode\t".join(',',@_).";\n";
}
*madc_hi = sub { madc_hi_cc_u32(@_) };

$ptx.=<<___;
.version 6.0	// CUDA 9.0 is the tested minimum
.target sm_32	// sm_32 is the minimum requirement,
		// compiling for higher sm_NM is not a problem
.address_size $ptr

___
$ptx.=<<___	if ($sfx eq "fp");
// BLS12-381 modulus
.const.u32	P[12] =   { 0xffffaaab, 0xb9feffff, 0xb153ffff, 0x1eabfffe,
                            0xf6b0f624, 0x6730d2a0, 0xf38512bf, 0x64774b84,
                            0x434bacd7, 0x4b1ba7b6, 0x397fe69a, 0x1a0111ea };
// -P so that subtraction can be performed with addition instructions
.const.u32	mP[12] =  { 0x00005555, 0x46010000, 0x4eac0000, 0xe1540001,
                            0x094f09db, 0x98cf2d5f, 0x0c7aed40, 0x9b88b47b,
                            0xbcb45328, 0xb4e45849, 0xc6801965, 0xe5feee15 };
.const.u32	p0[2]  =  { 0xfffcfffd, 0x89f3fffc };

___
$ptx.=<<___;
.extern .shared .b64 xoffload[];

.visible .func mul_${sfx}(.param.b$ptr rptr,
                          .param.b$ptr aptr,
                          .param.b$ptr bptr)
{
	.reg.b$ptr	%rptr, %aptr, %bptr;
	.reg.b32	%in<12>;
	.reg.b32	%acc<13>;
	.reg.b32	%bi, %ni, %mi, %cnt;
	.reg.pred	%p;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%bptr, [bptr];
	ld.param.b$ptr		%rptr, [rptr];
	cvta.to.local.u$ptr	%bptr, %bptr;	// bptr is expected to be local
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local

	//mov.u32		%xptr, xoffload;
	//mov.u32		%bi, %tid.x;
	//shl.b32		%bi, %bi, 3;
	//add.u32		%xptr, %xptr, %bi;
	//ld.shared.b32		%bi, [%xptr];

	mov.b32			%cnt, 11;	// loop counter
	ld.local.b32		%bi, [%bptr];
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {			### load a[0:11]
	&ld_v2_b32	("{%in$i, %in$j}, [%aptr+4*$i]");
}
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {			### a[0:11]*b[0]
	&mul_lo_u32	("%acc$i, %in$i, %bi");
	&mul_hi_u32	("%acc$j, %in$i, %bi");
}
	&ld_const_b32	("%mi, [p0]");
	&mul_lo_u32	("%mi, %acc0, %mi");		### a[0]*p0

for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {	### n[0:11]*mi
	$madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&ld_const_b32	("%ni, [P+4*$i]");
	&$madc_lo	("%acc$i, %mi, %ni, %acc$i");
	&madc_hi	("%acc$j, %mi, %ni, %acc$j");
}
for($i=1, $j=0; $i<12; $i++, $j++) {
	&mov_b32	("%acc$j, %acc$i");
}	&addc_u32	("%acc$j, 0, 0");

$ptx.="Loop:\n";
{
    for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {	### a[0:11]*b[i]
	$madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&$madc_lo	("%acc$i, %in$j, %bi, %acc$i");
	&madc_hi	("%acc$j, %in$j, %bi, %acc$j");
    }
    $ptx.="	setp.ne.u32	%p, %cnt, 0;\n".
          "@%p	ld.local.b32	%bi, [%bptr+4];\n";

    for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {	### n[0:11]*ni
	$madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&ld_const_b32	("%ni, [P+4*$j]");
	&$madc_lo	("%acc$i, %mi, %ni, %acc$i");
	&madc_hi	("%acc$j, %mi, %ni, %acc$j");
    }
    $ptx.="@!%p	bra.uni		Lbreak;\n".		### break;
          "	sub.u32		%cnt, %cnt, 1;\n".
          "	add.u$ptr	%bptr, %bptr, 4;\n";

    for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {	### a[0:11]*b[i]
	$madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&$madc_lo	("%acc$i, %in$i, %bi, %acc$i");
	&madc_hi	("%acc$j, %in$i, %bi, %acc$j");
    }	&addc_u32	("%acc$i, 0, 0");

	&ld_const_b32	("%mi, [p0]");
	&mul_lo_u32	("%mi, %acc0, %mi");		### a[0]*p0

    for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {	### n[0:11]*mi
	$madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&ld_const_b32	("%ni, [P+4*$i]");
	&$madc_lo	("%acc$i, %mi, %ni, %acc$i");
	&madc_hi	("%acc$j, %mi, %ni, %acc$j");
    }
    for($i=1, $j=0; $i<12; $i++, $j++) {
	&mov_b32	("%acc$j, %acc$i");
    }	&addc_u32	("%acc$j, %acc$i, 0");
	&bra_uni	("Loop");			### loop
$ptx.="Lbreak:\n";
}

	&ld_const_b32	("%in0, [mP]");		### subtract modulus
	&add_cc_u32	("%in0, %acc0, %in0");
for($i=1; $i<12; $i++) {
	&ld_const_b32	("%in$i, [mP+4*$i]");
	&addc_cc_u32	("%in$i, %acc$i, %in$i");
}	&addc_u32	("%ni, 0, 0");
	&setp_ne_u32	("%p, %ni, 0");
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### select correct answer
    $ptx.="@%p	mov.b32		%acc$i, %in$i;\n".
          "@%p	mov.b32		%acc$j, %in$j;\n";
	&st_local_v2_b32	("[%rptr+4*$i], {%acc$i, %acc$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func sqr_${sfx}(.param.b$ptr rptr,
                          .param.b$ptr aptr)
{
	.reg.b$ptr	%rptr, %aptr;
	.reg.b32	%in<12>;
	.reg.b32	%sqr<24>;

	ld.param.b$ptr	%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr	%rptr, [rptr];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local

___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### load input
	&ld_v2_b32	("{%in$i, %in$j}, [%aptr+4*$i]");
}

sqr_384([map("%sqr$_",(0..23))], [map("%in$_",(0..11))]);
mul_by_1([map("%sqr$_",(0..11))]);

	&add_cc_u32	("%sqr0, %sqr0, %sqr12");
for($i=1, $j=13; $i<11; $i++, $j++) {
	&addc_cc_u32	("%sqr$i, %sqr$i, %sqr$j");
}	&addc_u32	("%sqr$i, %sqr$i, %sqr$j");

final_sub([map("%sqr$_",(0..11))], [map("%sqr$_",(12..23))]);

for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### store the result
	&st_local_v2_b32	("[%rptr+4*$i], {%sqr$i, %sqr$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func add_${sfx}(.param.b$ptr rptr,	// 384-bit
                          .param.b$ptr aptr,
                          .param.b$ptr bptr)
{
	.reg.b$ptr	%rptr, %aptr, %bptr;
	.reg.b32	%a<13>;
	.reg.b32	%b<12>;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%bptr, [bptr];
	ld.param.b$ptr		%rptr, [rptr];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### load a[0:11] and b[0:11]
	&ld_v2_b32	("{%a$i, %a$j}, [%aptr+4*$i]");
	&ld_v2_b32	("{%b$i, %b$j}, [%bptr+4*$i]");
}
	&add_cc_u32	("%a0, %a0, %b0");	### addition
for($i=1; $i<12; $i++) {
	&addc_cc_u32	("%a$i, %a$i, %b$i");
}	&addc_u32	("%a$i, 0, 0");

final_sub([map("%a$_",(0..12))], [map("%b$_",(0..11))]);

for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### store the result
	&st_local_v2_b32	("[%rptr+4*$i], {%a$i, %a$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func sub_${sfx}(.param.b$ptr rptr,	// 384-bit
                          .param.b$ptr aptr,
                          .param.b$ptr bptr)
{
	.reg.b$ptr	%rptr, %aptr, %bptr;
	.reg.b32	%a<13>;
	.reg.b32	%b<12>;
	.reg.pred	%p;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%bptr, [bptr];
	ld.param.b$ptr		%rptr, [rptr];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### load a[0:11] and b[0:11]
	&ld_v2_b32	("{%a$i, %a$j}, [%aptr+4*$i]")
	&ld_v2_b32	("{%b$i, %b$j}, [%bptr+4*$i]");
}
	&sub_cc_u32	("%a0, %a0, %b0");	### subtraction
for($i=1; $i<12; $i++) {
 	&subc_cc_u32	("%a$i, %a$i, %b$i");
}	&subc_u32	("%a$i, 0, 0");
for($i=0; $i<12; $i++) {			### mask modulus
	&ld_const_u32	("%b$i, [P+4*$i]");
	&and_b32	("%b$i, %b$i, %a12");
}
	&add_cc_u32	("%a0, %a0, %b0");	### add masked modulus
for($i=1; $i<11; $i++) {
	&addc_cc_u32	("%a$i, %a$i, %b$i");
}	&addc_u32	("%a$i, %a$i, %b$i");

for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&st_local_v2_b32	("[%rptr+4*$i], {%a$i, %a$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func cneg_${sfx}(.param.b$ptr rptr,	// 384-bit
                           .param.b$ptr aptr,
                           .param.b32 flag)
{
	.reg.b$ptr	%rptr, %aptr;
	.reg.b32	%a<12>;
	.reg.b32	%b<12>;
	.reg.b32	%flag;
	.reg.pred	%p;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%rptr, [rptr];
	ld.param.b32		%flag, [flag];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
	setp.ne.u32		%p, %flag, 0;
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### load a[0:11]
	&ld_v2_b32	("{%a$i, %a$j}, [%aptr+4*$i]");
}
for(my $subc, $i=0; $i<12; $i++) {		### negate
    $subc = $subc ? subc_cc_u32 : sub_cc_u32;
	&ld_const_b32	("%b$i, [P+4*$i]");
	&$subc		("%b$i, %b$i, %a$i");
	&or_b32		("%flag, %a0, %a1")	if ($i==1);
	&or_b32		("%flag, %flag, %a$i")	if ($i>1);
}
    $ptx.="@%p	setp.ne.u32	%p, %flag, 0;\n";
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### select correct answer
    $ptx.="@%p	mov.b32		%a$i, %b$i;\n".
          "@%p	mov.b32		%a$j, %b$j;\n";
	&st_local_v2_b32	("[%rptr+4*$i], {%a$i, %a$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func rshift_${sfx}(.param.b$ptr rptr,	// 384-bit
                             .param.b$ptr aptr,
                             .param.u32 count)
{
	.reg.b$ptr	%rptr, %aptr;
	.reg.b32	%a<13>;
	.reg.b32	%b<12>;
	.reg.b32	%count;
	.reg.pred	%p;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%rptr, [rptr];
	ld.param.b32		%count, [count];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### load a[0:11]
	&ld_v2_b32	("{%a$i, %a$j}, [%aptr+4*$i]");
}	&and_b32	("%a12, %a0, 1");
	&neg_s32	("%a12, %a12");
	&sub_u32	("%count, %count, 1");

$ptx.="Loop:\n";
for($i=0; $i<12; $i++) {			### add modulus if a0 is odd
	&ld_const_b32	("%b$i, [P+4*$i]");
	&and_b32	("%b$i, %b$i, %a12");
}
	&add_cc_u32	("%a0, %a0, %b0");
for(my $addc, $i=1; $i<12; $i++) {
	&addc_cc_u32	("%a$i, %a$i, %b$i");
}	&addc_u32	("%a12, 0, 0");
for($i=0, $j=1; $i<12; $i++, $j++) {		### shift a[0:12] right
	&shf_r_wrap_b32	("%a$i, %a$i, %a$j, 1");
}	&and_b32	("%a12, %a0, 1");
        &neg_s32	("%a12, %a12");
	&setp_ne_u32	("%p, %count, 0");
	&sub_u32	("%count, %count, 1");
    $ptx.="@%p	bra.uni		Loop;\n";

for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&st_local_v2_b32	("[%rptr+4*$i], {%a$i, %a$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func lshift_${sfx}(.param.b$ptr rptr,	// 384-bit
                             .param.b$ptr aptr,
                             .param.u32 count)
{
	.reg.b$ptr	%rptr, %aptr;
	.reg.b32	%a<13>;
	.reg.b32	%b<12>;
	.reg.b32	%count;
	.reg.pred	%p;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%rptr, [rptr];
	ld.param.b32		%count, [count];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
	sub.u32			%count, %count, 1;
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### load a[0:11]
	&ld_v2_b32	("{%a$i, %a$j}, [%aptr+4*$i]");
}
$ptx.="Loop:\n";
	&add_cc_u32	("%a0, %a0, %a0");	### add a[0:11] with itself
for($i=1; $i<12; $i++) {			# addition is faster than funnel shift
	&addc_cc_u32	("%a$i, %a$i, %a$i");
}	&addc_u32	("%a12, 0, 0");

final_sub([map("%a$_",(0..12))], [map("%b$_",(0..11))]);

    $ptx.="	setp.ne.u32	%p, %count, 0;\n".
          "	sub.u32		%count, %count, 1;\n".
          "@%p	bra.uni		Loop;\n";
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&st_local_v2_b32	("[%rptr+4*$i], {%a$i, %a$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func mul_by_3_${sfx}(.param.b$ptr rptr,	// 384-bit
                               .param.b$ptr aptr)
{
	.reg.b$ptr	%rptr, %aptr;
	.reg.b32	%a<13>;
	.reg.b32	%b<12>;
	.reg.b32	%c<12>;
	.reg.pred	%p;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%rptr, [rptr];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### load a[0:11]
	&ld_v2_b32	("{%c$i, %c$j}, [%aptr+4*$i]");
}
	&add_cc_u32	("%a0, %c0, %c0");	### add a[0:11] with itself
for($i=1; $i<12; $i++) {
	&addc_cc_u32	("%a$i, %c$i, %c$i");
}	&addc_u32	("%a12, 0, 0");

final_sub([map("%a$_",(0..12))], [map("%b$_",(0..11))]);

	&add_cc_u32	("%a0, %a0, %c0");	### add[0:11]
for($i=1; $i<12; $i++) {
	&addc_cc_u32	("%a$i, %a$i, %c$i");
}	&addc_u32	("%a12, 0, 0");

final_sub([map("%a$_",(0..12))], [map("%b$_",(0..11))]);

for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&st_local_v2_b32	("[%rptr+4*$i], {%a$i, %a$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func from_${sfx}(.param.b$ptr rptr,
                           .param.b$ptr aptr)
{
	.reg.b$ptr	%rptr, %aptr;
	.reg.b32	%lo<12>;
	.reg.b32	%hi<12>;
	.reg.b32	%bi, %ni, %cnt;
	.reg.pred	%p;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%rptr, [rptr];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
	mov.b32			%cnt, 11;	// loop counter
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&ld_v2_b32	("{%lo$i, %lo$j}, [%aptr+4*$i]");
}
	&ld_const_b32	("%bi, [p0]");
	&mul_lo_u32	("%bi, %lo0, %bi");
$ptx.="Loop:\n";
{
	&setp_ne_u32	("%p, %cnt, 0");
	&sub_u32	("%cnt, %cnt, 1");
    for($i=0; $i<12; $i++) {			### reduction
	&ld_const_b32	("%ni, [P+4*$i]");
	&mad_lo_cc_u32	("%lo$i, %bi, %ni, %lo$i");
	&madc_hi_u32	("%hi$i, %bi, %ni, 0");
    }
    $ptx.="@!%p	bra.uni		Lbreak;\n";

	&add_cc_u32	("%lo0, %lo1, %hi0");
    for($i=1, $j=2; $i<11; $i++, $j++) {
	&addc_cc_u32	("%lo$i, %lo$j, %hi$i");
    }	&addc_u32	("%lo11, %hi11, 0");

    &ld_const_b32	("%bi, [p0]");
    &mul_lo_u32		("%bi, %lo0, %bi");
    &bra_uni		("Loop");
$ptx.="Lbreak:\n";
}
	&add_cc_u32	("%lo0, %lo1, %hi0");
    for(my $addc, $i=1, $j=2; $i<11; $i++, $j++) {
	&addc_cc_u32	("%lo$i, %lo$j, %hi$i");
    }	&addc_u32	("%lo11, %hi11, 0");

final_sub([map("%lo$_",(0..11))], [map("%hi$_",(0..11))]);

for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### store the result
	&st_local_v2_b32	("[%rptr+4*$i], {%lo$i, %lo$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func mul_384(.param.b$ptr rptr,
                       .param.b$ptr aptr,
                       .param.b$ptr bptr)
{
	.reg.b$ptr	%rptr, %aptr, %bptr;
	.reg.b32	%in<12>;
	.reg.b32	%even<12>;
	.reg.b32	%odd<12>;
	.reg.b32	%bi, %bj, %cnt;
	.reg.pred	%p;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%bptr, [bptr];
	ld.param.b$ptr		%rptr, [rptr];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local

	mov.b32			%cnt, 5;	// loop counter
	ld.v2.b32		{%bi, %bj}, [%bptr];
	cvta.to.local.u$ptr	%bptr, %bptr;	// bptr is expected to be local
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&ld_v2_b32	("{%in$i, %in$j}, [%aptr+4*$i]");
}
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### a[0:10:2]*b[0]
	&mul_lo_u32	("%even$i, %in$i, %bi");
	&mul_hi_u32	("%even$j, %in$i, %bi");
}
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {		### a[1:11:2]*b[0]
	&mul_lo_u32	("%odd$i, %in$j, %bi");
	&mul_hi_u32	("%odd$j, %in$j, %bi");
}	&st_local_b32	("[%rptr], %even0");
	&add_cc_u32	("%odd0, %odd0, %even1");

$ptx.="Loop:\n";
{
    for($i=0, $j=1, $k=2, $l=3; $i<10; $i+=2, $j+=2, $k+=2, $l+=2) {
	&madc_lo_cc_u32	("%even$i, %in$j, %bj, %even$k");
	&madc_hi_cc_u32	("%even$j, %in$j, %bj, %even$l");
    }	&madc_lo_cc_u32	("%even$i, %in$j, %bj, 0");
	&madc_hi_u32	("%even$j, %in$j, %bj, 0");
    for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {
        $madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&$madc_lo	("%odd$i, %in$i, %bj, %odd$i");
	&madc_hi_cc_u32	("%odd$j, %in$i, %bj, %odd$j");
    }	&addc_u32	("%even11, %even11, 0");
	&st_local_b32	("[%rptr+4], %odd0");
	&add_cc_u32	("%even0, %even0, %odd1");

    $ptx.="	setp.ne.u32	%p, %cnt, 0;\n".
          "@%p	ld.local.v2.b32	{%bi, %bj}, [%bptr+8];\n".
          "@!%p	bra.uni		Lbreak;\n";

    for($i=0, $j=1, $k=2, $l=3; $i<10; $i+=2, $j+=2, $k+=2, $l+=2) {
	&madc_lo_cc_u32	("%odd$i, %in$j, %bi, %odd$k");
	&madc_hi_cc_u32	("%odd$j, %in$j, %bi, %odd$l");
    }	&madc_lo_cc_u32	("%odd$i, %in$j, %bi, 0");
	&madc_hi_u32	("%odd$j, %in$j, %bi, 0");
    for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {
        $madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&$madc_lo	("%even$i, %in$i, %bi, %even$i");
	&madc_hi_cc_u32	("%even$j, %in$i, %bi, %even$j");
    }	&addc_u32	("%odd11, %odd11, 0");
	&st_local_b32	("[%rptr+8], %even0");
	&add_cc_u32	("%odd0, %odd0, %even1");

    $ptx.="	sub.u32		%cnt, %cnt, 1;\n".
          "	add.u$ptr	%bptr, %bptr, 8;\n".
          "	add.u$ptr	%rptr, %rptr, 8;\n".
          "	bra.uni		Loop;\n".
"Lbreak:\n";
}
for($i=1, $j=2; $i<11; $i++,$j++) {
	&addc_cc_u32	("%even$i, %even$i, %odd$j");
}	&addc_u32	("%even$i, %even$i, 0");
for($i=0, $j=1, $k=2; $i<12; $i+=2, $j+=2, $k+=2) {
	&st_local_v2_b32	("[%rptr+4*$k], {%even$i, %even$j}");
}
$ptx.=<<___;
	ret;
}

___

########################################################################
sub sqr_384 {
my @even = @{@_[0]};	# @even is the return value
my @inp  = @{@_[1]};
my ($i, $j, $k, $l) = (0);

$ptx.=<<___;
    {
	.reg.b32	%odd<24>;

___
for($j=2*($i+1), $k=$j+1, $l=$i+2; $l<12; $j+=2, $k+=2, $l+=2) {
	&mul_lo_u32	("@even[$j], @inp[$l], @inp[$i]");
	&mul_hi_u32	("@even[$k], @inp[$l], @inp[$i]");
}
for($j=2*$i,     $k=$j+1, $l=$i+1; $l<12; $j+=2, $k+=2, $l+=2) {
	&mul_lo_u32	("%odd$j, @inp[$l], @inp[$i]");
	&mul_hi_u32	("%odd$k, @inp[$l], @inp[$i]");
}   $ptx.="\n";

while($i<10) {
    $i++;
    for(my $madc_lo, $j=2*($i+1), $k=$j+1, $l=$i+2; $l<11; $j+=2, $k+=2, $l+=2) {
        $madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&$madc_lo	("@even[$j], @inp[$l], @inp[$i], @even[$j]");
	&madc_hi_cc_u32	("@even[$k], @inp[$l], @inp[$i], @even[$k]");
    }	&madc_lo_cc_u32	("@even[$j], @inp[$l], @inp[$i], 0");
	&madc_hi_u32	("@even[$k], @inp[$l], @inp[$i], 0");
    for(my $madc_lo, $j=2*$i,     $k=$j+1, $l=$i+1; $l<12; $j+=2, $k+=2, $l+=2) {
        $madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&$madc_lo	("%odd$j, @inp[$l], @inp[$i], %odd$j");
	&madc_hi_cc_u32	("%odd$k, @inp[$l], @inp[$i], %odd$k");
    }	&addc_u32	("@even[$k], @even[$k], 0")		if ($i<8);

    $i++;
    for(my $madc_lo, $j=2*$i,     $k=$j+1, $l=$i+1; $l<11; $j+=2, $k+=2, $l+=2) {
        $madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&$madc_lo	("%odd$j, @inp[$l], @inp[$i], %odd$j");
	&madc_hi_cc_u32	("%odd$k, @inp[$l], @inp[$i], %odd$k");
    }	&madc_lo_cc_u32	("%odd$j, @inp[$l], @inp[$i], 0");
	&madc_hi_u32	("%odd$k, @inp[$l], @inp[$i], 0");
    for(my $madc_lo, $j=2*($i+1), $k=$j-1, $l=$i+2; $l<12; $j+=2, $l+=2) {
        $madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32; $k+=2;
	&$madc_lo	("@even[$j], @inp[$l], @inp[$i], @even[$j]");
	&madc_hi_cc_u32	("@even[$k], @inp[$l], @inp[$i], @even[$k]");
    }	&addc_u32	("%odd$k, %odd$k, 0")			if($i<8);
}   $ptx.="\n";

	&add_cc_u32	("@even[2], @even[2], %odd1");
for($i=3, $j=2; $i<22; $i++, $j++) {
	&addc_cc_u32	("@even[$i], @even[$i], %odd$j");
}	&addc_u32	("@even[$i], %odd$j, 0");

	&mov_b32	("@even[0], 0");
	&add_cc_u32	("@even[1], %odd0, %odd0");
for($i=2; $i<23; $i++) {
	&addc_cc_u32	("@even[$i], @even[$i], @even[$i]");
}	&addc_u32	("@even[$i], 0, 0");

for(my $madc_lo, $i=0, $j=0, $k=1; $i<12; $i++, $j+=2, $k+=2) {
    $madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&$madc_lo	("@even[$j], @inp[$i], @inp[$i], @even[$j]");
	&madc_hi_cc_u32	("@even[$k], @inp[$i], @inp[$i], @even[$k]");
}   $ptx.="    }\n\n";
}

$ptx.=<<___;
.visible .func sqr_384(.param.b$ptr rptr,
                       .param.b$ptr aptr)
{
    .reg.b$ptr	%rptr, %aptr;
    .reg.b32	%in<12>;
    .reg.b32	%out<24>;

    ld.param.b$ptr	%aptr, [aptr];	// expect generic addresses
    ld.param.b$ptr	%rptr, [rptr];
    cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local

___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
    &ld_v2_b32	("{%in$i, %in$j}, [%aptr+4*$i]");
}   $ptx.="\n";

sqr_384([map("%out$_",(0..23))], [map("%in$_",(0..11))]);

for($j=0, $k=1; $j<24; $j+=2, $k+=2) {
    &st_local_v2_b32	("[%rptr+4*$j], {%out$j, %out$k}");
}
$ptx.=<<___;
    ret;
}

___

########################################################################
sub mul_by_1 {
my @even = @{@_[0]};	# even is in-out
my @odd  = map("%odd$_", (0..11));

$ptx.=<<___;
    {
	.reg.b32	%odd<12>;
	.reg.b32	%ni, %mi, %mj, %cnt;
	.reg.pred	%p;

	mov.b32		%cnt, 5;	// loop counter

	ld.const.b32	%mi, [p0];
	mul.lo.u32	%mi, @even[0], %mi;
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&ld_const_b32	("%ni, [P+4*$j]");
	&mul_lo_u32	("@odd[$i], %mi, %ni");
	&mul_hi_u32	("@odd[$j], %mi, %ni");
}

if (1) {
$ptx.="Loop:\n";

    for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {
	$madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&ld_const_b32	("%ni, [P+4*$i]");
	&$madc_lo	("@even[$i], %mi, %ni, @even[$i]");
	&madc_hi_cc_u32	("@even[$j], %mi, %ni, @even[$j]");
    }	&addc_u32	("@odd[11], @odd[11], 0");
	&add_cc_u32	("@odd[0], @odd[0], @even[1]");

	&ld_const_b32	("%mj, [p0]");
	&mul_lo_u32	("%mj, @odd[0], %mj");

    for($i=0, $j=1, $k=2, $l=3; $i<10; $i+=2, $j+=2, $k+=2, $l+=2) {
	&ld_const_b32	("%ni, [P+4*$j]");
	&madc_lo_cc_u32	("@even[$i], %mj, %ni, @even[$k]");
	&madc_hi_cc_u32	("@even[$j], %mj, %ni, @even[$l]");
    }	&ld_const_b32	("%ni, [P+4*$j]");
	&madc_lo_cc_u32	("@even[$i], %mj, %ni, 0");
	&madc_hi_u32	("@even[$j], %mj, %ni, 0");
    for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {
	$madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&ld_const_b32	("%ni, [P+4*$i]");
	&$madc_lo	("@odd[$i], %mj, %ni, @odd[$i]");
	&madc_hi_cc_u32	("@odd[$j], %mj, %ni, @odd[$j]");
    }	&addc_u32	("@even[11], @even[11], 0");
	&add_cc_u32	("@even[0], @even[0], @odd[1]");

    $ptx.="	setp.eq.u32	%p, %cnt, 0;\n".
          "@%p	bra.uni		Lbreak;\n".
          "	ld.const.b32	%mi, [p0];\n".
          "	mul.lo.u32	%mi, @even[0], %mi;\n";

    for($i=0, $j=1, $k=2, $l=3; $i<10; $i+=2, $j+=2, $k+=2, $l+=2) {
	&ld_const_b32	("%ni, [P+4*$j]");
	&madc_lo_cc_u32	("@odd[$i], %mi, %ni, @odd[$k]");
	&madc_hi_cc_u32	("@odd[$j], %mi, %ni, @odd[$l]");
    }	&ld_const_b32	("%ni, [P+4*$j]");
	&madc_lo_cc_u32	("@odd[$i], %mi, %ni, 0");
	&madc_hi_u32	("@odd[$j], %mi, %ni, 0");

	&sub_u32	("%cnt, %cnt, 1");
	&bra_uni	("Loop");
$ptx.="Lbreak:\n";
} else {	# fully unrolled loop
  for(my $cnt=5;;) {
    for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {
        $madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&ld_const_b32	("%ni, [P+4*$i]");
	&$mad_lo	("@even[$i], %mi, %ni, @even[$i]");
	&madc_hi_cc_u32	("@even[$j], %mi, %ni, @even[$j]");
    }	&addc_u32	("@odd[11], @odd[11], 0");
	&add_cc_u32	("@odd[0], @odd[0], @even[1]");

	&ld_const_b32	("%mj, [p0]");
	&mul_lo_u32	("%mj, @odd[0], %mj");

    for($i=0, $j=1, $k=2, $l=3; $i<10; $i+=2, $j+=2, $k+=2, $l+=2) {
	&ld_const_b32	("%ni, [P+4*$j]");
	&madc_lo_cc_u32	("@even[$i], %mj, %ni, @even[$k]");
	&madc_hi_cc_u32	("@even[$j], %mj, %ni, @even[$l]");
    }	&ld_const_b32	("%ni, [P+4*$j]");
	&madc_lo_cc_u32	("@even[$i], %mj, %ni, 0");
	&madc_hi_u32	("@even[$j], %mj, %ni, 0");
    for(my $madc_lo, $i=0, $j=1; $i<12; $i+=2, $j+=2) {
	$madc_lo = $madc_lo ? madc_lo_cc_u32 : mad_lo_cc_u32;
	&ld_const_b32	("%ni, [P+4*$i]");
	&$mad_lo	("@odd[$i], %mj, %ni, @odd[$i]");
	&madc_hi_cc_u32	("@odd[$j], %mj, %ni, @odd[$j]");
    }	&addc_u32	("@even[11], @even[11], 0");
	&add_cc_u32	("@even[0], @even[0], @odd[1]");

	&ld_const_b32	("%mi, [p0]");
	&mul_lo_u32	("%mi, @even[0], %mi");

    last if (!$cnt--);

    for($i=0, $j=1, $k=2, $l=3; $i<10; $i+=2, $j+=2, $k+=2, $l+=2) {
	&ld_const_b32	("%ni, [P+4*$j]");
	&madc_lo_cc_u32	("@odd[$i], %mi, %ni, @odd[$k]");
	&madc_hi_cc_u32	("@odd[$j], %mi, %ni, @odd[$l]");
    }	&ld_const_b32	("%ni, [P+4*$j]");
	&madc_lo_cc_u32	("@odd[$i], %mi, %ni, 0");
	&madc_hi_u32	("@odd[$j], %mi, %ni, 0");
  }
}
for($i=1, $j=2; $i<11; $i++,$j++) {
    &addc_cc_u32	("@even[$i], @even[$i], @odd[$j]");
}   &addc_u32		("@even[$i], @even[$i], 0");
$ptx.="    }\n";
}

sub final_sub {
my @inout = @{@_[0]};
my @temp = @{@_[1]};
my ($t, $z) = $#inout==12 ? (@inout[12], @inout[12]) : ("%t", "0");

$ptx.=<<___;
    {
	.reg.pred	%p;
	.reg.b32	%t;

___
	&ld_const_b32	("@temp[0], [mP]");	### subtract modulus
	&add_cc_u32	("@temp[0], @inout[0], @temp[0]");
for($i=1; $i<12; $i++) {
	&ld_const_b32	("@temp[$i], [mP+4*$i]");
	&addc_cc_u32	("@temp[$i], @inout[$i], @temp[$i]");
}	&addc_u32	("$t, $z, 0");
	&setp_ne_u32	("%p, $t, 0");
for($i=0; $i<12; $i++) {			### select correct answer
    $ptx.="@%p	mov.b32		@inout[$i], @temp[$i];\n"
}
$ptx.="    }\n";
}

$ptx.=<<___;
.visible .func redc_${sfx}(.param.b$ptr rptr,
                           .param.b$ptr aptr)
{
    .reg.b$ptr	%rptr, %aptr;
    .reg.b32	%inout<24>;

    ld.param.b$ptr	%aptr, [aptr];	// expect generic addresses
    ld.param.b$ptr	%rptr, [rptr];
    cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local

___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
    &ld_v2_b32	("{%inout$i, %inout$j}, [%aptr+4*$i]");
}

mul_by_1([map("%inout$_",(0..11))]);

for($i=12, $j=13; $i<24; $i+=2, $j+=2) {
    &ld_v2_b32	("{%inout$i, %inout$j}, [%aptr+4*$i]");
}
    &add_cc_u32	("%inout0, %inout0, %inout12");
for($i=1, $j=13; $i<11; $i++, $j++) {
    &addc_cc_u32("%inout$i, %inout$i, %inout$j");
}   &addc_u32	("%inout$i, %inout$i, %inout$j");

final_sub([map("%inout$_",(0..11))], [map("%inout$_",(12..23))]);

for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
    &st_local_v2_b32	("[%rptr+4*$i], {%inout$i, %inout$j}");
}
$ptx.=<<___;
    ret;
}

.visible .func add_${sfx}x2(.param.b$ptr rptr,
                             .param.b$ptr aptr,
                             .param.b$ptr bptr)
{
	.reg.b$ptr	%rptr, %aptr, %bptr;
	.reg.b32	%a<13>;
	.reg.b32	%b<12>;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%bptr, [bptr];
	ld.param.b$ptr		%rptr, [rptr];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&ld_v2_b32	("{%a$i, %a$j}, [%aptr+4*$i]");
	&ld_v2_b32	("{%b$i, %b$j}, [%bptr+4*$i]");
}
	&add_cc_u32	("%a0, %a0, %b0");
for($i=1; $i<12; $i++) {
	&addc_cc_u32	("%a$i, %a$i, %b$i");
}
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&st_local_v2_b32("[%rptr+4*$i], {%a$i, %a$j}");
	&ld_v2_b32	("{%a$i, %a$j}, [%aptr+48+4*$i]");
	&ld_v2_b32	("{%b$i, %b$j}, [%bptr+48+4*$i]");
}
for($i=0; $i<12; $i++) {
	&addc_cc_u32	("%a$i, %a$i, %b$i");
}	&addc_u32	("%a12, 0, 0");

final_sub([map("%a$_",(0..12))], [map("%b$_",(0..11))]);

for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&st_local_v2_b32("[%rptr+48+4*$i], {%a$i, %a$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func sub_${sfx}x2(.param.b$ptr rptr,
                             .param.b$ptr aptr,
                             .param.b$ptr bptr)
{
	.reg.b$ptr	%rptr, %aptr, %bptr;
	.reg.b32	%a<13>;
	.reg.b32	%b<12>;
	.reg.pred	%p;

	ld.param.b$ptr		%aptr, [aptr];	// expect generic addresses
	ld.param.b$ptr		%bptr, [bptr];
	ld.param.b$ptr		%rptr, [rptr];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
___
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&ld_v2_b32	("{%a$i, %a$j}, [%aptr+4*$i]");
	&ld_v2_b32	("{%b$i, %b$j}, [%bptr+4*$i]");
}
	&sub_cc_u32	("%a0, %a0, %b0");
for($i=1; $i<12; $i++) {
	&subc_cc_u32	("%a$i, %a$i, %b$i");
}
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&st_local_v2_b32	("[%rptr+4*$i], {%a$i, %a$j}");
	&ld_v2_b32		("{%a$i, %a$j}, [%aptr+48+4*$i]");
	&ld_v2_b32		("{%b$i, %b$j}, [%bptr+48+4*$i]");
}
for($i=0; $i<12; $i++) {
	&subc_cc_u32	("%a$i, %a$i, %b$i");
}	&subc_u32	("%a12, 0, 0");
for($i=0; $i<12; $i++) {
	&ld_const_u32	("%b$i, [P+4*$i]");
	&and_b32	("%b$i, %b$i, %a12");
}
	&add_cc_u32	("%a0, %a0, %b0");
for(my $addc, $i=1; $i<11; $i++) {
	&addc_cc_u32	("%a$i, %a$i, %b$i");
}	&addc_u32	("%a$i, %a$i, %b$i");
for($i=0, $j=1; $i<12; $i+=2, $j+=2) {
	&st_local_v2_b32	("[%rptr+48+4*$i], {%a$i, %a$j}");
}
$ptx.=<<___;
	ret;
}

.visible .func vec_load_global(.param.b$ptr rptr,
                               .param.b$ptr aptr,
                               .param.b32 sz)	// has to be divisible by 16
{
	.reg.b$ptr	%rptr, %aptr1, %aptr2, %tptr;
	.reg.b32	%a<13>, %l, %lptr;
	.reg.pred	%odd, %p;

	ld.param.b$ptr		%aptr1, [aptr];
	cvta.to.global.u$ptr	%aptr1, %aptr1;	// a 'nop'
___
$ptx.=<<___	if ($ptr==64);
	// copy neighbour's pointer
	mov.b64			{%a0, %a1}, %aptr1;
	shfl.sync.bfly.b32	%a2, %a0, 1, 0x1f, -1;
	shfl.sync.bfly.b32	%a3, %a1, 1, 0x1f, -1;
	mov.b64			%aptr2, {%a2, %a3};
___
$ptx.=<<___	if ($ptr!=64);
	// copy neighbour's pointer
	shfl.sync.bfly.b32	%aptr2, %aptr1, 1, 0x1f, -1;
___
$ptx.=<<___;
	mov.b32		%l, %laneid;
	and.b32		%l, %l, 1;
	setp.ne.u32	%odd, %l, 0;

	add.u$ptr	%rptr,  %aptr1, 16;
	add.u$ptr	%tptr,  %aptr2, 16;
@%odd	mov.b$ptr	%aptr2, %rptr;
@%odd	mov.b$ptr	%aptr1, %tptr;

	ld.param.b$ptr	%rptr, [rptr];
	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
	ld.param.b32	%l,    [sz];
	add.u$ptr	%rptr, %rptr, -32;

Loop:
	// coalesce 256 bits from even thread
	ld.global.cg.nc.v4.b32	{%a0,%a1,%a2,%a3}, [%aptr1];
	// coalesce 256 bits from odd thread
	ld.global.cg.nc.v4.b32	{%a4,%a5,%a6,%a7}, [%aptr2];

	add.u$ptr		%aptr1, %aptr1, 32;
	add.u$ptr		%aptr2, %aptr2, 32;
	add.u$ptr		%rptr,  %rptr, 32;
	setp.gt.s32		%p, %l, 16;
	sub.s32			%l, %l, 32;

	// transpose 128-bit halves
	shfl.sync.bfly.b32	%a8,  %a0, 1, 0x1f, -1;
	shfl.sync.bfly.b32	%a9,  %a1, 1, 0x1f, -1;
	shfl.sync.bfly.b32	%a10, %a2, 1, 0x1f, -1;
	shfl.sync.bfly.b32	%a11, %a3, 1, 0x1f, -1;
	shfl.sync.bfly.b32	%a12, %a4, 1, 0x1f, -1;
@!%odd	mov.b32			%a4,  %a8;
	shfl.sync.bfly.b32	%a8,  %a5, 1, 0x1f, -1;
@!%odd	mov.b32			%a5,  %a9;
	shfl.sync.bfly.b32	%a9,  %a6, 1, 0x1f, -1;
@!%odd	mov.b32			%a6,  %a10;
	shfl.sync.bfly.b32	%a10, %a7, 1, 0x1f, -1;
@!%odd	mov.b32			%a7,  %a11;
@%odd	mov.b32			%a0,  %a12;
@%odd	mov.b32			%a1,  %a8;
@%odd	mov.b32			%a2,  %a9;
@%odd	mov.b32			%a3,  %a10;

        // save with 128-bit granularity
	st.local.v2.b32		[%rptr+4*0], {%a0, %a1};
	st.local.v2.b32		[%rptr+4*2], {%a2, %a3};
@%p	st.local.v2.b32		[%rptr+4*4], {%a4, %a5};
@%p	st.local.v2.b32		[%rptr+4*6], {%a6, %a7};

	setp.gt.s32		%p, %l, 0;
@%p	bra.uni		Loop;

	ret;
}
___

sub vec_select {
my $sz = shift;

$ptx.=<<___;
.visible .func vec_select_$sz(.param.b$ptr rptr,
                              .param.b$ptr inp1,
                              .param.b$ptr inp2,
                              .param.b32 sel_a)
{
	.reg.b$ptr	%rptr, %inp1, %inp2;
	.reg.b64	%a<6>, %b<6>;
	.reg.b32	%sel_a;
	.reg.pred	%p;

	ld.param.b$ptr		%inp1, [inp1];
	ld.param.b$ptr		%inp2, [inp2];
	ld.param.b$ptr		%rptr, [rptr];
	ld.param.b32		%sel_a, [sel_a];
	setp.eq.u32		%p, %sel_a, 0;

	cvta.to.local.u$ptr	%rptr, %rptr;	// rptr is expected to be local
___
for($sz/=8, $j=0; $j<$sz;) {
    for($i=0; $i<6; $i++, $j++) {
        $ptx.="	ld.b64		%a$i, [%inp1+8*$j];\n".
              "	ld.b64		%b$i, [%inp2+8*$j];\n"	if ($j<6);
    }
    for($i=0; $i<6; $i++) {
        $ptx.="@%p	mov.b64		%a$i, %b$i;\n"
    }
    for($k=$j, $j-=6, $i=0; $i<6; $i++, $j++, $k++) {
        $ptx.="	st.local.b64	[%rptr+8*$j], %a$i;\n";
        $ptx.="	ld.b64		%a$i, [%inp1+8*$k];\n".
              "	ld.b64		%b$i, [%inp2+8*$k];\n"	if ($j<($sz-6));
    }
}
$ptx.=<<___;

	ret;
}
___
}
vec_select(48);
vec_select(96);
vec_select(192);
vec_select(144);
vec_select(288);

print $ptx;
close STDOUT;
