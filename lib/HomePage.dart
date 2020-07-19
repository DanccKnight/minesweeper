import 'dart:math';
import 'package:flutter/material.dart';
import 'package:minesweeper/Square.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<Square>> board;
  int rowCount = 15;
  int columnCount = 20;
  int limit = 20;
  int bombCount;
  int tappedSquares;
  int markedSquares;
  int remainingSquares;
  Random random = new Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    bombCount = 0;
    tappedSquares = 0;
    markedSquares = 0;
    remainingSquares = columnCount * rowCount;

    //generate empty board
    board = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        return Square();
      });
    });

    //fill in bombs
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (random.nextInt(limit) % 3 == 0) {
          board[i][j].isBombPresent = true;
          bombCount++;
        }
      }
    }

    //get bombsAround values for each square
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (i > 0) {
          if (board[i - 1][j].isBombPresent) board[i][j].bombsAround += 1;
        }

        if (j > 0) {
          if (board[i][j - 1].isBombPresent) board[i][j].bombsAround += 1;
        }

        if (i > 0 && j > 0) {
          if (board[i - 1][j - 1].isBombPresent)
            board[i - 1][j - 1].bombsAround += 1;
        }

        if (i < rowCount - 1 && j < columnCount - 1) {
          board[i + 1][j + 1].bombsAround += 1;
        }

        if (i > 0 && j < columnCount - 1) {
          board[i - 1][j + 1].bombsAround += 1;
        }

        if (i < rowCount - 1 && j > 0) {
          board[i + 1][j - 1].bombsAround += 1;
        }

        if (i < rowCount - 1) {
          if (board[i + 1][j].isBombPresent) board[i][j].bombsAround += 1;
        }

        if (j < columnCount - 1) {
          if (board[i][j + 1].isBombPresent) board[i][j].bombsAround += 1;
        }
      }
    }

    setState(() {});
  }

  void actionOnTap(int i, int j) {
    board[i][j].isTapped = true;
    remainingSquares -= 1;

    if (i > 0) {
      if (board[i - 1][j].bombsAround == 0 && !board[i - 1][j].isTapped)
        actionOnTap(i - 1, j);
    }

    if (j > 0) {
      if (board[i][j - 1].bombsAround == 0 && !board[i][j - 1].isTapped)
        actionOnTap(i, j - 1);
    }

    if (i < rowCount - 1) {
      if (board[i + 1][j].bombsAround == 0 && !board[i + 1][j].isTapped)
        actionOnTap(i + 1, j);
    }

    if (i < columnCount - 1) {
      if (board[i][j + 1].bombsAround == 0 && !board[i][j + 1].isTapped)
        actionOnTap(i, j + 1);
    }

    //TODO -> Move this to the place where you called actionOnTap(). Set state after the function executes instead of in the function.
    setState(() {});
  }

  void showGameOverMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Game over"),
            content: Text("Looks like you stepped on a mine"),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Dismiss"))
            ],
          );
        });
  }

  void showGameClearedMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You win"),
            content: Text("Good job, you cleared the game"),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Dismiss"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount),
            itemBuilder: (context,index){
                return Container(color: Colors.grey);
            },
          ),
          SizedBox(height: 50)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => startGame(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
