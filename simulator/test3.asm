
.text
.main:

addi $s0, $0, 9
addi $s7, $0, 4

mul $t5, $t1, $s7
addi $s1, $s1, $t6
addi $t1, $t1, 1
sub $t3, $t5, $t1
nor $t6, $t3, $s7
ori $t2, $t5, $s1

halt
