            .data
prompt:                   .asciiz "What year is it? " 
leapyearprompt:           .asciiz "Is a leap year"
notleapyearprompt:        .asciiz "Is not a leap year"
          
year:                     .word 0
mod4:                     .word 0
mod400:                   .word 0
mod100:                   .word 0
            .text

main:
            #print string
            la $a0, prompt 
            addi $v0, $0, 4
            syscall 
          
            #read int
            addi $v0, $0, 5
            syscall
            sw $v0, year
          
            # mod4 = year mod 4 
            lw $t0, year
            addi $t1, $0, 4
            div $t0, $t1
            mfhi $t2
            sw $t2, mod4
          
            #mod400 = year mod 400
            lw $t0, year
            addi $t1, $0, 400
            div $t0, $t1
            mfhi $t2
            sw $t2, mod400
          
            #mod100 = year mod 100
            lw $t0, year
            addi $t1, $0, 100
            div $t0, $t1
            mfhi $t2
            sw $t2, mod100
          
            #t0 = year mod 4, t1 = year mod 400, t2 = year mod 100
            lw $t0, mod4
            lw $t1, mod400
            lw $t2, mod100
          
            bne $t0, $0, notleapyear #if year is not divisible by 4, goto notleapyear
            bne $t2, $0, leapyear #if year is not divisible 100, goto leapyear
            beq $t1, $0, leapyear # if year is divisble by 400, goto leapyear
            j notleapyear #goto notleapyear       
            
            
leapyear:            
            #print "is a leap year"
            la $a0, leapyearprompt
            addi $v0, $0, 4
            syscall
          
            j exit

notleapyear:
            #print "is not a leap year"
            la $a0, notleapyearprompt
            addi $v0, $0, 4
            syscall

exit: 
            #exit program
            addi $v0, $0, 10
            syscall


          