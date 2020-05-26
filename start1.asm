.data

PX_Prompt: .asciiz   "Player 1 enter a number : "
PO_Prompt: .asciiz   "Player 2 enter a number : "
box_1: .asciiz   "     |     |     \n"
box_2: .asciiz   "  "
box_3: .asciiz   "  |  "
box_4: .asciiz   "_____|_____|_____\n"
box_5: .asciiz   "  \n"
Invalid_String: .asciiz   "\n Bad move. Please ty again : "
PWX: .asciiz   "\n Player 1 wins."
PWO: .asciiz   "\n Player 2 wins."
draw_prompt: .asciiz   "\nThe game is a draw."

.text

.globl start
start:	
# add ra to stack. jump to gameplay and write output to registers based on # stack pointer
	addiu $sp, $sp, -20
	
	sw $ra, 16($sp)
	jal gamePlay
	lw $ra, 16($sp) 
	lw $a2, 12($sp)
      lb $s0, 8($sp)
      lb $s3, 4($sp)
      lb $s4, ($sp)
	addiu $sp, $sp, 20
	
      j  GameBoard 

                       
print_board:             # Calling function to print board values
      lb $t0, 0($a2)
      lb $t1, 1($a2)
      lb $t2, 2($a2)
      lb $t3, 3($a2)
      lb $t4, 4($a2)
      lb $t5, 5($a2)
      lb $t6, 6($a2)
      lb $t7, 7($a2)
      lb $t8, 8($a2)
      beq $s0, 2, Player2
      
Player1:      				# player 1 turn
              
       addi $s0, $zero, 2
       la $a0, PX_Prompt
       li $v0, 4
       syscall
       
       addi $s6, $zero, 88 
       j condition
       
Player2:                       	 #  Player 2 turn
       addi $s0, $zero, 1
       la $a0, PO_Prompt
       li $v0, 4
       syscall
       
       addi $s6, $zero, 79
       
# Conditional check for valid user input
# if condition is valid, store byte of user input in array ("square") that corresponds to game board position 

condition:                      
         addi $v0, $zero, 12
         syscall
               
         addi $a3, $v0, 0
         beq $a3, $s3, m9
         beq $a3, $s4, m9
         bne $a3, $t0, m1
         sb  $s6, 0($a2)
         j m10
m1:
         bne $a3, $t1, m2
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 1($a2)
         j m10
m2:
         bne $a3, $t2, m3
         beq $a3, $s6, m9
         sb  $s6, 2($a2)
         j m10
m3:
         bne $a3, $t3, m4
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 3($a2)
         j m10
m4:
         bne $a3, $t4, m5
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 4($a2)
         j m10
m5:
         bne $a3, $t5, m6
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 5($a2)
         j m10
m6:
         bne $a3, $t6, m7
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 6($a2)
         j m10
m7:
         bne $a3, $t7, m8
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 7($a2)
         j m10
m8:
         bne $a3, $t8, m9
             beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 8($a2)
         j m10
m9:
         la  $a0, Invalid_String
         addi $v0, $zero, 4
         syscall
       
         j condition
m10:
         beq $v0,1,game_status
         beq $v0,0,game_status
         
         j CheckWin                     # Funtion Call to check if game continues
        
game_status:
	 addi $k1, $v0, 0	
         beq $k1, -1, start
         beq $v0,0,draw
         beq $s0, 1, WPO_Prompt
         
WPX_Prompt:     	                
# add $ra to stack. jump to Gameboard to refresh final marker.    
	addiu $sp, $sp, -4
	sw $ra, ($sp)
	jal GameBoard
	lw $ra, ($sp)
	addiu $sp, $sp, 4

# string prompt of player 1 wins
         la  $a0, PWX
     li $v0, 4
         syscall
         j exit
WPO_Prompt:  
 # add $ra to stack. jump to Gameboard to refresh final marker.    
	addiu $sp, $sp, -4
	sw $ra, ($sp)
	jal GameBoard
	lw $ra, ($sp)
	addiu $sp, $sp, 4

                          
 # string prompt of player 2 wins
         la  $a0, PWO
         li $v0, 4
         syscall
         j exit
draw:  
# add $ra to stack. jump to Gameboard to refresh final marker. 
# draw has 0 in $v0  and $k0 
	  
	addiu $sp, $sp, -4
	sw $ra, ($sp)
	li $k1, 1 # triggers gameboard to not branch to printboard
	jal GameBoard
	lw $ra, ($sp)
        addiu $sp, $sp, 4  
                         
# string print of a game draw
         la $a0, draw_prompt
         li $v0, 4
         syscall
         j exit
exit:                                 
				      #terminate program
	li $v0, 10
        syscall


# check for consective player markers to determine win 
# if no winner, -1 indicates game will continue 
# 0 indicates no board positions available  therefore a draw
# 1 indicates player 2 is winner
# else player 1 is winner
# indicating values will be used in hello2

CheckWin:                                 
        lb $t0, 0($a2)                   
        lb $t1, 1($a2)                    
        lb $t2, 2($a2)                    
        lb $t3, 3($a2)
        lb $t4, 4($a2)
        lb $t5, 5($a2)
        lb $t6, 6($a2)
        lb $t7, 7($a2)
        lb $t8, 8($a2)
        bne $t0, $t1, C2
        bne $t1, $t2, C2
        addi $v0, $zero, 1
        beq $v0,1,game_status
        beq $v0,10,game_status
        jr $ra 
C2:
        bne $t3, $t4, C3
        bne $t4, $t5, C3
        addi $v0, $zero, 1
        j m10
C3:
        bne $t6, $t7, C4
        bne $t7, $t8, C4
        addi $v0, $zero, 1
        j m10
C4:
        bne $t0, $t3, C5
        bne $t3, $t6, C5
        addi $v0, $zero, 1
        j m10
C5:
        bne $t1, $t4, C6
        bne $t4, $t7, C6
        addi $v0, $zero, 1
        j m10
C6:
        bne $t2, $t5, C7
        bne $t5, $t8, C7
        addi $v0, $zero, 1
        j m10
C7:
        bne $t0, $t4, C8
        bne $t4, $t8, C8
        addi $v0, $zero, 1
        j m10
C8:
        bne $t2, $t4, C9
        bne $t4, $t6, C9
        addi $v0, $zero, 1
        j m10
C9:
        beq $t0, '1', C10
        beq $t1, '2', C10
        beq $t2, '3', C10
        beq $t3, '4', C10
        beq $t4, '5', C10
        beq $t5, '6', C10
        beq $t6, '7', C10
        beq $t7, '8', C10
        beq $t8, '9', C10
        addi $v0, $zero, 0
        j m10
C10:
        addi $v0, $zero, -1
        #j m10

GameBoard:                                #This function will display the #board
     lb $t0, 0($a2)
     lb $t1, 1($a2)
     lb $t2, 2($a2)
     lb $t3, 3($a2)
     lb $t4, 4($a2)
     lb $t5, 5($a2)
     lb $t6, 6($a2)
     lb $t7, 7($a2)
     lb $t8, 8($a2)
     
     li $v0, 4
     la $a0, box_5 			# newline spacer
     syscall
   
     li $v0, 4
     la $a0, box_1
     syscall
     
     li $v0, 4
     la $a0, box_2
     syscall
     
B1:  
     addi $a0, $t0, 0
     li $v0, 11
     syscall
    
     la $a0, box_3
     li $v0, 4
     syscall
     
B2:  
     addi $a0, $t1, 0
     li $v0, 11
     syscall
     
     la $a0, box_3
     li $v0, 4
     syscall

B3:  
     addi $a0, $t2, 0
     li $v0, 11
     syscall
     
     la $a0, box_5
     li $v0, 4
     syscall
     
     la $a0, box_4
     syscall
     
     la $a0, box_1
     syscall
     
     la $a0, box_2
     syscall

B4:
     addi $a0, $t3, 0
     li $v0, 11
     syscall
     
     la $a0, box_3
     li $v0, 4
     syscall

B5: 
     addi $a0, $t4, 0
     li $v0, 11
     syscall
     
     la $a0, box_3
     li $v0, 4
     syscall

B6:
     addi $a0, $t5, 0
     li $v0, 11
     syscall
     
     la $a0, box_5
     li $v0, 4
     syscall
     
     la $a0, box_4
     syscall
     
     la $a0, box_1
     syscall
     
     la $a0, box_2
     syscall

B7:
     addi $a0, $t6, 0
     li $v0, 11
     syscall
   
     la $a0, box_3
     li $v0, 4
     syscall

B8:
     addi $a0, $t7, 0
     li $v0, 11
     syscall
     
     la $a0, box_3
     li $v0, 4
     syscall

B9:
     addi $a0, $t8, 0
     li $v0, 11
     syscall
     
     la $a0, box_5
     li $v0, 4
     syscall
     
     la $a0, box_1
     syscall
     
    beq $k1, 0, print_board
	
     jr $ra # return to stack caller in checkwinner
