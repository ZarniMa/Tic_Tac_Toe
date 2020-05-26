.data
square_array:   .byte      '1', '2', '3', '4', '5', '6', '7', '8', '9'  

.text

.globl gamePlay		# corresponds to gameboard and player indicator

gamePlay:

     la $a2, square_array              # array
     addi $s0, $zero, 1 
     addi $s3, $zero, 88 # player id
     addi $s4, $zero, 79 # players id

     # store values to stack
     sw $a2, 12($sp) # array address to stack
     sb $s0, 8($sp)  # save to stack
     sb $s3, 4($sp) # save id to stack
     sb $s4, ($sp) # save id to stack
     jr $ra # return to caller (start)
