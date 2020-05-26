.data
tic:      		.asciiz   " \n\n Tic Tac Toe.\n"
Player_Prompt:    .asciiz   " Player 1 = X  &&  Player 2 = O \n\n"

.text

.globl main
main: 
	# display game title
	li $v0, 4
	la, $a0, tic
	syscall
	
	li $v0, 4
	la, $a0, Player_Prompt
	syscall

	jal start
	
	
	# terminate program
	li $v0, 10
        syscall
