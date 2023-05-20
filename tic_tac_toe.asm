.data
    board: .asciiz "123456789"
    prompt1: .asciiz "\nEnter 1 to Restart Game.\nEnter 0 to exist!\n"
    prompt2: .asciiz "\nWelcome to Tic Tac Toe game!\n\nDecide who plays first (Enter 1 OR 2): "
    prompt3: .asciiz "\nPlayer "
    prompt4: .asciiz " starts first!\n"
    prompt5: .asciiz "\nPlayer 1 is x and player 2 is o\n"
    prompt6: .asciiz "Enter which grid space to move to(1-9): "
    cantPlayThere: .asciiz "\nCant play there. try again!\n"
    spaceOpenBracket: .asciiz " ("
    closeBracketSpace: .asciiz ") :\n"
    newLine: .asciiz "\n"
    space: .asciiz " "
    verticalBorderAndSpace: .asciiz " | "
    horizontalBorder:   .asciiz "\n---|---|---\n"
    gameOver: .asciiz "\nGAME OVER\nNo winner\n"
    winner: .asciiz " is the winner\n\n"

.text

# //Olise Start
#int main() {
main:
#  char board[9] = {'1', '2', '3', '4', '5', '6', '7', '8', '9'}; $s0
    la $s0, board #load address of string

#  int gameOption; // restart or exit game $v0


#  do {
    main_DoWhile:

#    startGame(board);
    jal startGame

#    resetBoard(board);
    jal resetBoard

#    printf("\nEnter 1 to Restart Game.\nEnter 0 to exist!\n");
        li $v0, 4
        la $a0, prompt1
        syscall

#    scanf("%d", &gameOption);
        li $v0, 5
        syscall

#  } while (gameOption == 1);
        beq $v0, 1, main_DoWhile



#  return 0;
    li $v0, 10
    syscall
#}

# //Olise End

# //Olise Start
#void startGame(char *board) {
startGame:

#  int whoPlaysFirst; --> $t0

#  int numOfSpaceLeft = 9; // how many space left in the board --> $a2

#  do { // choose who plays first
    startGame_DoWhile:
        addi $sp, $sp -4 # alloc space for return address
        sw $ra, 0($sp)

#    printf("\nWelcome to Tic Tac Toe game!\n\n"
#           "Decide who plays first (Enter 1 OR 2): ");
        li $v0, 4
        la $a0, prompt2
        syscall

#    scanf("%d", &whoPlaysFirst);
        li $v0, 5
        syscall
        add $t0, $zero, $v0

#  } while (whoPlaysFirst != 1 && whoPlaysFirst != 2);
        bgt $t0, 2, startGame_DoWhile
        blt $t0, 1, startGame_DoWhile

#  printf("\nPlayer %d starts first!\n", whoPlaysFirst);
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 1
    add $a0, $t0, $zero
    syscall

    li $v0, 4
    la $a0, prompt4
    syscall

#  printf("\nPlayer 1 is x and player 2 is o\n");
    li $v0, 4
    la $a0, prompt5
    syscall

#  if (whoPlaysFirst == 1) {
    # if whoPlaysFirst = 2 branch to player2PlaysFirst
    beq $t0 2, player2PlaysFirst

#    play(whoPlaysFirst, board, 'x', numOfSpaceLeft);
    add $a0, $zero, $t0
    li  $a1, 'x'
    li $a2, 9 # numOfSpaceLeft
    jal play

    j endOfStartFunc

#  } else {
    player2PlaysFirst:

#    play(whoPlaysFirst, board, 'o', numOfSpaceLeft);
    add $a0, $zero, $t0
    li  $a1, 'o'
    li $a2, 9 # numOfSpaceLeft
    jal play
#  }

    endOfStartFunc:
        lw $ra, 0($sp)
        addi $sp, $sp, 4 # pop
        jr $ra
#}
# //Olise End

# //Olise Start
#int make_selection(char *board) {
make_selection: 
    addi $sp, $sp -8
    sw $ra, 0($sp) # store return address to stack

#  int selection; --> $t0

#  int validFlag = 0; // 1 --> valid, 0 --> not valid --> $t1
     li $t1, 0 # set valid to 0

#  do {
    make_SelectionDoWhile:
    
#    printf("Enter which grid space to move to(1-9): ");
    
    # display prompt
    li $v0, 4
    la $a0, prompt6
    syscall 

#    scanf("%d", &selection);
    
    # ask for user input (int)
    li $v0, 5
    syscall 
    
    # move user input to $t0 (selection)
    add $t0, $v0, $zero
    
    # save selection in stack incase of
    # function call
    sw $t0, 4($sp) 

#    validFlag = validateChoice(selection, board);
    add $a0, $zero, $t0 # arg 1 for function
    jal validateChoice
    
    # move return value to validFlag
    add $t1, $zero, $v0

#    if (validFlag == 0) {
    
    # if its a valid selection jump 
    # to the end of function
    bnez $t1, end_make_Selection
    
#      printf("\nCant play there. try again!\n");
 
    # display message
    li $v0, 4
    la $a0, cantPlayThere
    syscall 
#    }

#  } while (validFlag == 0);
     # loop again 
    j make_SelectionDoWhile

    
#  return selection;
    end_make_Selection:
        # get values back from stack
        lw $v0, 4($sp) # get selection
        lw $ra, 0($sp) # get return address
        addi $sp, $sp, 8 #pop stack
        
        jr $ra # return address
#}
# //Olise End


# //Olise Start
#void draw_board(char *board) {
draw_board:

#  printf("\n");
    li $v0, 4
    la  $a0, newLine
    syscall

    li $t0, 0 # base offset




#  printf(" %c | %c | %c \n", board[0], board[1], board[2]);
#  printf("---|---|---\n");
#  printf(" %c | %c | %c \n", board[3], board[4], board[5]);
#  printf("---|---|---\n");
#  printf(" %c | %c | %c \n", board[6], board[7], board[8]);
    dbForLoop:
        li $v0, 4
        la $a0, space
        syscall

        li $v0, 11
        lb $a0, board($t0)
        syscall

        addi $t0, $t0, 1 # $t0 ++

        li $v0, 4
        la $a0, verticalBorderAndSpace
        syscall

        li $v0, 11
        lb $a0, board($t0)
        syscall

        addi $t0, $t0, 1 # $t0 ++

        li $v0, 4
        la $a0, verticalBorderAndSpace
        syscall

        li $v0, 11
        lb $a0, board($t0)
        syscall

        addi $t0, $t0, 1 # $t0 ++

        # if we are not done display
        # the horizontal border
        bgt $t0 7 dbEndOfForLoop

        li $v0, 4
        la $a0, horizontalBorder
        syscall

        blt $t0 7 dbForLoop

    dbEndOfForLoop:
#  printf("\n");
        li $v0, 4
        la  $a0, newLine
        syscall

        jr $ra
#}
# //Olise End

# //Connor and Olise Start
#void updateBoard(char *board, int squareIndex, char playerMark) {
			     #  // playerMark is x or o
updateBoard: # $a1 = squareIndex, $a2 = playerMark		     


   

   			     #  // squareIndex means what block the player chose
			     #  squareIndex--; // so we can use it as index for the char[]

    addi $a1, $a1, -1        # Subtract 1 from squareIndex
    
    # update board with index
    sb $a2, board($a1)
    

    jr   $ra                 # Return to the calling function

#// connor and Olise end


#// Olise and Connor
#int check_for_winner(char *board, int numOfSpaces) {
check_for_winner:
    bgtz $a0, check_winner   # Branch if numOfSpaces > 0

    li $v0, -1               # Return -1 if no moves left
    jr $ra

return_1: # winning match found 
    li $v0, 1
    jr $ra   

check_winner:
    la $t1, board            # Load the address of board into $t1
# Horizontal check

    lb $t2, ($t1)            # Load board[0] into $t2
    lb $t3, 1($t1)           # Load board[1] into $t3
    lb $t4, 2($t1)           # Load board[2] into $t4
    seq $t5, $t2, $t3        # store 1 if board[0] == board[1]
    seq $t6, $t3, $t4        # store 1 if board[1] == board[2]
    add $t5, $t5, $t6        
    beq $t5, 2, return_1     # means we have a match 

    lb $t2, 3($t1)           # Load board[3] into $t2
    lb $t3, 4($t1)           # Load board[4] into $t3
    lb $t4, 5($t1)           # Load board[5] into $t4
    seq $t5, $t2, $t3        # store 1 if board[3] == board[4]
    seq $t6, $t3, $t4        # store 1 if board[4] == board[5]
    add $t5, $t5, $t6        
    beq $t5, 2, return_1     # means we have a match

    lb $t2, 6($t1)           # Load board[6] into $t2
    lb $t3, 7($t1)           # Load board[7] into $t3
    lb $t4, 8($t1)           # Load board[8] into $t4
    seq $t5, $t2, $t3        # store 1 if board[6] == board[7]
    seq $t6, $t3, $t4        # store 1 if board[7] == board[8]
    add $t5, $t5, $t6        
    beq $t5, 2, return_1     # means we have a match

# diagonal check
    lb $t2, ($t1)            # Load board[0] into $t2
    lb $t3, 4($t1)           # Load board[4] into $t3
    lb $t4, 8($t1)           # Load board[8] into $t4
    seq $t5, $t2, $t3        # store 1 if board[0] == board[4]
    seq $t6, $t3, $t4        # store 1 if board[4] == board[8]
    add $t5, $t5, $t6        
    beq $t5, 2, return_1     # means we have a match
    
    lb $t2, 2($t1)           # Load board[2] into $t2
    lb $t3, 4($t1)           # Load board[4] into $t3
    lb $t4, 6($t1)           # Load board[6] into $t4
    seq $t5, $t2, $t3        # store 1 if board[2] == board[4]
    seq $t6, $t3, $t4        # store 1 if board[4] == board[6]
    add $t5, $t5, $t6        
    beq $t5, 2, return_1     # means we have a match
    
# Vertical Check
    lb $t2, ($t1)            # Load board[0] into $t2
    lb $t3, 3($t1)           # Load board[3] into $t3
    lb $t4, 6($t1)           # Load board[6] into $t4
    seq $t5, $t2, $t3        # store 1 if board[0] == board[3]
    seq $t6, $t3, $t4        # store 1 if board[3] == board[6]
    add $t5, $t5, $t6        
    beq $t5, 2, return_1     # means we have a match

    lb $t2, 1($t1)           # Load board[1] into $t2
    lb $t3, 4($t1)           # Load board[4] into $t3
    lb $t4, 7($t1)           # Load board[7] into $t4
    seq $t5, $t2, $t3        # store 1 if board[1] == board[4]
    seq $t6, $t3, $t4        # store 1 if board[4] == board[7]
    add $t5, $t5, $t6        
    beq $t5, 2, return_1     # means we have a match

    lb $t2, 2($t1)           # Load board[2] into $t2
    lb $t3, 5($t1)           # Load board[5] into $t3
    lb $t4, 8($t1)           # Load board[8] into $t4
    seq $t5, $t2, $t3        # store 1 if board[2] == board[5]
    seq $t6, $t3, $t4        # store 1 if board[5] == board[8]
    add $t5, $t5, $t6        
    beq $t5, 2, return_1     # means we have a match

    # No winner yet
    li $v0, 0
    jr $ra
# //olise and connor end

# //cornor and Olise start
#int validateChoice(int choice, char *board) {
validateChoice: # choice --> $a0
    
#  char squareChoice; --> $t0
    
#  int returnValue = 0; // 0 --> not a valid choice --> $v0
#                      // 1 --> its a valid choice
    li $v0, 0 # default

#  if (choice > 0 && choice < 10) {
    blt $a0, 1, endOfValidateChoice      # Branch to invalid label if input is less than 1
    bgt $a0, 9, endOfValidateChoice      # Branch to invalid label if input is greater than 9
    
#    //"choice--" -->this is to make the
#    // choices usable for indexing the
#    // array
#    choice--;

    # move the choice from $a0 to $t0 
    # then subtract 1 from it. Index 
    # ffor accessing the board
    addi $t0, $a0, -1 
    
#    squareChoice = board[choice];
    lb $t0, board($t0)
    
    

#    if (squareChoice != 'x' && squareChoice != 'o') {

    # 120 is decimal for 'x' 111 is decimal for '0' 
    # if we see a 'x' or 'o' branch to funnction 
    # end
    beq $t0, 120, endOfValidateChoice
    beq $t0, 111, endOfValidateChoice
    
#      returnValue = 1; // its a valid choice
    
    # set return value to 1
    li $v0, 1
#    }
#  }

    endOfValidateChoice:
#  return returnValue;
        jr $ra #return the value at $v0
#}

# //Cornor and Olise end



# //Olise Start

#void play(int playerId, char *board, char playerMark, int numOfSpaceLeft) {
# ($a0 --> playerId, $s0 --> board, $a1 --> playerMark, $a2 --> numOfSpaceLeft)
play:

#  // playerMark is either x or o
#  int playerSelection; --> $t3
    #add $t3, $zero, $zero
#  int gameStatus;    --> $t4
    #add $t4, $zero, $zero

    # moved arguments to temp registers
    add $t0, $a0, $zero # playerId --> $t0
    add $t1, $a1, $zero # playerMark --> $t1
    add $t2, $a2, $zero # numOfSpaceLeft --> $t2

    # store temp vars to stack
    addi $sp, $sp, -16 # push
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t1, 8($sp)
    sw $t2, 12($sp)

#  printf("\nPlayer %d (%c) :\n", playerId, playerMark);
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 1
    add $a0, $t0, $zero
    syscall

     li $v0, 4
     la $a0, spaceOpenBracket
     syscall

     # display player mark
     li $v0 11
     add $a0, $zero, $t1
     syscall

     li $v0, 4
     la $a0, closeBracketSpace
     syscall

#  draw_board(board);
    jal draw_board
    # restore temp variables
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)


#  playerSelection = make_selection(board);
    jal make_selection
    
    # move result from $v0 to $t3
    add $t3, $v0, $zero
    
    # restore temp variables
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)
    
#  updateBoard(board, playerSelection, playerMark);
    
    # prep params for function
    add $a1, $t3, $zero # playerSelection 
    add $a2, $t1, $zero # playerMark
    
    # call updateBoard
    jal updateBoard
    
    # restore temp variables
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)
    
#  numOfSpaceLeft--;

    # update number of spaces 
    # left in the board  
    addi $t2, $t2, -1
    
    # update the value stored 
    # in the stack
    sw $t2, 12($sp)
    
    
#  gameStatus = check_for_winner(board, numOfSpaceLeft);
    add $a0, $t2, $zero # num of moves
    jal check_for_winner
    
    # restore temp variables
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)
    
    add $t4, $zero, $v0 # store return values to $t4  

#  if (gameStatus == 1 || gameStatus == -1) { // base case

    # if game status($t4) == 0 
    # jump to play_Else label
    beq $t4, 0, play_Else
    
#    draw_board(board);
    jal draw_board
    
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)
    
#    if (gameStatus != -1) {

    # if game status == -1
    beq $t4, -1, finishNoWiner
#      printf("\nPlayer %d is the winner\n\n", playerId);

    # display winnner message
    li $v0, 4
    la $a0, prompt3
    syscall 
    
    li $v0, 1
    add $a0, $t0, $zero
    syscall 
    
    li $v0, 4
    la $a0, winner
    syscall 

    j endOfPlay
#    } else {
    finishNoWiner:
    
#      printf("\nGAME OVER\nNo winner\n");
    
    # display game over message
        li $v0, 4
        la $a0, gameOver
        syscall 
#    }

    j endOfPlay

#  } else { // recursive case
    play_Else:

#    if (playerId == 1) { // if current player = 1

    # if current playerID is not 1 
    # jump to label player1Plays
    bne $t0, 1 player1Plays
    
#      play(2, board, 'o', numOfSpaceLeft);

    # load  argument for function
    li $a0, 2 # playerID
    li $a1, 'o' # player Mark
    add $a2, $zero, $t2 #num of spaces left
    
    jal play # call the play function again

    j endOfPlay # go to the end of play function
    
#    } else {
    player1Plays:

#      play(1, board, 'x', numOfSpaceLeft);
    
    # load  argument for function
    li $a0, 1 # playerID
    li $a1, 'x' # player Mark
    add $a2, $zero, $t2 #num of spaces left
    
    jal play
    
#    }
#  }
    endOfPlay:
        lw $ra, 0($sp) # load return address
    	add $sp, $sp 16 # pop
    	jr $ra
#}
# //Olise End


#Connor Start

resetBoard:

    addi $sp, $sp, -4 # Adjust stack for saved $ra
    sw $ra, 0($sp)    # Save return address
    la $t0, board     # Load address of board

    li $t1, 1         # Initialize loop counter with 1

    resetLoop:
        li $v0, 11        # system call for storing byte
        add $a0, $t1, $zero # convert counter to ASCII and store it in $a0
        addi $a0, $a0, 48 # 48 is ASCII offset for numbers
        sb $a0, 0($t0)    # Store the ASCII number in the board

        addi $t0, $t0, 1  # Increment board address
        addi $t1, $t1, 1  # Increment loop counter

        blt $t1, 10, resetLoop # Repeat for all board indices

        lw $ra, 0($sp)    # Restore return address
        addi $sp, $sp, 4  # Restore stack pointer

        jr $ra            # Return to calling function


#Connor End
