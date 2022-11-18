                   .data
sizeprompt:             .asciiz "What size is your list? "
itemprompt:             .asciiz "enter an integer: "     
aprompt:                .asciiz "enter a: "
bprompt:                .asciiz "enter b: "       
appearsprompt:          .asciiz " appears "  
timesprompt:            .asciiz " times\n"
size:                   .word 0
item:                   .word 0
the_list:               .word 0
i:                      .word 0  
a:                      .word 0
b:                      .word 0
             
                 
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
              
appendloop:
               #while i < size:
               lw $t0, i
               lw $t1, size
               slt $t2, $t0, $t1
               beq $t2, $0, endappendloop #if i > size, goto endappendloop
              
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
               lw $t5 item
               sw $t5, ($t4) #the_list[i] = item
              
               lw $t0, i
               addi $t0, $t0, 1
               sw $t0, i #i = i + 1
              
               j appendloop #goto appendloop
               
endappendloop:
               la $a0, aprompt 
               addi $v0, $0, 4 #print("enter a: ")
               syscall
               
               addi $v0, $0, 5 #read int
               syscall
               sw $v0, a #a = int(input("give a: "))
               
               la $a0, bprompt
               addi $v0, $0, 4 #print("enter b: ")
               syscall
               
               addi $v0, $0, 5 #read int
               syscall
               sw $v0, b #b = int(input("give b: "))
               
main:
               add $fp, $sp, $0 #make sure the frame pointer is at the same as the stack pointer
               addi $sp, $sp, -8 #2 arguments allocation
               lw $t0, a #t0 = a
               lw $t1, b #t1 = b
               sw $t0, -8($fp) #store the 2 arguments onto the stack
               sw $t1, -4($fp)
               jal countlist #call the countlist function
               
               addi $sp, $sp, 8 #deallocate 2 arguments
               
               addi $sp, $sp, -8 #2 arguments allocation
               lw $t0, the_list #t0 = the_list
               sw $t0, -8($fp) #store the 2 arguments onto the stack
               sw $v0, -4($fp) # -4($fp) = return value of countlist function
               jal freqfn #call the freqfn function
               
               addi $sp, $sp, 8 #deallocate 2 arguments
               
               addi $v0, $0, 10 #exit program
               syscall

               
countlist: 
               addi $sp, $sp, -8
               sw $fp, ($sp) #store old fp
               sw $ra, 4($sp) #store old ra
               add $fp, $sp, $0
               
               addi $sp, $sp, -16 #allocate for 4 local variables 
               lw $t0, 8($fp) #t0 = a
               lw $t1, 12($fp) #t1 = b
               sub $t2, $t1, $t0 #t2 = b - a
                                   
countlistcont:
               addi $t2, $t2, 1 #t2 = t2 + 1
               addi $t3, $0, 0 #i
               addi $t4, $0, 0 #number
               
               sw $t2, 12($sp) #c = b - a
               sw $t3, 8($sp) #i = 0
               sw $t4, 4($sp) #number = 0
               
               #space required = 4*(c+1)
               lw $t0, -4($fp) #get c
               addi $t0, $t0, 1
               addi $t1, $0, 4
               mult $t0, $t1
               
               #allocate 4*(c+1) memory 
               mflo $a0
               addi $v0, $0, 9
               syscall
               sw $v0, 0($sp) #count_list = [0]*c
               
               lw $t0, -4($fp)
               lw $t1, -16($fp)
               sw $t0, ($t1) #store the size of the array at the start of the memory block

addcountlist:  
               lw $t0, -8($fp) #t0 = i
               lw $t1, -4($fp) #t1 = c
               slt $t2, $t0, $t1
               beq $t2, $0, endcountfn
               
               lw $t0, 8($fp) #t0 = a
               lw $t1, -8($fp) #t1 = i
               add $t2, $t0, $t1
               sw $t2, -12($fp) #number = a + i
               
               lw $t0, -8($fp) #address of the element is at 4(i+1) + count_list
               lw $t1, -16($fp)
               addi $t0, $t0, 1
               addi $t2, $0, 4
               mult $t0, $t2
               mflo $t3
               add $t4, $t1, $t3
               lw $t5, -12($fp)
               sw $t5, ($t4) #count_list[i] = number
               
               lw $t0, -8($fp)
               addi $t0, $t0, 1
               sw $t0, -8($fp) #i = i + 1
               
               j addcountlist #goto addcountlist
endcountfn:
               lw $v0, -16($fp) #get ready to return count_list
               addi $sp, $sp, 16 #deallocate 4 local variables
               lw $fp, ($fp) #store fp
               lw $ra, 4($sp) #store ra
               addi $sp, $sp, 8 #deallocate $fp and $ra
             
               jr $ra #return to place of call

freqfn: 
               addi $sp, $sp, -8
               sw $fp, ($sp) #store old fp
               sw $ra, 4($sp) #store old ra
               add $fp, $sp, $0
              
               addi $sp, $sp, -28 #allocate for 7 local variables
               addi $t0, $0, 0 #j 
               addi $t1, $0, 0 #val 
               addi $t2, $0, 0 #k 
               addi $t3, $0, 0 #count 
               lw $t4, 8($fp) #t4 = my_list
               lw $t5, ($t4) #t5 = len(my_list)
               lw $t6, 12($fp) #t6 = range_list
               lw $t7, ($t6) #t7 = len(range_list)
              
               sw $t0, 24($sp) #j = 0
               sw $t1, 20($sp) #val = 0
               sw $t2, 16($sp) #k = 0
               sw $t3, 12($sp) #count = 0
               sw $t5, 8($sp) #n = len(my_list)
               sw $t7, 4($sp) #c = len(range_list)
              
               addi $t0, $0, 0 #item
               sw $t0, 0($sp) # item = 0
              
getval:
               lw $t0, -4($fp) #t0 = j
               lw $t1, -24($fp) #t1 = c
               slt $t2, $t0, $t1
               beq $t2, $0, endfreqfn #if j > c, goto freqloop
              
               lw $t0, -4($fp) #t0 = j
               lw $t1, 12($fp) #t1 = range_list
               addi $t0 $t0, 1 #address of the element is at 4(j+1) + range_list
               addi $t2, $0, 4
               mult $t0, $t2
               mflo $t3
               add $t4, $t1, $t3
               lw $t5, ($t4) #t5 = range_list[j]
               sw $t5, -8($fp) #val = range_list[j]
              
               addi $t0, $0, 0
               sw $t0, -12($fp) #k = 0
              
               addi $t0, $0, 0
               sw $t0, -16($fp) #count = 0
              
freqloop:
               lw $t0, -12($fp) #t0 = k
               lw $t1, -20($fp) #t1 = n
               slt $t2, $t0, $t1
               beq $t2, $0, endgetval
              
               lw $t0, -12($fp) #t0 = k
               lw $t1, 8($fp) #t1 = my_list
               addi $t0 $t0, 1
               addi $t2, $0, 4
               mult $t0, $t2
               mflo $t3
               add $t4, $t1, $t3
               lw $t5, ($t4) #t5 = my_list[k]
               sw $t5, -28($fp) #item = my_list[k]
              
               lw $t0, -28($fp) #t0 = item
               lw $t1, -8($fp)
               beq $t0, $t1, addcount #if item == val, goto addcount
              
               j endfreq #goto endfreq
              
addcount:
               lw $t0, -16($fp) 
               addi $t0, $t0, 1
               sw $t0, -16($fp) #count = count + 1

endfreq: 
               lw $t0, -12($fp)
               addi $t0, $t0, 1
               sw $t0, -12($fp) #k = k + 1
              
               j freqloop #goto freqloop

endgetval:
               lw $t0, -16($fp) #t0 = count
               bne $t0, $0, printstuff #if count != 0, goto printstuff

               j iterategetval #goto iterategetval

printstuff:                                          
               lw $a0, -8($fp)
               addi $v0, $0, 1 #print val
               syscall 
              
               la $a0, appearsprompt
               addi $v0, $0, 4 #print "appears"
               syscall
              
               lw $a0, -16($fp)
               addi $v0, $0, 1 #print count
               syscall
              
               la $a0, timesprompt
               addi $v0, $0, 4 #print "times"
               syscall  
              
iterategetval:
               lw $t0, -4($fp)
               addi $t0, $t0, 1
               sw $t0, -4($fp) #j = j + 1
              
               j getval #goto getval
               
endfreqfn:
               addi $sp, $sp, 28 #deallocate 7 local variables
               lw $fp, ($fp) #store fp
               lw $ra, 4($sp) #store ra
               addi $sp, $sp, 8 #deallocate $fp and $ra
               
               jr $ra #return to place of call
                             
