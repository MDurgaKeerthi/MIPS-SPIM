#program: insertion sort 

.data
myarray: .space 450
threespaces: .asciiz "    " 
newline: .asciiz "\n"
header: .asciiz "INSERTION SORT"
msg1: .asciiz "enter the number of numbers(please enter <110): "
msg2: .asciiz "enter the starting number(a): "
msg3: .asciiz "enter the difference(d)as negative number for decreasing sequence and positive number for icreasing sequence :  " 
rmsg1: .asciiz "enter seed x: "
rmsg2: .asciiz "enter seed y: "
rmsg3: .asciiz "enter seed z: "
rmsg4: .asciiz "enter seed w: "
choice: .asciiz "enter 0 to exit, 1 for arithmatic Sequence and 2 for random numbers: "
prompt1: .asciiz "1.Sequence in ascending order is taken as input "
prompt2: .asciiz "2.Sequence in descending order is taken as input "
prompt3: .asciiz "3.Sequence in random order is taken as input "
sorted: .asciiz "the sorted order: " 
counter: .asciiz "The number of comparisions are: "

.text
main:
    li $v0,4
    la $a0,header                  #printing header
    syscall

    li $v0,4
    la $a0,newline                  #printing newline
    syscall

    la $s4, myarray

while:
    li $v0, 4
    la $a0, choice                  #asking for type of input
    syscall

    li $v0,5
    syscall
    move $t0, $v0                   #input 

    beq $t0, 0, exit                #going to labels accordingly
    beq $t0, 1, arthimatic
    beq $t0, 2, random
    addi $t8, $0, 2 
    slt $t7, $t8, $t0                 #2 < input
    beq $t7, 1, exit
    
arthimatic:                         #loop for arithmatic Sequence
    li $v0, 4
    la $a0, msg1                    #prompt for entering the number of elements
    syscall

    li $v0,5
    syscall
    move $s5, $v0                   #s5 is number of numbers

    li $v0, 4
    la $a0, msg2
    syscall                         #prompt for entering the starting value

    li $v0,5
    syscall
    move $s0, $v0                   #s0 is starting value

    li $v0, 4
    la $a0, msg3
    syscall                         #prompt for entering the difference

    li $v0,5
    syscall
    move $s1, $v0                   #s1 is difference

    slt $t1, $s1, $0
    beq $t1, 1, negativeprompt
    li $v0, 4
    la $a0, prompt1                 #prompts whether increasing or decreasing Sequence
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    j next
    negativeprompt: li $v0, 4
                    la $a0, prompt2
                    syscall
                    li $v0, 4
                    la $a0, newline
                    syscall
next:  
    addi $t0, $0, 0   # i is 0
    sll $t9, $s5, 2
loop:    
    sw $s0, myarray($t0)            #finding the elements for arithmatic Sequence                
    addi $t0, $t0, 4
    add $s0, $s0, $s1
    bne $t0, $t9, loop
    j call

random:                             #loop for random number Sequence
    li $v0, 4
    la $a0, msg1                    #prompt for entering the number of elements
    syscall
    li $v0,5
    syscall
    move $s5, $v0                   #s5 is number of numbers

    li $v0, 4
    la $a0, rmsg1                   #prompt for entering the seed x
    syscall
    li $v0,5
    syscall
    move $s0, $v0                   #x

    li $v0, 4
    la $a0, rmsg2                   #prompt for seed y
    syscall
    li $v0,5
    syscall
    move $s1, $v0                   #y

    li $v0, 4
    la $a0, rmsg3                   #prompt for entering the seed z
    syscall
    li $v0,5
    syscall
    move $t4, $v0                   #z 

    li $v0, 4
    la $a0, rmsg4                   #prompt for entering the seed w
    syscall
    li $v0,5
    syscall
    move $t5, $v0                   #w

    li $v0, 4
    la $a0, prompt3                 #heading of random order
    syscall

    addi $t0, $0, 0
    sll $t9, $s5, 2
rand:                               #loop finding the random elements 
    addi $t1, $s0, 0                #t = x
    sll $t2, $t1, 11                #t<<11
    xor $t1, $t1, $t2               # t ^= t<<11
    srl $t2, $t1, 8                 #t>>8 
    xor $t1, $t1, $t2               #t ^= t>>8
    move $s0, $s1                   #x = y
    move $s1, $t4                   #y = z
    move $t4, $t5                   #z = w
    srl $t2, $t5, 19                #w>>19
    xor $t5, $t5, $t2               # w ^= w>>19 
    xor $t5, $t5, $t1               #w ^= t
    sw $t5, myarray($t0)            #getting the random element
    addi $t0, $t0, 4
    bne $t0, $t9, rand              #looping
    j call


call:
    move $a0, $s4
    move $a1, $s5
    jal sort                        #caling the sort function

    li $v0, 4
    la $a0, sorted                  #printing the statement
    syscall
    addi $t0, $0, 0
print:    
    lw $t6, myarray($t0)
    li $v0, 1
    move $a0, $t6                   #printing elements
    syscall
    li $v0, 4
    la $a0, threespaces             #printing spaces
    syscall
    addi $t0, $t0, 4
    bne $t0, $t9, print    
    li $v0, 4
    la $a0, newline                 #printing counter
    syscall
    j while                         #continuing the process

exit:    li $v0, 10
         syscall                    #end of program

sort:
    addi $sp, $sp, -20              #putting to stack
    sw $ra, 16($sp)
    sw $s3, 12($sp)
    sw $s2, 8($sp)
    sw $s6, 4($sp)
    sw $s7, 0($sp)

    move $s2, $a0                   #myarray
    move $s3, $a1                   #size

    addi $s7, $0, 1                 #$s7 is i
    addi $s0, $0, 0                 #counter

    for1: slt $t2, $s7, $s3         #i < size
          beq $t2, $0, exit1
          sll $t2, $s7, 2           #i*4
          add $t2, $t2, $s2         #address of a[i]
          lw $s5, 0($t2)            #temp = a[i]
          addi $s6, $s7, -1         #$s6 is j
    for2: 
        beq $s6, -1, exit2          #j>=0
        sll $t2, $s6, 2             #4 * j
        add $t3, $t2, $s2           #address of a[j]
        lw $t3, 0($t3)              #a[j]
        slt $t2, $s5, $t3           #comparing a[i] and a[j]
        addi $s0, $s0, 1            #incrementing the counter
        beq $t2, $0, exit2
        addi $t2, $s6, 1            #j+1
        sll $t2, $t2, 2             # 4 * (j+1)
        sw $t3, myarray($t2)        #a[j+1] = a[j]    
        addi $s6, $s6, -1           #j--
        j for2
     exit2: 
            addi $t2, $s6, 1        #j+1
            sll $t2, $t2, 2         #4 * (j+1)
            sw $s5, myarray($t2)    #a[j+1] = temp
            addi $s7, $s7, 1        #i++
            j for1          
    exit1:  
            li $v0, 4
            la $a0, counter
            syscall
            li $v0, 1
            move $a0, $s0           #printing the number of comparisions
            syscall
            li $v0, 4
            la $a0, newline         #printing the newline
            syscall
            lw $s7, 0($sp)
            lw $s6, 4($sp)
            lw $s2, 8($sp)
            lw $s3, 12($sp)
            lw $ra, 16($sp) 
            addi $sp, $sp, 20
            jr $ra                  #return


            
