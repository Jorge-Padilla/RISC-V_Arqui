###################################################
##        Jorge Alberto Padilla Gutierrez        ##
##                 Potencia.asm                  ##
###################################################
.data
	
.text
auipc s0, 0xFC10	# Set Memory Map locations for GPIO and UART
addi s1, s0, 0x0024	# 0x10010024 = GPIO Out
addi s2, s0, 0x0028	# 0x10010028 = GPIO In
addi s3, s0, 0x0030	# 0x10010030 = Rx Data
addi s4, s0, 0x0034	# 0x10010034 = Tx Data
addi s5, s0, 0x0038	# 0x10010038 = Rx Ready
addi s6, s0, 0x003C	# 0x1001003C = Tx Send

__loop:
jal	ra, __main
jal	zero, __loop

# int main(void) {
__main:
	# int potencia;
	addi	s0, zero, 0
	# potencia = Potencia(6, 6);
	addi	sp, sp, -4
	sw	ra, 0(sp)
	addi	a2, zero, 6
	addi	a3, zero, 6
	jal	ra, __Potencia
	lw	ra, 0(sp)
	addi	sp, sp, 4
	addi	s0, a0, 0
	# return 0;
	addi	a0, zero, 0
	jalr	zero, ra, 0
# }

# int Potencia(int m,int n){
__Potencia:
	# if (n < 1){
	slti	t0, a3, 1
	beq	t0, zero, __else
	__if:
		# return(1);
		addi	a0, zero, 1
		jalr	zero, ra, 0
	# } else {
	__else:
		# return(m*Potencia(m,n - 1));
		addi	sp, sp, -12
		sw	ra, 8(sp)
		sw	a2, 4(sp)
		sw	a3, 0(sp)
		addi	a3, a3, -1
		jal	ra, __Potencia
		lw	a3, 0(sp)
		lw	a2, 4(sp)
		lw	ra, 8(sp)
		addi	sp, sp, 12
		mul	a0, a2, a0
		jalr	zero, ra, 0
	# }
# }

# nop
__end:
addi	zero, zero, 0x0
