###################################################
##        Jorge Alberto Padilla Gutierrez        ##
##        Carlos Rodrigo Fernandez Garcia        ##
##                   test1.asm                   ##
###################################################
.data
	null:	.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	vals:	.word 8 -2 4 -1 5 -6 9 0 3 -7

.text
auipc	s0, 0xFC10	# Set Memory Map Pointer
addi	s1, s0, 0x0040	# Set Last Value Pointer
addi	s2, s0, 0x0064	# Set Last Value Pointer

lw	s3, 0(s1)	# Store first value as smalest
__main:
	lw	zero, 0(s1)		
	lw	sp, 8(s1)		
	lw	tp, 12(s1)		
	add	sp, sp, tp		
	and	gp, sp, zero
	lw	t0, 10(s1)
	or	t2, t0, zero
	lw	t1, 4(s1)
	or	t2, t2, t1
	slt	a0, zero, t2
	slt	a1, t2, zero
	addi	t6, zero, -1
	beq	t2, zero, __main
	jal	zero, __label1
__label2:
	beq	zero, zero, __label2
__label1:
	jal	a4, __label2