               .data
sizeprompt:             .asciiz "What size is your list? "
itemprompt:             .asciiz "enter an integer: "
targetprompt:           .asciiz "number you want to count? "             
countprompt:            .asciiz "target count is "
size:                   .word 0
item:                   .word 0
the_list:               .word 0
x:                      .word 0
y:                      .word 0
target:                 .word 0
number:                 .word 0
count:                  .word 0

               .text
main:  
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
               lw $t0, x
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
              
               lw $t0, x #address of the element is at 4(x+1) + the_list
               lw $t1, the_list
               addi $t0, $t0, 1
               addi $t2, $0, 4
               mult $t0, $t2
               mflo $t3
               add $t4, $t1, $t3 
               lw $t5 item
               sw $t5, ($t4) #the_list[i] = item
              
               lw $t0, x
               addi $t0, $t0, 1
               sw $t0, x #x = x + 1
              
               j appendloop #goto appendloop
              
endappendloop:             
               la $a0, targetprompt #get string
               addi $v0, $0, 4
               syscall #print string
              
               addi $v0, $0, 5 #read int
               syscall
               sw $v0, target #target = int(input("number you want to count? "))
              
countloop: 
               #while k < size:
               lw $t0, y
               lw $t1, size
               slt $t2, $t0, $t1
               beq $t2, $0, print #if y > size, goto print
              
               lw $t0, y #address of the element is at 4(y+1) + the_list
               lw $t1, the_list
               addi $t0, $t0, 1
               addi $t2, $0, 4
               mult $t0, $t2
               mflo $t3
               add $t4, $t1, $t3
               lw $t5, ($t4) 
               sw $t5, number #number = the_list[k]
               
               lw $t0, target
               lw $t1, number
               beq $t0, $t1, addcount #if target == number, goto addcount
               
               j loopcontinued #goto loopcontinued
               
addcount:  
               lw $t0, count 
               addi $t0, $t0, 1
               sw $t0, count #count = count + 1
               
loopcontinued:
               lw $t0, y
               addi $t0, $t0, 1
               sw $t0, y #y = y + 1
               
               j countloop #goto countloop             
              
print:
               la $a0, countprompt #get string
               addi $v0, $0, 4
               syscall #print string
              
               lw $a0, count #get int
               addi $v0, $0, 1 #print int
               syscall #print("target count is {}".format(count))        
              
exit:
               #exit program
               addi $v0, $0, 10
               syscall
