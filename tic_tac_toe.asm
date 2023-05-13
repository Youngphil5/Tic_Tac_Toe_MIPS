.data 
    board: .asciiz "123456789"
    prompt1: .asciiz "\nEnter 1 to Restart Game.\nEnter 0 to exist!\n"
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
#  int whoPlaysFirst;
#  int numOfSpaceLeft = 9; // how many space left in the board

#  do { // choose who plays first
#    printf("\nWelcome to Tic Tac Toe game!\n\n"
#           "Decide who plays first (Enter 1 OR 2): ");

#    scanf("%d", &whoPlaysFirst);
#  } while (whoPlaysFirst != 1 && whoPlaysFirst != 2);

#  printf("\nPlayer %d starts first!\n", whoPlaysFirst);
#  printf("\nPlayer 1 is x and player 2 is o\n");

#  if (whoPlaysFirst == 1) {
#    play(whoPlaysFirst, board, 'x', numOfSpaceLeft);
#  } else {
#    play(whoPlaysFirst, board, 'o', numOfSpaceLeft);
#  }
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

#// Connor Start
#void draw_board(char *board) {
#  printf("\n");
#  printf(" %c | %c | %c \n", board[0], board[1], board[2]);
#  printf("---|---|---\n");
#  printf(" %c | %c | %c \n", board[3], board[4], board[5]);
#  printf("---|---|---\n");
#  printf(" %c | %c | %c \n", board[6], board[7], board[8]);
#  printf("\n");
#}
#// Connor End

#// Olise Start
#void updateBoard(char *board, int squareIndex, char playerMark) {
#  // playerMark is x or o
#  // squareIndex means what block the player chose
#  squareIndex--; // so we can use it as index for the char[]

#  board[squareIndex] = playerMark;
#}
#// Olise End

#// Connor Start
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
#// Connor End

#// Olise Start
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

#void play(int playerId, char *board, char playerMark, int numOfSpaceLeft) {
#  // playerMark is either x or o
#  int playerSelection;
#  int gameStatus;

#  printf("\nPlayer %d (%c) :\n", playerId, playerMark);
#  draw_board(board);

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
#}

#void resetBoard(char *board) {
#  for (int x = 0; x < 9; x++) {
#    board[x] = 1 + x + '0';
#  }
#}
#// Olise End