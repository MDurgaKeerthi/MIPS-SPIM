   .data
L1: .word 4, 7, 1, 9, 3, 71, 45, 10, 8
L2: .space 4
hello:	.asciiz "the maximum is: "

.text
main:

	
	move $s0,  $zero    #t0 is i
    add $s6, $0, 36   #size is 9*4
    lw $s7, L1($s0)   #loading s7 with first element of array
   add $s5, $s7, $0   #max is intializd to first element of array s5 is max
loop:
    lw $s7, L1($s0)   #updating array element
    slt $t3, $s5, $s7  #comparing array element and max
    bne $t3, $zero, max  # going to max label
    loop1:
    addi $s0, $s0, 4        #increment max
    beq $s0, $s6, exit      #exiting if i goes beyond size
    j loop

max:
    move $s5, $s7       #updating max
    j loop1

exit:
    li $v0, 4
    la $a0, hello    #printing string
    syscall    

    li $v0, 1       #printing max
    move $a0, $s5
    syscall

     li $v0, 10          #ending program
    syscall