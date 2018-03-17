.data
l1 : .word 3 5 6 end

.text
.main:

add $t0, $0, $0 
addi $t1, $0, 9
addi $t4, $t1, 6
slti $t8, $t4, $t1
la $s5, l1
lw $s6, 4($s5) 

sw $t4, 4($s5)


sub $t2, $t1, $t4
mul $t7, $t1, $t2
and $t6, $t1, $t4
slt $t9, $t4, $s6
sw $0, 8($s5)
beq $s3, $0, exit
for:
or $t5, $t2, $t7
ori $t3, $t1, 2
andi $s0, $t7, 8
nor $s3, $t6, $t2
j exit



exit:
addi $s0, $0, 12 

halt
