.text
.main:

addi $t1, $0, 9
addi $t4, $t1, 6
slti $t8, $t4, $t1

sub $t2, $t1, $t4
mul $t7, $t1, $t2
and $t6, $t1, $t4
or $t5, $t2, $t7
ori $t3, $t1, 2
andi $s0, $t7, 8
nor $s3, $t6, $t2

halt
