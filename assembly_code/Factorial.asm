###################################################
##        Jorge Alberto Padilla Gutierrez        ##
##                Factorial.asm                  ##
###################################################
.data
	# null:	.word 0 0 0 0 0 0 0 0 0 0 0 0 12 0 1 0
.text
auipc s0, 0xFC10	# Set Memory Map locations for GPIO and UART
addi s1, s0, 0x0024	# 0x10010024 = GPIO_Out
addi s2, s0, 0x0028	# 0x10010028 = GPIO_In
addi s3, s0, 0x0030	# 0x10010030 = Rx_Data
addi s4, s0, 0x0034	# 0x10010034 = Tx_Data
addi s5, s0, 0x0038	# 0x10010038 = Rx_Ready
addi s6, s0, 0x003C	# 0x1001003C = Tx_Send

__loop:
jal	ra, __main
jal	zero, __loop

# int main(void) {
__main:
	# while (!UART.Rx_Ready);
	__whileRx:
		lw	t0, 0(s5)
		beq	t0, zero, __whileRx
	# int rx = UART.Rx;
	lw	s7, 0(s3)
	# int factorial = Factorial(rx);
	addi	sp, sp, -4
	sw	ra, 0(sp)
	add	a2, s7, zero
	jal	ra, __Factorial
	lw	ra, 0(sp)
	addi	sp, sp, 4
	addi	s8, a0, 0
	# for(int i = 4; i > 0; i--){
	addi	s9, zero, 4
	__forUART:
	beq	s9, zero, __outUART
	__loopUART:
		# UART.Tx = (factorial >> (i-1)*3) & 255;
		addi	t1, s9, -1
		slli	t2, t1, 3
		srl	t3, s8, t2
		andi	t4, t3, 0xFF
		sw	t4, 0(s4)
		# UART.Tx_Send = 1;
		addi	t5, zero, 1
		sw	t5, 0(s6)
		# while(UART.Tx_Send);
		__whileTx:
			lw	t6, 0(s6)
			bne	t6, zero, __whileTx
	# }
	addi	s9, s9, -1
	jal	zero, __forUART
	__outUART:
	# return 0;
	addi	a0, zero, 0
	jalr	zero, ra, 0
# }

# int Factorial(int n){
__Factorial:
	# if (n < 1){
	slti	t0, a2, 1
	beq	t0, zero, __else
	__if:
		# return(1);
		addi	a0, zero, 1
		jalr	zero, ra, 0
	# } else {
	__else:
		# return(n*Factorial(n - 1));
		addi	sp, sp, -8
		sw	ra, 4(sp)
		sw	a2, 0(sp)
		addi	a2, a2, -1
		jal	ra, __Factorial
		lw	a2, 0(sp)
		lw	ra, 4(sp)
		addi	sp, sp, 8
		mul	a0, a2, a0
		jalr	zero, ra, 0
	# }
# }

# nop
__end:
addi	zero, zero, 0x0
