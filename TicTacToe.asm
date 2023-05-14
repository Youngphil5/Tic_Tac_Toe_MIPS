.data 
    board: .asciiz "123456789"
    prompt1: .asciiz "\nEnter 1 to Restart Game.\nEnter 0 to exist!\n"
    prompt2: .asciiz "\nWelcome to Tic Tac Toe game!\n\nDecide who plays first (Enter 1 OR 2): "
    prompt3: .asciiz "\nPlayer "
    prompt4: .asciiz " starts first!\n"
    prompt5: .asciiz "\nPlayer 1 is x and player 2 is o\n"
    spaceOpenBracket: .asciiz " ("
    closeBracketSpace: .asciiz ") :\n"
    newLine: .asciiz "\n"
    space: .asciiz " "
    verticalBorderAndSpace: .asciiz " | "
    horizontalBorder:   .asciiz "\n---|---|---\n"
    
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

#// Olise End

#// Olise Start
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
#// Olise End

#// Connor and Olise Start
#int make_selection(char *board) {
#  //  being written must take user input for where to move and place
#  // appropriate symobol in their desired grid space should somehow
#  // use the draw method
#  int selection;
#  int validFlag = 0; // 1 --> valid, 0 --> not valid

#  do {
#    printf("Enter which grid space to move to(1-9): ");
#    scanf("%d", &selection);

#    validFlag = validateChoice(selection, board);

#    if (validFlag == 0) {
#      printf("\nCant play there. try again!\n");
#    }
#  } while (validFlag == 0);

#  return selection;
#}
#// Connor and Olise End

#// Olise Start
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
#// Olise End

# Connor Start

updateBoard:		     #// 
			     #void updateBoard(char *board, int squareIndex, char playerMark) {
			     #  // playerMark is x or o
			     
    addi $sp, $sp, -8        # Adjust stack pointer for two local variables
    sw   $ra, 0($sp)         # Save the return address
    sw   $s0, 4($sp)         # Save the base address of the board
    
   			     #  // squareIndex means what block the player chose
			     #  squareIndex--; // so we can use it as index for the char[]

    addi $t0, $a1, -1        # Subtract 1 from squareIndex

    add  $s0, $a0, $zero     # Set $s0 to the base address of the board
    add  $t1, $zero, $t0     # Copy the modified squareIndex to $t1

    sll  $t1, $t1, 2         # Multiply squareIndex by 4 to get byte offset
    addu $t1, $s0, $t1       # Calculate the address of the chosen block

    lb   $t2, 0($t1)         # Load the character from the chosen block
    add  $t2, $zero, $a2     # Set $t2 to playerMark

    sb   $t2, 0($t1)         # Store playerMark in the chosen block
    
    			     #  // squareIndex means what block the player chose
			     #  squareIndex--; // so we can use it as index for the char[]
			     #  board[squareIndex] = playerMark;


    lw   $ra, 0($sp)         # Restore the return address
    lw   $s0, 4($sp)         # Restore the base address of the board
    addi $sp, $sp, 8         # Restore the stack pointer

    jr   $ra                 # Return to the calling function
    
    # connor Bend


#// 
#int check_for_winner(char *board, int numOfSpaces) {
#  if (numOfSpaces > 0) {

#    if ((board[0] == board[1]) && (board[1] == board[2])) {
#      return 1;
#    } else if ((board[3] == board[4]) && (board[4] == board[5])) {
#      return 1;
#    } else if ((board[6] == board[7]) && (board[7] == board[8])) {
#      return 1;
#    } else if ((board[0] == board[5]) && (board[5] == board[8])) {
#      return 1;
#    } else if ((board[0] == board[3]) && (board[3] == board[6])) {
#      return 1;
#    } else if ((board[1] == board[4]) && (board[4] == board[7])) {
#      return 1;
#    } else if ((board[2] == board[5]) && (board[5] == board[8])) {
#      return 1;
#    } else if ((board[0] == board[4]) && (board[4] == board[8])) {
#      return 1;
#    } else if ((board[2] == board[4]) && (board[4] == board[6])) {
#      return 1; // 1 --> win move detected
#    } else {
#      return 0; // no winner yet
#    }
#  } else {
#    return -1; // no moves left
#  }
#}
#// 

#// 
#int validateChoice(int choice, char *board) {
#  char squareChoice;
#  int returnValue = 0; // 0 --> not a valid choice
#                      // 1 --> its a valid choice

#  if (choice > 0 && choice < 10) {
#    //"choice--" -->this is to make the
#    // choices usable for indexing the
#    // array
#    choice--;
#    squareChoice = board[choice];

#    if (squareChoice != 'x' && squareChoice != 'o') {
#      returnValue = 1; // its a valid choice
#    }
#  }

#  return returnValue;
#}

#// Olise Start
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
#  updateBoard(board, playerSelection, playerMark);
#  numOfSpaceLeft--;

#  gameStatus = check_for_winner(board, numOfSpaceLeft);

#  if (gameStatus == 1 || gameStatus == -1) { // base case
#    draw_board(board);

#    if (gameStatus != -1) {
#      printf("\nPlayer %d is the winner\n\n", playerId);
#    } else {
#      printf("\nGAME OVER\nNo winner\n");
#    }

#  } else { // recursive case

#    if (playerId == 1) { // if current player = 1
#      play(2, board, 'o', numOfSpaceLeft);
#    } else {
#      play(1, board, 'x', numOfSpaceLeft);
#    }
#  }
    lw $ra, 0($sp) # load return address
    add $sp, $sp 16 # pop
    jr $ra 
#}
#// Olise End

#Connor Start
resetBoard:        #  we can reuse code rhere rather than rewritw a whole new function to rest
    j drawBoard    #  we can just redraw the board here I belive 
    	           #   void resetBoard(char *board) {
	           #     for (int x = 0; x < 9; x++)    {
      	           #     board[x] = 1 + x + '0';
	           #    }
                   #  }
#Connor End
