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
	