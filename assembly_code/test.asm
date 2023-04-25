###################################################
##        Jorge Alberto Padilla Gutierrez        ##
##                    test.asm                   ##
###################################################
.data

.text
	auipc	ra, 0xfc10
	
	addi	t0, zero, 1
	addi	t1, zero, 2
	addi	t2, zero, 3
	addi	t3, zero, 4
	addi	t4, zero, 5
	addi	t5, zero, 6
	addi	t6, zero, 7
	
	add	s0, t4, t6
	and	s1, s0, t2
	xor	s2, s0, t3
	
	add	s0, t4, t6
	and	s3, t2, s0
	xor	s4, t3, s0
	
	add	s0, t4, t6
	and	s5, s0, s0
	xor	s6, s0, s0
	
	add	s0, t4, t6
	and	s7, s0, s1
	xor	s8, s0, s7
	
	add	s0, t4, t6
	and	s9, s1, s0
	xor	s10, s9, s0
	
	addi	s0, ra, 4
	sw	s0, 0(ra)
	
	addi	s1, ra, 8
	sw	s1, 4(ra)
	sw	s1, 8(ra)
	
	addi	s2, ra, 12
	sw	s0, 0(s2)
	sw	s1, 4(s2)
	
	addi	s3, ra, 20
	sw	s3, 0(s3)
	sw	s3, 4(s3)
	
	addi	s0, ra, 24
	addi	s1, ra, 28
	sw	s1, 0(s0)
	
	addi	s0, ra, 24
	addi	s1, ra, 28
	sw	s0, 0(s1)
	
	lw	s0, 0(ra)
	addi	s1, s0, 1
	
	lw	s0, 4(ra)
	add	s2, s0, s1
	add	s3, s1, s0
	
	lw	s0, 8(ra)
	add	s4, s1, s0
	add	s5, s0, s1
	
	lw	s0, 12(ra)
	add	s6, s0, s0
	add	s7, s0, s0
	
	lw	s0, 0(ra)
	xor	s1, t0, t1
	add	s2, s0, t0
	
	lw	s0, 4(ra)
	xor	s2, t1, t2
	add	s3, t0, s0
	
	lw	s0, 8(ra)
	xor	s3, t2, t3
	add	s4, s0, s0
	
	lw	s0, 0(ra)
	sw	s0, 4(ra)
	
	add	s0, ra, zero
	lw	s1, 4(s0)
	