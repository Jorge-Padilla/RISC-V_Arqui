###################################################
##        Jorge Alberto Padilla Gutierrez        ##
##                    test.asm                   ##
###################################################
.data

.text
	auipc	ra, 0xfc10
	lui		s0, 0xfc10
	
	addi	t0, zero, 1
	addi	t1, zero, 2
	addi	t2, zero, 3
	addi	t3, zero, 4
	addi	t4, zero, 5
	addi	t5, zero, 6
	addi	t6, zero, 7

	add		s0, t0, t1
	sub		s1, t1, t2
	xor		s2, t2, t2
	or		s3, t3, t1
	and		s4, t4, t0
	sll		s5, t5, t1
	srl		s6, t6, t2
	sra		s7, t0, t3
	slt		s8, t1, t4
	sltu	s9, t2, t5
	mul		s10, t3, t6

	addi	s0, t0, t6
	xori	s1, t1, t5
	ori		s2, t2, t4
	andi	s3, t3, t3
	slli	s4, t4, t2
	srli	s5, t5, t1
	srai	s6, t6, t0
	slti	s7, t5, t1
	sltiu	s8, t4, t2

	sw		s3, 0(ra)