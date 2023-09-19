###################################################
##        Jorge Alberto Padilla Gutierrez        ##
##        Carlos Rodrigo Fernandez Garcia        ##
##                  testmul.asm                  ##
###################################################
.data
	null:	.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	vals:	.word 8 -2 4 -1 5 -6 9 0 3 -7

.text
auipc	s0, 0xFC10	# Set Memory Map Pointer
addi	s1, s0, 0x0040	# Set Last Value Pointer
addi	s2, s0, 0x0064	# Set Last Value Pointer

__main:
	lw	s3, 0(s1)
	lw	s4, 4(s1)
	lw	s5, 8(s1)
	lw	s6, 12(s1)
	lw	s7, 16(s1)
	lw	s8, 20(s1)
	lw	s9, 24(s1)
	lw	s10, 28(s1)
__muls:
	mul	t0, s3, s4
	mul	t1, s4, s5
	mul	t2, s5, s6
	mul	t3, s6, s7
	mul	t4, s7, s8
	add	t5, t4, t3
	add	t6, t5, t4
	mul	t0, s8, s9
	add	t1, t2, t3
	add 	t2, t3, t4
	mul	t3, t0, t0
	add	t3, t0, t0
	add	t4, t0, t0
	add	t5, t0, t0
	add	t6, t3, t3
	lw	t0, 0(s1)
	mul	t1, t0, t6
	beq	t1, zero, __main
	add	t0, zero, zero
	addi	t1, zero 2
	addi	t3, zero, 0x10
	addi	t4, zero, 1
__loop:
	addi	t0, t0, 1
	mul	t2, t0, t1
	beq	t2, t3, __end
	jal	zero, __loop
__end:
	mul	t0, t2, t4
	sw	t0, 4(s2)
	addi	zero, zero, 0
