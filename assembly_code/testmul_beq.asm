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
addi	s2, s0, 0x0070	# Set Last Value Pointer

__main:
	lw	s3, 0(s1)
	lw	s4, 4(s1)
	
__muls:
	mul	t0, s3, s4
        beq	t0, zero, __main
        beq	a0, zero, __main