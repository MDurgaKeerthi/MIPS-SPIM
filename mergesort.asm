#program: mergesort

.data
myarray: .word 0:100
mergearray:  .word 0:100
threespaces: .asciiz "    "
newline: .asciiz "\n"
header: .asciiz "MERGE SORT"
msg1: .asciiz "enter the number of numbers(please enter <110): "
msg2: .asciiz "enter the starting number(a): "
msg3: .asciiz "enter the difference(d) as negative number for decreasing sequence and positive number for icreasing sequence : " 
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

    while:
        li $v0,4
        la $a0,choice                  #asking for type of input
        syscall

        li $v0,5     
        syscall
        move $t0,$v0                    #input        

        beq $t0, 0, exitMain            #going to labels accordingly
        beq $t0, 1, arthimatic
        beq $t0, 2, random
        addi $t8, $0, 2 
        slt $t7, $t8, $t0               #2 < input
        beq $t7, 1, exitMain

    arthimatic:                         #loop for arithmatic Sequence
        li $v0, 4
        la $a0, msg1                    #prompt for entering the number of elements
        syscall

        li $v0,5
        syscall
        move $s5, $v0                   #s5 is number of numbers

        li $v0, 4
        la $a0, msg2                    #prompt for entering the starting value
        syscall

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

   random:                              #loop for random number Sequence
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
        la $a0, rmsg2                   #prompt for entering the seed y
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
        addi $t1, $s0, 0                #t=x
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
        move $a0, $0    
        addi $a1,$s5,-1
        addi $s3, $0, 0
        jal mergesort                   #caling the sort function  

    li $v0,4
    la $a0,sorted                       #printing the statement
    syscall
    addi $t0, $0, 0
    sll $t9, $s5, 2
print1:    
    lw $t6, myarray($t0)
    li $v0, 1
    move $a0, $t6                       #printing elements
    syscall
    li $v0, 4
    la $a0, threespaces                 #printing spaces
    syscall
    addi $t0, $t0, 4
    bne $t0, $t9, print1    

    li $v0, 4
    la $a0, newline                     #printing the newline
    syscall

    li $v0, 4
    la $a0, counter
    syscall

    li $v0, 1
    move $a0, $s3                       #printing the counter value
    syscall

    li $v0, 4
    la $a0, newline                     #printing the newline
    syscall

    j while                             #continuing the process
 
 exitMain:                              #end of the program
    li $v0,10
    syscall
 

mergesort:  
    addi $sp,$sp,-12                    #writing to the stack
    sw $ra,0($sp)
    sw $a0,4($sp)                       #low 
    sw $a1,8($sp)                       #high    

    beq $a0,$a1,exitMs                  #if (low == high)

    add $s1,$a0,$a1   
    srl $s1,$s1,1                       #mid = (low + high) /2

    move $a1, $s1                       
    jal mergesort                       #mergesort(low, mid)

    lw $a0,4($sp)    
    lw $a1,8($sp)    
    add $s1,$a0,$a1   
    srl $s1,$s1,1		
    add $s1,$s1,1                       #mid + 1 

    move $a0,$s1
    lw $a1,8($sp)    
    jal mergesort                       #mergesort(mid+1, high)

    lw $a0,4($sp)   
    lw $a1,8($sp) 
    jal merge                           #merge(low, high)   

    exitMs:   
        lw $ra,0($sp)                   #end of mergesort function
        add $sp,$sp,12  
        jr $ra                          #return

merge:
    addi $sp,$sp,-12                    #writing to the stack
    sw $ra,0($sp)  
    sw $a0,4($sp)                       #low
    sw $a1,8($sp)                       #high

    add $s7,$a0,$a1
    srl $s7,$s7,1                       #mid

    addi $s6,$s7,1                      #mid+1
    addi $s5,$a1,1                      #high + 1

    addi $s0,$a0,0                      #i = low 
    addi $s1,$s6,0                      #j= mid+1
    addi $s2,$0,0                       #k = 0

for:
    beq $s0,$s6,while1                  #i <= mid
    beq $s1,$s5,while1                  #j <= high    

    sll $t0,$s0,2                       #i*4
    lw $t0, myarray($t0)	            #a[i]
		
    sll $t1,$s1,2                       #j*4
    lw $t1, myarray($t1)	            #a[j]
		
    slt $t7,$t1,$t0                     #if a[i] < a[j]
    addi $s3, $s3, 1                    #incrementing the counter
    bne $t7,0,else

    sll $t8,$s2,2                       #4*k
    sw $t0 ,mergearray($t8)             #mergearray[k] = a[i]
    addi $s0,$s0,1                      #i++
    addi $s2,$s2,1                      #k++
    j for  

else:
    sll $t1,$s1,2                       #4*j    
    lw $t1, myarray($t1)                #a[j]    
    sll $t8,$s2,2                       #4*k
    sw $t1 ,mergearray($t8)             #mergearray[k] = a[j]
    addi $s1,$s1,1                      #j++
    addi $s2,$s2,1                      #k++
    j for  

while1: 
    beq $s0,$s6,while2                  #i <= mid
    sll $t0,$s0,2                       #4*i    
    lw $t0, myarray($t0)                #a[i]
    sll $t8,$s2,2                       #4*k
    sw $t0 ,mergearray($t8)             #mergearray[k] = a[i]    
    addi $s0,$s0,1                      #i++
    addi $s2,$s2,1                      #k++
    j while1

while2: 
    beq $s1,$s5,transfer                #j <= high
    sll $t1,$s1,2                       #4*j
    lw $t1, myarray($t1)                #a[j]
    sll $t8,$s2,2                       #4*k
    sw $t1 ,mergearray($t8)             #mergearray[k] = a[j]
    addi $s1,$s1,1                      #j++
    addi $s2,$s2,1                      #k++
    j while2

transfer: 
    addi $t2,$0,0                       # i = 0
    for1:
        slt $t3,$t2,$s2                 # i <= k   
        beq $t3,0,exitmerge
        sll $t5,$t2,2                   #4*i
        lw $t5, mergearray($t5)         #mergearray[i]
        add $t3,$t2,$a0                 #i+l
        sll $t4,$t3,2                   #4*(i+l)
        sw $t5, myarray($t4)            #a[i+l] = mergearray[i]
        addi $t2,$t2,1                  #i++
        j for1

exitmerge:                              #end of merge function
    lw $ra,0($sp)
    add $sp,$sp,12  
    jr $ra  







