                   .data
citiesprompt:             .asciiz "How many cities? "
daysprompt:               .asciiz "How many days? "
cityprompt:               .asciiz "City "
tempprompt:               .asciiz "temperature? "
optionprompt:             .asciiz "\nPick an option"
optionaprompt:            .asciiz "\n1. Find max temperature of a city"
optionbprompt:            .asciiz "\n2. Quit"
optprompt:                .asciiz "\nWhat option? "
cityask:                  .asciiz "What city? "
maxtempprompt:            .asciiz "Max temperature is "
newline:                  .asciiz "\n"
cities:                   .word 0
days:                     .word 0
table:                    .word 0
option:                   .word 0
city:                     .word 0
citylist:                 .word 0
maxtemp:                  .word 0

                   .text
                   
initial: 
                   la $a0, citiesprompt 
                   addi $v0, $0, 4 #print("How many cities? ")
                   syscall
                   
                   addi $v0, $0, 5 #read int
                   syscall
                   sw $v0, cities #cities = int(input("number of cities? "))
                   
                   la $a0, daysprompt
                   addi $v0, $0, 4 #print("How many days? ")
                   syscall
                   
                   addi $v0, $0, 5 #read int
                   syscall
                   sw $v0, days #days = int(input("number of days? "))
                   
                   #space required = 4*(cities+1)
                   lw $t0, cities
                   addi $t0, $t0, 1
                   addi $t1, $0, 4
                   mult $t0, $t1
            
                   #allocate 4*(cities+1) memory 
                   mflo $a0
                   addi $v0, $0, 9
                   syscall     
                   sw $v0, table #table=[0]*cities
            
                   lw $t0, cities
                   lw $t1, table
                   sw $t0, ($t1) #store the size of the array at the start of the memory block
                   
gettable: 
                   add $fp, $sp, $0 #make sure the frame pointer is at the same as the stack pointer
                   addi $sp, $sp, -12 #allocate space for 3 arguments
                   lw $t0, cities #t0 = cities
                   lw $t1, days #t1 = days
                   lw $t2, table #t2 = table
                   sw $t0, -12($fp) #store the 3 arguments in the stack
                   sw $t1, -8($fp) 
                   sw $t2, -4($fp)
                   jal matrixtemp #call the matrixtemp function
                   
                   addi $sp, $sp, 12 #deallocate 3 arguments
                   
                   sw $v0, table #table = matrixoftemp(num_cities, num_days, table)

main:
                   addi $t0, $0, 0
                   lw $t0, option #option = 0 
                   
                   #while loop for option commences here
menuloop:          
                   lw $t0, option #t0 = option
                   addi $t1, $0, 2
                   beq $t0, $t1, exit #if option == 2, goto exit
                   
                   la $a0, optionprompt
                   addi $v0, $0, 4 #print("Pick an option")
                   syscall
                   
                   la $a0, optionaprompt
                   addi $v0, $0, 4 #print("1. Find max temperature of a city")
                   syscall
                   
                   la $a0, optionbprompt
                   addi $v0, $0, 4 #print("2. quit")
                   syscall
                   
                   la $a0, optprompt
                   addi $v0, $0, 4 #print("What option? ")
                   syscall
                   
                   addi $v0, $0, 5 #read int
                   syscall
                   sw $v0, option #option = int(input("what option? "))
                   
                   lw $t0, option
                   addi $t1, $0, 1
                   beq $t0, $t1, optone #if option == 1, goto optone
                   
                   j menuloop #goto menuloop
                   
optone:            
                   la $a0, cityask
                   addi $v0, $0, 4 #print("What city? ")
                   syscall
                   
                   addi $v0, $0, 5 #read int
                   syscall
                   sw $v0, city #city = int(input("What city? "))
                   
                   lw $t0, city #address of the element is at 4(city+1) + table
                   lw $t1, table
                   addi $t0 $t0, 1
                   addi $t2, $0, 4
                   mult $t0, $t2
                   mflo $t3
                   add $t4, $t1, $t3
                   lw $t5, ($t4) #t5 = table[city]
                   sw $t5, citylist #citylist = table[city]
                   
                   addi $sp, $sp, -4 #allocate space for one argument
                   lw $t0, citylist 
                   sw $t0, -4($fp) 
                   jal findmax #call the findmax function
                   
                   addi $sp, $sp, 4 #deallocate one argument
                   
                   sw $v0, maxtemp #maxtemp = findmax(citylist)
                   
                   la $a0, maxtempprompt 
                   addi $v0, $0, 4 #print("Max temperature is ")
                   syscall
                   
                   lw $a0, maxtemp
                   addi $v0, $0, 1 #print the maximum temperature for the city
                   syscall
                   
                   j menuloop #goto menuloop
                   
exit:
                   addi $v0, $0, 10 #exit program
                   syscall                   
                   
matrixtemp: 
                   addi $sp, $sp, -8
                   sw $fp, ($sp) #store old fp
                   sw $ra, 4($sp) #store old ra
                   add $fp, $sp, $0
                   
                   addi $sp, $sp, -16 #allocate for 4 local variables
                   addi $t0, $0, 0 #x
                   addi $t1, $0, 0 #y
                   addi $t2, $0, 0 #templist
                   addi $t3, $0, 0 #temp
                   
                   sw $t0, 12($sp) #x = 0
                   sw $t1, 8($sp) #y = 0
                   sw $t2, 4($sp) #templist = 0
                   sw $t3, 0($sp) #temp = 0
                   
cityloop:
                   lw $t0, -4($fp) #t0 = x
                   lw $t1, 8($fp) #t1 = cities
                   slt $t2, $t0, $t1
                   beq $t2, $0, endmatrixfn #if x > cities, goto endmatrixfn
                   
                   #space required = 4*(days+1)
                   lw $t0, 12($fp)
                   addi $t0, $t0, 1
                   addi $t1, $0, 4
                   mult $t0, $t1
              
                   #allocate 4*(days+1) memory
                   mflo $a0
                   addi $v0, $0, 9
                   syscall
                   sw $v0, -12($fp) #templist = [0]*cities
                   
                   lw $t0, 8($fp) #t0 = cities
                   lw $t1, -12($fp) #t1 = templist
                   sw $t0, ($t1) #store the size of the array at the start of the memory block
                   
                   la $a0, cityprompt #print "City"
                   addi $v0, $0, 4
                   syscall
                   
                   #print x
                   lw $a0, -4($fp) 
                   addi $v0, $0, 1 #print("City {}".format(x))
                   syscall
                   
                   la $a0, newline
                   addi $v0, $0, 4 #starts a newline
                   syscall 
                   
                   addi $t0, $0, 0
                   sw $t0, -8($fp) #y = 0
                   
templistloop:
                   lw $t0, -8($fp) #t0 = y
                   lw $t1, 12($fp) #t1 = days
                   slt $t2, $t0, $t1 
                   beq $t2, $0, endcity #if y > days, goto endcity
                   
                   la $a0, tempprompt 
                   addi $v0, $0, 4 #print("temperature? ")
                   syscall
                   
                   addi $v0, $0, 5
                   syscall
                   sw $v0, -16($fp) #temp = int(input("temperature? "))
                   
                   lw $t0, -8($fp) #t0 = y
                   lw $t1, -12($fp)
                   addi $t0, $t0, 1 #address of the element is at 4(y+1) + temp_list
                   addi $t2, $0, 4
                   mult $t0, $t2
                   mflo $t3
                   add $t4, $t1, $t3
                   lw $t5, -16($fp)
                   sw $t5, ($t4) #templist[y] = temp
                   
                   lw $t0, -8($fp)
                   addi $t0, $t0, 1
                   sw $t0, -8($fp) #y = y + 1
                   
                   j templistloop #goto templistloop
                   
                   
endcity:                   
                   lw $t0, -4($fp) #address of the element is at 4(x+1) + matrix
                   lw $t1, 16($fp)
                   addi $t0, $t0, 1
                   addi $t2, $0, 4
                   mult $t0, $t2
                   mflo $t3
                   add $t4, $t1, $t3
                   lw $t5, -12($fp)
                   sw $t5, ($t4) #matrix[x] = templist
                   
                   lw $t0, -4($fp)
                   addi $t0, $t0, 1
                   sw $t0, -4($fp) #x = x + 1
                   
                   j cityloop #goto cityloop

endmatrixfn:
                   lw $v0, 16($fp) #get ready to return matrix
                   addi $sp, $sp, 16
                   lw $fp, ($fp) #store fp
                   lw $ra, 4($sp) #store ra
                   addi $sp, $sp, 8 #deallocate $fp and $ra
             
                   jr $ra #return to place of call
 
findmax: 
                   addi $sp, $sp, -8
                   sw $fp, ($sp) #store old fp
                   sw $ra, 4($sp) #store old ra
                   add $fp, $sp, $0
                   
                   addi $sp, $sp, -16 #allocate for 4 local variables
                   addi $t0, $0, 0 #max
                   addi $t1, $0, 0 #i
                   addi $t2, $0, 0 #val
                   lw $t3, 8($fp) #t3 = my_list
                   lw $t4, ($t3) #t4 = len(my_list)
                   
                   sw $t0, 12($sp) #max = 0
                   sw $t1, 8($sp) #i = 0
                   sw $t2, 4($sp) #val = 0
                   sw $t4, 0($sp) #n = len(my_list)
                   
maxloop:
                   lw $t0, -8($fp) #t0 = i
                   lw $t1, -16($fp) #t1 = n
                   slt $t2, $t0, $t1
                   beq $t2, $0, endmaxfn #if i > n, goto endmaxfn
                   
                   lw $t0, -8($fp) #t0  = i
                   lw $t1, 8($fp) #t1 = my_list
                   addi $t0 $t0, 1 #address of the element is at 4(i+1) + my_list
                   addi $t2, $0, 4
                   mult $t0, $t2 
                   mflo $t3
                   add $t4, $t1, $t3
                   lw $t5, ($t4) #t5 = my_list[i]
                   sw $t5, -12($fp) #val = my_list[i]
                   
                   lw $t0, -12($fp) #t0 = val
                   lw $t1, -4($fp) #t1 = max
                   slt $t2, $t0, $t1
                   beq $t2, $0, newmax #if val > max, goto newmax
                   
                   j iteratemax #goto iteratemax
                   
newmax:            
                   lw $t0, -12($fp) 
                   sw $t0, -4($fp) #max = val                   
                   
iteratemax:
                   lw $t0, -8($fp)
                   addi $t0, $t0, 1
                   sw $t0, -8($fp) #i = i + 1
                   
                   j maxloop #goto maxloop

endmaxfn:
                   lw $v0, -4($fp) #get ready to ready max
                   addi $sp, $sp, 16 #deallocate 4 local variables
                   lw $fp, ($fp) #store fp
                   lw $ra, 4($sp) #store ra
                   addi $sp, $sp, 8 #deallocate $fp and $ra
                   
                   jr $ra #return to place of call
                   
                   
                 


                   
