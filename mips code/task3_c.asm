             .data
sizeprompt:             .asciiz "What size is your list? "
itemprompt:             .asciiz "enter an integer: "
rangeprompt:            .asciiz "range of the list is "
newline:                .asciiz "\n"
size:                   .word 0
the_list:               .word 0
item:                   .word 0
i:                      .word 0
min:                    .word 2147483647
max:                    .word 0
range:                  .word 0
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
            
loop:
             #while i < size:
             lw $t0, i
             lw $t1, size
             slt $t2, $t0, $t1
             beq $t2, $0, printrange #if i > size, goto printrange
            
             #print string
             la $a0, itemprompt
             addi $v0, $0, 4
             syscall
             
             #read int
             addi $v0, $0, 5
             syscall
             sw $v0, item #item = int(input("enter an integer: "))
            
             lw $t0, item
             lw $t1, min
             slt $t2, $t0, $t1
             bne $t2, $0, ismin #if item < min, goto ismin
             
secondloop:            
             lw $t0, item
             lw $t1, max
             slt $t2, $t0, $t1
             beq $t2, $0, ismax #if item > max, goto ismax
            
             j appendloop #goto appendloop
ismin:
             lw $t0, item 
             sw $t0, min #min = item

             j secondloop #goto appendloop
ismax:            
             lw $t0, item
             sw $t0, max #max = item

appendloop:            
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
            
printrange:
             lw $t0, min
             lw $t1, max
             sub $t2, $t1, $t0
             sw $t2, range #range = max - min

             la $a0, rangeprompt #get string
             addi $v0, $0, 4
             syscall #print string

             lw $a0, range #get int
             addi $v0, $0, 1 #print int
             syscall #print("range of the list is {}".format(range_list))

exit:
             #exit program
             addi $v0, $0, 10
             syscall
