             .data
sizeprompt:             .asciiz "What size is your list? "
itemprompt:             .asciiz "enter an integer: "
minprompt:              .asciiz "The minimum temperature is "
size:                   .word 0
the_list:               .word 0
item:                   .word 0
i:                      .word 0

             .text

initial:             
             #print string
             la $a0, sizeprompt
             addi $v0, $0, 4
             syscall
            
             #read int
             addi $v0, $0, 5
             syscall
             sw $v0, size #size = int(input("what size is your list? "))
             
             #space required = 4*(size+1)
             lw $t0, size
             addi $t0, $t0, 1
             addi $t1, $0, 4
             mult $t0, $t1
            
             #allocate 4*(size+1) memory 
             mflo $a0
             addi $v0, $0, 9
             syscall     
             sw $v0, the_list #the_list=[0]*size
            
             lw $t0, size
             lw $t1, the_list
             sw $t0, ($t1) #store the size of the array at the start of the memory block
            
loop:
             #while i < size:
             lw $t0, i
             lw $t1, size
             slt $t2, $t0, $t1
             beq $t2, $0, main #if i > size, goto printrange
            
             #print string
             la $a0, itemprompt
             addi $v0, $0, 4
             syscall
             
             #read int
             addi $v0, $0, 5
             syscall
             sw $v0, item #item = int(input("enter an integer: "))
                         
             lw $t0, i #address of the element is at 4(i+1) + the_list
             lw $t1, the_list
             addi $t0, $t0, 1
             addi $t2, $0, 4
             mult $t0, $t2
             mflo $t3
             add $t4, $t1, $t3
             lw $t5, item
             sw $t5, ($t4) #the_list[i] = item
            
             lw $t0, i
             addi $t0, $t0, 1
             sw $t0, i #i = i + 1
            
             j loop #goto loop
             
main:
             la $a0, minprompt 
             addi $v0, $0, 4 #print("The minimum temperature is ")
             syscall
             
             add $fp, $sp, $0 #make sure the frame pointer is at the same as the stack pointer
             addi $sp, $sp, -4 #one argument allocation
             lw $t0, the_list #t0 = the_list
             sw $t0, -4($fp) #store the one argument onto the stack
             jal minfn #call the minfn function
             
             addi $sp, $sp, 4 #deallocate one argument
             
             add $a0, $v0, $0
             addi $v0, $0, 1 #prints the frequency of the temperature
             syscall
             
             addi $v0, $0, 10 #exit program
             syscall
minfn: 
             addi $sp, $sp, -8
             sw $fp, ($sp) #store old fp
             sw $ra, 4($sp) #store old ra
             add $fp, $sp, $0
             
             addi $sp, $sp, -16 #allocate for 4 local variables 
             addi $t0, $0, 2147483647 #min 
             addi $t1, $0, 0 #y
             addi $t2, $0, 0 #itemmn
             lw $t3, 8($fp) #length
             lw $t4, ($t3)
             
             sw $t0, 12($sp) #min = 2147483647
             sw $t1, 8($sp) #y = 0
             sw $t2, 4($sp) #item = 0
             sw $t4, 0($sp) #length = len(my_list)
             
findmin:             
             lw $t0, -8($fp)
             lw $t1, -16($fp)
             slt $t2, $t0, $t1
             beq $t2, $0, endfn #if y < size, goto endfn
             
             #item = the_list[y]
             lw $t0, -8($fp) #t0 = y
             lw $t1, 8($fp) #t1 = the_list
             addi $t0 $t0, 1 #address is at 4(y+1) + the_list
             addi $t2, $0, 4
             mult $t0, $t2
             mflo $t3
             add $t4, $t1, $t3
             lw $t5, ($t4)
             sw $t5, -12($fp) #item = the_list[y]
             
             lw $t0, -12($fp) #get item
             lw $t1, -4($fp) #get min
             slt $t2, $t0, $t1
             bne $t2, $0, ismin #if item < min, goto ismin
             
             j fnloop #goto fnloop
             
             
ismin:
             lw $t0, -12($fp) #CHANGE TO LOCAL VARIABLES
             sw $t0, -4($fp) #min = item       
             
fnloop: 
             lw $t0, -8($fp)
             addi $t0, $t0, 1
             sw $t0, -8($fp) #y = y + 1
             
             j findmin #goto findmin

endfn:
             lw $v0, -4($fp) #get ready to return min
             addi $sp, $sp, 16 #deallocate 4 local variables
             lw $fp, ($fp) #store fp
             lw $ra, 4($sp) #store ra
             addi $sp, $sp, 8 #deallocate $fp and $ra
             
             jr $ra #return to place of call
             
             
