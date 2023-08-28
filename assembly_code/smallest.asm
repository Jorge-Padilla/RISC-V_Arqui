###################################################
##        Jorge Alberto Padilla Gutierrez        ##
##        Carlos Rodrigo Fernandez Garcia        ##
##                  smallest.asm                 ##
###################################################
.data
	null:	.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	vals:	.word 8 -2 4 -1 5 -6 9 0 3 -7

.text
auipc	s0, 0xFC10	# Set Memory Map Pointer
addi	s1, s0, 0x0044	# Set Last Value Pointer
addi	s2, s0, 0x0064	# Set Last Value Pointer

lw	s3, 0(s1)	# Store first value as smalest
__loop:
	addi	s1, s1, 4		# Increment Pointer
	lw	s4, 0(s1)		# Read next value
	slt	s5, s4, s3		# Set bit if next value is smaller
	beq	s5, zero, __next	# If not zero, go to next value
	add	s3, s4, zero		# Move the new smalest value
__next:
	beq	s1, s2, __store		# If we read all values, end loop
	jal	zero, __loop		# Continue loop
__store:
	sw	s3, 4(s2)		# Store smallest in memory
__end:
	jal	zero, __end		# End program