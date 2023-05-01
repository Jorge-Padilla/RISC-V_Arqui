###################################################
##        Jorge Alberto Padilla Gutierrez        ##
##              matriz_x_vector.asm              ##
###################################################
.data
	null:	.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	vector:	.word 1 2 3 4
	row_0:	.word 1 2 3 4
	row_1:	.word 5 6 7 8
	row_2:	.word 9 10 11 12
	row_3:	.word 13 14 15 16
	result:	.word 0 0 0 0

.text
auipc	s0, 0xFC10	# Set Memory Map locations for UART
addi	s1, s0, 0x0024	# 0x10010024 = GPIO_Out
addi	s2, s0, 0x0028	# 0x10010028 = GPIO_In
addi	s3, s0, 0x0030	# 0x10010030 = Rx_Data
addi	s4, s0, 0x0034	# 0x10010034 = Tx_Data
addi	s5, s0, 0x0038	# 0x10010038 = Rx_Ready
addi	s6, s0, 0x003C	# 0x1001003C = Tx_Send

# int vector[4] = { 1, 2, 3, 4 };
addi	s7, s0, 0x40
# int row[4][4] = {{ 1, 2, 3, 4 }, { 5, 6, 7, 8 }, { 9, 10, 11, 12 }, { 13, 14, 15, 16 }};
addi	s8, s0, 0x50
# int result[4] = { 0, 0, 0, 0 };
addi	s9, s0, 0x90
# int rows = 4
addi	s10, zero, 4

__loop:
jal	ra, __main
jal	zero, __loop

# int main(void) {
__main:
	# int *mem = &vector;
	add	t0, s7, zero
	# for (i = 0; i < 20; i++) {
	addi	t1, zero, 0
	__forUART:
	slti	t2, t1, 20
	beq	t2, zero, __outUART
		# while (!UART.Rx_Ready);
		__whileRx:
			lw	t3, 0(s5)
			beq	t3, zero, __whileRx
		# *mem = UART.Rx;
		lw	s11, 0(s3)
		sw	s11, 0(t0)
		# mem++;
		addi, t0, t0, 4
	# }
	addi	t1, t1, 1
	jal	zero, __forUART
	__outUART:
	# for (i = 0; i < rows; i++) {
	addi	t0, zero, 0
	__for1:
	slt	t1, t0, s10
	beq	t1, zero, __out1
	__loop1:
		# result[i] = DotProduct(vector, row[i]);
		slli	t2, t0, 2
		slli	t3, t0, 4
		add	s11, t2, s9
		add	t4, t3, s8
		addi	sp, sp, -4
		sw	ra, 0(sp)
		addi	a2, s7, 0
		addi	a3, t4, 0
		jal	ra, __DotProduct
		lw	ra, 0(sp)
		addi	sp, sp, 4
		sw	a0, 0(s11)
	# }
	addi	t0, t0, 1
	jal	zero, __for1
	__out1:
	# for(int i = 0; i < rows; i--){
	addi	t0, zero, 0
	__forSEND:
	slt	t1, t0, s10
	beq	t1, zero, __outSEND
	__loopSEND:
		# UART.Tx = DotProduct[i];
		slli	t2, t0, 2
		add	t3, t2, s9
		lw	t4, 0(t3)
		sw	t4, 0(s4)
		# UART.Tx_Send = 1;
		addi	t5, zero, 1
		sw	t5, 0(s6)
		# while(UART.Tx_Send);
		__whileTx:
			lw	t6, 0(s6)
			bne	t6, zero, __whileTx
	# }
	addi	t0, t0, 1
	jal	zero, __forSEND
	__outSEND:
	# return 0;
	addi	a0, zero, 0
	jalr	zero, ra, 0
# }

# int DotProduct(int[] a, int[] b) [
__DotProduct:
	# int dot = 0
	addi	t6, zero, 0
	# for (i = 0; i < colums; i++) {
	addi	t1, zero, 0
	__for2:
	slt	t2, t1, s10
	beq	t2, zero, __out2
	__loop2:
		# dot = dot + ProductFunction(a[i], b[i]);
		slli	t3, t1, 2
		add	t4, t3, a2
		add	t5, t3, a3
		addi	sp, sp, -12
		sw	ra, 8(sp)
		sw	a2, 4(sp)
		sw	a3, 0(sp)
		lw	a2, 0(t4)
		lw	a3, 0(t5)
		jal	ra, __ProductFunction
		lw	a3, 0(sp)
		lw	a2, 4(sp)
		lw	ra, 8(sp)
		addi	sp, sp, 12
		add	t6, t6, a0
	# }
	addi	t1, t1, 1
	jal	zero, __for2
	# return dot;
	__out2:
	addi	a0, t6, 0
	jalr	zero, ra, 0
# }

# int ProductFunction(int a, int b) {
__ProductFunction:
	# return(a*b);
	mul	a0, a2, a3
	jalr	zero, ra, 0
# }

# nop
__end:
addi	zero, zero, 0x0
addi	zero, zero, 0x0
addi	zero, zero, 0x0
addi	zero, zero, 0x0
addi	zero, zero, 0x0
