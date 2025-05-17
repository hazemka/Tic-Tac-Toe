
import 'dart:io';
import 'dart:math';

List<String> board = List.filled(9, ' ');
String currentPlayer = '';
String humanPlayer = '' ;
String aiPlayer = '';
int gameMode = 0 ; // 0=> two-Players or 1 => Player with AI

void main(){
  print("Welcome to Tic-Tac-Toe!");
  selectGameMode();
}

void playGame(){
  bool playAgain = true;
  while(playAgain){
    resetBoard();
    currentPlayer = humanPlayer;
    while(true){
      printBoard();
      int choice;
      if(gameMode == 1){
        // Player with AI
        if(currentPlayer == aiPlayer){
          choice = getAiChoice();
          print('Player $aiPlayer chosen (${choice+1})');
        }else{
          choice = getPlayerChoice();
        }
      }else{
        // Two players mode
        if(currentPlayer == '') currentPlayer = 'X' ;
        choice = getPlayerChoice();
      }
      // set choice
      board[choice] = currentPlayer;
      if(checkWinner()){
        printBoard();
        print('Player $currentPlayer wins!');
        break;
      }else if(isBoardFull()){
        print("It's a draw!");
        break;
      }
      // switch play to another player
      switchPlayer();
    }
    // ask to play again
    playAgain = askPlayAgain();
    if(playAgain){
      selectGameMode();
      break;
    }
  }
  // finish game
  print('Game finished');
}

void resetBoard(){
  board = List.filled(9, ' ');
}

void printBoard(){
  print('***************');
  for(int i = 0 ; i < 9 ; i+=3){
    print('${printCell(i)} | ${printCell(i+1)} | ${printCell(i+2)}');
    if(i < 6){
      print('---------');
    }
  }
  print('***************');
}

String printCell(int i) => board[i] == ' ' ? '${i + 1}' : board[i];

int getPlayerChoice(){
  int choice;
  while(true){
    print('Player $currentPlayer enter your choice (1-9)');
    String? input = stdin.readLineSync();
    if (input == null || int.tryParse(input) == null) {
      print("Invalid input. Please enter a number between 1 and 9.");
      continue;
    }
    choice = int.parse(input) - 1;
    // check choice
    if(choice < 0 || choice >= 9){
      print('Choice out of range. Choose number 1-9.');
    }else if(board[choice] != ' '){
      print('Cell already taken. Choose another.');
    }else {
      break;
    }
  }
  return choice;
}

bool checkWinner(){
  List<List<int>> winPatterns = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [2,4,6],
    [0,4,8]
  ];
  for(var pattern in winPatterns){
    if(board[pattern[0]] == currentPlayer && board[pattern[1]] == currentPlayer
        && board[pattern[2]] == currentPlayer){
      return true;
    }
  }
  return false;
}

bool isBoardFull(){
  return board.every((cell) => cell != ' ');
}

void switchPlayer() {
  currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
}

int getAiChoice(){
  print('Player $aiPlayer choosing a number ...');
  List<int> emptyCells = [];
  for(int i = 0 ; i < 9 ; i++){
    if(board[i] == ' '){
      emptyCells.add(i);
    }
  }
  Random random = Random();
  return emptyCells[random.nextInt(emptyCells.length)];
}

bool askPlayAgain() {
  while (true) {
    print('Are you need to Play again? (Y/N):');
    String? input = stdin.readLineSync()?.toUpperCase();

    if (input == 'Y') return true;
    if (input == 'N') return false;

    print("Invalid input. Enter Y or N.");
  }
}

void chooseMarker(){
  while(true){
    print('Choose your marker (X/O):');
    String? input = stdin.readLineSync()?.toUpperCase();
    if(input == 'X' || input == 'O'){
      humanPlayer = input!;
      aiPlayer = humanPlayer == 'X' ? 'O' : 'X';
      playGame();
      break;
    }else{
      print('Invalid input. Please choose X or O.');
    }
  }
}

void selectGameMode(){
  while(true){
    print('Select Game Mode:');
    print('1. Two Players.');
    print('2. Player with AI.');
    String? input = stdin.readLineSync();
    if(input == '1' || input == '2'){
      gameMode = input == '1' ? 0 : 1 ;
      if(gameMode == 0){
        playGame();
      }else if(gameMode == 1){
        chooseMarker();
      }
      break;
    }else{
      print('Invalid input. Please game mode 1 or 2.');
    }
  }
}

