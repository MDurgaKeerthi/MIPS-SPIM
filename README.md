# MIPS-SPIM

Files include insertion sort and merge sort implemented in MIPS. And the simulator (partial) written in C for MIPS.


Simulator:

file name input format: test1.asm  
  
array representation end with end and numbers of array should be seperated by spaces. Arrays can be declared in the the program.  
32 registers are used and among them only s-type and t-type are used in calculation purpose. Registers other than mentioned list can't be used.  
Labelnames should end with semicolon. In most of the places, spaces, tabs and newlines are allowed except in some situations where it is difficult to consider.  
The program declares some arrays to store the values which the test code gives. Function pointers are used to call the functions. First labelnames are extracted and file pointer is rewinded. Then line by line execution is done. This program is comaptible with the test code containing “.data”. The program ends with halt.
  
Allowed formats for the functions  
add $s1, $s2, $s6 here spaces are required between add, $s1, $s2, $s6 and is same for all the other functions  
addi $s1, $s2, 6  
sub $s1, $s2, $s6  
mul $s1, $s2, $s6  
and $s1, $s2, $s6   
andi $s1, $s2, 6   
or $s1, $s2, $s6   
ori $s1, $s2, 6   
nor $s1, $s2, $s6   
slt $s1, $s2, $s6   
slti $s1, $s2, 6   
la $s1, array   
lw $s2, 0($s1)   
sw $s2, 0($s1)   
beq $t1, $t2, exit   
bne $t1, $t2, exit  
j exit   
    
A special fucntion is written to get the register indices, it almost works in constant time.   
   
Errors:   
As mentioned above, spaces are important in instructions. Register values beyond the actual registers give errors. Words not previuosly mentioned either as loopnames or labelnames or arraynames or fucntion names give errors.  
