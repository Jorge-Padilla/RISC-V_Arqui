.text 
__zero:
addi a2, zero, 0x3
jal ra,__one
jal zero,__three
__one:
slti t0, a2, 0x1
beq t0, zero, __two
addi a0, zero, 0x1
jalr zero, ra, 0x0
__two:
addi sp, sp, -8
sw ra, 0x4(sp)
sw a2, 0x0(sp)
addi a2, a2, -1
jal ra, __one
lw a2, 0x0(sp)
lw ra, 0x4(sp)
addi sp, sp, 0x8
mul a0, a2, a0
jalr zero, ra, 0x0
__three:
nop